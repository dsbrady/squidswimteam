<cfcomponent displayname="Login" hint="CFC for Login Circuit">
	<cffunction name="checkLogin" access="public" displayname="Check Login" hint="Verifies user login" output="No" returntype="struct">
		<cfargument name="user" required="Yes" type="string">
		<cfargument name="pass" required="Yes" type="string">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="usersTbl" required="no" type="string" default="usersTbl">

		<cfset var strUser = StructNew()>

		<cfscript>
			strUser.success = "Yes";
			strUser.reason = "";
			strUser.username = arguments.user;
		</cfscript>

		<cfquery name="qryUserName" datasource="#arguments.DSN#">
			SELECT
				u.user_id,
				u.passwordSalt
			FROM
				#arguments.usersTbl# u
			WHERE
				active_code = 1
				AND
				(
					UPPER(u.email) = <cfqueryparam value="#UCASE(arguments.user)#" cfsqltype="CF_SQL_VARCHAR">
					OR UPPER(u.username) = <cfqueryparam value="#UCASE(arguments.user)#" cfsqltype="CF_SQL_VARCHAR">
				)
		</cfquery>

		<cfif NOT qryUserName.RecordCount>
			<cfset strUser.success = "No">
			<cfset strUser.reason = "The e-mail/password combination you entered was not found.*">
		<cfelse>
			<cfquery name="qryLogin" datasource="#arguments.DSN#">
				SELECT
					u.user_id
				FROM
					#arguments.usersTbl# u
				WHERE
					u.user_id = <cfqueryparam value="#qryUserName.user_id#" cfsqltype="CF_SQL_INTEGER">
					AND u.password = <cfqueryparam value="#hash(arguments.pass & qryUserName.passwordSalt)#" cfsqltype="CF_SQL_VARCHAR">
			</cfquery>

			<cfif NOT qryLogin.RecordCount>
				<cfset strUser.success = "No">
				<cfset strUser.reason = "The e-mail/password combination you entered was not found.*">
			</cfif>
		</cfif>

		<cfif NOT strUser.success>
			<cfreturn strUser>
		<cfelse>
			<!--- Update last login --->
			<cfquery name="qUpdateLastLogin" datasource="#arguments.DSN#">
				UPDATE
					#arguments.usersTbl#
				SET
					lastLogin = GetDate()
				WHERE
					user_id = <cfqueryparam value="#qryLogin.user_id#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>

			<cfset strUser.user_id = qryLogin.user_id>
		</cfif>

		<cfreturn strUser>
	</cffunction>

<!--- TODO: refactor to get rid of this and use User() instead --->
	<cffunction name="getUser" access="public" displayname="Get User" hint="Get User Info" output="No" returntype="struct">
		<cfargument name="user" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="usersTbl" required="no" type="string" default="usersTbl">
		<cfargument name="developerTbl" required="no" type="string" default="developerTbl">
		<cfargument name="preferenceTbl" required="no" type="string" default="preferenceTbl">
		<cfargument name="testerTbl" required="no" type="string" default="testerTbl">
		<cfargument name="officerTbl" required="no" type="string" default="officerTbl">
		<cfargument name="objectsTbl" required="no" type="string" default="objectsTbl">
		<cfargument name="officer_typeTbl" required="no" type="string" default="officerTypes">
		<cfargument name="officer_permissionTbl" required="no" type="string" default="officer_permissionTbl">
		<cfargument name="user_statusTbl" required="no" type="string" default="user_statusTbl">

		<!--- Get user's permissions --->
		<cfset arguments.user.permissions = this.getUserPermissions(arguments.user.user_id,arguments.objectsTbl,arguments.officerTbl,arguments.officer_permissionTbl,arguments.dsn)>

		<!--- Get user's other info --->
		<cfinvoke
			component="#this#"
			method="getUserInfo"
			returnvariable="arguments.user"
			user=#arguments.user#
			dsn=#arguments.DSN#
			usersTbl=#arguments.usersTbl#
			developerTbl=#arguments.developerTbl#
			preferenceTbl=#arguments.preferenceTbl#
			testerTbl=#arguments.testerTbl#
			user_statusTbl=#arguments.user_statusTbl#
		>

		<!--- Get user's officer info --->
		<cfinvoke
			component="#this#"
			method="getUserOfficerInfo"
			returnvariable="arguments.user"
			user=#arguments.user#
			dsn=#arguments.DSN#
			officerTbl=#arguments.officerTbl#
			officerTypeTbl=#arguments.officer_typeTbl#
		>

		<cfreturn arguments.user>
	</cffunction>

