<!---
<fusedoc
	fuse = "dsp_profile.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the profile.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="5 June 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
			</structure>

			<number name="user_id" scope="attributes" />
			<string name="username" scope="attributes" />
			<string name="first_name" scope="attributes" />
			<string name="middle_name" scope="attributes" />
			<string name="last_name" scope="attributes" />
			<string name="preferred_name" scope="attributes" />
			<string name="address1" scope="attributes" />
			<string name="address2" scope="attributes" />
			<string name="city" scope="attributes" />
			<string name="state_id" scope="attributes" />
			<string name="zip" scope="attributes" />
			<string name="country" scope="attributes" />
		</in>
		<out>
			<number name="user_id" scope="formOrUrl" />
			<string name="username" scope="formOrUrl" />
			<string name="username_old" scope="formOrUrl" />
			<string name="first_name" scope="formOrUrl" />
			<string name="first_name_old" scope="formOrUrl" />
			<string name="middle_name" scope="formOrUrl" />
			<string name="middle_name_old" scope="formOrUrl" />
			<string name="last_name" scope="formOrUrl" />
			<string name="last_name_old" scope="formOrUrl" />
			<string name="preferred_name" scope="formOrUrl" />
			<string name="preferred_name_old" scope="formOrUrl" />
			<string name="address1" scope="formOrUrl" />
			<string name="address1_old" scope="formOrUrl" />
			<string name="address2" scope="formOrUrl" />
			<string name="address2_old" scope="formOrUrl" />
			<string name="city" scope="formOrUrl" />
			<string name="city_old" scope="formOrUrl" />
			<string name="state_id" scope="formOrUrl" />
			<string name="state_id_old" scope="formOrUrl" />
			<string name="zip" scope="formOrUrl" />
			<string name="zip_old" scope="formOrUrl" />
			<string name="country" scope="formOrUrl" />
			<string name="country_old" scope="formOrUrl" />
		</out>
	</io>

