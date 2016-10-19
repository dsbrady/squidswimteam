<cfcomponent displayname="Registration" hint="Registration Component">
	<cffunction name="getRandomPassword" access="private" displayname="Get Random Password" hint="Gets Random Password" output="No" returntype="string">
		<cfargument name="numberOfCharacters" required="No" default="8" type="numeric">
		<cfset var placeCharacter = "">
		<cfset var currentPlace=0>
		<cfset var group=0>
		<cfset var subGroup=0>

		<cfloop from="1" to="#arguments.numberOfCharacters#" index="currentPlace">
			<cfset group = randRange(1,3)>
			<cfswitch expression="#group#">
				<cfcase value="1">
					<cfset placeCharacter = placeCharacter & chr(randRange(48,57))>
				</cfcase>
				<cfcase value="2">
					<cfset placeCharacter = placeCharacter & chr(randRange(97,122))>
				</cfcase>
				<cfcase value="3">
					<cfset placeCharacter = placeCharacter & chr(randRange(65,90))>
				</cfcase>
			</cfswitch>
		</cfloop>

		<cfreturn placeCharacter />
	</cffunction>

	<cffunction name="isValidEmail" access="private" displayname="Is Valid Email" hint="Validates an E-mail address" output="No" returntype="boolean">
		<cfargument name="email" required="Yes" type="string">

		<cfscript>
			var.isValid = true;
			email = UCASE(email);

			var.validChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890@._-,";

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
		</cfscript>

		<cfreturn var.isValid />
	</cffunction>

	<cffunction name="valMaster" access="public" displayname="Validate Master Registration Form" hint="Validates Master Registration Form" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";

			if (LEN(TRIM(arguments.formfields.first_name)) EQ 0)
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Your first name is required.*";
			}
			if (LEN(TRIM(arguments.formfields.last_name)) EQ 0)
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Your last name is required.*";
			}

			if (LEN(TRIM(arguments.formfields.dob)) EQ 0)
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Your date of birth is required.*";
			}
			else if (NOT isDate(arguments.formfields.dob))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter a valid date of birth.*";
			}

			if (LEN(TRIM(arguments.formfields.Home_daytele)) EQ 0)
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Your phone number is required.*";
			}

			if (LEN(TRIM(arguments.formfields.Home_email)) EQ 0)
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Your e-mail address is required.*";
			}
			else if (NOT isValidEmail(arguments.formfields.Home_email))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter a valid e-mail address.*";
			}
			if (LEN(TRIM(arguments.formfields.Home_addr1)) EQ 0)
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Your address is required.*";
			}
			if (LEN(TRIM(arguments.formfields.Home_city)) EQ 0)
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Your city is required.*";
			}
		</cfscript>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="setMaster" access="public" displayname="Set Master Values" hint="Sets Master Values" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";

			Session.goldrush2009.first_name = arguments.formfields.first_name;
			Session.goldrush2009.initial = arguments.formfields.initial;
			Session.goldrush2009.last_name = arguments.formfields.last_name;
			if (LEN(TRIM(arguments.formfields.pref_name)))
			{
				Session.goldrush2009.pref_name = arguments.formfields.pref_name;
			}
			else
			{
				Session.goldrush2009.pref_name = arguments.formfields.first_name;
			}
			Session.goldrush2009.ath_sex = arguments.formfields.ath_sex;
			Session.goldrush2009.dob = arguments.formfields.dob;
			Session.goldrush2009.home_addr1 = arguments.formfields.home_addr1;
			Session.goldrush2009.home_addr2 = arguments.formfields.home_addr2;
			Session.goldrush2009.home_city = arguments.formfields.home_city;
			Session.goldrush2009.home_country = arguments.formfields.home_country;
			Session.goldrush2009.home_daytele = arguments.formfields.home_daytele;
			Session.goldrush2009.home_email = arguments.formfields.home_email;
			Session.goldrush2009.home_state = arguments.formfields.home_state;
			Session.goldrush2009.home_zip = arguments.formfields.home_zip;
			Session.goldrush2009.registrationType = arguments.formfields.registrationType;
			Session.goldrush2009.master = 1;
		</cfscript>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="updateMaster" access="public" displayname="Update Master Information" hint="Updates Master Information" output="No" returntype="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="registrationTbl" required="yes" type="string">
		<cfargument name="athleteTbl" required="yes" type="string">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<cftransaction>
			<cfquery name="qAth" datasource="#arguments.DSN#">
				UPDATE
					#arguments.athleteTbl#
				SET
					first_name = <cfqueryparam value="#Session.goldrush2009.first_name#" cfsqltype="CF_SQL_VARCHAR">,
					initial = <cfqueryparam value="#Session.goldrush2009.initial#" cfsqltype="CF_SQL_VARCHAR" null="#IIF(LEN(TRIM(Session.goldrush2009.initial)),DE("No"),DE("Yes"))#">,
					last_name = <cfqueryparam value="#Session.goldrush2009.last_name#" cfsqltype="CF_SQL_VARCHAR">,
					pref_name = <cfqueryparam value="#Session.goldrush2009.pref_name#" cfsqltype="CF_SQL_VARCHAR">,
					birth_date = <cfqueryparam value="#Session.goldrush2009.dob#" cfsqltype="CF_SQL_VARCHAR">,
					home_daytele = <cfqueryparam value="#Session.goldrush2009.home_daytele#" cfsqltype="CF_SQL_VARCHAR">,
					home_addr1 = <cfqueryparam value="#Session.goldrush2009.home_addr1#" cfsqltype="CF_SQL_VARCHAR">,
					home_addr2 = <cfqueryparam value="#Session.goldrush2009.home_addr2#" cfsqltype="CF_SQL_VARCHAR" null="#IIF(LEN(TRIM(Session.goldrush2009.home_addr2)),DE("No"),DE("Yes"))#">,
					home_city = <cfqueryparam value="#Session.goldrush2009.home_city#" cfsqltype="CF_SQL_VARCHAR">,
					home_cntry = <cfqueryparam value="#Session.goldrush2009.home_country#" cfsqltype="CF_SQL_VARCHAR">,
					ath_sex = <cfqueryparam value="#Session.goldrush2009.ath_sex#" cfsqltype="CF_SQL_VARCHAR">,
					home_statenew = <cfqueryparam value="#Session.goldrush2009.home_state#" cfsqltype="CF_SQL_VARCHAR">,
					home_zip = <cfqueryparam value="#Session.goldrush2009.home_zip#" cfsqltype="CF_SQL_VARCHAR" null="#IIF(LEN(TRIM(Session.goldrush2009.home_zip)),DE("No"),DE("Yes"))#">,
					Home_email = <cfqueryparam value="#Session.goldrush2009.home_email#" cfsqltype="CF_SQL_VARCHAR">
				WHERE
					ath_no = <cfqueryparam value="#VAL(Session.goldrush2009.athlete_no)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>

			<cfquery name="qReg" datasource="#arguments.DSN#">
				UPDATE
					#arguments.registrationTbl#
				SET
					registrationType = <cfqueryparam value="#ListFirst(Session.goldrush2009.registrationType,"_")#" cfsqltype="CF_SQL_VARCHAR">,
					master = 1
				WHERE
					registration_id = <cfqueryparam value="#VAL(Session.goldrush2009.registration_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
		</cftransaction>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="initializeRegistration" access="public" displayname="Initialize Registration" hint="Initializes Registration and sends e-mail to user" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="registrationTbl" required="yes" type="string">
		<cfargument name="athleteTbl" required="yes" type="string">
		<cfargument name="fromEmail" required="yes" type="string">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<!--- Get password --->
		<cfset newPassword = getRandomPassword(8)>

		<cftransaction>
			<!--- Insert into athlete table --->
			<cfquery name="qAth" datasource="#arguments.DSN#">
				INSERT INTO
					#arguments.athleteTbl#
				(
					first_name,
					last_name,
					Home_email
				)
				VALUES
				(
					<cfqueryparam value="#arguments.formfields.first_name#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#arguments.formfields.last_name#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#arguments.formfields.home_email#" cfsqltype="CF_SQL_VARCHAR">
				)
			</cfquery>

			<!--- Get athlete number --->
			<cfquery name="qAthNO" datasource="#arguments.DSN#">
				SELECT
					MAX(ath_no) AS newID
				FROM
					#arguments.athleteTbl#
				WHERE
					first_name = <cfqueryparam value="#arguments.formfields.first_name#" cfsqltype="CF_SQL_VARCHAR">
					AND last_name = <cfqueryparam value="#arguments.formfields.last_name#" cfsqltype="CF_SQL_VARCHAR">
					AND Home_email = <cfqueryparam value="#arguments.formfields.home_email#" cfsqltype="CF_SQL_VARCHAR">
			</cfquery>

			<!--- Insert into registration table --->
			<cfquery name="qReg" datasource="#arguments.DSN#">
				INSERT INTO
					#arguments.registrationTbl#
				(
					athlete_no,
					password,
					username,
					paymentDue
				)
				VALUES
				(
					<cfqueryparam value="#VAL(qAthNO.newID)#" cfsqltype="CF_SQL_INTEGER">,
					<cfqueryparam value="#variables.newPassword#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#arguments.formfields.home_email#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#DateAdd("D",Request.paymentDaysDue,Now())#" cfsqltype="CF_SQL_TIMESTAMP">
				)
			</cfquery>

			<!--- Get registration id and set session variable --->
			<cfquery name="qRegID" datasource="#arguments.DSN#">
				SELECT
					MAX(registration_id) AS newID
				FROM
					#arguments.registrationTbl#
				WHERE
					password = <cfqueryparam value="#variables.newPassword#" cfsqltype="CF_SQL_VARCHAR">
					AND username = <cfqueryparam value="#arguments.formfields.home_email#" cfsqltype="CF_SQL_VARCHAR">
			</cfquery>
		</cftransaction>

		<cfscript>
			Session.goldrush2009.registration_id = qRegID.newID;
			Session.goldrush2009.athlete_no = qAthNo.newID;
			Session.goldrush2009.password = variables.newPassword;
			Session.goldrush2009.first_name = arguments.formfields.first_name;
			Session.goldrush2009.home_email = arguments.formfields.home_email;
			Session.goldrush2009.paymentDue = DateAdd("D",Request.paymentDaysDue,Now());
			if (LEN(TRIM(arguments.formfields.pref_name)))
			{
				Session.goldrush2009.pref_name = arguments.formfields.pref_name;
			}
			else
			{
				Session.goldrush2009.pref_name = arguments.formfields.first_name;
			}
		</cfscript>

		<!--- Send e-mail to user --->
		<cfset var.successs = sendUserPassword(arguments.fromEmail,session.goldrush2009)>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="sendUserPassword" access="private" displayname="Send User Password" hint="Sends User Password" output="No" returntype="struct">
		<cfargument name="fromEmail" required="yes" type="string">
		<cfargument name="strData" required="yes" type="struct">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

