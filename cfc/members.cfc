<cfcomponent displayname="Members Components" hint="CFC for Members">
	<cffunction name="updateOfficer" access="public" displayname="Update Officer" hint="Updates Officer" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="officerTbl" required="yes" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<cftransaction>
			<cfloop list="#arguments.formfields.user_id_old#" index="oldUser">
				<cfif ListFind(arguments.formfields.user_id,oldUser)>
					<cfset arguments.formfields.user_id = ListDeleteAt(arguments.formfields.user_id,ListFind(arguments.formfields.user_id,oldUser))>
				<cfelse>
					<cfquery name="qryRemoveOld" datasource="#arguments.dsn#">
						UPDATE
							#arguments.officerTbl#
						SET
							active_code = 0,
							modified_user = <cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
							modified_date = GetDate(),
							date_end = GetDate()
						WHERE
							officer_type_id = <cfqueryparam value="#VAL(arguments.formfields.officer_type_id)#" cfsqltype="CF_SQL_INTEGER">
							AND user_id = <cfqueryparam value="#VAL(oldUser)#" cfsqltype="CF_SQL_INTEGER">
							AND active_code = 1
					</cfquery>
				</cfif>
			</cfloop>
			<cfloop list="#arguments.formfields.user_id#" index="newUser">
				<!--- Insert into database --->
				<cfquery name="qryInsert" datasource="#arguments.DSN#">
					INSERT INTO
						#arguments.officerTbl#
					(
						officer_type_id,
						user_id,
						date_start,
						created_user,
						modified_user
					)
					VALUES
					(
						<cfqueryparam value="#VAL(arguments.formfields.officer_type_id)#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#VAL(newUser)#" cfsqltype="CF_SQL_INTEGER">,
						GetDate(),
						<cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">
					)
				</cfquery>
			</cfloop>

		</cftransaction>

		<cfreturn var.success>
	</cffunction>

	<cffunction name="payDues" access="public" displayname="payDues" hint="Pays Dues" output="No" returntype="struct">
		<cfargument name="dsn" required="no" type="string" default="squid" />
		<cfargument name="transactionTbl" required="yes" type="string" />
		<cfargument name="formfields" required="yes" type="struct" />
		<cfargument name="updating_user" required="yes" type="numeric" />
		<cfargument name="stDues" required="yes" type="struct" />

		<cfscript>
			var success = StructNew();
			success.success = "Yes";
			success.reason = "";
		</cfscript>

		<!--- Insert into database and get transaction_id --->
		<cftransaction isolation="SERIALIZABLE">
			<cfquery name="qInsert" datasource="#dsn#">
				INSERT INTO
					#transactionTbl#
				(
					member_id,
					duesYear,
					date_transaction,
					membershipFee,
					paymentConfirmed,
					notes,
					created_user,
					modified_user
				)
				VALUES
				(
					<cfqueryparam value="#VAL(formfields.user_id)#" cfsqltype="CF_SQL_INTEGER">,
					<cfqueryparam value="#VAL(arguments.stDues.membershipYear[arguments.stDues.duesIndex])#" cfsqltype="CF_SQL_INTEGER">,
					GetDate(),
					<cfqueryparam value="#VAL(arguments.stDues.fee[arguments.stDues.duesIndex])#" cfsqltype="CF_SQL_NUMERIC">,
					<cfqueryparam value="0" cfsqltype="CF_SQL_BIT">,
					<cfqueryparam value="Paypal Pending" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#VAL(updating_user)#" cfsqltype="CF_SQL_INTEGER">,
					<cfqueryparam value="#VAL(updating_user)#" cfsqltype="CF_SQL_INTEGER">
				)
			</cfquery>

			<cfquery name="qNewID" datasource="#DSN#">
				SELECT
					MAX(transaction_id) AS newID
				FROM
					#transactionTbl#
				WHERE
					member_id = <cfqueryparam value="#VAL(formfields.user_id)#" cfsqltype="CF_SQL_INTEGER">
					AND created_user = <cfqueryparam value="#VAL(updating_user)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>

			<cfset success.transaction_id = qNewID.newID />
		</cftransaction>

		<cfreturn success />
	</cffunction>

	<cffunction name="payDuesConfirm" access="public" displayname="payDuesConfirm" hint="Updates Membership Info after Paying Dues" output="No" returntype="struct">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="usersTbl" required="yes" type="string" />
		<cfargument name="user_statusTbl" required="yes" type="string" />
		<cfargument name="lookupCFC" required="yes" type="lookup_queries" />
		<cfargument name="userID" required="yes" type="numeric" />
		<cfargument name="expirationYear" required="true" type="numeric" />
		<cfargument name="notes" required="true" type="string" />
		<cfargument name="squidTransactionID" required="true" type="numeric" />

		<cfscript>
			var success = StructNew();
			success.success = "Yes";
			success.reason = "";
		</cfscript>

		<!--- Get Status Type --->
		<cfset qStatus = lookupCFC.getUserStatuses(dsn,user_statusTbl,"Member",0) />

		<!--- Update database --->
		<cfquery name="qUpdate" datasource="#dsn#">
			UPDATE
				#usersTbl#
			SET
				user_status_id = <cfqueryparam value="#qStatus.user_status_id#" cfsqltype="CF_SQL_INTEGER" />,
				date_expiration = <cfqueryparam value="#CreateDateTime(arguments.expirationYear,12,31,23,59,59)#" cfsqltype="CF_SQL_TIMESTAMP" />,
				modified_user = <cfqueryparam value="#arguments.userID#" cfsqltype="CF_SQL_INTEGER" />,
				modified_date = GetDate()
			WHERE
				user_id = <cfqueryparam value="#arguments.userID#" cfsqltype="CF_SQL_INTEGER" />
		</cfquery>

		<cfquery name="qUpdate2" datasource="#arguments.dsn#">
			UPDATE
				membershipTransactions
			SET
				member_id = <cfqueryparam value="#arguments.userID#" cfsqltype="CF_SQL_INTEGER" />,
				paymentconfirmed = <cfqueryparam value="1" cfsqltype="CF_SQL_BIT" />,
				notes = <cfqueryparam value="#arguments.notes#" cfsqltype="CF_SQL_VARCHAR" />,
				modified_date = GetDate(),
				modified_user = <cfqueryparam value="#VAL(arguments.userID)#" cfsqltype="CF_SQL_INTEGER" />
			WHERE
				transaction_id = <cfqueryparam value="#VAL(arguments.squidTransactionID)#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>

		<cfreturn success />
	</cffunction>

	<cffunction name="payDuesEmail" access="public" displayname="payDuesEmail" hint="Generates e-mail content after paying dues" output="No" returntype="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="usersTbl" required="yes" type="string">
		<cfargument name="qMember" required="yes" type="query">
		<cfargument name="stPayPal" required="yes" type="struct" />
		<cfargument name="expirationYear" required="yes" type="numeric" />
		<cfargument name="numSwims" default="0" type="numeric" />

		<cfset var genContent = StructNew() />
		<cfset var sameContent = "" />

		<cfscript>