</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.user_id" default="#Request.squid.user_id#" type="numeric">
	<cfparam name="attributes.status" default="2" type="numeric">
	<cfparam name="attributes.first_name" default="" type="string">
	<cfparam name="attributes.middle_name" default="" type="string">
	<cfparam name="attributes.last_name" default="" type="string">
	<cfparam name="attributes.preferred_name" default="" type="string">
	<cfparam name="attributes.address1" default="" type="string">
	<cfparam name="attributes.address2" default="" type="string">
	<cfparam name="attributes.city" default="" type="string">
	<cfparam name="attributes.state_id" default="CO" type="string">
	<cfparam name="attributes.zip" default="" type="string">
	<cfparam name="attributes.country" default="US" type="string">
	<cfparam name="attributes.email" default="" type="string">
	<cfparam name="attributes.email_format" default="plain" type="string">
	<cfparam name="attributes.birthday" default="" type="string">
	<cfparam name="attributes.phone_cell" default="" type="string">
	<cfparam name="attributes.phone_day" default="" type="string">
	<cfparam name="attributes.phone_night" default="" type="string">
	<cfparam name="attributes.fax" default="" type="string">
	<cfparam name="attributes.contact_emergency" default="" type="string">
	<cfparam name="attributes.phone_emergency" default="" type="string">
	<cfparam name="attributes.first_practice" default="" type="string">
	<cfparam name="attributes.intro_pass" default="0" type="boolean">
	<cfparam name="attributes.usms_no" default="" type="string">
	<cfparam name="attributes.usms_year" default="" type="string">
	<cfparam name="attributes.medical_conditions" default="" type="string">
	<cfparam name="attributes.comments" default="" type="string">
	<cfparam name="attributes.picture" default="" type="string">
	<cfparam name="attributes.picture_width" default="" type="string">
	<cfparam name="attributes.picture_height" default="" type="string">
	<cfparam name="attributes.balance" default=0 type="numeric">
	<cfparam name="attributes.profile_visible" default="1" type="boolean">
	<cfparam name="attributes.date_expiration" default="" type="string">
	<cfparam name="attributes.email_preference" default="1" type="numeric">
	<cfparam name="attributes.posting_preference" default="3" type="numeric">
	<cfparam name="attributes.calendar_preference" default="6" type="numeric">
	<cfparam name="attributes.emailPref" default="Plain Text" type="string">
	<cfparam name="attributes.postingPref" default="All Messages" type="string">
	<cfparam name="attributes.calendarPref" default="All Events" type="string">

	<cfparam name="attributes.returnFA" default="" type="string">
	<cfparam name="attributes.statusType" default="" type="string">
	<cfparam name="attributes.activityLevel" default="both" type="string">
	<cfparam name="attributes.addNew" default="false" type="boolean">

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Set up user's profile info --->
	<cfset strProfile = StructNew()>
	<cfset strProfile.user_id = attributes.user_id>

	<cfif NOT attributes.addNew>
		<cfinvoke
			component="#Request.user_cfc#"
			method="getUser"
			returnvariable="strProfile"
			user=#variables.strProfile#
			dsn=#Request.DSN#
			usersTbl=#Request.usersTbl#
			developerTbl=#Request.developerTbl#
			preferenceTbl=#Request.preferenceTbl#
			officerTbl=#Request.officerTbl#
			objectsTbl=#Request.objectsTbl#
			officer_permissionTbl=#Request.officer_permissionTbl#
			officer_typeTbl=#Request.officer_typeTbl#
			testerTbl=#Request.testerTbl#
			user_statusTbl=#Request.user_statusTbl#
		>

		<cfinvoke
			component="#Request.lookup_cfc#"
			method="getMembers"
			returnvariable="qryBalance"
			user_id=#attributes.user_id#
			dsn=#Request.DSN#
			usersTbl=#Request.usersTbl#
			user_statusTbl=#Request.user_statusTbl#
			transactionTbl=#Request.practice_transactionTbl#
			transaction_typeTbl=#Request.transaction_typeTbl#
			activityDays=#Request.activityDays#
		>

		<cfset attributes.balance = qryBalance.balance>
		<cfset swimPassExpiration = qryBalance.swimPassExpiration />

		<cfif (attributes.success IS NOT "No")>
			<cfscript>
				attributes.status = strProfile.status;
				attributes.statusType = strProfile.statusType;
				attributes.first_name = strProfile.first_name;
				attributes.middle_name = strProfile.middle_name;
				attributes.last_name = strProfile.last_name;
				attributes.preferred_name = strProfile.preferred_name;
				attributes.address1 = strProfile.address1;
				attributes.address2 = strProfile.address2;
				attributes.city = strProfile.city;
				attributes.state_id = strProfile.state_id;
				attributes.zip = strProfile.zip;
				attributes.country = strProfile.country;
				attributes.email = strProfile.email;
				attributes.birthday = DateFormat(strProfile.birthday,"m/d/yyyy");
				attributes.phone_cell = strProfile.phone_cell;
				attributes.phone_day = strProfile.phone_day;
				attributes.phone_night = strProfile.phone_night;
				attributes.fax = strProfile.fax;
				attributes.phone_emergency = strProfile.phone_emergency;
				attributes.contact_emergency = strProfile.contact_emergency;
				attributes.first_practice = Dateformat(strProfile.first_practice,"m/d/yyyy");
				attributes.intro_pass = strProfile.intro_pass;
				attributes.usms_no = strProfile.usms_number;
				attributes.usms_year = strProfile.usms_year;
				attributes.medical_conditions = strProfile.medical_conditions;
				attributes.comments = strProfile.comments;
				attributes.picture = strProfile.picture;
				attributes.picture_height = strProfile.picture_height;
				attributes.picture_width = strProfile.picture_width;
				attributes.profile_visible = strProfile.profile_visible;
				attributes.date_expiration = DateFormat(strProfile.date_expiration,'mm/dd/yyyy');;
				attributes.email_preference = strProfile.email_preference;
				attributes.posting_preference = strProfile.posting_preference;
				attributes.calendar_preference = strProfile.calendar_preference;
				attributes.emailPref = strProfile.emailPref;
				attributes.postingPref = strProfile.postingPref;
				attributes.calendarPref = strProfile.calendarPref;
				attributes.mailingListYN = strProfile.mailingListYN;
			</cfscript>
		</cfif>
	<cfelse>
			<cfscript>
				attributes.status = 2;
				attributes.statusType = "Member";
				attributes.first_name = "";
				attributes.middle_name = "";
				attributes.last_name = "";
				attributes.preferred_name = "";
				attributes.address1 = "";
				attributes.address2 = "";
				attributes.city = "";
				attributes.state_id = "CO";
				attributes.zip = "";
				attributes.country = "US";
				attributes.email = "";
				attributes.birthday = "";
				attributes.phone_cell = "";
				attributes.phone_day = "";
				attributes.phone_night = "";
				attributes.fax = "";
				attributes.phone_emergency = "";
				attributes.contact_emergency = "";
				attributes.first_practice = "";
				attributes.intro_pass = false;
				attributes.usms_no = "";
				attributes.usms_year = "";
				attributes.medical_conditions = "";
				attributes.comments = "";
				attributes.picture = "";
				attributes.picture_height = 0;
				attributes.picture_width = 0;
				attributes.date_expiration = "";
				attributes.profile_visible = true;
				attributes.email_preference = 1;
				attributes.posting_preference = 3;
				attributes.calendar_preference = 6;
				attributes.emailPref = "Plain Text";
				attributes.postingPref = "All Messages";
				attributes.calendarPref = "All Events";
				attributes.mailingListYN = 0;

				strProfile.first_name = "";
				strProfile.middle_name = "";
				strProfile.last_name = "";
				strProfile.preferred_name = "";
				strProfile.address1 = "";
				strProfile.address2 = "";
				strProfile.city = "";
				strProfile.state_id = "CO";
				strProfile.zip = "";
				strProfile.country = "US";
				strProfile.email = "";
				strProfile.birthday = "";
				strProfile.officer = ArrayNew(1);
				strProfile.profile_visible = true;
			</cfscript>
	</cfif>

	<cfset attributes.date_expiration = Replace(attributes.date_expiration,"-","/","ALL")>
	<cfset attributes.birthday = Replace(attributes.birthday,"-","/","ALL")>
	<cfset attributes.first_practice = Replace(attributes.first_practice,"-","/","ALL")>

	<!--- Get states --->
	<cfif attributes.actionType IS "view">
		<cfinvoke
			component="#Request.lookup_cfc#"
			method="getStates"
			returnvariable="qryStates"
			dsn=#Request.DSN#
			stateTbl=#Request.stateTbl#
			state_id=#strProfile.state_id#
		>
	<cfelseif attributes.user_id EQ Request.squid.user_id OR Secure("Update Members")>
		<cfinvoke
			component="#Request.lookup_cfc#"
			method="getStates"
			returnvariable="qryStates"
			dsn=#Request.DSN#
			stateTbl=#Request.stateTbl#
		>
	<cfelse>
		<cfinvoke
			component="#Request.lookup_cfc#"
			method="getStates"
			returnvariable="qryStates"
			dsn=#Request.DSN#
			stateTbl=#Request.stateTbl#
			state_id=#strProfile.state_id#
		>
	</cfif>

	<!--- Get Officer Types --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getOfficerTypes"
		returnvariable="qryOfficerTypes"
		dsn=#Request.DSN#
		officerTypeTbl=#Request.officer_typeTbl#
	>

	<!--- Get User Types --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getUserStatuses"
		returnvariable="qryUserTypes"
		dsn=#Request.DSN#
		user_statusTbl=#Request.user_statusTbl#
	>

	<!--- Get E-mail Preferences --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getPreferences"
		returnvariable="qryEmailPreferences"
		dsn=#Request.DSN#
		preferenceTbl=#Request.preferenceTbl#
		preference_type="EMAIL"
	>

	<!--- Get Posting Preferences --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getPreferences"
		returnvariable="qryPostingPreferences"
		dsn=#Request.DSN#
		preferenceTbl=#Request.preferenceTbl#
		preference_type="POSTING"
	>

	<!--- Get Calendar Preferences --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getPreferences"
		returnvariable="qryCalPreferences"
		dsn=#Request.DSN#
		preferenceTbl=#Request.preferenceTbl#
		preference_type="CALENDAR"
	>

	<cfset variables.tabindex = 1>

	<!--- Set up editable fields list --->
	<cfscript>
		editableFields = "";
		viewableFields = "first_name,middle_name,last_name,preferred_name,address,email,birthday,phone,emergency,first_practice,intro_pass,usms,comments,picture,officer,email_preference,posting_preference,calendar_preference,mailingListYN,balance,";

		if (attributes.user_id EQ Request.squid.user_id AND (CompareNoCase(attributes.actionType,"view") NEQ 0))
		{
			editableFields = editableFields & "first_name,middle_name,last_name,preferred_name,address,email,birthday,phone,emergency,first_practice,intro_pass,usms,medical,comments,picture,profile_visible,email_preference,posting_preference,calendar_preference,mailingListYN,";
			viewableFields = viewableFields & "medical,status,balance,profile_visible,date_expiration,";
		}
		if (Secure("Update Members") AND (CompareNoCase(attributes.actionType,"view") NEQ 0))
		{
			editableFields = editableFields & "first_name,middle_name,last_name,preferred_name,address,email,birthday,phone,emergency,first_practice,intro_pass,usms,medical,comments,picture,status,profile_visible,date_expiration,email_preference,posting_preference,calendar_preference,mailingListYN,";
			viewableFields = viewableFields & "medical,status,balance,profile_visible,date_expiration,";
		}
	</cfscript>