<cfmail from="#arguments.fromEmail#" to="#strData.home_email#" subject="SQUID Long Course Challenge Password" server="mail.squidswimteam.org">
#strData.pref_name#,

#wrap("Here is your password for updating your registration information for the 2004 SQUID Long Course Challenge:",50)#

#strData.password#

#wrap("If you have any questions, please contact us at #arguments.fromEmail#",50)#
</cfmail>
		<cfreturn var.success />
	</cffunction>

	<cffunction name="valLogin" access="public" displayname="Validate Login" hint="Validates Login" output="No" returntype="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="formfields" required="yes" type="struct">
		<cfargument name="loginTbl" required="yes" type="string">
		<cfargument name="loginKey" required="Yes" type="string">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
			var.success.username = arguments.formfields.username;
			var.success.password = arguments.formfields.password;
		</cfscript>

		<cfquery name="qryUserName" datasource="#arguments.DSN#">
			SELECT
				u.#arguments.loginKey# AS user_id
			FROM
				#arguments.loginTbl# u
			WHERE
				UCASE(u.username) = <cfqueryparam value="#UCASE(arguments.formfields.username)#" cfsqltype="CF_SQL_VARCHAR">
		</cfquery>

		<cfif NOT qryUserName.RecordCount>
			<cfset var.success.success = "No">
			<cfset var.success.reason = "The user name you entered was not found.*">
		<cfelse>
			<cfquery name="qryLogin" datasource="#arguments.DSN#">
				SELECT
					u.#arguments.loginKey# AS user_id
				FROM
					#arguments.loginTbl# u
				WHERE
					u.#arguments.loginKey# IN (<cfqueryparam value="#ValueList(qryUserName.user_id)#" cfsqltype="CF_SQL_INTEGER" list="Yes">)
					AND u.password = <cfqueryparam value="#arguments.formfields.password#" cfsqltype="CF_SQL_VARCHAR">
			</cfquery>

			<cfif NOT qryLogin.RecordCount>
				<cfset var.success.success = "No">
				<cfset var.success.reason = "The password you entered is incorrect.*">
			</cfif>
		</cfif>

		<cfif NOT var.success.success>
			<cfreturn var.success />
		<cfelse>
			<cfset var.success.user_id = qryLogin.user_id>
		</cfif>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="valRaces" access="public" displayname="Validate Race Registration Form" hint="Validates Race Registration Form" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">

		<cfscript>
			var.raceCount = 0;
			var.raceNum = 0;
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";

			if (LEN(TRIM(arguments.formfields.usms)) EQ 0)
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Your USMS Number is required.*";
			}
			if (NOT VAL(arguments.formfields.team_no))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Select a team (or ""Not listed"" if your team is not listed).*";
			}
			else if (VAL(arguments.formfields.team_no) EQ -1)
			{
				if ((LEN(trim(arguments.formfields.team_name)) EQ 0) OR (LEN(trim(arguments.formfields.team_short)) EQ 0) OR (LEN(trim(arguments.formfields.team_abbr)) EQ 0))
				{
					var.success.success = "No";
					var.success.reason = var.success.reason & "If your team is not currently listed, please enter the name, shortened name, and abbreviation of your team.*";
				}
			}
		</cfscript>

		<!---  Loop along selected races and verify the seed times and the number of events --->
		<cfloop collection="#arguments.formfields#" item="i">
			<cfscript>
				if (ListFirst(i,"_") EQ "event")
				{
					var.raceNum = ListLast(i,"_");
					if (LEN(TRIM(arguments.formfields["seed_" & var.raceNum])) EQ 0)
					{
						var.success.success = "No";
						var.success.reason = var.success.reason & "Please enter a seed time for event ##" & var.raceNum & ".*";
					}
					else if (NOT isValidSeed(arguments.formfields["seed_" & var.raceNum]))
					{
						var.success.success = "No";
						var.success.reason = var.success.reason & "Seed times must be in the format: ""min:sec.msec"" for event ##" & var.raceNum & ".*";
					}
					var.raceCount = var.raceCount + 1;

				}
			</cfscript>
		</cfloop>

		<cfscript>
			if (NOT var.raceCount)
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "You must select at least 1 race to swim.*";
			}
			else if (var.raceCount GT 5)
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please select only up to 5 races.*";
			}
		</cfscript>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="isValidSeed" access="private" displayname="Is Valid Seed" hint="Validates a seed time" output="No" returntype="boolean">
		<cfargument name="seedTime" required="Yes" type="string">

		<cfscript>
			var.isValid = true;
			var.aTemp = ListToArray(seedTime,":");
			var.mins = 0;
			var.secs = 0;
			var.msecs = 0;

			if (ArrayLen(var.aTemp) NEQ 2)
			{
				var.isValid = false;
			}
			else
			{
				var.mins = VAL(var.aTemp[1]);
				var.aTemp = ListToArray(var.aTemp[2],".");
				if (ArrayLen(var.aTemp) NEQ 2)
				{
					var.isValid = false;
				}
				else
				{
					var.secs = VAL(var.aTemp[1]);
					var.msecs = VAL(var.aTemp[2]);
					if ((var.mins LT 0) OR (var.secs LT 0) OR (var.msecs LT 0))
					{
						var.isValid = false;
					}
				}
			}
		</cfscript>

		<cfreturn var.isValid />
	</cffunction>

	<cffunction name="addTeam" access="public" displayname="Add Team" hint="Adds Team" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="teamTbl" required="yes" type="string">
		<cfargument name="returnID" required="yes" type="boolean">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<cftransaction isolation="SERIALIZABLE">
			<!--- Insert into team table --->
			<cfquery name="qAth" datasource="#arguments.DSN#">
				INSERT INTO
					#arguments.teamTbl#
				(
					team_name,
					team_short,
					team_abbr
				)
				VALUES
				(
					<cfqueryparam value="#arguments.formfields.team_name#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#arguments.formfields.team_short#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#arguments.formfields.team_abbr#" cfsqltype="CF_SQL_VARCHAR">
				)
			</cfquery>

			<!--- Get team number --->
			<cfquery name="qTeamNO" datasource="#arguments.DSN#">
				SELECT
					MAX(team_no) AS newID
				FROM
					#arguments.teamTbl#
				WHERE
					team_name = <cfqueryparam value="#arguments.formfields.team_name#" cfsqltype="CF_SQL_VARCHAR">
					AND team_short = <cfqueryparam value="#arguments.formfields.team_short#" cfsqltype="CF_SQL_VARCHAR">
					AND team_abbr = <cfqueryparam value="#arguments.formfields.team_abbr#" cfsqltype="CF_SQL_VARCHAR">
			</cfquery>

			<cfif arguments.returnID>
				<cfset var.success.team_no = qTeamNO.newID>
			</cfif>
		</cftransaction>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="setRaces" access="public" displayname="Set Race Values" hint="Sets Race Session Values" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">

		<cfscript>
			var raceIndex = 0;
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";

			Session.goldrush2009.usms = arguments.formfields.usms;
			Session.goldrush2009.team_no = arguments.formfields.team_no;
		</cfscript>
		<!--- Now, loop along the races they've entered and set session variables --->
		<cfloop collection="#arguments.formfields#" item="i">
			<cfscript>
				if (ListFirst(i,"_") EQ "event")
				{
					raceNum = VAL(ListLast(i,"_"));
					seedTime = arguments.formfields["seed_" & raceNum];
					// See if event is already in the array
					for (i=1; i LTE ArrayLen(Session.goldrush2009.aRaces); i = i + 1)
					{
						if (Session.goldrush2009.aRaces[i].event_ptr EQ raceNum)
						{
							Session.goldrush2009.aRaces[i].seedTime = seedTime;
							raceIndex = i;
							break;
						}
					}
					if (raceIndex EQ 0)
					{
						ArrayAppend(Session.goldrush2009.aRaces,StructNew());
						Session.goldrush2009.aRaces[ArrayLen(Session.goldrush2009.aRaces)].event_ptr = raceNum;
						Session.goldrush2009.aRaces[ArrayLen(Session.goldrush2009.aRaces)].seedTime = seedTime;
					}
				}
			</cfscript>
		</cfloop>

		<cfscript>
			Session.goldrush2009.races = 1;
		</cfscript>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="updateRaces" access="public" displayname="Update Races" hint="Adds Race and Registration Info" output="No" returntype="struct">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="entryTbl" required="yes" type="string">
		<cfargument name="registrationTbl" required="yes" type="string">
		<cfargument name="athleteTbl" required="yes" type="string">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<cftransaction isolation="SERIALIZABLE">
			<!--- First update team number info --->
			<cfquery name="qTeam" datasource="#arguments.DSN#">
				UPDATE
					#arguments.athleteTbl#
				SET
					team_no = <cfqueryparam value="#VAL(Session.goldrush2009.team_no)#" cfsqltype="CF_SQL_INTEGER">
				WHERE
					ath_no = <cfqueryparam value="#VAL(Session.goldrush2009.athlete_no)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>

			<!--- Now update USMS no --->
			<cfquery name="qUSMS" datasource="#arguments.DSN#">
				UPDATE
					#arguments.registrationTbl#
				SET
					usms = <cfqueryparam value="#Session.goldrush2009.usms#" cfsqltype="CF_SQL_VARCHAR">,
					races = 1
				WHERE
					athlete_no = <cfqueryparam value="#VAL(Session.goldrush2009.athlete_no)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>

			<!--- Now, delete any prior entries --->
			<cfquery name="qDel" datasource="#arguments.DSN#">
				DELETE FROM
					#arguments.entryTbl#
				WHERE
					ath_no = <cfqueryparam value="#VAL(Session.goldrush2009.athlete_no)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>

			<!--- Now, loop along the races they've entered and insert into database --->
			<cfloop from="1" to="#ArrayLen(Session.goldrush2009.aRaces)#" index="i">
				<!--- Convert seed time --->
				<cfset seedTime = ConvertSeed(Session.goldrush2009.aRaces[i].seedTime)>

				<!--- Insert into entry table --->
				<cfquery name="qEntry" datasource="#arguments.DSN#">
					INSERT INTO
						#arguments.entryTbl#
					(
						event_ptr,
						ath_no,
						ActSeed_course,
						ActualSeed_time,
						ConvSeed_course,
						ConvSeed_time
					)
					VALUES
					(
						<cfqueryparam value="#VAL(Session.goldrush2009.aRaces[i].event_ptr)#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#VAL(Session.goldrush2009.athlete_no)#" cfsqltype="CF_SQL_INTEGER">,
						'L',
						<cfqueryparam value="#seedTime#" cfsqltype="CF_SQL_DOUBLE">,
						'L',
						<cfqueryparam value="#seedTime#" cfsqltype="CF_SQL_DOUBLE">
					)
				</cfquery>
			</cfloop>
		</cftransaction>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="convertSeed" access="private" displayname="Convert Seed" hint="Converts a seed time from min:sec.msec to sec.msec" output="No" returntype="numeric">
		<cfargument name="seedTime" required="Yes" type="string">

		<cfscript>
			var newTime = 0;
			var.aTemp = ArrayNew(1);
			var.mins = 0;
			var.secs = 0;

			var.aTemp = ListToArray(arguments.seedTime,":");
			var.mins = VAL(var.aTemp[1]);
			var.secs = VAL(var.aTemp[2]);

			newTime = (var.mins * 60) + var.secs;
		</cfscript>

		<cfreturn newTime />
	</cffunction>

	<cffunction name="convertSeed2minutes" access="public" displayname="Convert Seed to Minutes" hint="Converts a seed time to min:sec.msec from sec.msec" output="Yes" returntype="string">
		<cfargument name="seedTime" required="Yes" type="string">
		<cfscript>
			var newTime = "";
			var mins = 0;
			var secs = 0;
			var msecs = 0;
			var secsTmp = 0;

			if (VAL(arguments.seedTime) EQ 0)
			{
				newTime = arguments.seedTime;
			}
			else
			{
				mins = (VAL(arguments.seedTime) \ 60);
				secs = VAL(arguments.seedTime) - (mins * 60);

				newTime = mins & ":" & NumberFormat(secs,"00.00");
			}
		</cfscript>

		<cfreturn newTime />
	</cffunction>

	<cffunction name="getRegistrationInfo" access="public" displayname="Get Registration Info" hint="Gets all registration info for a registrant" output="No" returntype="struct">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="athleteTbl" required="yes" type="string">
		<cfargument name="registrationTbl" required="yes" type="string">
		<cfargument name="entryTbl" required="yes" type="string">
		<cfargument name="housingTbl" required="yes" type="string">
		<cfargument name="registration_id" required="Yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<cftransaction>
			<!--- Get info from registration and athlete table --->
			<cfquery name="qReg" datasource="#arguments.DSN#">
				SELECT
					r.athlete_no,
					r.registrationType,
					r.usms,
					r.donation,
					r.totalFee,
					r.master,
					r.races,
					r.excursion_id,
					r.housing_id,
					r.payment,
					r.paypal_transaction,
					r.registrationFee,
					r.paymentSubmitted,
					r.paymentMethod,
					r.registrationSubmitted,
					r.registrationStarted,
					r.usms_received,
					a.last_name,
					a.first_name,
					a.initial,
					a.ath_sex,
					a.birth_date,
					a.team_no,
					a.pref_name,
					a.home_addr1,
					a.home_addr2,
					a.home_city,
					a.home_statenew,
					a.home_zip,
					a.home_cntry,
					a.home_daytele,
					a.home_email,
					h.num_guests,
					h.host_id,
					h.names AS housing_names,
					h.address AS housing_address,
					h.city AS housing_city,
					h.state AS housing_state,
					h.zip AS housing_zip,
					h.country AS housing_country,
					h.phone_day,
					h.phone_evening,
					h.email AS housing_email,
					h.nights,
					h.car,
					h.near_location,
					h.smoke,
					h.allergies,
					h.needs,
					h.sleeping,
					h.sleeping_share,
					h.temperament,
					r.paypalStatus,
					r.paymentDue,
					r.waiverName,
					r.waiverDate,
					r.waiverText,
					r.waiverSigned
				FROM
					(
						#arguments.athleteTbl# a
						INNER JOIN
						#arguments.registrationTbl# r
						ON
						a.ath_no = r.athlete_no
					)
					LEFT OUTER JOIN
					#arguments.housingTbl# h
					ON h.registration_id = r.registration_id
				WHERE
					r.registration_id = <cfqueryparam value="#VAL(arguments.registration_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>

			<cfset var.success.qReg = qReg>

			<!--- Now get the event info --->
			<cfquery name="qRaces" datasource="#arguments.DSN#">
				SELECT
					e.event_ptr,
					e.ConvSeed_time AS seedTime
				FROM
					#arguments.entryTbl# e
				WHERE
					e.ath_no = <cfqueryparam value="#VAL(qReg.athlete_no)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>

			<cfset var.success.qRaces = qRaces>
		</cftransaction>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="setExcursion" access="public" displayname="Set Excursion" hint="Sets Excursion Session Value" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";

			Session.goldrush2009.excursion = VAL(arguments.formfields.excursion);
		</cfscript>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="updateExcursion" access="public" displayname="Update Excursion" hint="Updates Excursion for Registrant" output="No" returntype="struct">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="registrationTbl" required="yes" type="string">
		<cfargument name="excursion_id" required="yes" type="numeric">
		<cfargument name="registration_id" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<cftransaction isolation="SERIALIZABLE">
			<!--- Update table --->
			<cfquery name="qExc" datasource="#arguments.DSN#">
				UPDATE
					#arguments.registrationTbl#
				SET
					excursion_id = <cfqueryparam value="#VAL(arguments.excursion_id)#" cfsqltype="CF_SQL_INTEGER">
				WHERE
					registration_id = <cfqueryparam value="#VAL(arguments.registration_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
		</cftransaction>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="addRegistrantHousing" access="public" displayname="Add Registrant Housing" hint="Adds Hosted Housing Request" output="No" returntype="struct">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="housingTbl" required="yes" type="string">
		<cfargument name="registrationTbl" required="yes" type="string">
		<cfargument name="registration_id" required="yes" type="numeric">
		<cfargument name="returnID" required="yes" type="boolean">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<cftransaction isolation="SERIALIZABLE">
			<!--- Insert into housing table --->
			<cfquery name="qHousing" datasource="#arguments.DSN#">
				INSERT INTO
					#arguments.housingTbl#
				(
					registration_id
				)
				VALUES
				(
					<cfqueryparam value="#VAL(arguments.registration_id)#" cfsqltype="CF_SQL_INTEGER">
				)
			</cfquery>

			<!--- Get housing id --->
			<cfquery name="qID" datasource="#arguments.DSN#">
				SELECT
					MAX(registrant_housing_id) AS newID
				FROM
					#arguments.housingTbl#
				WHERE
					registration_id = <cfqueryparam value="#VAL(arguments.registration_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>

			<!--- Update registration table --->
			<cfquery name="qReg" datasource="#arguments.DSN#">
				UPDATE
					#arguments.registrationTbl#
				SET
					housing_id = <cfqueryparam value="#VAL(qID.newID)#" cfsqltype="CF_SQL_INTEGER">
				WHERE
					registration_id = <cfqueryparam value="#VAL(arguments.registration_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>

			<cfif arguments.returnID>
				<cfset var.success.housing = qID.newID>
			</cfif>
		</cftransaction>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="valHousing" access="public" displayname="Validate Housing" hint="Validates Housing" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";

			if (NOT LEN(trim(arguments.formfields.names)))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter the name(s) of the guest(s).*";
			}
			if (NOT LEN(trim(arguments.formfields.city)))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter your city.*";
			}
			if (NOT LEN(trim(arguments.formfields.email)))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter your e-mail address.*";
			}
			else if (NOT isValidEmail(arguments.formfields.email))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter a valid e-mail address.*";
			}
			if (NOT ListLen(arguments.formfields.nights))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please select the nights you wish to stay.*";
			}
			if (NOT ListLen(arguments.formfields.sleeping))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please select the sleeping arrangements you prefer.*";
			}
			if (NOT ListLen(arguments.formfields.temperament))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please select your temperament.*";
			}
		</cfscript>

		<cfif NOT var.success.success>
			<cfreturn var.success />
		</cfif>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="updateHousing" access="public" displayname="Update Housing Request" hint="Updates Housing Request for Registrant" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="housingTbl" required="yes" type="string">
		<cfargument name="housing_id" required="yes" type="numeric">
		<cfargument name="registration_id" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<cftransaction isolation="SERIALIZABLE">
			<!--- Update table --->
			<cfquery name="qHousing" datasource="#arguments.DSN#">
				UPDATE
					#arguments.housingTbl#
				SET
					num_guests = <cfqueryparam value="#VAL(arguments.formfields.num_guests)#" cfsqltype="CF_SQL_INTEGER">,
					names = <cfqueryparam value="#arguments.formfields.names#" cfsqltype="CF_SQL_VARCHAR">,
					address = <cfqueryparam value="#arguments.formfields.address#" cfsqltype="CF_SQL_VARCHAR">,
					city = <cfqueryparam value="#arguments.formfields.city#" cfsqltype="CF_SQL_VARCHAR">,
					state = <cfqueryparam value="#arguments.formfields.state#" cfsqltype="CF_SQL_VARCHAR">,
					zip = <cfqueryparam value="#arguments.formfields.zip#" cfsqltype="CF_SQL_VARCHAR">,
					country = <cfqueryparam value="#arguments.formfields.country#" cfsqltype="CF_SQL_VARCHAR">,
					phone_day = <cfqueryparam value="#arguments.formfields.phone_day#" cfsqltype="CF_SQL_VARCHAR">,
					phone_evening = <cfqueryparam value="#arguments.formfields.phone_evening#" cfsqltype="CF_SQL_VARCHAR">,
					email = <cfqueryparam value="#arguments.formfields.email#" cfsqltype="CF_SQL_VARCHAR">,
					nights = <cfqueryparam value="#arguments.formfields.nights#" cfsqltype="CF_SQL_VARCHAR">,
					car = #arguments.formfields.car#,
					near_location = <cfqueryparam value="#arguments.formfields.near_location#" cfsqltype="CF_SQL_VARCHAR">,
					smoke = #arguments.formfields.smoke#,
					allergies = <cfqueryparam value="#arguments.formfields.allergies#" cfsqltype="CF_SQL_VARCHAR">,
					needs = <cfqueryparam value="#arguments.formfields.needs#" cfsqltype="CF_SQL_VARCHAR">,
					sleeping = <cfqueryparam value="#arguments.formfields.sleeping#" cfsqltype="CF_SQL_VARCHAR">,
					sleeping_share = <cfqueryparam value="#arguments.formfields.sleeping_share#" cfsqltype="CF_SQL_VARCHAR">,
					temperament = <cfqueryparam value="#arguments.formfields.temperament#" cfsqltype="CF_SQL_VARCHAR">
				WHERE
					registration_id = <cfqueryparam value="#VAL(arguments.registration_id)#" cfsqltype="CF_SQL_INTEGER">
					AND registrant_housing_id = <cfqueryparam value="#VAL(arguments.housing_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
		</cftransaction>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="setHousing" access="public" displayname="Set Housing Request" hint="Sets Housing Session Value" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";

			Session.goldrush2009.num_guests = VAL(arguments.formfields.num_guests);
			Session.goldrush2009.names = arguments.formfields.names;
			Session.goldrush2009.housing_address = arguments.formfields.address;
			Session.goldrush2009.housing_city = arguments.formfields.city;
			Session.goldrush2009.housing_state = arguments.formfields.state;
			Session.goldrush2009.housing_zip = arguments.formfields.zip;
			Session.goldrush2009.housing_country = arguments.formfields.country;
			Session.goldrush2009.housing_email = arguments.formfields.email;
			Session.goldrush2009.phone_day = arguments.formfields.phone_day;
			Session.goldrush2009.phone_evening = arguments.formfields.phone_evening;
			Session.goldrush2009.nights = arguments.formfields.nights;
			Session.goldrush2009.near_location = arguments.formfields.near_location;
			Session.goldrush2009.smoke = arguments.formfields.smoke;
			Session.goldrush2009.allergies = arguments.formfields.allergies;
			Session.goldrush2009.needs = arguments.formfields.needs;
			Session.goldrush2009.sleeping = arguments.formfields.sleeping;
			Session.goldrush2009.sleeping_share = arguments.formfields.sleeping_share;
			Session.goldrush2009.temperament = arguments.formfields.temperament;
			Session.goldrush2009.housing = arguments.formfields.housing;
		</cfscript>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="valPayment" access="public" displayname="Validate Payment" hint="Validates Payment" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";

			if (CompareNoCase(arguments.formfields.paymentMethod,"PayPal") AND CompareNoCase(arguments.formfields.paymentMethod,"Check"))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please select a proper payment method.*";
			}

			if (NOT isNumeric(arguments.formfields.donation))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter a number for your donation to IGLA.*";
			}
		</cfscript>

		<cfif NOT var.success.success>
			<cfreturn var.success />
		</cfif>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="updatePayment" access="public" displayname="Update Payment" hint="Updates Payment for Registrant" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="registrationTbl" required="yes" type="string">
		<cfargument name="registration_id" required="yes" type="numeric">
		<cfargument name="registrationFee" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<cftransaction isolation="SERIALIZABLE">
			<!--- Update table --->
			<cfquery name="qPayment" datasource="#arguments.DSN#">
				UPDATE
					#arguments.registrationTbl#
				SET
					donation = <cfqueryparam value="#VAL(arguments.formfields.donation)#" cfsqltype="CF_SQL_DOUBLE">,
					registrationFee = <cfqueryparam value="#VAL(arguments.registrationFee)#" cfsqltype="CF_SQL_DOUBLE">,
					totalFee = <cfqueryparam value="#VAL(arguments.formfields.donation) + VAL(arguments.registrationFee)#" cfsqltype="CF_SQL_DOUBLE">,
					paymentMethod = <cfqueryparam value="#arguments.formfields.paymentMethod#" cfsqltype="CF_SQL_VARCHAR">,
					paymentDue = <cfqueryparam value="#DateAdd("D",Request.paymentDaysDue,Now())#" cfsqltype="CF_SQL_TIMESTAMP">,
				<cfif CompareNoCase(arguments.formfields.paymentMethod,"check") EQ 0>
					payment = 1
				<cfelse>
					payment = 0
				</cfif>
				WHERE
					registration_id = <cfqueryparam value="#VAL(arguments.registration_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
		</cftransaction>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="setPayment" access="public" displayname="Set Payment" hint="Sets Payment Session Values" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="registrationFee" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";

			Session.goldrush2009.donation = VAL(arguments.formfields.donation);
			Session.goldrush2009.registrationFee = VAL(arguments.registrationFee);
			Session.goldrush2009.totalFee = VAL(arguments.formfields.donation) + VAL(arguments.registrationFee);
			Session.goldrush2009.paymentMethod = arguments.formfields.paymentMethod;
			if (CompareNoCase(arguments.formfields.paymentMethod,"check") EQ 0)
			{
				Session.goldrush2009.payment = true;
			}
			else
			{
				Session.goldrush2009.payment = false;
			}
		</cfscript>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="finalizeRegistration" access="public" displayname="Finalize Registration" hint="Finalizes the Registration" output="No" returntype="struct">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="registrationTbl" required="yes" type="string">
		<cfargument name="registration_id" required="yes" type="numeric">
		<cfargument name="paypal" required="yes" type="struct">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<cftransaction isolation="SERIALIZABLE">
			<!--- Update table --->
			<cfquery name="qPayment" datasource="#arguments.DSN#">
				UPDATE
					#arguments.registrationTbl#
				SET
					paypal_transaction = <cfqueryparam value="#arguments.paypal.txn_id#" cfsqltype="CF_SQL_VARCHAR">,
				<cfif LEN(arguments.paypal.txn_id)>
					paymentSubmitted = Now(),
					paypalStatus = <cfqueryparam value="#arguments.paypal.payment_status#" cfsqltype="CF_SQL_VARCHAR">,
				</cfif>
					registrationSubmitted = Now(),
					payment = 1
				WHERE
					registration_id = <cfqueryparam value="#VAL(arguments.registration_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
		</cftransaction>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="finalizeRegistrationSession" access="public" displayname="Finalize Registration Session" hint="Finalizes the Registration Session variables" output="No" returntype="struct">
		<cfargument name="paypal" required="yes" type="struct">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<cfscript>
			Session.goldrush2009.payment = true;
			if (LEN(arguments.paypal.txn_id))
			{
				Session.goldrush2009.paymentSubmitted = Now();
				Session.goldrush2009.paypalStatus = arguments.paypal.payment_status;
			}
			Session.goldrush2009.registrationSubmitted = Now();
			Session.goldrush2009.paypal_transaction = arguments.paypal.txn_id;
		</cfscript>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="finalizeRegistrationEmail" access="public" displayname="Finalize Registration Email" hint="Sends E-mails for Registration" output="No" returntype="struct">
		<cfargument name="from_email" required="Yes" type="string">
		<cfargument name="submit_email" required="no" default="" type="string">
		<cfargument name="data" required="Yes" type="struct">
		<cfargument name="housingResponseDeadline" required="yes" type="date">
		<cfargument name="mailServer" required="Yes" type="string">
		<cfargument name="teamName" required="yes" type="string">
		<cfargument name="qRaces" required="yes" type="query">
		<cfargument name="excursion" required="yes" type="string">
		<cfargument name="nights" required="yes" type="string">
		<cfargument name="sleeping" required="yes" type="string">
		<cfargument name="temperament" required="yes" type="string">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<!--- Create variables for e-mail --->
		<cfscript>
			userSubject = "SQUID Long Course Challenge Registration Submitted";
			userTo = data.Home_email;
			userFrom = arguments.from_email;
			commonContent = "";
			userContent = "";
			squidContent = "";
			squidSubject = data.first_name & " " & data.last_name & " - SQUID Long Course Challenge Registration Submitted";
			squidTo = data.Home_email;
			squidFrom = arguments.from_email;

			// Content for user's e-mail
			userContent = "#data.pref_name#,

