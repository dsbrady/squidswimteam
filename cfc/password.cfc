<cfcomponent displayname="Password" hint="CFC for Password Functions">
	<cffunction name="changePassword" access="public" displayname="Changes Password" hint="Changes user password" output="No" returntype="struct">
		<cfargument name="pass_old" required="Yes" type="string">
		<cfargument name="pass" required="Yes" type="string">
		<cfargument name="pass_confirm" required="Yes" type="string">
		<cfargument name="user_id" required="Yes" type="numeric">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="usersTbl" required="no" type="string" default="usersTbl">
		<cfargument name="preferenceTbl" required="yes" type="string">
		<cfargument name="fromEmail" required="yes" type="string">

		<cfset var success = StructNew() />
		<cfscript>
			success.success = "Yes";
			success.reason = "";
		</cfscript>

		<!--- Validate info --->
		<cfscript>
			// Make sure all the fields have something in them
			if (NOT LEN(trim(arguments.pass_old)))
			{
				success.success = "No";
				success.reason = "Please enter your old password.*";
			}
			else if (NOT LEN(trim(arguments.pass)))
			{
				success.success = "No";
				success.reason = "Please enter your new password.*";
			}

			// Make sure new password is different from old password
			else if (arguments.pass IS arguments.pass_old)
			{
				success.success = "No";
				success.reason = "The new password must be different from the old password.*";
			}

			// Make sure two new passwords match and are different from old password
			else if (arguments.pass IS NOT arguments.pass_confirm)
			{
				success.success = "No";
				success.reason = "The new passwords you entered are not the same. Please ensure that they match to confirm your new password.*";
			}

			else
			{
				validChars = 'abcdefghijklmnopqrstuvwxyz1234567890,_';
				hasNumber = false;

				// Make sure new password follows rules (only valid characters, at least one non-letter character)
				for (i=1; i LTE LEN(arguments.pass); i = i + 1)
				{
					checkChar = LCASE(MID(arguments.pass,i,1));

					if (NOT FIND(checkChar,validChars))
					{
						success.success = "No";
						success.reason = "Your password can contain only letters, numbers, a comma, or an underscore.*";
					}
					else if ((VAL(checkChar) EQ checkChar) AND (NOT hasNumber))
					{
						hasNumber = true;
					}
				}

				if (success.success AND (NOT hasNumber))
				{
					success.success = "No";
					success.reason = "Your new password must contain at least 1 number.*";
				}
			}
		</cfscript>

		<cfif NOT success.success>
			<cfreturn success>
		</cfif>

		<!--- Make sure old password is correct --->
		<cfquery name="qryVerifyOld" datasource="#arguments.DSN#">
			SELECT
				u.passwordSalt,
				u.password
			FROM
				#arguments.usersTbl# u
			WHERE
				u.user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>

		<cfif (Hash(pass_old & qryVerifyOld.passwordSalt) NEQ qryVerifyOld.password)>
			<cfscript>
				success.success = "No";
				success.reason = "Your old password is incorrect.*";
			</cfscript>
			<cfreturn success>
		</cfif>

		<!--- Everything's ok, so update password --->
		<cfinvoke
			component="#this#"
			method="updatePassword"
			returnvariable="success"
			user_id=#arguments.user_id#
			updating_user=#arguments.user_id#
			pass=#arguments.pass#
			tempPass=0
			dsn=#arguments.DSN#
			usersTbl=#arguments.usersTbl#
			preferenceTbl=#arguments.preferenceTbl#
			fromEmail=#arguments.fromEmail#
			sendEmail=true
		>

		<cfreturn success>

	</cffunction>

	<cffunction name="updatePassword" access="public" displayname="Updates Password" hint="Updates Password" output="No" returntype="struct">
		<cfargument name="user_id" required="Yes" type="numeric">
		<cfargument name="updating_user" required="Yes" type="numeric">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="usersTbl" required="yes" type="string">
		<cfargument name="preferenceTbl" required="yes" type="string">
		<cfargument name="pass" required="Yes" type="string">
		<cfargument name="tempPass" required="no" default="0" type="boolean">
		<cfargument name="fromEmail" required="yes" type="string">
		<cfargument name="sendEmail" required="yes" type="boolean">

		<cfset var success = StructNew() />
		<cfscript>
			success.success = "Yes";
			success.reason = "";
		</cfscript>

		<cftransaction action="BEGIN">
			<cftry>
				<cfset variables.passSalt = RandRange(1000,9999) />
				<cfquery name="qryUpdate" datasource="#arguments.dsn#">
					UPDATE
						#arguments.usersTbl#
					SET
						password = <cfqueryparam value="#hash(arguments.pass & variables.passSalt)#" cfsqltype="CF_SQL_VARCHAR">,
						passwordSalt = <cfqueryparam value="#variables.passSalt#" cfsqltype="CF_SQL_VARCHAR">,
						tempPassword = <cfqueryparam value="#arguments.tempPass#" cfsqltype="CF_SQL_BIT">,
						modified_user = <cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
						modified_date = GetDate()
					WHERE
						user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="CF_SQL_INTEGER">
				</cfquery>

				<cftransaction action="COMMIT" />

				<cfcatch type="Any">
					<cftransaction action="ROLLBACK" />
					<cfscript>
						success.success = "No";
						success.reason = "There was a database error.*";
					</cfscript>
					<cfreturn success>
				</cfcatch>
			</cftry>
		</cftransaction>

		<!--- Send E-mail to user --->
		<cfif arguments.sendEmail>
			<cfinvoke
				component="#this#"
				method="emailNewPassword"
				user_id=#arguments.user_id#
				dsn=#arguments.DSN#
				usersTbl=#arguments.usersTbl#
				preferenceTbl=#arguments.preferenceTbl#
				fromEmail=#arguments.fromEmail#
				pass=#arguments.pass#
			>
		</cfif>

		<cfreturn success>
	</cffunction>

	<cffunction name="emailNewPassword" access="public" displayname="E-mails New Password to User" hint="E-mails New Password to User" output="No">
		<cfargument name="user_id" required="Yes" type="numeric">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="usersTbl" required="no" type="string" default="usersTbl">
		<cfargument name="preferenceTbl" required="yes" type="string">
		<cfargument name="fromEmail" required="yes" type="string">
		<cfargument name="pass" required="yes" type="string">

		<!--- Get info for e-mail --->
		<cfquery name="qryUser" datasource="#arguments.DSN#">
			SELECT
				u.email,
				p.preference AS email_format,
				u.preferred_name
			FROM
				#arguments.usersTbl# u,
				#arguments.preferenceTbl# p
			WHERE
				u.email_preference = p.preference_id
				AND u.user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>

		<cfif qryUser.RecordCount AND LEN(TRIM(qryUser.email)) GT 0>