<!--- TODO: refactor to get rid of this and use User() instead --->
	<cffunction name="getUserPermissions" access="public" displayname="Get User Permissions" hint="Get User Permissions" output="No" returntype="string">
		<cfargument name="user_id" required="Yes" type="numeric">
		<cfargument name="objectsTbl" required="no" type="string" default="objectsTbl">
		<cfargument name="officerTbl" required="no" type="string" default="officerTbl">
		<cfargument name="officer_permissionTbl" required="no" type="string" default="officer_permissionTbl">
		<cfargument name="dsn" required="no" type="string" default="squid">

		<cfquery name="qryPermissions" datasource="#arguments.DSN#">
			SELECT
				obj.object_name
			FROM
				#arguments.officer_permissionTbl# op,
				#arguments.officerTbl# o,
				#arguments.objectsTbl# obj
			WHERE
				o.officer_type_id = op.officer_type_id
				AND op.object_id = obj.object_id
				AND o.user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="CF_SQL_INTEGER">
				AND o.active_code = 1
				AND op.active_code = 1
				AND obj.active_code = 1
		</cfquery>

		<cfreturn ValueList(qryPermissions.object_name,",")>
	</cffunction>

<!--- TODO: refactor to get rid of this and use User() instead --->
	<cffunction name="getUserInfo" access="public" displayname="Get User Info" hint="Get User Info" output="No" returntype="struct">
		<cfargument name="user" required="Yes" type="struct">
		<cfargument name="usersTbl" required="no" type="string" default="usersTbl">
		<cfargument name="preferenceTbl" required="no" type="string" default="preferenceTbl">
		<cfargument name="developerTbl" required="no" type="string" default="developerTbl">
		<cfargument name="testerTbl" required="no" type="string" default="testerTbl">
		<cfargument name="user_statusTbl" required="no" type="string" default="user_statusTbl">
		<cfargument name="dsn" required="no" type="string" default="squid">

		<cfquery name="qryUserInfo" datasource="#arguments.DSN#">
			SELECT
				u.username,
				u.first_name,
				u.middle_name,
				u.last_name,
				u.preferred_name,
				u.phone_cell,
				u.email,
				u.email_preference,
				ep.preference AS emailPref,
				u.posting_preference,
				pp.preference AS postingPref,
				u.calendar_preference,
				cp.preference AS calendarPref,
				u.address1,
				u.address2,
				u.city,
				u.state_id,
				u.zip,
				u.country,
				u.phone_day,
				u.phone_night,
				u.fax,
				u.comments,
				u.first_practice,
				u.medical_conditions,
				u.contact_emergency,
				u.phone_emergency,
				u.birthday,
				u.usms_number,
				u.usms_year,
				u.intro_pass,
				u.picture,
				u.picture_height,
				u.picture_width,
				u.date_expiration,
				u.profile_visible,
				u.user_status_id,
				st.status,
				u.tempPassword,
				u.mailingListYN,
				u.created_date,
				u.created_user
			FROM
				#arguments.usersTbl# u
				INNER JOIN #arguments.preferenceTbl# ep
					ON ep.preference_id = u.email_preference
				INNER JOIN #arguments.preferenceTbl# pp
					ON pp.preference_id = u.posting_preference
				INNER JOIN #arguments.preferenceTbl# cp
					ON cp.preference_id = u.calendar_preference
				INNER JOIN #arguments.user_statusTbl# st
					ON st.user_status_id = u.user_status_id
			WHERE
				u.user_id = <cfqueryparam value="#arguments.user.user_id#" cfsqltype="CF_SQL_INTEGER">
				AND u.active_code = 1
		</cfquery>

		<cfscript>
			arguments.user.username = qryUserInfo.username;
			arguments.user.first_name = qryUserInfo.first_name;
			arguments.user.middle_name = qryUserInfo.middle_name;
			arguments.user.last_name = qryUserInfo.last_name;
			arguments.user.preferred_name = qryUserInfo.preferred_name;
			arguments.user.phone_cell = qryUserInfo.phone_cell;
			arguments.user.email = qryUserInfo.email;
			arguments.user.email_preference = qryUserInfo.email_preference;
			arguments.user.emailPref = qryUserInfo.emailPref;
			arguments.user.posting_preference = qryUserInfo.posting_preference;
			arguments.user.postingPref = qryUserInfo.postingPref;
			arguments.user.calendar_preference = qryUserInfo.calendar_preference;
			arguments.user.calendarPref = qryUserInfo.calendarPref;
			arguments.user.address1 = qryUserInfo.address1;
			arguments.user.address2 = qryUserInfo.address2;
			arguments.user.city = qryUserInfo.city;
			arguments.user.state_id = qryUserInfo.state_id;
			arguments.user.zip = qryUserInfo.zip;
			arguments.user.country = qryUserInfo.country;
			arguments.user.phone_day = qryUserInfo.phone_day;
			arguments.user.phone_night = qryUserInfo.phone_night;
			arguments.user.fax = qryUserInfo.fax;
			arguments.user.comments = qryUserInfo.comments;
			arguments.user.first_practice = qryUserInfo.first_practice;
			arguments.user.medical_conditions = qryUserInfo.medical_conditions;
			arguments.user.contact_emergency = qryUserInfo.contact_emergency;
			arguments.user.phone_emergency = qryUserInfo.phone_emergency;
			arguments.user.birthday = qryUserInfo.birthday;
			arguments.user.usms_number = qryUserInfo.usms_number;
			arguments.user.usms_year = qryUserInfo.usms_year;
			arguments.user.intro_pass = qryUserInfo.intro_pass;
			arguments.user.picture = qryUserInfo.picture;
			arguments.user.picture_height = qryUserInfo.picture_height;
			arguments.user.picture_width = qryUserInfo.picture_width;
			arguments.user.status = qryUserInfo.user_status_id;
			arguments.user.statusType = qryUserInfo.status;
			arguments.user.tempPassword = qryUserInfo.tempPassword;
			arguments.user.date_expiration = qryUserInfo.date_expiration;
			arguments.user.profile_visible = qryUserInfo.profile_visible;
			arguments.user.created_date = qryUserInfo.created_date;
			arguments.user.created_user = qryUserInfo.created_user;
			arguments.user.mailingListYN = qryUserInfo.mailingListYN;
		</cfscript>

		<cfreturn arguments.user>
	</cffunction>

	<cffunction name="getUserOfficerInfo" access="public" displayname="Get User's Officer Info" hint="Get User's Officer Info" output="No" returntype="struct">
		<cfargument name="user" required="Yes" type="struct">
		<cfargument name="officerTbl" required="no" type="string" default="officers">
		<cfargument name="officer_typeTbl" required="no" type="string" default="officerTypes">
		<cfargument name="dsn" required="no" type="string" default="squid">

		<cfquery name="qryOfficerInfo" datasource="#arguments.DSN#">
			SELECT
				o.officer_type_id,
				ot.officer_type,
				ot.profile,
				o.date_start,
				o.date_end
			FROM
				#arguments.officer_typeTbl# ot,
				#arguments.officerTbl# o
			WHERE
				o.officer_type_id = ot.officer_type_id
				AND o.user_id = <cfqueryparam value="#arguments.user.user_id#" cfsqltype="CF_SQL_INTEGER">
				AND o.active_code = 1
		</cfquery>

		<cfset arguments.user.officer = ArrayNew(1)>

		<cfloop query="qryOfficerInfo">
			<cfscript>
				i = ArrayLen(arguments.user.officer) + 1;
				arguments.user.officer[i] = StructNew();
				arguments.user.officer[i].officer_type_id = qryOfficerInfo.officer_type_id;
				arguments.user.officer[i].officer_type = qryOfficerInfo.officer_type;
				arguments.user.officer[i].officer_profile = qryOfficerInfo.profile;
				arguments.user.officer[i].date_start = qryOfficerInfo.date_start;
				arguments.user.officer[i].date_end = qryOfficerInfo.date_end;
			</cfscript>
		</cfloop>

		<cfreturn arguments.user>
	</cffunction>
	<cffunction name="logout" access="public" displayname="Logout" hint="Logout" output="No">
		<cfargument name="structKey" required="Yes" type="string">

		<!--- Clear out session --->
		<cfscript>
			StructDelete(Session,arguments.structKey);
		</cfscript>
	</cffunction>
</cfcomponent>