#Wrap("You are now registered for ""Swim With an Altitude: SQUID Long Course Challenge 2004."" A copy of the information you have provided is at the end of this message.",50)#

";
			if (data.registrationType NEQ "social")
			{
				if (LEN(data.paypal_transaction))
				{
					userContent = userContent & Wrap("Your payment of US" & DollarFormat(data.totalFee) & " has been successfully sent via PayPal.  However, to complete your registration, you must send a copy of your USMS/FINA card and a signed liability waiver postmarked by " & DateFormat(Session.goldrush2009.paymentDue,"m/d/yyyy") & " to:",50);
				}
				else
				{
					userContent = userContent & Wrap("You have a balance of US" & DollarFormat(data.totalFee) & ".  We must receive a check made out to ""SQUID Swim Team"" postmarked by " & DateFormat(Session.goldrush2009.paymentDue,"m/d/yyyy") & ". Send that check, a copy of your USMS/FINA card, and a signed liability waiver to:",50);
				}
userContent = userContent &
"	SQUID Swim Team
	P.O. Box 480912
	Denver, CO 80248-0912

";
			}
			else
			{
				if (LEN(data.paypal_transaction))
				{
					userContent = userContent & Wrap("Your payment of US" & DollarFormat(data.totalFee) & " has been successfully sent via PayPal.",50);
				}
				else
				{
					userContent = userContent & Wrap("You have a balance of US" & DollarFormat(data.totalFee) & ".  We must receive a check made out to ""SQUID Swim Team"" postmarked by " & DateFormat(Session.goldrush2009.paymentDue,"m/d/yyyy") & ". Send that check to:",50);
userContent = userContent &
"	SQUID Swim Team
	P.O. Box 480912
	Denver, CO 80248-0912

";
				}
			}

			if (VAL(data.housing))
			{
				userContent = userContent & Wrap("While SQUID makes every effort to provide hosted housing for all who request it, we can not guarantee housing for you.  If you have not received information regarding your housing request by " & DateFormat(arguments.housingResponseDeadline,"m/d/yyyy") & ", please contact us at " & arguments.from_email & ".",50) &
"

";
			}

			// Content for SQUID's e-mail
			squidContent = Wrap("#data.first_name# #data.initial# #data.last_name# (#data.pref_name#) has submitted registration for the SQUID Long Course Challenge.",50);

			squidContent = squidContent & "