<!--- Send e-mail --->
<cfif qryUser.email_format IS "HTML">
<cfmail from="#arguments.fromEmail#" to="#qryUser.email#" subject="SQUID Password Changed" type="HTML" server="mail.squidswimteam.org">
<html>
<head>
	<link media="screen" rel="stylesheet" href="#Request.ss_main#">
</head>
<body>
<p class="plain_text">
	Your SQUID password has been changed. Please keep a record of your new password.
</p>
<p class="plain_text">
	New Password: <strong>#pass#</strong>
</p>
</body>
</html>
</cfmail>
<cfelse>
<cfmail from="#arguments.fromEmail#" to="#qryUser.email#" subject="SQUID Password Changed" server="mail.squidswimteam.org">
Your SQUID password has been changed. Please keep a record of your new password.

New Password: #pass#
</cfmail>
</cfif>
</cfif>
	</cffunction>

	<cffunction name="forgottenPassword" access="public" displayname="Retrieves Forgotten Password" hint="Retrieves Forgotten Password" output="No" returntype="struct">
		<cfargument name="user_name" required="Yes" type="string">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="usersTbl" required="no" type="string" default="usersTbl">
		<cfargument name="preferenceTbl" required="yes" type="string">
		<cfargument name="fromEmail" required="yes" type="string">

		<cfset var success = StructNew() />
		<cfscript>
			success.success = "Yes";
			success.reason = "";
		</cfscript>

		<!--- Validate info --->
		<cfscript>
			// Make sure all the fields have something in them
			if (NOT LEN(trim(arguments.user_name)))
			{
				success.success = "No";
				success.reason = "Please enter your user name.*";
			}
		</cfscript>

		<cfif NOT success.success>
			<cfreturn success>
		</cfif>

		<!--- Get info --->
		<cfquery name="qryPassword" datasource="#arguments.DSN#">
			SELECT
				u.user_id,
				u.email,
				p.preference AS email_format,
				u.preferred_name
			FROM
				#arguments.usersTbl# u,
				#arguments.preferenceTbl# p
			WHERE
				u.email_preference = p.preference_id
				AND UPPER(u.email) = <cfqueryparam value="#UCASE(arguments.user_name)#" cfsqltype="CF_SQL_VARCHAR">
				AND u.active_code = 1
		</cfquery>

		<!--- Set new password --->
		<cfset variables.password = RandRange(100000,999999) />

		<cfif (NOT qryPassword.RecordCount)>
			<cfscript>
				success.success = "No";
				success.reason = "Your user name was not found.*";
			</cfscript>
			<cfreturn success>
		<cfelseif LEN(TRIM(qryPassword.email)) EQ 0>
			<cfscript>
				success.success = "No";
				success.reason = "We do not have your e-mail address on file.  Please use the ""Contact Us"" link for assistance.*";
			</cfscript>
			<cfreturn success>
		</cfif>
		<!--- Update password --->
		<cfinvoke
			component="#this#"
			method="updatePassword"
			returnvariable="success"
			user_id=#qryPassword.user_id#
			updating_user=#qryPassword.user_id#
			pass=#variables.password#
			tempPass=1
			dsn=#arguments.DSN#
			usersTbl=#arguments.usersTbl#
			preferenceTbl=#arguments.preferenceTbl#
			fromEmail=#arguments.fromEmail#
			sendEmail=false
		>

		<!--- Everything's ok, so send e-mail --->
<cfif qryPassword.email_format IS "HTML">
<cfmail from="#arguments.fromEmail#" to="#qryPassword.email#" subject="SQUID Password" type="HTML" server="mail.squidswimteam.org">
<html>
<head>
	<link media="screen" rel="stylesheet" href="#Request.ss_main#">
</head>
<body>
<p class="plain_text">
	You have requested that we send you your SQUID password. For security purposes, we are unable to retrieve users' passwords.  When you forget your password, we
	change your password to a new temporary random password. Your new temporary password is listed below.
</p>
<p class="plain_text">
	Password: <strong>#variables.password#</strong>
</p>
</body>
</html>
</cfmail>
<cfelse>
<cfmail from="#arguments.fromEmail#" to="#qryPassword.email#" subject="SQUID Password" server="mail.squidswimteam.org">
#Wrap("You have requested that we send you your SQUID password. For security purposes, we are unable to retrieve users' passwords.  When you forget your password, we 	change your password to a new temporary random password. Your new temporary password is listed below.",50)#

Your password is listed below.

Password: #variables.password#
</cfmail>
</cfif>

		<cfreturn success>

	</cffunction>

</cfcomponent>