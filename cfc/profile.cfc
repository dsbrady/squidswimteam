<cfcomponent displayname="Profile Components" hint="CFC for Profiles">
	<cffunction name="isValidEmail" access="public" displayname="Is Valid Email" hint="Validates an E-mail address" output="No" returntype="boolean">
		<cfargument name="email" required="Yes" type="string">

		<cfscript>
			var.isValid = true;
			email = UCASE(email);

			var.validChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890@._-,";

			if (len(trim(arguments.email)) GT 0)
			{
				// First, see if there are any invalid characters
				for (i=1; i LTE Len(email); i = i + 1)
				{
					if (NOT Find(MID(email,i,1),var.validChars))
					{
						var.isValid = false;
					}
				}

				// Next, make sure there is 1 and only 1 @ sign
				var.charCount = 0;
				var.startPos = 1;

				while (Find("@",email,var.startPos))
				{
					var.charCount = var.charCount + 1;
					var.startPos = Find("@",email,var.startPos) + 1;
				}

				if (var.charCount NEQ 1)
				{
					var.isValid = false;
				}

				// Next, get the part after the @ sign
				var.domain = Right(email,(Len(email) - Find("@",email)));

				// Make sure there is at least one "."
				var.charCount = 0;
				var.startPos = 1;

				while (Find(".",var.domain,var.startPos))
				{
					var.charCount = var.charCount + 1;
					var.startPos = Find(".",var.domain,var.startPos) + 1;
				}

				if (var.charCount LT 1)
				{
					var.isValid = false;
				}
			}
			else
			{
				var.isValid = false;
			}
		</cfscript>

		<cfreturn var.isValid>
	</cffunction>

	<cffunction name="isValidPassword" access="public" displayname="Is Valid password" hint="Validates a password" output="false" returntype="boolean">
		<cfargument name="password" required="true" type="string" />
		<cfargument name="validPasswordRegularExpression" required="true" type="string" />

		<cfset var local = structNew() />
		<cfset local.isValid = true />

		<cfif len(arguments.password) EQ 0 OR len(reReplace(arguments.password,arguments.validPasswordRegularExpression,"")) GT 0>
			<cfset local.isValid = false />
		</cfif>

		<cfreturn local.isValid />
	</cffunction>

	<cffunction name="updateProfile" access="public" displayname="Updates Profile" hint="Updates Profile" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="image_component" required="no" type="string" default="">
		<cfargument name="usersTbl" required="no" type="string" default="usersTbl">
		<cfargument name="updating_user" required="yes" type="numeric">
		<cfargument name="image_path" required="no" type="string" default="">
		<cfargument name="image_name" required="no" type="string" default="">
		<cfargument name="imageField" required="no" type="string" default="picture">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<!--- Validate data --->
		<cfscript>
			if ((LEN(trim(arguments.formfields.date_expiration)) GT 0) AND (NOT isDate(arguments.formfields.date_expiration)))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter a valid date for the Member Until date.*";
			}
			if ((NOT isValid("email",arguments.formfields.email)))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter a valid e-mail address.*";
			}
			if (NOT LEN(trim(arguments.formfields.first_name)))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter the first name.*";
			}
			if (NOT LEN(trim(arguments.formfields.last_name)))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter the last name.*";
			}
			if ((LEN(trim(arguments.formfields.first_practice)) GT 0) AND (NOT isDate(arguments.formfields.first_practice)))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter a valid date for the first practice.*";
			}
			if ((LEN(trim(formfields.usms_no)) GT 0) AND (LEN(trim(formfields.usms_year)) EQ 0))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter the year for which your USMS Number is valid.*";
			}
			if ((LEN(trim(arguments.formfields.birthday)) GT 0) AND (NOT isDate(arguments.formfields.birthday)))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter a valid date for the birthday.*";
			}
			if (LEN(trim(arguments.formfields.comments)) GT 255)
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "The ""Comments"" field is limited to 255 characters.*";
			}
		</cfscript>

		<cfif NOT var.success.success>
			<cfreturn var.success>
		</cfif>

		<!--- Update unsubscribe status --->
		<cfif arguments.formfields.isUnsubscribed NEQ arguments.formfields.isUnsubscribedPrevious>
			<cfif arguments.formfields.isUnsubscribed>
				<!--- Unsubscribe --->
				<cfquery name="unsubscribe" datasource="#arguments.dsn#">
					INSERT INTO unsubscribes (
						userID,
						email,
						unsubscribeDate,
						resubscribeDate,
						modifiedBy,
						modifiedDate
					)
					VALUES (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.formfields.user_id#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formfields.email#" />,
						GETDATE(),
						NULL,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.updating_user#" />,
						GETDATE()
					)
				</cfquery>
			<cfelse>
				<!--- Resubscribe --->
				<cfquery name="resubscribe" datasource="#arguments.dsn#">
					UPDATE unsubscribes
					SET resubscribeDate = GETDATE(),
						modifiedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.updating_user#" />,
						modifiedDate = GETDATE()
					WHERE (userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.formfields.user_id#" />
						OR email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formfields.email#" />)
						AND resubscribeDate IS NULL
				</cfquery>
			</cfif>
		</cfif>

		<!--- If changing email, see if already exists --->
		<cfif CompareNoCase(arguments.formfields.email,arguments.formfields.username_old) NEQ 0>
			<cftransaction>
				<cfquery name="qryUserName" datasource="#arguments.DSN#">
					SELECT
						u.user_id
					FROM
						#arguments.usersTbl# u
					WHERE
						UPPER(u.email) = <cfqueryparam value="#UCASE(arguments.formfields.email)#" cfsqltype="CF_SQL_VARCHAR">
						AND u.user_id <> <cfqueryparam value="#arguments.formfields.user_id#" cfsqltype="CF_SQL_INTEGER">
						AND u.active_code = 1
				</cfquery>

				<cfif qryUserName.RecordCount>
					<cfset var.success.success = "No">
					<cfset var.success.reason = "The e-mail address you entered is already in use.*">

					<cfreturn var.success>
				</cfif>

				<!--- Update E-mail Address --->
				<cfif arguments.formfields.addNew>
					<cfset arguments.formfields.password = "changeme" & RandRange(10,9999)>
					<cfquery name="qryUpdateUserName" datasource="#arguments.DSN#">
						INSERT INTO
							#arguments.usersTbl#
						(
							email,
							password,
							created_user,
							modified_user
						)
						VALUES
						(
							<cfqueryparam value="#LCASE(arguments.formfields.email)#" cfsqltype="CF_SQL_VARCHAR">,
							<cfqueryparam value="#arguments.formfields.password#" cfsqltype="CF_SQL_VARCHAR">,
							<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
							<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">
						)
					</cfquery>

					<!--- Get new user_id --->
					<cfquery name="qryNewID" datasource="#arguments.dsn#">
						SELECT
							MAX(u.user_id) AS user_id
						FROM
							#arguments.usersTbl# u
						WHERE
							UPPER(u.email) = <cfqueryparam value="#UCASE(arguments.formfields.email)#" cfsqltype="CF_SQL_VARCHAR">
					</cfquery>

					<cfset arguments.formfields.user_id = qryNewID.user_id>
				<cfelse>
					<cfquery name="qryUpdateUserName" datasource="#arguments.DSN#">
						UPDATE
							#arguments.usersTbl#
						SET
							email = <cfqueryparam value="#LCASE(arguments.formfields.email)#" cfsqltype="CF_SQL_VARCHAR">,
							modified_user = <cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
							modified_date = GetDate()
						WHERE
							user_id = <cfqueryparam value="#arguments.formfields.user_id#" cfsqltype="CF_SQL_INTEGER">
					</cfquery>
				</cfif>
			</cftransaction>
			<cfset arguments.image_name = "user" & arguments.formfields.user_id />
		</cfif>

		<!--- If uploading a picture, do so --->
		<cfif TRIM(LEN(arguments.formfields.picture))>
			<cfinvoke
				component="#arguments.image_component#"
				method="uploadPhoto"
				returnvariable="var.success"
				image_path=#arguments.image_path#
				image_name=#arguments.image_name#
				max_width=320
				max_height=320
				overwrite=true
				imageField=#arguments.imageField#
			>
		</cfif>

		<cfif NOT var.success.success>
			<cfreturn var.success>
		</cfif>

		<!--- Update user info --->
		<cfquery name="qryUpdateUserInfo" datasource="#arguments.dsn#">
			UPDATE
				#arguments.usersTbl#
			SET
				user_status_id = <cfqueryparam value="#arguments.formfields.status#" cfsqltype="CF_SQL_INTEGER">,
				first_name = <cfqueryparam value="#arguments.formfields.first_name#" cfsqltype="CF_SQL_VARCHAR">,
				middle_name = <cfqueryparam value="#arguments.formfields.middle_name#" cfsqltype="CF_SQL_VARCHAR">,
				last_name = <cfqueryparam value="#arguments.formfields.last_name#" cfsqltype="CF_SQL_VARCHAR">,
				preferred_name = <cfqueryparam value="#arguments.formfields.preferred_name#" cfsqltype="CF_SQL_VARCHAR">,
				address1 = <cfqueryparam value="#arguments.formfields.address1#" cfsqltype="CF_SQL_VARCHAR">,
				address2 = <cfqueryparam value="#arguments.formfields.address2#" cfsqltype="CF_SQL_VARCHAR">,
				city = <cfqueryparam value="#arguments.formfields.city#" cfsqltype="CF_SQL_VARCHAR">,
				state_id = <cfqueryparam value="#arguments.formfields.state_id#" cfsqltype="CF_SQL_VARCHAR">,
				zip = <cfqueryparam value="#arguments.formfields.zip#" cfsqltype="CF_SQL_VARCHAR">,
				country = <cfqueryparam value="#arguments.formfields.country#" cfsqltype="CF_SQL_VARCHAR">,
				birthday = <cfqueryparam value="#arguments.formfields.birthday#" cfsqltype="CF_SQL_TIMESTAMP" null="#IIF(LEN(arguments.formfields.birthday),DE("NO"),DE("YES"))#">,
				phone_cell = <cfqueryparam value="#arguments.formfields.phone_cell#" cfsqltype="CF_SQL_VARCHAR">,
				phone_day = <cfqueryparam value="#arguments.formfields.phone_day#" cfsqltype="CF_SQL_VARCHAR">,
				phone_night = <cfqueryparam value="#arguments.formfields.phone_night#" cfsqltype="CF_SQL_VARCHAR">,
				fax = <cfqueryparam value="#arguments.formfields.fax#" cfsqltype="CF_SQL_VARCHAR">,
				contact_emergency = <cfqueryparam value="#arguments.formfields.contact_emergency#" cfsqltype="CF_SQL_VARCHAR">,
				phone_emergency = <cfqueryparam value="#arguments.formfields.phone_emergency#" cfsqltype="CF_SQL_VARCHAR">,
				first_practice = <cfqueryparam value="#arguments.formfields.first_practice#" cfsqltype="CF_SQL_TIMESTAMP" null="#IIF(LEN(arguments.formfields.first_practice),DE("NO"),DE("YES"))#">,
				intro_pass = #arguments.formfields.intro_pass#,
				profile_visible = <cfqueryparam value="#VAL(arguments.formfields.profile_visible)#" cfsqltype="CF_SQL_BIT" />,
				date_expiration = <cfqueryparam value="#arguments.formfields.date_expiration# 11:59:59 PM" cfsqltype="CF_SQL_TIMESTAMP" null="#IIF(LEN(arguments.formfields.date_expiration),DE("NO"),DE("YES"))#">,
				usms_number = <cfqueryparam value="#arguments.formfields.usms_no#" cfsqltype="CF_SQL_VARCHAR">,
				usms_year = <cfqueryparam value="#formfields.usms_year#" cfsqltype="CF_SQL_INTEGER" null="#IIF(LEN(TRIM(formfields.usms_year)),DE("No"),DE("Yes"))#" />,
				medical_conditions = <cfqueryparam value="#arguments.formfields.medical_conditions#" cfsqltype="CF_SQL_VARCHAR">,
				email_preference = <cfqueryparam value="#arguments.formfields.email_preference#" cfsqltype="CF_SQL_INTEGER">,
				posting_preference = <cfqueryparam value="#arguments.formfields.posting_preference#" cfsqltype="CF_SQL_INTEGER">,
				mailingListYN = <cfqueryparam value="#VAL(arguments.formfields.mailingListYN)#" cfsqltype="CF_SQL_BIT" />,
				comments = <cfqueryparam value="#arguments.formfields.comments#" cfsqltype="CF_SQL_VARCHAR">,
			<cfif StructKeyExists(var.success,"imageName")>
				picture = <cfqueryparam value="#var.success.imageName#" cfsqltype="CF_SQL_VARCHAR">,
				picture_height = <cfqueryparam value="#var.success.imageHeight#" cfsqltype="CF_SQL_INTEGER">,
				picture_width = <cfqueryparam value="#var.success.imageWidth#" cfsqltype="CF_SQL_INTEGER">,
			</cfif>
				modified_user = <cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
				modified_date = GetDate()
			WHERE
				user_id = <cfqueryparam value="#arguments.formfields.user_id#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>

		<cfreturn var.success>
	</cffunction>

	<cffunction name="updatePreferences" access="public" displayname="Updates Preferences" hint="Updates Preferences" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="usersTbl" required="no" type="string" default="usersTbl">
		<cfargument name="updating_user" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<!--- Update user info --->
		<cfquery name="qryUpdateUserInfo" datasource="#arguments.dsn#">
			UPDATE
				#arguments.usersTbl#
			SET
				email_preference = <cfqueryparam value="#arguments.formfields.email_preference#" cfsqltype="CF_SQL_INTEGER">,
				posting_preference = <cfqueryparam value="#arguments.formfields.posting_preference#" cfsqltype="CF_SQL_INTEGER">,
				modified_user = <cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
				modified_date = GetDate()
			WHERE
				user_id = <cfqueryparam value="#arguments.formfields.user_id#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>

		<cfreturn var.success>
	</cffunction>

	<cffunction name="deletePhoto" access="public" displayname="Deletes Picture" hint="Deletes Picture" output="No" returntype="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="image_component" required="yes" type="string">
		<cfargument name="usersTbl" required="yes" type="string">
		<cfargument name="user_id" required="yes" type="numeric">
		<cfargument name="updating_user" required="yes" type="numeric">
		<cfargument name="image_path" required="no" type="string" default="">
		<cfargument name="image_name" required="no" type="string" default="">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<!--- Delete photo --->
		<cfinvoke
			component="#arguments.image_component#"
			method="deletePhoto"
			returnvariable="var.success"
			image_path=#arguments.image_path#
			image_name=#arguments.image_name#
		>

		<cfif NOT var.success.success>
			<cfreturn var.success>
		</cfif>

		<!--- Update database --->
		<cfquery name="qryUpdateUserPhoto" datasource="#arguments.dsn#">
			UPDATE
				#arguments.usersTbl#
			SET
				picture = NULL,
				picture_height = 0,
				picture_width = 0,
				modified_user = <cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
				modified_date = GetDate()
			WHERE
				user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>

		<cfreturn var.success>
	</cffunction>

	<cffunction name="getExistingUser" access="public" output="false" returntype="query">
		<cfargument name="dsn" required="true" type="string" />
		<cfargument name="email" required="yes" type="string" />

		<cfquery name="local.user" datasource="#arguments.DSN#">
			SELECT
				u.user_id,
				us.status
			FROM
				users u
				INNER JOIN userStatuses us ON u.user_status_id = us.user_status_id
			WHERE
				UPPER(u.email) = <cfqueryparam value="#UCASE(arguments.email)#" cfsqltype="CF_SQL_VARCHAR" />
				AND u.active_code = 1
		</cfquery>

		<cfreturn local.user />
	</cffunction>
</cfcomponent>