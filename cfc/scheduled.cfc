<cfcomponent displayname="Scheduled Tasts" hint="Scheduled Tasks">
	<cffunction name="expireMembers" access="public" displayname="Expire Members" hint="Expires Members" output="No" returntype="struct">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="usersTbl" required="yes" type="string">
		<cfargument name="user_statusTbl" required="yes" type="string">
		<cfargument name="lookup_cfc" required="yes" type="string">
		<cfargument name="from_email" required="yes" type="string">
		<cfargument name="unsubscribeURL" required="true" type="string" />
		<cfargument name="encryptionKey" required="true" type="string" />
		<cfargument name="encryptionAlgorithm" required="true" type="string" />
		<cfargument name="encryptionEncoding" required="true" type="string" />

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<!--- Get expired members --->
		<cfquery name="qryExpired" datasource="#arguments.dsn#">
			SELECT
				u.user_id,
				u.last_name,
				u.preferred_name,
				u.email,
				u.date_expiration
			FROM
				#arguments.usersTbl# u,
				#arguments.user_statusTbl# s
			WHERE
				u.user_status_id = s.user_status_id
				AND UPPER(s.status) = 'MEMBER'
				AND u.date_expiration < GetDate()
				AND u.active_code = 1
				AND NOT EXISTS
				(
					SELECT
						us.userID
					FROM
						unsubscribes us
					WHERE
						(
							u.user_id = us.userID
							OR u.email = us.email
						)
						AND us.resubscribeDate IS NULL
				)
		</cfquery>

		<cfif qryExpired.RecordCount GT 0>
			<!--- Get new status type --->
			<cfinvoke
				component="#arguments.lookup_cfc#"
				method="getUserStatuses"
				returnvariable="qryStatus"
				dsn=#arguments.DSN#
				user_statusTbl=#arguments.user_statusTbl#
				status="Swimming Nonmember"
			>

			<!--- Update status of expired swimmers --->
			<cfquery name="qryUpdate" datasource="#arguments.dsn#">
				UPDATE
					#arguments.usersTbl#
				SET
					user_status_id = <cfqueryparam value="#qryStatus.user_status_id#" cfsqltype="CF_SQL_INTEGER">,
					modified_user = 0,
					modified_date = GetDate()
				WHERE
					user_id IN
					(
						<cfqueryparam value="#ValueList(qryExpired.user_id)#" cfsqltype="CF_SQL_INTEGER" list="Yes">
					)
			</cfquery>


			<!--- send e-mail to users --->
			<cfloop query="qryExpired">
				<!--- Get unsubscribe content --->
				<cfset unsubscribeContent = membersCFC.getUnsubscribeContent(arguments.dsn,qryExpired.user_id,arguments.unsubscribeURL,arguments.encryptionKey,arguments.encryptionAlgorithm,arguments.encryptionEncoding) />
				<cfif LEN(TRIM(qryExpired.email)) GT 0>
<cfmail from="#arguments.from_email#" to="#qryExpired.email#" subject="SQUID Membership Expired" server="mail.squidswimteam.org">
#qryExpired.preferred_name#,

#Wrap("Your membership to SQUID expired on #DateFormat(qryExpired.date_expiration,"mmm. d, yyyy")#.  You will no longer have access to the ""Member Area"" of the SQUID web site nor will you receive a newsletter.",72)#
#Wrap("If you would like to renew your membership, please go to the Membership section of the SQUID web site <http://www.squidswimteam.org/> and download the Membership Form PDF.",72)#
#Wrap("If you have any questions, please reply to this e-mail or use the ""Contact Us"" link on the web site.",72)#