</cfsilent>
<cfif attributes.success IS "no">
	<h2>There were problems with your submission:</h2>
	<ul class="errorText">
		<cfloop list="#attributes.reason#" index="variables.theItem" delimiters="*">
			<li><cfoutput>#variables.theItem#</cfoutput></li>
		</cfloop>
	</ul>
	<p>Please make corrections below and re-submit the information.</p>
<cfelseif attributes.success IS "yes">
	<p class="errorText">
		Changes Saved.
	</p>
</cfif>

<cfoutput>
<form name="profileForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post" onsubmit="return validate(this);" enctype="multipart/form-data">
	<input type="hidden" name="user_id" value="#attributes.user_id#" />
	<input type="hidden" name="returnFA" value="#attributes.returnFA#" />
	<input type="hidden" name="activityLevel" value="#attributes.activityLevel#" />
	<input type="hidden" name="statusType" value="#attributes.statusType#" />
	<input type="hidden" name="addNew" value="#attributes.addNew#" />
<table width="550" border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td align="center" colspan="2">
				<h2>
					#Request.page_title#
				</h2>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr valign="top">
			<td colspan="2" align="center">
				<a href="#Request.self#?fuseaction=#XFA.menu#">Menu</a>
				> Profile
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
<cfif (strProfile.profile_visible) OR (attributes.user_id EQ Request.squid.user_id) OR (Secure("Update Members"))>
	<cfif ListLen(editableFields)>
		<tr valign="top">
			<td colspan="2">
				Make any changes below and click "Save Profile" to save your changes.
			</td>
		</tr>
	</cfif>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
	<cfif ListFindNoCase(viewableFields,"picture")>
		<cfif FileExists(Request.member_picture_path & "\" & attributes.picture)>
			<tr valign="top">
				<td colspan="2" align="center">
					<img src="#Request.member_picture_folder#/#attributes.picture#" height="#attributes.picture_height#" width="#attributes.picture_width#"  alt="Photo of #attributes.first_name# #attributes.last_name#" border="0" />
				</td>
			</tr>
		</cfif>
		<cfif FileExists(Request.member_picture_path & "\" & attributes.picture) AND ListFindNoCase(editableFields,"picture")>
			<tr valign="top">
				<td colspan="2" align="center"hey>
					<a href="#Request.self#?fuseaction=#XFA.delete_picture#" onclick="return confirm('Delete Picture?');">Delete Picture</a>
				</td>
			</tr>
		</cfif>
		<cfif ListFindNoCase(editableFields,"picture")>
			<tr valign="top">
				<td>
					<strong>Upload Picture:</strong>
				</td>
				<td>
					<input type="file" name="picture" size="25" maxlength="255" tabindex="#variables.tabindex#" />
					<cfset variables.tabindex = variables.tabindex + 1>
				</td>
			</tr>
			<tr valign="top">
				<td colspan="2">
					<em>(Must be in GIF or JPG format and must be no larger than 320 x 320)</em>
				</td>
			</tr>
		</cfif>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"profile_visible")>
		<tr valign="top">
			<td colspan="2">
			<cfif ListFindNoCase(editableFields,"profile_visible")>
				<input type="checkbox" name="profile_visible" value="1" tabindex="#variables.tabindex#" <cfif attributes.profile_visible>checked="checked"</cfif> />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				<input type="hidden" name="profile_visible" value="#attributes.profile_visible#" />
				<img align="absmiddle" height="25" width="22" alt="<cfif attributes.profile_visible>Yes<cfelse>No</cfif>" src="images/checkbox_<cfif attributes.profile_visible>on<cfelse>off</cfif>.gif" />
			</cfif>
				Allow other members to view my information
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"status")>
		<tr valign="top">
			<td>
				<strong>Type:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"status")>
				<select name="status" size="1" tabindex="#variables.tabindex#">
				<cfloop query="qryUserTypes">
					<option value="#qryUserTypes.user_status_id#" <cfif attributes.status IS qryUserTypes.user_status_id>selected="selected"</cfif>>#qryUserTypes.status#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				<input type="hidden" name="status" value="#attributes.status#" />
				#attributes.statusType#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"date_expiration")>
		<tr valign="top">
			<td>
				<strong>Member Until:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"date_expiration")>
				<input type="text" name="date_expiration" size="10" maxlength="10" value="#attributes.date_expiration#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				<input type="hidden" name="date_expiration" value="#attributes.date_expiration#" />
				#attributes.date_expiration#
			</cfif>
			<cfif Request.squid.user_id EQ attributes.user_id AND DateDiff("D",Now(),Request.squid.date_expiration) LTE Request.renewalDays>
				<a href="#Request.self#?fuseaction=#XFA.dues#">Pay Dues</a>
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"email")>
		<tr valign="top">
			<td>
				<strong>E-mail Address:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"email")>
				<input type="text" name="email" size="25" maxlength="255" value="#attributes.email#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.email#
			</cfif>
			</td>
		</tr>
	</cfif>