";
			if (data.registrationType NEQ "social")
			{
				if (LEN(data.paypal_transaction))
				{
					squidContent = squidContent & Wrap("Their payment of US" & DollarFormat(data.totalFee) & " has been successfully sent via PayPal.  They must still send a copy of their USMS/FINA card and a signed liability waiver postmarked by " & DateFormat(Session.goldrush2009.paymentDue,"m/d/yyyy") & ".",50);
				}
				else
				{
					squidContent = squidContent & Wrap("They have a balance of US" & DollarFormat(data.totalFee) & ".  We must receive a check and a copy of their USMS/FINA card and a signed liability waiver postmarked by " & DateFormat(Session.goldrush2009.paymentDue,"m/d/yyyy") & ".",50);
				}
			}
			else
			{
				if (LEN(data.paypal_transaction))
				{
					squidContent = squidContent & Wrap("Their payment of US" & DollarFormat(data.totalFee) & " has been successfully sent via PayPal.",50);
				}
				else
				{
					squidContent = squidContent & Wrap("They have a balance of US" & DollarFormat(data.totalFee) & ".  We must receive a check postmarked by " & DateFormat(Session.goldrush2009.paymentDue,"m/d/yyyy") & ".",50);
				}
			}

			// Content for both e-mail
commonContent = commonContent &
"