sameContent = "
User Name:		#qMember.email#
Name:			#qMember.preferred_name# #qMember.last_name#
Paid Through:		#arguments.expirationYear#
";
if (val(arguments.numSwims) GT 0)
{
	sameContent &= "Swims Purchased:	#VAL(arguments.numSwims)#
";
}
sameContent &= "Cost:			#DollarFormat(VAL(arguments.stPayPal.amt))#
PayPal Transaction ID:	#arguments.stPayPal.transactionID#
";

genContent.userMail = "
#qMember.preferred_name#,

#wrap("You have successfully paid for your SQUID membership through " & arguments.expirationYear & "  via PayPal.  The details of your transaction are below.",60)#
#chr(10)##chr(13)#
#chr(10)##chr(13)#
#sameContent#
#chr(10)##chr(13)#
#chr(10)##chr(13)#
If you have any questions, please contact us at <squid@squidswimteam.org>.
";

genContent.squidMail = "
#wrap("#qMember.preferred_name# #qMember.last_name# has paid for their SQUID membership through "  & arguments.expirationYear & " via PayPal.  The details of the transaction are below.",60)#
#chr(10)##chr(13)#
#chr(10)##chr(13)#
#sameContent#
";
		</cfscript>

		<cfreturn genContent />
	</cffunction>

	<cffunction name="addUser" access="public" displayname="addUser" hint="Adds User" output="No" returntype="numeric">
		<cfargument name="formfields" required="yes" type="struct" />
		<cfargument name="userTbl" required="yes" type="string" />
		<cfargument name="user_statusTbl" required="yes" type="string" />
		<cfargument name="lookupCFC" required="yes" type="lookup_queries" />
		<cfargument name="dsn" required="no" type="string" default="squid" />

		<!--- Get password --->
		<cfset stPassword = getPassword() />

		<!--- Set temporary expiration --->
		<cfset expirationDate = CreateDateTime(Year(Now()) - 1,12,31,23,59,59) />

		<!--- Get Status Type --->
		<cfset qStatus = lookupCFC.getUserStatuses(dsn,user_statusTbl,"Member",0) />

		<cfif arguments.formfields.preferred_name IS "">
			<cfset arguments.formfields.preferred_name = arguments.formfields.first_name />
		</cfif>

		<!--- Insert into database and get user_id --->
		<cftransaction isolation="SERIALIZABLE">
			<cfquery name="qInsert" datasource="#dsn#">
				INSERT INTO
					#userTbl#
				(
					password,
					passwordSalt,
					first_name,
					middle_name,
					last_name,
					preferred_name,
					phone_cell,
					email,
					address1,
					address2,
					city,
					state_id,
					zip,
					country,
					phone_day,
					phone_night,
					fax,
					medical_conditions,
					contact_emergency,
					phone_emergency,
					birthday,
					user_status_id,
					usms_number,
					date_expiration,
					created_user,
					modified_user
				)
				VALUES
				(
					<cfqueryparam value="#Hash(stPassword.password & stPassword.salt)#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#stPassword.salt#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#formfields.first_name#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#formfields.middle_name#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#formfields.last_name#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#formfields.preferred_name#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#formfields.phone_cell#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#formfields.email#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#formfields.address1#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#formfields.address2#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#formfields.city#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#formfields.state_id#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#formfields.zip#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#formfields.country#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#formfields.phone_day#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#formfields.phone_night#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#formfields.fax#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#formfields.medical_conditions#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#formfields.contact_emergency#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#formfields.phone_emergency#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#formfields.birthday#" cfsqltype="CF_SQL_TIMESTAMP" null="#IIF(LEN(formfields.birthday),DE("NO"),DE("YES"))#">,
					<cfqueryparam value="#qStatus.user_status_id#" cfsqltype="CF_SQL_INTEGER" />,
					<cfqueryparam value="#formfields.usms_no#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#CreateODBCDateTime(expirationDate)#" cfsqltype="CF_SQL_TIMESTAMP">,
					0,
					0
				)
			</cfquery>

			<cfquery name="qNewID" datasource="#DSN#">
				SELECT
					MAX(user_id) AS newID
				FROM
					#userTbl#
				WHERE
					email = <cfqueryparam value="#formfields.email#" cfsqltype="CF_SQL_VARCHAR">
			</cfquery>

			<!--- Update created/modified user --->
			<cfquery name="qUpdate" datasource="#DSN#">
				UPDATE
					#userTbl#
				SET
					created_user = <cfqueryparam value="#VAL(qNewID.newID)#" cfsqltype="CF_SQL_INTEGER">,
					modified_user = <cfqueryparam value="#VAL(qNewID.newID)#" cfsqltype="CF_SQL_INTEGER">
				WHERE
					user_id = <cfqueryparam value="#VAL(qNewID.newID)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
		</cftransaction>

		<cfreturn VAL(qNewID.newID) />
	</cffunction>

	<cffunction name="getPassword" access="private" displayname="getPassword" hint="Gets Password and Salt" output="No" returntype="struct">
		<cfset var stPassword = StructNew() />
		<cfset stPassword.password = RandRange(10000000,99999999) />
		<cfset stPassword.salt = RandRange(1000,9999) />

		<cfreturn stPassword />
	</cffunction>

	<cffunction name="setUserEvent" access="public" displayname="setUserEvent" hint="Sets User Event" output="No" returntype="struct">
		<cfargument name="formfields" required="yes" type="struct" />
		<cfargument name="dsn" required="no" type="string" default="squid" />
		<cfargument name="userEventTbl" required="yes" type="string" />

		<!--- First, validate data --->
		<cfscript>
			var success = valUserEvent(formfields);
		</cfscript>

		<cfif success.success>
			<!--- Either insert or update --->
			<cfif VAL(formfields.eventID)>
				<cfquery name="qUpdate" datasource="#dsn#">
					UPDATE
						#userEventTbl#
					SET
						user_id = <cfqueryparam value="#val(formfields.user_id)#" cfsqltype="CF_SQL_INTEGER" />,
						distanceID = <cfqueryparam value="#formfields.distanceID#" cfsqltype="CF_SQL_INTEGER" />,
						strokeID = <cfqueryparam value="#formfields.strokeID#" cfsqltype="CF_SQL_INTEGER" />,
						distanceTypeID = <cfqueryparam value="#formfields.distanceTypeID#" cfsqltype="CF_SQL_INTEGER" />,
						unitID = <cfqueryparam value="#formfields.unitID#" cfsqltype="CF_SQL_INTEGER" />,
						seedTime = <cfqueryparam value="#convertSeed(formfields.seedTime)#" cfsqltype="CF_SQL_DOUBLE" />,
						eventDate = <cfqueryparam value="#formfields.eventDate#" cfsqltype="CF_SQL_TIMESTAMP" null="#IIF(LEN(TRIM(formfields.eventDate)),DE("NO"),DE("Yes"))#" />,
						eventLocation = <cfqueryparam value="#formfields.eventLocation#" cfsqltype="CF_SQL_VARCHAR" null="#IIF(LEN(TRIM(formfields.eventLocation)),DE("NO"),DE("Yes"))#" />
					WHERE
						eventID = <cfqueryparam value="#VAL(formfields.eventID)#" cfsqltype="CF_SQL_INTEGER" />
				</cfquery>
			<cfelse>
				<cfquery name="qInsert" datasource="#dsn#">
					INSERT INTO
						#userEventTbl#
					(
						user_id,
						distanceID,
						strokeID,
						distanceTypeID,
						unitID,
						seedTime,
						eventDate,
						eventLocation
					)
					VALUES
					(
						<cfqueryparam value="#val(formfields.user_id)#" cfsqltype="CF_SQL_INTEGER" />,
						<cfqueryparam value="#formfields.distanceID#" cfsqltype="CF_SQL_INTEGER" />,
						<cfqueryparam value="#formfields.strokeID#" cfsqltype="CF_SQL_INTEGER" />,
						<cfqueryparam value="#formfields.distanceTypeID#" cfsqltype="CF_SQL_INTEGER" />,
						<cfqueryparam value="#formfields.unitID#" cfsqltype="CF_SQL_INTEGER" />,
						<cfqueryparam value="#convertSeed(formfields.seedTime)#" cfsqltype="CF_SQL_DOUBLE" />,
						<cfqueryparam value="#formfields.eventDate#" cfsqltype="CF_SQL_TIMESTAMP" null="#IIF(LEN(TRIM(formfields.eventDate)),DE("NO"),DE("Yes"))#" />,
						<cfqueryparam value="#formfields.eventLocation#" cfsqltype="CF_SQL_VARCHAR" null="#IIF(LEN(TRIM(formfields.eventLocation)),DE("NO"),DE("Yes"))#" />
					)
				</cfquery>
			</cfif>
		</cfif>

		<cfreturn success />
	</cffunction>

	<cffunction name="valUserEvent" access="public" displayname="valUserEvent" hint="Validates User Event" output="No" returntype="struct">
		<cfargument name="formfields" required="yes" type="struct" />

		<cfscript>
			var success = StructNew();
			success.success = true;
			success.reason = "";
		</cfscript>

		<cfscript>
			if (LEN(TRIM(formfields.seedTime)) EQ 0 OR NOT isValidSeed(formfields.seedTime))
			{
				success.success = "No";
				success.reason = success.reason & "Please enter a seed time in the format: ""min:sec.00"".*";
			}
		</cfscript>
		<cfreturn success />
	</cffunction>

	<cffunction name="convertSeed" access="private" displayname="Convert Seed" hint="Converts a seed time from min:sec.msec to sec.msec" output="No" returntype="numeric">
		<cfargument name="seedTime" required="Yes" type="string" />

		<cfscript>
			var newTime = 0;
			var aTemp = ArrayNew(1);
			var mins = 0;
			var secs = 0;

			aTemp = ListToArray(seedTime,":");
			if (ArrayLen(aTemp) GT 1)
			{
				mins = VAL(aTemp[1]);
				secs = VAL(aTemp[2]);
			}
			else
			{
				mins = 0;
				secs = VAL(seedTime);
			}

			newTime = (mins * 60) + secs;
		</cfscript>

		<cfreturn newTime />
	</cffunction>

	<cffunction name="convertSeed2minutes" access="public" displayname="Convert Seed to Minutes" hint="Converts a seed time to min:sec.msec from sec.msec" output="No" returntype="string">
		<cfargument name="seedTime" required="Yes" type="string" />
		<cfscript>
			var newTime = "";
			var mins = 0;
			var secs = 0;
			var msecs = 0;
			var secsTmp = 0;

			if (VAL(seedTime) EQ 0)
			{
				newTime = seedTime;
			}
			else
			{
				mins = (VAL(seedTime) \ 60);
				secs = VAL(seedTime) - (mins * 60);

				newTime = mins & ":" & NumberFormat(secs,"00.00");
			}
		</cfscript>

		<cfreturn newTime />
	</cffunction>

	<cffunction name="isValidSeed" access="private" displayname="isValidSeed" hint="Validates a seed time" output="No" returntype="boolean">
		<cfargument name="seedTime" required="Yes" type="string" />

		<cfscript>
			var isValid = true;
			var aTemp = ListToArray(seedTime,":");
			var mins = 0;
			var secs = 0;
			var msecs = 0;

			if (ArrayLen(aTemp) GT 2)
			{
				isValie = false;
			}
			else
			{
				if (ArrayLen(aTemp) NEQ 2)
				{
					mins = 0;
					aTemp = ListToArray(aTemp[1],".");
				}
				else
				{
					mins = VAL(aTemp[1]);
					aTemp = ListToArray(aTemp[2],".");
				}
				if (ArrayLen(aTemp) NEQ 2)
				{
					isValid = false;
				}
				else
				{
					secs = VAL(aTemp[1]);
					msecs = VAL(aTemp[2]);
					if ((mins LT 0) OR (secs LT 0) OR (msecs LT 0))
					{
						isValid = false;
					}
				}
			}
		</cfscript>

		<cfreturn isValid />
	</cffunction>

	<cffunction name="getUnsubscribeContent" access="public" hint="Generates the text and link for the unsubscribe content at the bottom of e-mails" output="false" returntype="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="userID" required="true" type="numeric" />
		<cfargument name="unsubscribeURL" required="true" type="string" />
		<cfargument name="encryptionKey" required="true" type="string" />
		<cfargument name="encryptionAlgorithm" required="true" type="string" />
		<cfargument name="encryptionEncoding" required="true" type="string" />

		<cfset var cfc = structNew() />
		<cfset cfc.qUser = "" />

		<cfset cfc.content = structNew() />
		<cfset cfc.content.text = "" />
		<cfset cfc.content.html = "" />
		<cfset cfc.link = arguments.unsubscribeURL />

		<!--- Get the user's e-mail and password salt to be used to generate an encrypted link --->
		<cfquery name="cfc.qUser" datasource="#arguments.dsn#">
			SELECT
				u.passwordSalt,
				u.email
			FROM
				users u
			WHERE
				u.user_id = <cfqueryparam value="#arguments.userID#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfif cfc.qUser.recordCount>
			<cfset cfc.link = cfc.link & encrypt(arguments.userID & "|" & cfc.qUser.passwordSalt & "|" & cfc.qUser.email,arguments.encryptionKey,arguments.encryptionAlgorithm,arguments.encryptionEncoding) />
			<cfset cfc.content.text = "To unsubscribe from all SQUID mailings, please use the following link: " />
			<cfset cfc.content.text = cfc.content.text & "<#cfc.link#>" />
			<cfset cfc.content.html = "<p>To unsubscribe from all SQUID mailings, please use this <a href=""#cfc.link#"">Unsubscribe</a> link or copy and paste the following URL into your browser:<br />" />
			<cfset cfc.content.html = cfc.content.html & "#cfc.link#</p>" />
		</cfif>

		<cfreturn cfc.content />
	</cffunction>

	<cffunction name="unsubscribe" access="public" hint="Unsubscribes a user" output="false" returntype="struct">
		<cfargument name="dsn" required="true" type="string" />
		<cfargument name="uid" required="true" type="string" />
		<cfargument name="encryptionKey" required="true" type="string" />
		<cfargument name="encryptionAlgorithm" required="true" type="string" />
		<cfargument name="encryptionEncoding" required="true" type="string" />

		<cfset var cfc = structNew() />
		<cfset cfc.qUser = "" />
		<cfset cfc.uidDecrypted = "" />
		<cfset cfc.userID = 0 />
		<cfset cfc.passwordSalt = "" />
		<cfset cfc.email = "" />

		<cfset cfc.results = structNew() />
		<cfset cfc.results.success = true />
		<cfset cfc.results.reason = "" />

		<cftry>
			<cfset cfc.uidDecrypted = decrypt(arguments.uid,arguments.encryptionKey,arguments.encryptionAlgorithm,arguments.encryptionEncoding) />

			<cfcatch type="Any">
				<cfset cfc.results.success = false />
				<cfset cfc.results.reason = "There was a problem processing your unsubscribe link. Please verify the URL and try again.<br><br>If you continue to have problems, please use the Contact Us link below." />
			</cfcatch>
		</cftry>

		<!--- Assuming the decryption worked, continue --->
		<cfif cfc.results.success>
			<cfif listLen(cfc.uidDecrypted,"|") NEQ 3>
				<cfset cfc.results.success = false />
				<cfset cfc.results.reason = "There was a problem processing your unsubscribe link. Please verify the URL and try again.<br><br>If you continue to have problems, please use the Contact Us link below." />
			<cfelse>
				<cfset cfc.userID = ListGetAt(cfc.uidDecrypted,1,"|") />
				<cfset cfc.passwordSalt = ListGetAt(cfc.uidDecrypted,2,"|") />
				<cfset cfc.email = ListGetAt(cfc.uidDecrypted,3,"|") />

				<!--- Verify that the user exists based on the user ID and the username (e-mail doesn't matter for this) --->
				<cfquery name="cfc.qUser" datasource="#arguments.dsn#">
					SELECT
						u.user_id
					FROM
						users u
					WHERE
						u.user_id = <cfqueryparam value="#cfc.userID#" cfsqltype="cf_sql_integer" />
						AND u.passwordSalt = <cfqueryparam value="#cfc.passwordSalt#" cfsqltype="cf_sql_varchar" />
						AND u.email = <cfqueryparam value="#cfc.email#" cfsqltype="cf_sql_varchar" />
				</cfquery>

				<cfif NOT cfc.qUser.recordCount>
					<cfset cfc.results.success = false />
					<cfset cfc.results.reason = "There was a problem processing your unsubscribe link. Please verify the URL and try again.<br><br>If you continue to have problems, please use the Contact Us link below." />
				<cfelse>
					<!--- Now, we need to process the unsubscribe --->
					<cfquery datasource="#arguments.dsn#">
						INSERT INTO
							unsubscribes
						(
							userID,
							email
						)
						VALUES
						(
							<cfqueryparam value="#cfc.userID#" cfsqltype="cf_sql_integer" />,
							<cfqueryparam value="#cfc.email#" cfsqltype="cf_sql_varchar" />
						)
					</cfquery>
				</cfif>
			</cfif>
		</cfif>

		<cfreturn cfc.results />
	</cffunction>

	<cffunction name="mergeUsers" access="public" hint="Merges Users" output="false" returntype="struct">
		<cfargument name="dsn" required="true" type="string" />
		<cfargument name="formfields" required="true" type="struct" />
		<cfargument name="user_status_id" required="true" type="numeric" />

		<cfset var cfc = structNew() />
		<cfset cfc.qMergePracticeTransactions = "" />
		<cfset cfc.qMergeMembershipTransactions = "" />
		<cfset cfc.qUpdatePrimaryUser = "" />
		<cfset cfc.qUpdateSecondaryUser = "" />

		<cfset cfc.results = structNew() />
		<cfset cfc.results.success = true />
		<cfset cfc.results.reason = "Users merged" />

		<cftransaction>
			<!--- Merge practice transactions --->
			<cfquery name="cfc.qMergePracticeTransactions" datasource="#arguments.dsn#">
				UPDATE
					practiceTransactions
				SET
					member_id = <cfqueryparam value="#arguments.formfields.primaryUserID#" cfsqltype="cf_sql_integer" />
				WHERE
					member_id IN (<cfqueryparam value="#arguments.formfields.secondaryUsers#" cfsqltype="cf_sql_integer" list="true" />)
					AND active_code = 1
			</cfquery>

			<!--- Merge membership transactions --->
			<cfquery name="cfc.qMergeMembershipTransactions" datasource="#arguments.dsn#">
				UPDATE
					membershipTransactions
				SET
					member_id = <cfqueryparam value="#arguments.formfields.primaryUserID#" cfsqltype="cf_sql_integer" />
				WHERE
					member_id IN (<cfqueryparam value="#arguments.formfields.secondaryUsers#" cfsqltype="cf_sql_integer" list="true" />)
					AND active_code = 1
			</cfquery>

			<!--- Update primary user's information --->
			<cfquery name="cfc.qUpdatePrimaryUser" datasource="#arguments.dsn#">
				UPDATE
					users
				SET
					first_name = <cfqueryparam value="#arguments.formfields.first_name#" cfsqltype="cf_sql_varchar" />,
					middle_name = <cfqueryparam value="#arguments.formfields.middle_name#" cfsqltype="cf_sql_varchar" />,
					last_name = <cfqueryparam value="#arguments.formfields.last_name#" cfsqltype="cf_sql_varchar" />,
					preferred_name = <cfqueryparam value="#arguments.formfields.preferred_name#" cfsqltype="cf_sql_varchar" />,
					email = <cfqueryparam value="#arguments.formfields.email#" cfsqltype="cf_sql_varchar" />,
					phone_cell = <cfqueryparam value="#arguments.formfields.phone_cell#" cfsqltype="cf_sql_varchar" />,
					phone_day = <cfqueryparam value="#arguments.formfields.phone_day#" cfsqltype="cf_sql_varchar" />,
					phone_night = <cfqueryparam value="#arguments.formfields.phone_night#" cfsqltype="cf_sql_varchar" />,
					fax = <cfqueryparam value="#arguments.formfields.fax#" cfsqltype="cf_sql_varchar" />,
					address1 = <cfqueryparam value="#arguments.formfields.address1#" cfsqltype="cf_sql_varchar" />,
					address2 = <cfqueryparam value="#arguments.formfields.address2#" cfsqltype="cf_sql_varchar" />,
					city = <cfqueryparam value="#arguments.formfields.city#" cfsqltype="cf_sql_varchar" />,
					state_id = <cfqueryparam value="#arguments.formfields.state_id#" cfsqltype="cf_sql_varchar" />,
					zip = <cfqueryparam value="#arguments.formfields.zip#" cfsqltype="cf_sql_varchar" />,
					country = <cfqueryparam value="#arguments.formfields.country#" cfsqltype="cf_sql_varchar" />,
					user_status_id = <cfqueryparam value="#arguments.user_status_id#" cfsqltype="cf_sql_varchar" />,
					date_expiration = <cfqueryparam value="#parseDateTime(arguments.formfields.date_expiration & " 23:59:59")#" cfsqltype="cf_sql_timestamp" null="#len(trim(arguments.formfields.date_expiration)) EQ 0#" />
				WHERE
					user_id = <cfqueryparam value="#arguments.formfields.primaryUserID#" cfsqltype="cf_sql_integer" />
			</cfquery>

			<!--- Deactivate seconday users --->
			<cfquery name="cfc.qUpdateSecondaryUser" datasource="#arguments.dsn#">
				UPDATE
					users
				SET
					email = email + 'OLD',
					active_code = 0
				WHERE
					user_id IN (<cfqueryparam value="#arguments.formfields.secondaryUsers#" cfsqltype="cf_sql_integer" list="true" />)
			</cfquery>
		</cftransaction>

		<cfreturn cfc.results />
	</cffunction>

	<cffunction name="isSelectedOfficer" access="public" hint="Determines if user is given officer type" output="false" returntype="boolean">
		<cfargument name="aOfficer" required="true" type="array" description="user's array of current offices" />
		<cfargument name="officer" required="true" type="string" />

		<cfset var local = structNew() />
		<cfset local.isOfficer = false />

		<cfloop from="1" to="#arrayLen(arguments.aOfficer)#" index="local.i">
			<cfif arguments.aOfficer[local.i].officer_type EQ arguments.officer>
				<cfset local.isOfficer = true />
				<cfbreak />
			</cfif>
		</cfloop>

		<cfreturn local.isOfficer />
	</cffunction>

	<cffunction name="isValidLiabilitySignature" access="public" output="false" returntype="boolean">
		<cfargument name="signature" required="yes" type="string" />
		<cfargument name="firstName" required="yes" type="string" />
		<cfargument name="lastName" required="yes" type="string" />

		<cfset var isValid = true />

		<!--- Make sure the first and last characters of the signature match the first characters of the first and last names --->
		<cfif len(trim(arguments.signature)) EQ 0 OR len(trim(arguments.firstName)) EQ 0 OR len(trim(arguments.lastName)) EQ 0>
			<cfset isValid = false />
		<cfelseif lcase(left(arguments.signature,1)) NEQ lcase(left(arguments.firstName,1)) OR lcase(right(arguments.signature,1)) NEQ lcase(left(arguments.lastName,1))>
			<cfset isValid = false />
		</cfif>

		<cfreturn isValid />
	</cffunction>

	<cffunction name="insertMemberApplication" access="public" output="false" returntype="struct">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="formfields" required="yes" type="struct" />

		<cfset var local = structNew() />
		<cfset local.stResults = structNew() />
		<cfset local.stResults.isSuccessful = true />
		<cfset local.stResults.memberApplicationID = 0 />

		<cfquery name="local.qInsert" datasource="#arguments.dsn#">
			SET NOCOUNT ON;

			INSERT INTO memberApplications
			(
				email,
				firstName,
				middleName,
				lastName,
				preferredName,
				address1,
				address2,
				city,
				stateID,
				country,
				postalCode,
				phone1,
				phoneType1,
				phone2,
				phoneType2,
				mailingList,
				emergencyName,
				emergencyPhone,
				emergencyRelationship,
				liabilitySignature,
				liabilitySignatureDate,
				userID
			)
			values
			(
				<cfqueryparam value="#arguments.formfields.email#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formfields.firstName#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formfields.middleName#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formfields.lastName#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formfields.preferredName#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formfields.address1#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formfields.address2#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formfields.city#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formfields.stateID#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formfields.country#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formfields.zip#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formfields.phone1#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formfields.phoneType1#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formfields.phone2#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formfields.phoneType2#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formfields.mailingList#" cfsqltype="cf_sql_bit" />,
				<cfqueryparam value="#arguments.formfields.emergencyName#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formfields.emergencyPhone#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formfields.emergencyRelation#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formfields.liabilitySignature#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formfields.liabilitySignatureDate#" cfsqltype="cf_sql_date" />,
				0
			);

			SET NOCOUNT OFF;

			SELECT scope_identity() AS memberApplicationID;
		</cfquery>

		<cfset local.stResults.memberApplicationID = local.qInsert.memberApplicationID />

		<cfreturn local.stResults />
	</cffunction>

	<cffunction name="insertMemberApplicationTransaction" access="public" output="false" returntype="numeric">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="formfields" required="yes" type="struct" />
		<cfargument name="stDues" required="yes" type="struct" />
		<cfargument name="userID" required="yes" type="numeric" />

		<cfset var local = structNew() />
		<cfset local.stResults = structNew() />
		<cfset local.stResults.isSuccessful = true />
		<cfset local.stResults.memberApplicationID = 0 />

		<cfquery name="local.qInsert" datasource="#arguments.dsn#">
			SET NOCOUNT ON;

			INSERT INTO membershipTransactions
			(
				member_id,
				duesYear,
				date_transaction,
				membershipFee,
				paymentConfirmed,
				notes,
				created_user,
				modified_user
			)
			VALUES
			(
				<cfqueryparam value="#VAL(arguments.userID)#" cfsqltype="CF_SQL_INTEGER">,
				<cfqueryparam value="#VAL(arguments.stDues.membershipYear[arguments.stDues.duesIndex])#" cfsqltype="CF_SQL_INTEGER">,
				GetDate(),
				<cfqueryparam value="#VAL(arguments.stDues.fee[arguments.stDues.duesIndex])#" cfsqltype="CF_SQL_NUMERIC">,
				<cfqueryparam value="0" cfsqltype="CF_SQL_BIT">,
				<cfqueryparam value="Paypal Pending" cfsqltype="CF_SQL_VARCHAR">,
				0,
				0
			);

			SET NOCOUNT OFF;

			SELECT scope_identity() AS membershipTransactionID;
		</cfquery>

		<cfset local.membershipTransactionID = local.qInsert.membershipTransactionID />

		<cfreturn local.membershipTransactionID />
	</cffunction>

	<cffunction name="addUserFromMembershipApplication" access="public" displayname="addUserFromMembershipApplication" output="false" returntype="numeric">
		<cfargument name="dsn" required="no" type="string" default="squid" />
		<cfargument name="formfields" required="yes" type="struct" />
		<cfargument name="lookupCFC" required="yes" type="lookup_queries" />
		<cfargument name="stDues" required="yes" type="struct" />
		<cfargument name="memberApplicationID" required="yes" type="numeric" />

		<cfset var local = structNew() />

		<!--- Get Status Type --->
		<cfset local.qStatus = arguments.lookupCFC.getUserStatuses(dsn,"userStatuses","Member",0) />

		<!--- Get password salt --->
		<cfset local.salt = RandRange(1000,9999) />

		<!--- Set up phone data --->
		<cfset local.phone_cell = "" />
		<cfset local.phone_day = "" />
		<cfset local.phone_night = "" />

		<cfset local.expirationDate = CreateDateTime(VAL(arguments.stDues.membershipYear[arguments.stDues.duesIndex]),12,31,23,59,59) />

		<cfswitch expression="#arguments.formfields.phoneType1#">
			<cfcase value="cell">
				<cfset local.phone_cell = arguments.formfields.phone1 />
			</cfcase>
			<cfcase value="daytime">
				<cfset local.phone_day = arguments.formfields.phone1 />
			</cfcase>
			<cfcase value="evening">
				<cfset local.phone_night = arguments.formfields.phone1 />
			</cfcase>
		</cfswitch>
		<cfswitch expression="#arguments.formfields.phoneType2#">
			<cfcase value="cell">
				<cfset local.phone_cell = arguments.formfields.phone2 />
			</cfcase>
			<cfcase value="daytime">
				<cfset local.phone_day = arguments.formfields.phone2 />
			</cfcase>
			<cfcase value="evening">
				<cfset local.phone_night = arguments.formfields.phone2 />
			</cfcase>
		</cfswitch>

		<!--- Insert into database and get user_id --->
		<cftransaction isolation="SERIALIZABLE">
			<cfquery name="local.qInsert" datasource="#arguments.dsn#">
				SET NOCOUNT ON;
				INSERT INTO
					users
				(
					password,
					passwordSalt,
					first_name,
					middle_name,
					last_name,
					preferred_name,
					phone_cell,
					email,
					address1,
					address2,
					city,
					state_id,
					zip,
					country,
					phone_day,
					phone_night,
					contact_emergency,
					phone_emergency,
					date_expiration,
					mailingListYN,
					tempPassword,
					user_status_id
				)
				VALUES
				(
					<cfqueryparam value="#Hash(arguments.formfields.password & local.salt)#" cfsqltype="CF_SQL_VARCHAR" />,
					<cfqueryparam value="#local.salt#" cfsqltype="CF_SQL_VARCHAR" />,
					<cfqueryparam value="#arguments.formfields.firstName#" cfsqltype="CF_SQL_VARCHAR" />,
					<cfqueryparam value="#arguments.formfields.middleName#" cfsqltype="CF_SQL_VARCHAR" null="#len(arguments.formfields.middleName) EQ 0#" />,
					<cfqueryparam value="#arguments.formfields.lastName#" cfsqltype="CF_SQL_VARCHAR" />,
					<cfqueryparam value="#arguments.formfields.preferredName#" cfsqltype="CF_SQL_VARCHAR" />,
					<cfqueryparam value="#local.phone_cell#" cfsqltype="CF_SQL_VARCHAR" null="#len(local.phone_cell) EQ 0#" />,
					<cfqueryparam value="#arguments.formfields.email#" cfsqltype="CF_SQL_VARCHAR" />,
					<cfqueryparam value="#arguments.formfields.address1#" cfsqltype="CF_SQL_VARCHAR"/ >,
					<cfqueryparam value="#arguments.formfields.address2#" cfsqltype="CF_SQL_VARCHAR" />,
					<cfqueryparam value="#arguments.formfields.city#" cfsqltype="CF_SQL_VARCHAR" />,
					<cfqueryparam value="#arguments.formfields.stateID#" cfsqltype="CF_SQL_VARCHAR" />,
					<cfqueryparam value="#arguments.formfields.zip#" cfsqltype="CF_SQL_VARCHAR" />,
					<cfqueryparam value="#arguments.formfields.country#" cfsqltype="CF_SQL_VARCHAR" />,
					<cfqueryparam value="#local.phone_day#" cfsqltype="CF_SQL_VARCHAR" null="#len(local.phone_day) EQ 0#" />,
					<cfqueryparam value="#local.phone_night#" cfsqltype="CF_SQL_VARCHAR" null="#len(local.phone_night) EQ 0#" />,
					<cfqueryparam value="#arguments.formfields.emergencyName#" cfsqltype="CF_SQL_VARCHAR" />,
					<cfqueryparam value="#arguments.formfields.emergencyPhone#" cfsqltype="CF_SQL_VARCHAR" />,
					<cfqueryparam value="#CreateODBCDateTime(local.expirationDate)#" cfsqltype="CF_SQL_TIMESTAMP">,
					<cfqueryparam value="#arguments.formfields.mailingList#" cfsqltype="CF_SQL_BIT" />,
					0,
					<cfqueryparam value="#local.qStatus.user_status_id#" cfsqltype="CF_SQL_INTEGER" />
				);

				SET NOCOUNT OFF;

				SELECT scope_identity() AS newUserID;
			</cfquery>

			<cfquery name="local.updateCreatedModifiedUser" datasource="#arguments.dsn#">
				UPDATE users
				SET created_user = user_id,
					modified_user = user_id
				WHERE user_id = <cfqueryparam value="#local.qInsert.newUserID#" cfsqltype="cf_sql_integer" />
			</cfquery>
		</cftransaction>

		<!--- Update the memberApplication table --->
		<cfquery name="local.qUpdateApplication" datasource="#arguments.dsn#">
			UPDATE memberApplications
			SET userID = <cfqueryparam value="#local.qInsert.newUserID#" cfsqltype="cf_sql_integer" />
			WHERE memberApplicationID = <cfqueryparam value="#arguments.memberApplicationID#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn val(local.qInsert.newUserID) />
	</cffunction>

	<cffunction name="removeMemberApplicationData" access="public" output="false" returntype="void">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="userID" required="yes" type="numeric" />
		<cfargument name="membershipTransactionID" required="yes" type="numeric" />
		<cfargument name="memberApplicationID" required="yes" type="numeric" />
		<cfargument name="practiceTransactionID" required="yes" type="numeric" />

		<cfset var local = structNew() />

		<cfquery name="local.deleteUser" datasource="#arguments.dsn#">
			DELETE FROM users
			WHERE user_id = <cfqueryparam value="#arguments.userID#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfquery name="local.deleteUser" datasource="#arguments.dsn#">
			DELETE FROM membershipTransactions
			WHERE transaction_ID = <cfqueryparam value="#arguments.membershipTransactionID#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfquery name="local.deleteUser" datasource="#arguments.dsn#">
			DELETE FROM memberApplications
			WHERE memberApplicationID = <cfqueryparam value="#arguments.memberApplicationID#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfif arguments.practiceTransactionID GT 0>
			<cfquery name="local.deleteUser" datasource="#arguments.dsn#">
				DELETE FROM practiceTransactions
				WHERE transaction_ID = <cfqueryparam value="#arguments.practiceTransactionID#" cfsqltype="cf_sql_integer" />
			</cfquery>
		</cfif>

		<cfreturn />
	</cffunction>

</cfcomponent>