<!--- (11/30/2012) This is no longer used
	<cfif ListFindNoCase(viewableFields,"username")>
		<tr valign="top">
			<td width="150">
				<strong>User Name:</strong>
			</td>
			<td width="250">
			<cfif ListFindNoCase(editableFields,"username")>
				<input type="text" name="username" size="20" maxlength="20" value="#attributes.username#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.username#
			</cfif>
			</td>
		</tr>
	</cfif>
--->
	<cfif ListFindNoCase(viewableFields,"first_name")>
		<tr valign="top">
			<td>
				<strong>First Name:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"first_name")>
				<input type="text" name="first_name" size="20" maxlength="50" value="#attributes.first_name#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.first_name#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"middle_name")>
		<tr valign="top">
			<td>
				<strong>Middle Name:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"middle_name")>
				<input type="text" name="middle_name" size="20" maxlength="50" value="#attributes.middle_name#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.middle_name#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"last_name")>
		<tr valign="top">
			<td>
				<strong>Last Name:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"last_name")>
				<input type="text" name="last_name" size="20" maxlength="50" value="#attributes.last_name#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.last_name#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"preferred_name")>
		<tr valign="top">
			<td>
				<strong>Preferred Name:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"preferred_name")>
				<input type="text" name="preferred_name" size="20" maxlength="50" value="#attributes.preferred_name#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.preferred_name#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"address")>
		<tr valign="top">
			<td>
				<strong>Address:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"address")>
				<input type="text" name="address1" size="20" maxlength="50" value="#attributes.address1#" tabindex="#variables.tabindex#" /><br />
				<cfset variables.tabindex = variables.tabindex + 1>
				<input type="text" name="address2" size="20" maxlength="50" value="#attributes.address2#" tabindex="#variables.tabindex#" /><br />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.address1#
				<cfif LEN(TRIM(attributes.address2)) GT 0>
					<br />
					#attributes.address2#
				</cfif>
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"address")>
		<tr valign="top">
			<td>
				<strong>City, State, ZIP:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"address")>
				<input type="text" name="city" size="15" maxlength="50" value="#attributes.city#" tabindex="#variables.tabindex#" />,
				<cfset variables.tabindex = variables.tabindex + 1>
				<select name="state_id" size="1" tabindex="#variables.tabindex#">
				<cfloop query="qryStates">
					<option value="#qryStates.state_id#" <cfif attributes.state_id IS qryStates.state_id>selected="selected"</cfif>>#qryStates.state#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
				<input type="text" name="zip" size="10" maxlength="10" value="#attributes.zip#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.city#, #qryStates.state# #attributes.zip#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"address")>
		<tr valign="top">
			<td>
				<strong>Country:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"address")>
				<select name="country" id="country" size="1" tabindex="#variables.tabindex#">
				<cfloop query="application.qCountries">
					<option value="#application.qCountries.countryCode#" <cfif attributes.country IS application.qCountries.countryCode OR attributes.country IS application.qCountries.threeLetterCountryCode>selected="true"</cfif>>#application.qCountries.country#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.country#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"mailingListYN")>
		<tr valign="top">
			<td>
				<strong>Receive Postal Mail?</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"mailingListYN")>
				<select name="mailingListYN" size="1" tabindex="#variables.tabindex#">
					<option value="0" <cfif NOT attributes.mailingListYN>selected="selected"</cfif>>No</option>
					<option value="1" <cfif attributes.mailingListYN>selected="selected"</cfif>>Yes</option>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#YesNoFormat(attributes.mailingListYN)#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"phone")>
		<tr valign="top">
			<td>
				<strong>Cell Phone:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"phone")>
				<input type="text" name="phone_cell" size="15" maxlength="50" value="#attributes.phone_cell#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.phone_cell#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"phone")>
		<tr valign="top">
			<td>
				<strong>Daytime Phone:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"phone")>
				<input type="text" name="phone_day" size="15" maxlength="50" value="#attributes.phone_day#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.phone_day#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"phone")>
		<tr valign="top">
			<td>
				<strong>Evening Phone:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"phone")>
				<input type="text" name="phone_night" size="15" maxlength="50" value="#attributes.phone_night#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.phone_night#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"phone")>
		<tr valign="top">
			<td>
				<strong>Fax:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"phone")>
				<input type="text" name="fax" size="15" maxlength="50" value="#attributes.fax#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.fax#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"emergency")>
		<tr valign="top">
			<td>
				<strong>Emergency Contact:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"emergency")>
				<input type="text" name="contact_emergency" size="20" maxlength="50" value="#attributes.contact_emergency#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.contact_emergency#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"emergency")>
		<tr valign="top">
			<td>
				<strong>Emergency Phone:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"emergency")>
				<input type="text" name="phone_emergency" size="15" maxlength="50" value="#attributes.phone_emergency#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.phone_emergency#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif NOT attributes.addNew AND ListFindNoCase(viewableFields,"balance")>
		<cfif isDate(qryBalance.swimPassExpiration)>
			<tr valign="top">
				<td>
					<strong>Swim Pass Expires</strong>:
				</td>
				<td>
					#dateFormat(qryBalance.swimPassExpiration,"m/d/yyyy")#
				<cfif attributes.user_id EQ Request.squid.user_id>
					<br />
					<a href="#Request.self#?fuseaction=#XFA.buySwims#">Buy Swims/Pass</a>
				</cfif>
				</td>
			</tr>
		<cfelse>
			<tr valign="top">
				<td>
					<strong>Swim Balance:</strong>
				</td>
				<td>
					#VAL(attributes.balance)#
				<cfif attributes.user_id EQ Request.squid.user_id>
					<a href="#Request.self#?fuseaction=#XFA.buySwims#">Buy Swims/Pass</a>
				</cfif>
				</td>
			</tr>
		</cfif>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"first_practice")>
		<tr valign="top">
			<td>
				<strong>First Practice:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"first_practice")>
				<input type="text" name="first_practice" size="10" maxlength="10" value="#attributes.first_practice#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.first_practice#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"intro_pass")>
		<tr valign="top">
			<td>
				<strong>Used Intro Pass?</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"intro_pass")>
				<input type="radio" name="intro_pass" value="1" <cfif attributes.intro_pass>checked="checked"</cfif> tabindex="#variables.tabindex#" />
				Yes
				<cfset variables.tabindex = variables.tabindex + 1>
				<input type="radio" name="intro_pass" value="0" <cfif NOT attributes.intro_pass>checked="checked"</cfif> tabindex="#variables.tabindex#" />
				No
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#YesNoFormat(attributes.intro_pass)#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"usms")>
		<tr valign="top">
			<td>
				<strong>USMS Number:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"usms")>
				<input type="text" name="usms_no" size="10" maxlength="15" value="#attributes.usms_no#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.usms_no#
			</cfif>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>USMS Year:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"usms")>
				<input type="text" name="usms_year" size="4" maxlength="4" value="#attributes.usms_year#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.usms_year#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"medical")>
		<tr valign="top">
			<td>
				<strong>Medical Conditions:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"medical")>
				<input type="text" name="medical_conditions" size="20" maxlength="255" value="#attributes.medical_conditions#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.medical_conditions#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"birthday")>
		<tr valign="top">
			<td>
				<strong>Birthday:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"birthday")>
				<input type="text" name="birthday" size="10" maxlength="10" value="#attributes.birthday#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.birthday#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"officer")>
		<tr valign="top">
			<td>
				<strong>Offices:</strong>
			</td>
			<td>
		<cfloop from="1" to="#ArrayLen(strProfile.officer)#" index="i">
			<cfif strProfile.officer[i].officer_profile>
				#strProfile.officer[i].officer_type#<br />
			</cfif>
		</cfloop>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"email_preference")>
		<tr valign="top">
			<td>
				<strong>E-mail Format:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"email_preference")>
				<select name="email_preference" size="1" tabindex="#variables.tabindex#">
				<cfloop query="qryEmailPreferences">
					<option value="#qryEmailPreferences.preference_id#" <cfif attributes.email_preference EQ qryEmailPreferences.preference_id>selected="selected"</cfif>>#qryEmailPreferences.preference#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				<input type="hidden" name="email_preference" value="#attributes.email_preference#" />
				#attributes.emailPref#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"posting_preference")>
		<tr valign="top">
			<td>
				<strong>Announcement Receipt Format:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"posting_preference")>
				<select name="posting_preference" size="1" tabindex="#variables.tabindex#">
				<cfloop query="qryPostingPreferences">
					<option value="#qryPostingPreferences.preference_id#" <cfif attributes.posting_preference EQ qryPostingPreferences.preference_id>selected="selected"</cfif>>#qryPostingPreferences.preference#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				<input type="hidden" name="posting_preference" value="#attributes.posting_preference#" />
				#attributes.postingPref#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"calendar_preference")>
		<tr valign="top">
			<td>
				<strong>Calendar Receipt Format:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"calendar_preference")>
				<select name="calendar_preference" size="1" tabindex="#variables.tabindex#">
				<cfloop query="qryCalPreferences">
					<option value="#qryCalPreferences.preference_id#" <cfif attributes.calendar_preference EQ qryCalPreferences.preference_id>selected="selected"</cfif>>#qryCalPreferences.preference#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				<input type="hidden" name="calendar_preference" value="#attributes.calendar_preference#" />
				#attributes.calendarPref#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"comments")>
		<tr valign="top">
			<td>
				<strong>Comments:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"comments")>
				<textarea name="comments" rows="4" cols="40" tabindex="#variables.tabindex#">#attributes.comments#</textarea>
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.comments#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif ListLen(editableFields)>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2" align="center">
				<input type="submit" name="submitBtn" value="Save Profile" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
				<input type="reset" name="resetBtn" value="Reset Form" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	</cfif>
<cfelse>
		<tr valign="top">
			<td colspan="2">
				You do not have access to view this Member.
			</td>
		</tr>
</cfif>
	</tbody>
</table>
	<input type="hidden" name="username_old" value="#strProfile.email#" />
</form>
</cfoutput>