REGISTRATION INFORMATION
Register for:	";

if (data.registrationType IS "both")
{
	commonContent = commonContent & "Swim Meet and Social Events";
}
else if (data.registrationType IS "meet")
{
	commonContent = commonContent & "Swim Meet only";
}
else
{
	commonContent = commonContent & "Social Events only";
}
commonContent = commonContent &
" (US#DollarFormat(data.registrationFee)#)
Name:		#data.first_name# #data.initial# #data.last_name# (#data.pref_name#)
DOB:		#data.dob#
Sex:		#data.ath_sex#
Phone:		#data.home_daytele#
E-mail:		#data.home_email#
Address:	#data.home_addr1#
";
if (LEN(TRIM(data.home_addr2)))
{
commonContent = commonContent &
"		#data.home_addr2#
";
}
commonContent = commonContent &
"		#data.home_city#, #data.home_state# #data.home_zip#
		#data.home_country#

";

if (data.registrationType IS NOT "social")
{
	commonContent = commonContent &
	"EVENT REGISTRATION
USMS ##:		#data.usms#
Team:		#arguments.teamName#
Races Entered:
";
	for (i = 1; i LTE arguments.qRaces.RecordCount; i = i + 1)
	{
	commonContent = commonContent &
	"		#arguments.qRaces.eventDescription[i]# (#convertSeed2minutes(VAL(arguments.qRaces.convSeed_time[i]))#)
	";
	}
}