#wrap(unsubscribeContent.text,72)#
</cfmail>
				</cfif>
			</cfloop>
		</cfif>

		<cfset var.success.expired = qryExpired>

		<cfreturn var.success>

	</cffunction>

	<cffunction name="sendSwimPassExpirationNotifications" access="public" output="false" returntype="query">
		<cfargument name="dsn" required="true" type="string" />
		<cfargument name="fromAddress" required="true" type="string" />
		<cfargument name="replyToAddress" required="true" type="string" />
		<cfargument name="qExpiredPasses" required="true" type="query" />
		<cfargument name="dropInFee" required="true" type="numeric" />
		<cfargument name="buySwimsURL" required="true" type="string" />

		<cfset local = structNew() />
		<cfset local.qFailedNotifications = queryNew("usersSwimPassID,firstName,lastName,emailAddress,errorMessage,errorDetail,errorTrace","integer,varchar,varchar,varchar,varchar,varchar,varchar") />

		<!--- loop over each record and send the e-mail, marking which ones failed --->
		<cfloop query="arguments.qExpiredPasses">
			<cftry>
				<cfmail from="#arguments.fromAddress#" to="#arguments.qExpiredPasses.email#" replyTo="#arguments.replyToAddress#" subject="Your SQUID swim pass has expired!" server="mail.squidswimteam.org" type="html">
					<p>
						#arguments.qExpiredPasses.first_name#,
					</p>
					<p>
						Your #arguments.qExpiredPasses.swimPass# SQUID swim pass has expired as of #dateFormat(arguments.qExpiredPasses.expirationDate,"mmm. d, yyyy")#. 
						Unless you buy a new pass, you will be charged the #dollarFormat(arguments.dropInFee)# drop-in fee for every practice you attend.  
						We strongly encourage you to buy a new pass now to avoid those charges.
					</p>
					<p>
						You can purchase a new pass or pay your outstanding balance by using the following link:	<a href="#arguments.buySwimsURL#">Buy swim pass</a>
					</p>
					<p>
						If you feel you have received this notification in error, please reply to this message or use the "Contact Us" link on the web site.
					</p>
				</cfmail>

				<!--- Update successful record --->
				<cfquery name="local.qUpdate" datasource="#arguments.dsn#">
					UPDATE usersSwimPasses
					SET expirationNotificationDate = getDate(),
						modified = getDate(),
						modifiedBy = 0
					WHERE usersSwimPassID = <cfqueryparam value="#arguments.qExpiredPasses.usersSwimPassiD#" cfsqltype="cf_sql_int" />
				</cfquery>

				<cfcatch type="any">
					<cfset queryAddRow(local.qFailedNotifications) />
					<cfset querySetCell(local.qFailedNotifications,"usersSwimPassID",arguments.qExpiredPasses.usersSwimPassID,local.qFailedNotifications.recordCount) />
					<cfset querySetCell(local.qFailedNotifications,"firstName",arguments.qExpiredPasses.first_name,local.qFailedNotifications.recordCount) />
					<cfset querySetCell(local.qFailedNotifications,"lastName",arguments.qExpiredPasses.last_name,local.qFailedNotifications.recordCount) />
					<cfset querySetCell(local.qFailedNotifications,"emailAddress",arguments.qExpiredPasses.email,local.qFailedNotifications.recordCount) />
					<cfset querySetCell(local.qFailedNotifications,"errorMessage",cfcatch.message,local.qFailedNotifications.recordCount) />
					<cfset querySetCell(local.qFailedNotifications,"errorDetail",cfcatch.detail,local.qFailedNotifications.recordCount) />
					<cfset querySetCell(local.qFailedNotifications,"errorTrace",cfcatch.tagContext[1].raw_trace,local.qFailedNotifications.recordCount) />
				</cfcatch>
			</cftry>
		</cfloop>
		
		<cfreturn local.qFailedNotifications />
	</cffunction>

	<cffunction name="sendSwimPassExpirationWarnings" access="public" output="false" returntype="query">
		<cfargument name="dsn" required="true" type="string" />
		<cfargument name="fromAddress" required="true" type="string" />
		<cfargument name="replyToAddress" required="true" type="string" />
		<cfargument name="qExpiringPasses" required="true" type="query" />
		<cfargument name="dropInFee" required="true" type="numeric" />
		<cfargument name="buySwimsURL" required="true" type="string" />

		<cfset local = structNew() />
		<cfset local.qFailedNotifications = queryNew("usersSwimPassID,firstName,lastName,emailAddress,errorMessage,errorDetail,errorTrace","integer,varchar,varchar,varchar,varchar,varchar,varchar") />

		<!--- loop over each record and send the e-mail, marking which ones failed --->
		<cfloop query="arguments.qExpiringPasses">
			<cftry>
				<cfmail from="#arguments.fromAddress#" to="#arguments.qExpiringPasses.email#" replyTo="#arguments.replyToAddress#" subject="(#arguments.qExpiringPasses.notificationNumber# Notice) Your SQUID swim pass is expiring soon!" server="mail.squidswimteam.org" type="html">
					<p>
						#arguments.qExpiringPasses.first_name#,
					</p>
					<p>
						Your #arguments.qExpiringPasses.swimPass# SQUID swim pass will expire in #arguments.qExpiringPasses.daysUntilExpiration# 
						day<cfif arguments.qExpiringPasses.daysUntilExpiration NEQ 1>s</cfif> (on #dateFormat(arguments.qExpiringPasses.expirationDate,"mmm. d, yyyy")#). 
						Unless you buy a new pass, you will be charged the #dollarFormat(arguments.dropInFee)# drop-in fee for every practice you attend after your pass expires.  
						We strongly encourage you to buy a new pass now to avoid those charges.
					</p>
					<p>
						You can purchase a new pass or pay your outstanding balance by using the following link:	<a href="#arguments.buySwimsURL#">Buy swim pass</a>
					</p>
					<p>
						If you feel you have received this notification in error, please reply to this message or use the "Contact Us" link on the web site.
					</p>
				</cfmail>

				<!--- Update successful record --->
				<cfquery name="local.qUpdate" datasource="#arguments.dsn#">
					UPDATE usersSwimPasses
					SET 
					<cfif isDate(arguments.qExpiringPasses.expirationWarningDate1)>
						expirationWarningDate2 = getDate(),
					<cfelse>
						expirationWarningDate1 = getDate(),
					</cfif>
						modified = getDate(),
						modifiedBy = 0
					WHERE usersSwimPassID = <cfqueryparam value="#arguments.qExpiringPasses.usersSwimPassiD#" cfsqltype="cf_sql_int" />
				</cfquery>

				<cfcatch type="any">
					<cfset queryAddRow(local.qFailedNotifications) />
					<cfset querySetCell(local.qFailedNotifications,"usersSwimPassID",arguments.qExpiringPasses.usersSwimPassID,local.qFailedNotifications.recordCount) />
					<cfset querySetCell(local.qFailedNotifications,"firstName",arguments.qExpiringPasses.first_name,local.qFailedNotifications.recordCount) />
					<cfset querySetCell(local.qFailedNotifications,"lastName",arguments.qExpiringPasses.last_name,local.qFailedNotifications.recordCount) />
					<cfset querySetCell(local.qFailedNotifications,"emailAddress",arguments.qExpiringPasses.email,local.qFailedNotifications.recordCount) />
					<cfset querySetCell(local.qFailedNotifications,"errorMessage",cfcatch.message,local.qFailedNotifications.recordCount) />
					<cfset querySetCell(local.qFailedNotifications,"errorDetail",cfcatch.detail,local.qFailedNotifications.recordCount) />
					<cfset querySetCell(local.qFailedNotifications,"errorTrace",cfcatch.tagContext[1].raw_trace,local.qFailedNotifications.recordCount) />
				</cfcatch>
			</cftry>
		</cfloop>
		
		<cfreturn local.qFailedNotifications />
	</cffunction>

	<cffunction name="processSwimPassExpirationEmailFailures" access="public" output="false" returntype="void">
		<cfargument name="fromAddress" required="true" type="string" />
		<cfargument name="toAddress" required="true" type="string" />
		<cfargument name="stFailures" required="true" type="struct" />

		<cfset local = structNew() />

		<cfmail from="#arguments.fromAddress#" to="#arguments.toAddress#" subject="Swim Pass Expiration failures" server="mail.squidswimteam.org" type="html">
			<p>
				The following swim pass expiration notifications failed:
			</p>
			<cfif arguments.stFailures.qFailedExpirationNotifications.recordCount GT 0>
				<p>
					<strong>Expiration Notifications:</strong>
				</p>
				<cfloop query="arguments.stFailures.qFailedExpirationNotifications">
						<p>
							User: #arguments.stFailures.qFailedExpirationNotifications.firstName# #arguments.stFailures.qFailedExpirationNotifications.lastName#<br />
							Email: #arguments.stFailures.qFailedExpirationNotifications.emailAddress#<br />
							usersSwimPassID: #arguments.stFailures.qFailedExpirationNotifications.usersSwimPassID#<br />
							Message: #arguments.stFailures.qFailedExpirationNotifications.errorMessage#<br />
							Detail: #arguments.stFailures.qFailedExpirationNotifications.errorDetail#<br />
							Trace: #arguments.stFailures.qFailedExpirationNotifications.errorTrace#
						</p>
				</cfloop>
			</cfif>

			<cfif arguments.stFailures.qFailedExpirationWarnings.recordCount GT 0>
				<p>
					<strong>Expiration Warnings:</strong>
				</p>
				<cfloop query="arguments.stFailures.qFailedExpirationWarnings">
						<p>
							User: #arguments.stFailures.qFailedExpirationWarnings.firstName# #arguments.stFailures.qFailedExpirationWarnings.lastName#<br />
							Email: #arguments.stFailures.qFailedExpirationWarnings.emailAddress#<br />
							usersSwimPassID: #arguments.stFailures.qFailedExpirationWarnings.usersSwimPassID#<br />
							Message: #arguments.stFailures.qFailedExpirationWarnings.errorMessage#<br />
							Detail: #arguments.stFailures.qFailedExpirationWarnings.errorDetail#<br />
							Trace: #arguments.stFailures.qFailedExpirationWarnings.errorTrace#
						</p>
				</cfloop>
			</cfif>
		</cfmail>
		
		<cfreturn />
	</cffunction>

	<cffunction name="processBalanceNotifications" access="public" output="false" returntype="void">
		<cfargument name="dsn" required="true" type="string" />
		<cfargument name="pricePerSwim" required="true" type="numeric" />
		<cfargument name="unsubscribeURL" required="true" type="string" />
		<cfargument name="encryptionKey" required="true" type="string" />
		<cfargument name="encryptionAlgorithm" required="true" type="string" />
		<cfargument name="encryptionEncoding" required="true" type="string" />
		<cfargument name="fromAddress" required="true" type="string" />
		<cfargument name="replyToAddress" required="true" type="string" />

		<cfset var local = structNew() />

		<cfset local.objMembers = createObject("component","squidswimteam.cfc.members") />
		<cfset local.qNotifications = getUserBalanceNotifications(arguments.dsn,arguments.pricePerSwim) />
		<cfset local.qLastNotification = "" />
		<cfset local.unsubscribeContent = "" />
		<cfset local.sendEmail = false />

		<!--- Loop over the query, send out the e-mails, and update the userBalanceNotificationsTable --->
		<cfloop query="local.qNotifications">
			<cfset local.sendEmail = false />
			<!--- If resetNotification, then we need to do some more checks to determine whether to send the e-mail --->
			<cfif NOT local.qNotifications.resetBalanceNotifications>
				<cfset local.qLastNotification = getLastBalanceNotificationByUserID(arguments.dsn,local.qNotifications.user_id) />
				<!--- If it is not recurring and the last notification was a different notification, send the e-mail --->
				<cfif  NOT local.qNotifications.isRepeating AND (local.qLastNotification.recordCount EQ 0 OR local.qLastNotification.balanceNotificationID NEQ local.qNotifications.balanceNotificationID)>
					<cfset local.sendEmail = true />
				<!--- Else if it is recurring and the "rest period" has passed since the last notification, send the e-mail --->
				<cfelseif local.qNotifications.isRepeating AND (local.qLastNotification.recordCount EQ 0 OR dateCompare(dateAdd("d",local.qNotifications.restingPeriodDays,local.qLastNotification.createdDate),now()) LTE 0)>
					<cfset local.sendEmail = true />
				</cfif>
			<!--- Else if resetNotification, send an e-mail --->
			<cfelse>
				<cfset local.sendEmail = true />
			</cfif>
			
			<!--- If ok to send e-mail, send it out, insert record into userBalanceNotifications, and set resetBalanceNotifications = 0 --->
			<cfif local.sendEmail>
				<!--- Get unsubscribe content --->
				<cfset local.unsubscribeContent = local.objMembers.getUnsubscribeContent(arguments.dsn,local.qNotifications.user_id,arguments.unsubscribeURL,arguments.encryptionKey,arguments.encryptionAlgorithm,arguments.encryptionEncoding) />
				<cfmail from="#arguments.fromAddress#" to="#local.qNotifications.email#" replyTo="#arguments.replyToAddress#" subject="SQUID Balance Alert" server="mail.squidswimteam.org" type="html">
					#evaluate(de(local.qNotifications.emailContent))#
					#local.unsubscribeContent.html#
				</cfmail>

				<cfquery name="local.qInsertBalanceNotification" datasource="#arguments.dsn#">
					INSERT INTO userBalanceNotifications
					(
						balanceNotificationID,
						userID,
						createdUser,
						modifiedUser
					)
					VALUES
					(
						<cfqueryparam value="#local.qNotifications.balanceNotificationID#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#local.qNotifications.user_id#" cfsqltype="cf_sql_integer" />,
						0,
						0
					);
					UPDATE users
					SET
						resetBalanceNotifications = 0,
						modified_user = 0,
						modified_date = getDate()
					WHERE
						user_id = <cfqueryparam value="#local.qNotifications.user_id#" cfsqltype="cf_sql_integer" />
				</cfquery>
			</cfif>
		</cfloop>

		<cfreturn />
	</cffunction>

	<cffunction name="getUserBalanceNotifications" access="private" output="false" returntype="query">
		<cfargument name="dsn" required="true" type="string" />
		<cfargument name="pricePerSwim" required="true" type="numeric" />
		
		<cfset var local = structNew() />
		<cfset local.qNotifications = "" />

		<cfquery name="local.qNotifications" datasource="#arguments.dsn#">
			SELECT
				bn.balanceNotificationID,
				bn.notificationName,
				bn.emailContent,
				bn.minimumBalance,
				bn.maximumBalance,
				bn.isRepeating,
				bn.restingPeriodDays,
				u.user_id,
				u.email,
				COALESCE(u.preferred_name,u.last_name) AS first_name,
				u.last_name,
				u.swimBalance,
				u.resetBalanceNotifications,
				s.status
			FROM
				balanceNotifications bn
				INNER JOIN users u ON
					u.swimBalance >= coalesce(bn.minimumBalance, u.swimBalance)
					AND u.swimBalance <= coalesce(bn.maximumBalance, u.swimBalance)
					AND u.active_code = 1
					AND bn.isActive = 1
				INNER JOIN userStatuses s ON
					u.user_status_id = s.user_status_id
					AND UPPER(s.status) = 'MEMBER'
			WHERE
				NOT EXISTS
				(
					SELECT
						us.userID
					FROM
						unsubscribes us
					WHERE
						(
							u.user_id = us.userID
							OR u.email = us.email
						)
						AND us.resubscribeDate IS NULL
				)
			ORDER BY
				u.last_name,
				COALESCE(u.preferred_name,u.last_name)
		</cfquery>

		<cfreturn local.qNotifications />
	</cffunction>

	<cffunction name="getLastBalanceNotificationByUserID" access="private" output="false" returntype="query">
		<cfargument name="dsn" required="true" type="string" />
		<cfargument name="userID" required="true" type="numeric" />
		
		<cfset var local = structNew() />
		<cfset local.qNotification = "" />

		<cfquery name="local.qNotification" datasource="#arguments.dsn#">
			SELECT
				TOP 1
				ubn.balanceNotificationID,
				ubn.createdDate
			FROM
				userBalanceNotifications ubn
				INNER JOIN balanceNotifications bn ON
					ubn.balanceNotificationID = bn.balanceNotificationID
			WHERE
				ubn.userID = <cfqueryparam value="#arguments.userID#" cfsqltype="cf_sql_bigint" />
			ORDER BY
				ubn.createdDate DESC
		</cfquery>

		<cfreturn local.qNotification />
	</cffunction>
</cfcomponent>
