<cfcomponent displayname="Accounting Components" hint="CFC for Accounting">
	<cffunction name="getUnconfirmedTransactions" access="public" displayname="getUnconfirmedTransactions" hint="Gets query of unconfirmed PayPal transactions" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="practiceTransactionTbl" required="yes" type="string" />
		<cfargument name="membershipTransactionTbl" required="yes" type="string" />
		<cfargument name="transactionTypeTbl" required="yes" type="string" />
		<cfargument name="usersTbl" required="yes" type="string" />
		<cfargument name="transactionID" required="yes" type="numeric" />
		<cfargument name="transactionTypeID" required="yes" type="numeric" />

		<cfscript>
			var qData = "";
		</cfscript>

		<!--- Run query --->
		<cfquery name="qData" datasource="#dsn#">
			SELECT
				pt.transaction_id,
				pt.member_id,
				pt.date_transaction,
				pt.paymentConfirmed,
				pt.notes,
				pt.usersSwimPassID,
				tt.transaction_type,
				tt.transaction_type_id,
				u.preferred_name,
				u.last_name
			FROM
				#practiceTransactionTbl# pt
				INNER JOIN #transactionTypeTbl# tt
				ON pt.transaction_type_id = tt.transaction_type_id
					INNER JOIN #usersTbl# u
					ON pt.member_id = u.user_id
			WHERE
				pt.active_code = 1
				AND pt.paymentConfirmed = 0
			<cfif VAL(transactionID) AND VAL(transactionTypeID) GT 0>
				AND pt.transaction_id = <cfqueryparam value="#VAL(transactionID)#" cfsqltype="CF_SQL_INTEGER" />
				AND pt.transaction_type_id = <cfqueryparam value="#VAL(transactionTypeID)#" cfsqltype="CF_SQL_INTEGER" />
			<cfelseif VAL(transactionID)>
				AND 1 = 0
			</cfif>
		UNION
			SELECT
				mt.transaction_id,
				mt.member_id,
				mt.date_transaction,
				mt.paymentConfirmed,
				mt.notes,
				0 AS usersSwimPassID,
				'Membership' AS transaction_type,
				-1,
				u.preferred_name,
				CASE WHEN
					u.last_name IS NULL
				THEN
					'(none)'
				ELSE
					u.last_name
				END AS last_name
			FROM
				#membershipTransactionTbl# mt
				LEFT OUTER JOIN #usersTbl# u
				ON mt.member_id = u.user_id
			WHERE
				mt.active_code = 1
				AND mt.paymentConfirmed = 0
			<cfif VAL(transactionID) AND VAL(transactionTypeID) LT 0>
				AND mt.transaction_id = <cfqueryparam value="#VAL(transactionID)#" cfsqltype="CF_SQL_INTEGER" />
			<cfelseif VAL(transactionID)>
				AND 1 = 0
			</cfif>
			ORDER BY
				date_transaction,
				u.last_name,
				u.preferred_name
		</cfquery>

		<cfreturn qData />
	</cffunction>

	<cffunction name="confirmTransaction" access="public" displayname="confirmTransaction" hint="Confirms PayPal Transaction" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct" />
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="practiceTransactionTbl" required="yes" type="string" />
		<cfargument name="membershipTransactionTbl" required="yes" type="string" />
		<cfargument name="usersTbl" required="yes" type="string" />
		<cfargument name="user_statusTbl" required="yes" type="string" />
		<cfargument name="updatingUser" required="yes" type="numeric">
		<cfargument name="cfcLookup" required="yes" type="lookup_queries" />
		<cfargument name="cfcMembers" required="yes" type="members" />

		<cfscript>
			var stSuccess = StructNew();
			var stTemp = StructNew();
			stSuccess.success = "Yes";
			stSuccess.reason = "Payment Confirmed";
		</cfscript>

		<cftransaction>
			<!--- Do update --->
				<cfquery name="qUpdate" datasource="#DSN#">
					UPDATE
					<cfif VAL(formfields.transaction_type_id) GT 0>
						#practiceTransactionTbl#
					<cfelse>
						#membershipTransactionTbl#
					</cfif>
					SET
						paymentConfirmed = <cfqueryparam value="1" cfsqltype="CF_SQL_BIT" />,
						notes = <cfqueryparam value="#formfields.notes#" cfsqltype="CF_SQL_VARCHAR" />,
						modified_date = GetDate(),
						modified_user = <cfqueryparam value="#updatingUser#" cfsqltype="CF_SQL_INTEGER" />
					WHERE
						transaction_id = <cfqueryparam value="#formfields.transaction_id#" cfsqltype="CF_SQL_INTEGER">
				</cfquery>

				<!--- If a swim pass purchase, activate the pass and zero out their swim balance --->
				<cfif val(arguments.formfields.usersSwimPassID) GT 0>

					<cfquery name="qUpdatePass" datasource="#arguments.dsn#">
						UPDATE
							usersSwimPasses
						SET
							active = 1
						WHERE
							usersSwimPassID = <cfqueryparam value="#val(arguments.formfields.usersSwimPassID)#" cfsqltype="cf_sql_integer" />
					</cfquery>

					<cfset stAdjustment = structNew() />
					<cfset stAdjustment.transaction_id = 0 />
					<cfset stAdjustment.date_transaction = now() />
					<cfset stAdjustment.transaction_type_id = arguments.cfcLookup.getTransactionTypes(arguments.dsn,"transactionTypes",0,false,"Swim Pass Balance Adjustment").transaction_type_id />
					<cfset stAdjustment.member_id = arguments.formfields.user_id />
					<cfset stAdjustment.num_swims = -1 * arguments.cfcLookup.getMembers(arguments.dsn,arguments.usersTbl,arguments.user_statusTbl,arguments.practiceTransactionTbl,"transactionTypes",arguments.formfields.user_id,90,"ALL",false,false,"",false,now(),false,"officers","officerTypes","").balance />
					<cfset stAdjustment.notes = "Balance Adjustment for Swim Pass" />

					<cfif stAdjustment.num_swims NEQ 0>
						<cfset updateTransaction(stAdjustment,arguments.dsn,arguments.practiceTransactionTbl,arguments.updatingUser) />
					</cfif>
				</cfif>

				<!--- If membership transaction, we need to update the user's expiration date --->
				<cfif VAL(formfields.transaction_type_id) LT 0>
					<cfquery name="qExpiration" datasource="#dsn#">
						SELECT
							date_expiration
						FROM
							#usersTbl#
						WHERE
							user_id = <cfqueryparam value="#formfields.user_id#" cfsqltype="CF_SQL_INTEGER" />
					</cfquery>

					<!--- Calculate new membership expiration --->
					<cfif qExpiration.date_expiration EQ Year(Now()) OR Month(Now()) GTE 11>
						<cfset formfields.expirationYear = Year(Now()) + 1 />
					<cfelse>
						<cfset formfields.expirationYear = Year(Now()) />
					</cfif>

					<cfset stTemp = cfcMembers.payDuesConfirm(dsn,usersTbl,user_statusTbl,cfcLookup,arguments.formfields.user_id,arguments.formfields.expirationYear,arguments.formfields.notes,arguments.formfields.transaction_id) />
				</cfif>
		</cftransaction>

		<cfreturn stSuccess>
	</cffunction>

	<cffunction name="deleteTransaction" access="public" displayname="Delete Transaction" hint="Deletes Transaction" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="transactionTbl" required="yes" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">

		<cfscript>
			var stSuccess = StructNew();
			stSuccess.success = "Yes";
			stSuccess.reason = "";
		</cfscript>

		<!--- Do delete --->
		<cfif VAL(arguments.formfields.transaction_id)>
			<cftransaction>
				<cfquery name="qryUpdate" datasource="#arguments.DSN#">
					UPDATE
						#arguments.transactionTbl#
					SET
						active_code = 0,
						modified_user = <cfqueryparam value="#updating_user#" cfsqltype="CF_SQL_INTEGER">,
						modified_date = GetDate()
					WHERE
						transaction_id = <cfqueryparam value="#formfields.transaction_id#" cfsqltype="CF_SQL_INTEGER">
				</cfquery>
			</cftransaction>
		</cfif>

		<cfreturn stSuccess>
	</cffunction>

	<cffunction name="updateTransaction" access="public" displayname="Update Transaction" hint="Updates Transaction" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="transactionTbl" required="yes" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<!--- Validate data --->
		<cfscript>
			if (NOT LEN(trim(arguments.formfields.date_transaction)) OR (NOT isDate(arguments.formfields.date_transaction)))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter a valid transaction date.*";
			}
			if (arguments.formfields.transaction_type_id LT 1)
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please select a transaction type.*";
			}

			if (arguments.formfields.member_id LT 1)
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please select a Member.*";
			}

			if (INT(VAL(arguments.formfields.num_swims)) NEQ VAL(arguments.formfields.num_swims))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter an integer for the swims.*";
			}
		</cfscript>

		<cfif NOT var.success.success>
			<cfreturn var.success>
		</cfif>

		<!--- Do add or update --->
		<cfif VAL(arguments.formfields.transaction_id)>
			<cfquery name="qryUpdate" datasource="#arguments.DSN#">
				UPDATE
					#arguments.transactionTbl#
				SET
					date_transaction = <cfqueryparam value="#arguments.formfields.date_transaction#" cfsqltype="CF_SQL_DATE">,
					member_id = <cfqueryparam value="#arguments.formfields.member_id#" cfsqltype="CF_SQL_INTEGER">,
					transaction_type_id = <cfqueryparam value="#arguments.formfields.transaction_type_id#" cfsqltype="CF_SQL_INTEGER">,
					num_swims = <cfqueryparam value="#arguments.formfields.num_swims#" cfsqltype="CF_SQL_INTEGER">,
					notes = <cfqueryparam value="#arguments.formfields.notes#" cfsqltype="CF_SQL_VARCHAR">,
					modified_user = <cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
					modified_date = GetDate()
				WHERE
					transaction_id = <cfqueryparam value="#arguments.formfields.transaction_id#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
		<cfelse>
			<cfquery name="qryInsert" datasource="#arguments.DSN#">
				INSERT INTO
					#arguments.transactionTbl#
				(
					date_transaction,
					member_id,
					transaction_type_id,
					num_swims,
					notes,
					created_user,
					modified_user
				)
				VALUES
				(
					<cfqueryparam value="#arguments.formfields.date_transaction#" cfsqltype="CF_SQL_DATE">,
					<cfqueryparam value="#arguments.formfields.member_id#" cfsqltype="CF_SQL_INTEGER">,
					<cfqueryparam value="#arguments.formfields.transaction_type_id#" cfsqltype="CF_SQL_INTEGER">,
					<cfqueryparam value="#arguments.formfields.num_swims#" cfsqltype="CF_SQL_INTEGER">,
					<cfqueryparam value="#arguments.formfields.notes#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
					<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">
				)
			</cfquery>
		</cfif>

		<cfreturn var.success>
	</cffunction>

	<cffunction name="deletePractice" access="public" displayname="Delete Practice" hint="Deletes Practice" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="practicesTbl" required="yes" type="string">
		<cfargument name="transactionTbl" required="no" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<!--- Do delete --->
		<cfif VAL(arguments.formfields.practice_id)>
			<cftransaction>
				<cfquery name="qryUpdate" datasource="#arguments.DSN#">
					UPDATE
						#arguments.practicesTbl#
					SET
						active_code = 0,
						modified_user = <cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
						modified_date = GetDate()
					WHERE
						practice_id = <cfqueryparam value="#arguments.formfields.practice_id#" cfsqltype="CF_SQL_INTEGER">
				</cfquery>

				<!--- Remove any transactions for this practice, as well --->
				<cfquery name="qTransactions" datasource="#arguments.DSN#">
					UPDATE
						#arguments.transactionTbl#
					SET
						active_code = 0,
						modified_user = <cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
						modified_date = GetDate()
					WHERE
						practice_id = <cfqueryparam value="#arguments.formfields.practice_id#" cfsqltype="CF_SQL_INTEGER">
				</cfquery>
			</cftransaction>
		</cfif>

		<cfreturn var.success>
	</cffunction>

	<cffunction name="updatePractice" access="public" displayname="Update Practice" hint="Updates Practice" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="practicesTbl" required="yes" type="string">
		<cfargument name="usersTbl" required="yes" type="string">
		<cfargument name="guest_status_id" required="yes" type="numeric">
		<cfargument name="member_status_id" required="yes" type="numeric">
		<cfargument name="transactionTbl" required="no" type="string">
		<cfargument name="transaction_typeTbl" required="no" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<cfset lookupCFC = createObject("component","lookup_queries") />
		<!--- Validate data --->
		<cfscript>
			if (NOT LEN(trim(arguments.formfields.date_practice)) OR (NOT isDate(arguments.formfields.date_practice)))
			{
				var.success.success = "No";
				var.success.reason = "Please enter a valid practice date.*";
			}
		</cfscript>

		<!--- See if there are new guests or members to add and create a structure/array to hold that info --->
		<cfset var.newpeople = ArrayNew(1)>
		<cfloop collection="#arguments.formfields#" item="i">
			<cfscript>
				if (CompareNoCase(Left(i,9),"newguest_") EQ 0)
				{
					var.newpeople[ArrayLen(var.newpeople) + 1] = StructNew();
					var.newpeople[ArrayLen(var.newpeople)].status_type_id = guest_status_id;
					var.newpeople[ArrayLen(var.newpeople)].first_name = arguments.formfields["first_" & i];
					var.newpeople[ArrayLen(var.newpeople)].last_name = arguments.formfields["last_" & i];
				}
				else if (CompareNoCase(Left(i,10),"newmember_") EQ 0)
				{
					var.newpeople[ArrayLen(var.newpeople) + 1] = StructNew();
					var.newpeople[ArrayLen(var.newpeople)].status_type_id = member_status_id;
					var.newpeople[ArrayLen(var.newpeople)].first_name = arguments.formfields["first_" & i];
					var.newpeople[ArrayLen(var.newpeople)].last_name = arguments.formfields["last_" & i];
				}
			</cfscript>
		</cfloop>

		<cfif NOT var.success.success>
			<cfreturn var.success>
		</cfif>

		<!--- If there are new people to add, put them in the users table and then add them to the appropriate list --->
		<cfif (ArrayLen(var.newpeople))>
			<cfloop from="1" to="#ArrayLen(var.newpeople)#" index="i">
				<cfset var.usernameSuffix = 0>
				<cfset var.usernameSuccess = false>
				<cfset var.username = LCASE(LEFT(var.newpeople[i].first_name,1) & var.newpeople[i].last_name)>
				<cftransaction>
					<!--- Make sure username's not taken --->
					<cfloop condition="NOT var.usernameSuccess">
						<cfquery name="qryUsername" datasource="#arguments.dsn#">
							SELECT
								u.user_id
							FROM
								#arguments.usersTbl# u
							WHERE
								lower(u.username) = <cfqueryparam value="#var.username#" cfsqltype="CF_SQL_VARCHAR">
						</cfquery>

						<cfif qryUsername.RecordCount>
							<cfset var.usernameSuffix = var.usernameSuffix + 1>
							<cfset var.username = LCASE(LEFT(var.newpeople[i].first_name,1) & var.newpeople[i].last_name & var.usernameSuffix)>
						<cfelse>
							<cfset var.usernameSuccess = true>
							<cfset var.success.username = var.username>
						</cfif>
					</cfloop>

					<cfset password = RandRange(100000,999999)>
					<cfset salt = RandRange(1000,9999)>

					<!--- Insert user --->
					<cfquery name="qryInsert" datasource="#arguments.dsn#">
						INSERT INTO
							#arguments.usersTbl#
						(
							username,
							password,
							passwordSalt,
							first_name,
							last_name,
							preferred_name,
							user_status_id,
							created_user,
							modified_user
						)
						VALUES
						(
							<cfqueryparam value="#var.username#" cfsqltype="CF_SQL_VARCHAR">,
							<cfqueryparam value="#Hash(password & salt)#" cfsqltype="CF_SQL_VARCHAR">,
							<cfqueryparam value="#salt#" cfsqltype="CF_SQL_VARCHAR">,
							<cfqueryparam value="#var.newpeople[i].first_name#" cfsqltype="CF_SQL_VARCHAR">,
							<cfqueryparam value="#var.newpeople[i].last_name#" cfsqltype="CF_SQL_VARCHAR">,
							<cfqueryparam value="#var.newpeople[i].first_name#" cfsqltype="CF_SQL_VARCHAR">,
							<cfqueryparam value="#var.newpeople[i].status_type_id#" cfsqltype="CF_SQL_INTEGER">,
							<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
							<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">
						)
					</cfquery>

					<cfquery name="qryNewID" datasource="#arguments.dsn#">
						SELECT
							MAX(u.user_id) AS newID
						FROM
							#arguments.usersTbl# u
						WHERE
							lower(u.username) = <cfqueryparam value="#var.username#" cfsqltype="CF_SQL_VARCHAR">
					</cfquery>

					<cfif CompareNoCase(var.newpeople[i].status_type_id,"guest") EQ 0>
						<cfset arguments.formfields.guests = ListAppend(arguments.formfields.guests,qryNewID.newID)>
					<cfelse>
						<cfset arguments.formfields.members = ListAppend(arguments.formfields.members,qryNewID.newID)>
					</cfif>
				</cftransaction>
			</cfloop>
		</cfif>

		<cftransaction>
			<!--- Do add or update for practice itself--->
			<cfif VAL(arguments.formfields.practice_id)>
				<cfquery name="qryUpdate" datasource="#arguments.DSN#">
					UPDATE
						#arguments.practicesTbl#
					SET
						date_practice = <cfqueryparam value="#arguments.formfields.date_practice#" cfsqltype="CF_SQL_DATE">,
						members = <cfqueryparam value="#VAL(arguments.formfields.membersTot)#" cfsqltype="CF_SQL_INTEGER">,
						guests = <cfqueryparam value="#VAL(arguments.formfields.guestsTot)#" cfsqltype="CF_SQL_INTEGER">,
						notes = <cfqueryparam value="#arguments.formfields.notes#" cfsqltype="CF_SQL_VARCHAR">,
						facility_id = <cfqueryparam value="#arguments.formfields.facility_id#" cfsqltype="CF_SQL_INTEGER">,
						coach_id = <cfqueryparam value="#arguments.formfields.coach_id#" cfsqltype="CF_SQL_INTEGER">,
						modified_user = <cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
						modified_date = GetDate()
					WHERE
						practice_id = <cfqueryparam value="#arguments.formfields.practice_id#" cfsqltype="CF_SQL_INTEGER">
				</cfquery>
			<cfelse>
				<cfquery name="qryInsert" datasource="#arguments.DSN#">
					INSERT INTO
						#arguments.practicesTbl#
					(
						date_practice,
						members,
						guests,
						notes,
						facility_id,
						coach_id,
						created_user,
						modified_user
					)
					VALUES
					(
						<cfqueryparam value="#arguments.formfields.date_practice#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#VAL(arguments.formfields.membersTot)#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#VAL(arguments.formfields.guestsTot)#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#arguments.formfields.notes#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#arguments.formfields.facility_id#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#arguments.formfields.coach_id#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">
					)
				</cfquery>

				<cfquery name="qryNewID" datasource="#arguments.DSN#">
					SELECT
						MAX(p.practice_id) AS newID
					FROM
						#arguments.practicesTbl# p
					WHERE
						date_practice = <cfqueryparam value="#arguments.formfields.date_practice#" cfsqltype="CF_SQL_DATE">
						AND active_code = 1
				</cfquery>

				<cfset arguments.formfields.practice_id = qryNewID.newID>
			</cfif>

			<!--- Queries for transaction types --->
			<cfinvoke
				component="#arguments.lookup_cfc#"
				method="getTransactionTypes"
				returnvariable="qrySwimType"
				dsn=#arguments.DSN#
				transaction_typeTbl=#arguments.transaction_typeTbl#
				transaction_type="SWIM WORKOUT"
			>

			<cfinvoke
				component="#arguments.lookup_cfc#"
				method="getTransactionTypes"
				returnvariable="qryVisitType"
				dsn=#arguments.DSN#
				transaction_typeTbl=#arguments.transaction_typeTbl#
				transaction_type="VISIT WORKOUT"
			>


		<!--- Insert/Update members --->
			<cfif ListSort(arguments.formfields.members,"numeric") IS NOT ListSort(arguments.formfields.membersOld,"numeric")>
				<!--- Loop along new list of members--->
				<cfloop list="#arguments.formfields.members#" index="i">
					<!--- See if member has a current swim pass --->
					<cfset usersSwimPassID = lookupCFC.getActiveUsersSwimPassesByUserIDAndDate(arguments.dsn,i,arguments.formfields.date_practice).usersSwimPassID />
					<cfif val(usersSwimPassID) GT 0>
						<cfset numberOfSwims = 0 />
					<cfelse>
						<cfset numberOfSwims = qrySwimType.default_swims />
					</cfif>

					<!--- If it's not in the old list of members, insert into database --->
					<cfif NOT ListFind(arguments.formfields.membersOld,i)>
						<cfquery name="qryInsertMember" datasource="#arguments.dsn#">
							INSERT INTO
								#arguments.transactionTbl#
							(
								member_id,
								num_swims,
								practice_id,
								transaction_type_id,
								date_transaction,
								notes,
								created_user,
								modified_user
							)
							VALUES
							(
								<cfqueryparam value="#i#" cfsqltype="CF_SQL_INTEGER">,
								<cfqueryparam value="#numberOfSwims#" cfsqltype="CF_SQL_INTEGER">,
								<cfqueryparam value="#arguments.formfields.practice_id#" cfsqltype="CF_SQL_INTEGER">,
								<cfqueryparam value="#qrySwimType.transaction_type_id#" cfsqltype="CF_SQL_INTEGER">,
								<cfqueryparam value="#arguments.formfields.date_practice#" cfsqltype="CF_SQL_VARCHAR">,
								<cfqueryparam value="#arguments.formfields.notes#" cfsqltype="CF_SQL_VARCHAR">,
								<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
								<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">
							)
						</cfquery>
					<!--- If it is, remove it from the list of old members --->
					<cfelse>
						<cfset arguments.formfields.membersOld = ListDeleteAt(arguments.formfields.membersOld,ListFind(arguments.formfields.membersOld,i))>
					</cfif>
				</cfloop>

				<!--- Now, deactivate remaining people in old members list --->
				<cfif ListLen(arguments.formfields.membersOld)>
					<cfquery name="qryRemoveMember" datasource="#arguments.dsn#">
						UPDATE
							#arguments.transactionTbl#
						SET
							active_code = 0,
							modified_user = <cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
							modified_date = GetDate()
						WHERE
							practice_id = <cfqueryparam value="#arguments.formfields.practice_id#" cfsqltype="CF_SQL_INTEGER">
							AND member_id IN
							(
								<cfqueryparam value="#arguments.formfields.membersOld#" cfsqltype="CF_SQL_INTEGER" list="Yes">
							)
							AND transaction_type_id = <cfqueryparam value="#qrySwimType.transaction_type_id#" cfsqltype="CF_SQL_INTEGER">
					</cfquery>
				</cfif>
			</cfif>

		<!--- Insert/Update existing guests --->
			<cfif ListSort(arguments.formfields.guests,"numeric") IS NOT ListSort(arguments.formfields.guestsOld,"numeric")>
				<!--- Loop along new list of guests --->
				<cfloop list="#arguments.formfields.guests#" index="i">
					<!--- If it's not in the old list of guests, insert into database --->
					<cfif NOT ListFind(arguments.formfields.guestsOld,i)>
						<cfquery name="qryInsertGuest" datasource="#arguments.dsn#">
							INSERT INTO
								#arguments.transactionTbl#
							(
								member_id,
								num_swims,
								practice_id,
								transaction_type_id,
								date_transaction,
								notes,
								created_user,
								modified_user
							)
							VALUES
							(
								<cfqueryparam value="#i#" cfsqltype="CF_SQL_INTEGER">,
								<cfqueryparam value="#qryVisitType.default_swims#" cfsqltype="CF_SQL_INTEGER">,
								<cfqueryparam value="#arguments.formfields.practice_id#" cfsqltype="CF_SQL_INTEGER">,
								<cfqueryparam value="#qryVisitType.transaction_type_id#" cfsqltype="CF_SQL_INTEGER">,
								<cfqueryparam value="#arguments.formfields.date_practice#" cfsqltype="CF_SQL_VARCHAR">,
								<cfqueryparam value="#arguments.formfields.notes#" cfsqltype="CF_SQL_VARCHAR">,
								<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
								<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">
							)
						</cfquery>
					<!--- If it is, remove it from the list of old guests --->
					<cfelse>
						<cfset arguments.formfields.guestsOld = ListDeleteAt(arguments.formfields.guestsOld,ListFind(arguments.formfields.guestsOld,i))>
					</cfif>
				</cfloop>

				<!--- Now, deactivate remaining people in old guests list --->
				<cfif ListLen(arguments.formfields.guestsOld)>
					<cfquery name="qryRemoveGuest" datasource="#arguments.dsn#">
						UPDATE
							#arguments.transactionTbl#
						SET
							active_code = 0,
							modified_user = <cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
							modified_date = GetDate()
						WHERE
							practice_id = <cfqueryparam value="#arguments.formfields.practice_id#" cfsqltype="CF_SQL_INTEGER">
							AND member_id IN
							(
								<cfqueryparam value="#arguments.formfields.guestsOld#" cfsqltype="CF_SQL_INTEGER" list="Yes">
							)
							AND transaction_type_id = <cfqueryparam value="#qryVisitType.transaction_type_id#" cfsqltype="CF_SQL_INTEGER">
					</cfquery>
				</cfif>
			</cfif>

			<!--- Update all transaction dates for this practice --->
			<cfquery name="qUpdateDates" datasource="#arguments.dsn#">
				UPDATE
					#arguments.transactionTbl#
				SET
					date_transaction = <cfqueryparam value="#arguments.formfields.date_practice#" cfsqltype="CF_SQL_DATE">,
					modified_user = <cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
					modified_date = GetDate()
				WHERE
					practice_id = <cfqueryparam value="#arguments.formfields.practice_id#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
		</cftransaction>

		<cfreturn var.success>
	</cffunction>

	<cffunction name="updateDefaults" access="public" displayname="Update Defaults" hint="Updates Practice Defaults" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="defaultsTbl" required="yes" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<!--- Validate data --->
		<cfscript>
			if (NOT VAL(arguments.formfields.coach_id))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please select a coach.*";
			}
			if (NOT VAL(arguments.formfields.facility_id))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please select a facility.*";
			}
			if (NOT (VAL(arguments.formfields.sunday) OR VAL(arguments.formfields.monday) OR VAL(arguments.formfields.tuesday) OR VAL(arguments.formfields.wednesday) OR VAL(arguments.formfields.thursday) OR VAL(arguments.formfields.friday) OR VAL(arguments.formfields.saturday)))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please select at least one default practice day.*";
			}
		</cfscript>

		<cfif NOT var.success.success>
			<cfreturn var.success>
		</cfif>

		<!--- Deactivate other defaults and insert new defaults--->
		<cftransaction>
			<cfquery name="qryDeactivate" datasource="#arguments.DSN#">
				UPDATE
					#arguments.defaultsTbl#
				SET
					active_code = 0,
					modified_user = <cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
					modified_date = GetDate()
			</cfquery>

			<cfquery name="qryInsert" datasource="#arguments.DSN#">
				INSERT INTO
					#arguments.defaultsTbl#
				(
					coach_id,
					facility_id,
					sunday,
					monday,
					tuesday,
					wednesday,
					thursday,
					friday,
					saturday,
					created_user,
					modified_user
				)
				VALUES
				(
					<cfqueryparam value="#arguments.formfields.coach_id#" cfsqltype="CF_SQL_INTEGER">,
					<cfqueryparam value="#arguments.formfields.facility_id#" cfsqltype="CF_SQL_INTEGER">,
					<cfqueryparam value="#arguments.formfields.sunday#" cfsqltype="CF_SQL_BIT">,
					<cfqueryparam value="#arguments.formfields.monday#" cfsqltype="CF_SQL_BIT">,
					<cfqueryparam value="#arguments.formfields.tuesday#" cfsqltype="CF_SQL_BIT">,
					<cfqueryparam value="#arguments.formfields.wednesday#" cfsqltype="CF_SQL_BIT">,
					<cfqueryparam value="#arguments.formfields.thursday#" cfsqltype="CF_SQL_BIT">,
					<cfqueryparam value="#arguments.formfields.friday#" cfsqltype="CF_SQL_BIT">,
					<cfqueryparam value="#arguments.formfields.saturday#" cfsqltype="CF_SQL_BIT">,
					<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
					<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">
				)
			</cfquery>
		</cftransaction>

		<cfreturn var.success>
	</cffunction>

	<cffunction name="getDefaults" access="public" displayname="Get Defaults" hint="Gets Query of Practice Defaults" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="defaultsTbl" required="yes" type="string">

		<cfquery name="qryDefaults" datasource="#arguments.DSN#">
			SELECT
				d.coach_id,
				d.facility_id,
				d.sunday,
				d.monday,
				d.tuesday,
				d.wednesday,
				d.thursday,
				d.friday,
				d.saturday
			FROM
				#arguments.defaultsTbl# d
			WHERE
				d.active_code = 1
		</cfquery>

		<cfreturn qryDefaults>
	</cffunction>

	<cffunction name="deleteCoach" access="public" displayname="Delete Coach" hint="Deletes Coach" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="officerTbl" required="yes" type="string">
		<cfargument name="officer_typeTbl" required="yes" type="string">
		<cfargument name="lookup_cfc" required="yes" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<!--- Validate data --->
		<cfscript>
			if (NOT VAL(arguments.formfields.coach_id))
			{
				var.success.success = "No";
				var.success.reason = "Please select a coach to delete.*";
			}
		</cfscript>


		<cfif NOT var.success.success>
			<cfreturn var.success>
		</cfif>

		<!--- Get officer type id --->
		<cfinvoke
			component="#arguments.lookup_cfc#"
			method="getOfficerTypes"
			returnvariable="qryOfficerTypes"
			dsn=#arguments.DSN#
			officerTypeTbl=#arguments.officer_typeTbl#
			officerType="Coach"
		>

		<!--- Do Delete --->
		<cftransaction>
			<cfquery name="qryUpdate" datasource="#arguments.DSN#">
				UPDATE
					#arguments.officerTbl#
				SET
					date_end = GetDate(),
					active_code = 0,
					modified_user = <cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
					modified_date = GetDate()
				WHERE
					user_id = <cfqueryparam value="#arguments.formfields.coach_id#" cfsqltype="CF_SQL_INTEGER">
					AND officer_type_id = <cfqueryparam value="#qryOfficerTypes.officer_type_id#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
		</cftransaction>

		<cfreturn var.success>
	</cffunction>

	<cffunction name="addCoach" access="public" displayname="Updates Coach" hint="Updates Coach" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="officerTbl" required="yes" type="string">
		<cfargument name="officer_typeTbl" required="yes" type="string">
		<cfargument name="lookup_cfc" required="yes" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<!--- Validate data --->
		<cfscript>
			if (NOT VAL(arguments.formfields.coach_id))
			{
				var.success.success = "No";
				var.success.reason = "Please select a coach.*";
			}
		</cfscript>


		<cfif NOT var.success.success>
			<cfreturn var.success>
		</cfif>

		<!--- Get officer type id --->
		<cfinvoke
			component="#arguments.lookup_cfc#"
			method="getOfficerTypes"
			returnvariable="qryOfficerTypes"
			dsn=#arguments.DSN#
			officerTypeTbl=#arguments.officer_typeTbl#
			officerType="Coach"
		>

		<!--- Do insert --->
		<cftransaction>
			<cfquery name="qryInsert" datasource="#arguments.DSN#">
				INSERT INTO
					#arguments.officerTbl#
				(
					user_id,
					officer_type_id,
					date_start,
					created_user,
					modified_user
				)
				VALUES
				(
					<cfqueryparam value="#arguments.formfields.coach_id#" cfsqltype="CF_SQL_INTEGER">,
					<cfqueryparam value="#qryOfficerTypes.officer_type_id#" cfsqltype="CF_SQL_INTEGER">,
					<cfqueryparam value="#DateFormat(Now(),"M/D/YYYY")#" cfsqltype="CF_SQL_DATE">,
					<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
					<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">
				)
			</cfquery>
		</cftransaction>

		<cfreturn var.success>
	</cffunction>

	<cffunction name="updateFacility" access="public" displayname="Updates Facility" hint="Updates Facility" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="facilityTbl" required="yes" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<!--- Validate data --->
		<cfscript>
			if (NOT LEN(trim(arguments.formfields.facility)))
			{
				var.success.success = "No";
				var.success.reason = "Please enter the facility name.*";
			}
		</cfscript>

		<cfif NOT var.success.success>
			<cfreturn var.success>
		</cfif>

		<!--- Do add or update --->
		<cfif VAL(arguments.formfields.facility_id)>
			<cftransaction>
				<cfquery name="qryUpdate" datasource="#arguments.DSN#">
					UPDATE
						#arguments.facilityTbl#
					SET
						facility = <cfqueryparam value="#arguments.formfields.facility#" cfsqltype="CF_SQL_VARCHAR">,
						modified_user = <cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
						modified_date = GetDate()
					WHERE
						facility_id = <cfqueryparam value="#arguments.formfields.facility_id#" cfsqltype="CF_SQL_INTEGER">
				</cfquery>
			</cftransaction>
		<cfelse>
			<cftransaction>
				<cfquery name="qryInsert" datasource="#arguments.DSN#">
					INSERT INTO
						#arguments.facilityTbl#
					(
						facility,
						created_user,
						modified_user
					)
					VALUES
					(
						<cfqueryparam value="#arguments.formfields.facility#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">
					)
				</cfquery>
			</cftransaction>
		</cfif>

		<cfreturn var.success>
	</cffunction>

	<cffunction name="deleteFacility" access="public" displayname="Delete Facility" hint="Deletes Facility" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="facilityTbl" required="yes" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<!--- Do delete --->
		<cfif VAL(arguments.formfields.facility_id)>
			<cftransaction>
				<cfquery name="qryUpdate" datasource="#arguments.DSN#">
					UPDATE
						#arguments.facilityTbl#
					SET
						active_code = 0,
						modified_user = <cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
						modified_date = GetDate()
					WHERE
						facility_id = <cfqueryparam value="#arguments.formfields.facility_id#" cfsqltype="CF_SQL_INTEGER">
				</cfquery>
			</cftransaction>
		</cfif>

		<cfreturn var.success>
	</cffunction>

	<cffunction name="getPracticeDates" access="public" displayname="Get Practice Dates" hint="Given a date range, gets practice dates in that range" output="No" returntype="array">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="defaultsTbl" required="yes" type="string">
		<cfargument name="date_begin" required="yes" type="string">
		<cfargument name="date_end" required="yes" type="string">

		<cfscript>
			var.aDates = ArrayNew(1);
			var.aDefaults = ArrayNew(1);
			var.dow = "Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday";
			var.numDays = DateDiff("D",arguments.date_begin,arguments.date_end) + 1;
			var.currDate = ParseDateTime(arguments.date_begin);
		</cfscript>

		<!--- Get Default days --->
		<cfinvoke
			component="#this#"
			method="getDefaults"
			returnvariable="qryDefaults"
			dsn=#arguments.DSN#
			defaultsTbl=#arguments.defaultsTbl#
		>

		<cfloop list="#var.dow#" index="i">
			<cfscript>
				if (qryDefaults[i][1] IS "Yes")
				{
					var.aDefaults[ArrayLen(var.aDefaults) + 1] = i;
				}
			</cfscript>
		</cfloop>

		<!--- Now, loop over the date range and see if it's a practice day --->
		<cfloop from="1" to="#var.numDays#" index="i">
			<cfif ListFind(ArrayToList(var.aDefaults,","),DayOfWeekAsString(DayOfWeek(var.currDate)),",")>
				<cfset var.aDates[ArrayLen(var.aDates) + 1] = var.currDate>
			</cfif>
			<cfset var.currDate = DateAdd("D",1,var.currDate)>
		</cfloop>

		<cfreturn var.aDates>
	</cffunction>

	<cffunction name="getAttendanceData" access="public" displayname="Get Attendance Data" hint="Gets the attendnace numbers for a date range, specific days of week, and whether members only are wanted" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="transactionTbl" required="yes" type="string">
		<cfargument name="transactionTypeTbl" required="yes" type="string">
		<cfargument name="fromDate" required="yes" type="string">
		<cfargument name="toDate" required="yes" type="string">
		<cfargument name="dow" required="yes" type="string">
		<cfargument name="includeVisitors" required="no" type="boolean" default="false">

		<cfquery name="qData" datasource="#arguments.dsn#">
			SELECT
				CAST(Year(t.date_transaction) AS varchar(4)) + CASE WHEN Month(t.date_transaction) < 10 THEN '0' ELSE '' END +  CAST(Month(t.date_transaction) AS varchar(2)) AS monthSort,
				DateName(month,t.date_transaction) + ' ' + CAST(Year(t.date_transaction) AS varchar(4)) AS practiceMonth,
				COUNT(t.transaction_id) AS numSwimmers,
				t.date_transaction,
				t.practice_id
			FROM
				#arguments.transactionTbl# t,
				#arguments.transactionTypeTbl# tt
			WHERE
				t.transaction_type_id = tt.transaction_type_id
				AND tt.transaction_type IN
				(
				<cfif arguments.includeVisitors>
					'Visit Workout',
				</cfif>
					'Swim Workout'
				)
				AND t.date_transaction >= <cfqueryparam value="#arguments.fromDate#" cfsqltype="CF_SQL_DATE">
				AND t.date_transaction <= <cfqueryparam value="#arguments.toDate#" cfsqltype="CF_SQL_DATE">
			<cfif arguments.dow IS NOT "ALL">
				AND DatePart(dw,t.date_transaction) IN
				(
					<cfqueryparam value="#arguments.dow#" cfsqltype="CF_SQL_INTEGER" list="Yes" />
				)
			</cfif>
				AND t.active_code = 1
			GROUP BY
				t.date_transaction,
				t.practice_id
			ORDER BY
				t.date_transaction ASC
		</cfquery>

		<cfreturn qData>
	</cffunction>

	<cffunction name="activateCoach" access="public" displayname="activateCoach" hint="Activates or Deactivates a Coach" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="officerTbl" required="yes" type="string">
		<cfargument name="officer_typeTbl" required="yes" type="string">
		<cfargument name="lookup_cfc" required="yes" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<!--- Validate data --->
		<cfscript>
			if (NOT VAL(arguments.formfields.coach_id))
			{
				var.success.success = "No";
				var.success.reason = "Please select a coach to update.*";
			}
		</cfscript>


		<cfif NOT var.success.success>
			<cfreturn var.success>
		</cfif>

		<!--- Get officer type id --->
		<cfinvoke
			component="#arguments.lookup_cfc#"
			method="getOfficerTypes"
			returnvariable="qryOfficerTypes"
			dsn=#arguments.DSN#
			officerTypeTbl=#arguments.officer_typeTbl#
			officerType="Coach"
		>

		<!--- Do Status Change --->
		<cftransaction>
			<cfquery name="qUpdate" datasource="#arguments.DSN#">
				UPDATE
					#arguments.officerTbl#
				SET
				<cfif formfields.active>
					date_end = NULL,
				<cfelse>
					date_end = GetDate(),
				</cfif>
					modified_user = <cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
					modified_date = GetDate()
				WHERE
					user_id = <cfqueryparam value="#arguments.formfields.coach_id#" cfsqltype="CF_SQL_INTEGER">
					AND officer_type_id = <cfqueryparam value="#qryOfficerTypes.officer_type_id#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
		</cftransaction>

		<cfreturn var.success>
	</cffunction>

</cfcomponent>