if (data.registrationType IS NOT "meet")
{
	commonContent = commonContent &
	"
EXCURSION:";
	if (VAL(data.excursion))
	{
		commonContent = commonContent & "	#arguments.excursion#
	";
	}
	else
	{
		commonContent = commonContent & "	(none selected)
	";
	}
}

	commonContent = commonContent & "
HOSTED HOUSING REQUEST
";
if (VAL(data.housing))
{
	commonContent = commonContent &
"Guests:		#data.num_guests#
Name(s):	#data.housing_names#
Address:	#data.housing_address#
		#data.housing_city#, #data.housing_state# #data.housing_zip#
		#data.housing_country#
Phone:		#data.phone_day# (day)
		#data.phone_evening# (evening)
E-mail:		#data.housing_email#
Nights:		#arguments.nights#
Car?		#YesNoFormat(data.car)#
Near:		#data.near_location#
Smoke?		#YesNoFormat(data.smoke)#
Allergies:	#data.allergies#
Needs:		#data.needs#
Arrangements:	#arguments.sleeping#
Temperament:	#arguments.temperament#
";
}
else
{
	commonContent = commonContent &
"		(not submitted)
";
}

	commonContent = commonContent &
"
PAYMENT INFORMATION
Registration:	US#DollarFormat(data.registrationFee)#
Donation:	US#DollarFormat(data.donation)#
		------------
Total:		US#DollarFormat(data.totalFee)#

Method:		#data.paymentMethod#
";

			this.sendEmail(userTo,userFrom,userSubject,userContent & commonContent,"plain",arguments.mailServer);

			if (LEN(data.paypal_transaction))
			{
				commonContent = commonContent &
"Transaction:	#data.paypal_transaction#
";
			}

			this.sendEmail(squidTo,squidFrom,squidSubject,squidContent & commonContent,"plain",arguments.mailServer);
		</cfscript>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="sendEmail" access="public" displayname="Send Email" hint="Sends E-mails" output="No">
		<cfargument name="to" required="Yes" type="string">
		<cfargument name="from" required="Yes" type="string">
		<cfargument name="subject" required="Yes" type="string">
		<cfargument name="content" required="Yes" type="string">
		<cfargument name="type" required="Yes" type="string">
		<cfargument name="mailServer" required="Yes" type="string">

<cfmail from="#arguments.from#" to="#arguments.to#" subject="#arguments.subject#" type="#arguments.type#" server="#arguments.mailServer#">
#arguments.content#
</cfmail>

		<cfreturn />
	</cffunction>

	<cffunction name="initializeSession" access="public" displayname="Initialize Session" hint="Initializes Session Variables" output="no">
		<cfscript>
			Session.goldrush2009.registration_id = 0;
			Session.goldrush2009.athlete_no = 0;
			Session.goldrush2009.master = false;
			Session.goldrush2009.races = false;
			Session.goldrush2009.excursion = 0;
			Session.goldrush2009.housing = 0;
			Session.goldrush2009.payment = false;

			Session.goldrush2009.last_name = "";
			Session.goldrush2009.first_name = "";
			Session.goldrush2009.initial = "";
			Session.goldrush2009.pref_name = "";
			Session.goldrush2009.dob = "";
			Session.goldrush2009.ath_sex = "M";
			Session.goldrush2009.Home_daytele = "";
			Session.goldrush2009.Home_email = "";
			Session.goldrush2009.Home_addr1 = "";
			Session.goldrush2009.Home_addr2 = "";
			Session.goldrush2009.Home_city = "";
			Session.goldrush2009.Home_state = "CO";
			Session.goldrush2009.Home_zip = "";
			Session.goldrush2009.Home_country = "";
			Session.goldrush2009.registrationType = "both";
			Session.goldrush2009.donation = 0;
			Session.goldrush2009.totalFee = 0;
			Session.goldrush2009.usms = "";
			Session.goldrush2009.team_no = 0;
			Session.goldrush2009.host_id = 0;
			Session.goldrush2009.num_guests = 0;
			Session.goldrush2009.housing_names = "";
			Session.goldrush2009.housing_address = "";
			Session.goldrush2009.housing_city = "";
			Session.goldrush2009.housing_state = "";
			Session.goldrush2009.housing_zip = "";
			Session.goldrush2009.housing_country = "";
			Session.goldrush2009.phone_day = "";
			Session.goldrush2009.phone_evening = "";
			Session.goldrush2009.housing_email = "";
			Session.goldrush2009.nights = "";
			Session.goldrush2009.car = "";
			Session.goldrush2009.near_location = "";
			Session.goldrush2009.smoke = "";
			Session.goldrush2009.allergies = "";
			Session.goldrush2009.needs = "";
			Session.goldrush2009.sleeping = "";
			Session.goldrush2009.sleeping_share = "";
			Session.goldrush2009.temperament = "";
			Session.goldrush2009.paypal_transaction = "";
			Session.goldrush2009.registrationFee = 0;
			Session.goldrush2009.paymentSubmitted = "";
			Session.goldrush2009.registrationSubmitted = "";
			Session.goldrush2009.registrationStarted = Now();
			Session.goldrush2009.paymentMethod = "PayPal";
			Session.goldrush2009.usms_received = false;
			Session.goldrush2009.paypalStatus = "";
			Session.goldrush2009.paymentDue = DateAdd("D",Request.paymentDaysDue,Now());
			Session.goldrush2009.waiverName = "";
			Session.goldrush2009.waiverDate = "";
			Session.goldrush2009.waiverText = "";
			Session.goldrush2009.waiverSigned = false;

			Session.goldrush2009.aRaces = ArrayNew(1);
		</cfscript>

		<cfreturn />
	</cffunction>

	<cffunction name="valWaiver" access="public" displayname="Validate Waiver" hint="Validates Waiver" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="waiverText" required="Yes" type="string">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";

			if (NOT LEN(TRIM(arguments.formfields.waiverName)))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "You must enter your name in order to sign the liability waiver.*";
			}

			if (CompareNoCase(arguments.formfields.waiverText, arguments.waiverText))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Do not edit the waiver text.*";
			}
		</cfscript>

		<cfif NOT var.success.success>
			<cfreturn var.success />
		</cfif>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="setWaiver" access="public" displayname="Set Waiver" hint="Sets Waiver Session Values" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";

			Session.goldrush2009.waiverName = arguments.formfields.waiverName;
			Session.goldrush2009.waiverDate = Now();
			Session.goldrush2009.waiverText = arguments.formfields.waiverText;
		</cfscript>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="updateWaiver" access="public" displayname="Update Waiver" hint="Updates Waiver for Registrant" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="registrationTbl" required="yes" type="string">
		<cfargument name="registration_id" required="yes" type="numeric">
		<cfargument name="waiverDate" required="yes" type="date">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<cftransaction isolation="SERIALIZABLE">
			<!--- Update table --->
			<cfquery name="qWaiver" datasource="#arguments.DSN#">
				UPDATE
					#arguments.registrationTbl#
				SET
					waiverName = <cfqueryparam value="#arguments.formfields.waiverName#" cfsqltype="CF_SQL_VARCHAR">,
					waiverDate = <cfqueryparam value="#arguments.waiverDate#" cfsqltype="CF_SQL_TIMESTAMP">,
					waiverText = <cfqueryparam value="#arguments.formfields.waiverText#" cfsqltype="CF_SQL_LONGVARCHAR">
				WHERE
					registration_id = <cfqueryparam value="#VAL(arguments.registration_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
		</cftransaction>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="parsePayPalResponse" access="public" displayname="Parse PayPal Response" hint="Parses Response from PayPal" output="No" returntype="struct">
		<cfargument name="content" required="Yes" type="string">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
			var.success.paypal = StructNew();
		</cfscript>

		<cfif LEFT(arguments.content,7) IS "SUCCESS">
			<!--- Successful, so process --->
			<cfloop list="#arguments.content#" index="i" delimiters="#CHR(10)#">
				<cfif CompareNoCase(ListFirst(i,"="),"custom") EQ 0>
					<cfset var.success.paypal["registration_id"] = ListLast(i,"=")>
				<cfelse>
					<cfset var.success.paypal[ListFirst(i,"=")] = ListLast(i,"=")>
				</cfif>
			</cfloop>

			<cfset var.success.paypal.success = true>

		<cfelse>
			<!--- Failure --->
			<cfset var.success.paypal.success = false>
		</cfif>

		<cfreturn var.success />
	</cffunction>

</cfcomponent>