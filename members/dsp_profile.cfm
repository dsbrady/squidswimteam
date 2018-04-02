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
	<cfparam name="attributes.emailPreferenceID" default="1" type="numeric">
	<cfparam name="attributes.posting_preference" default="3" type="numeric">
	<cfparam name="attributes.isUnsubscribed" default="false" type="boolean">
	<cfparam name="attributes.emailPref" default="Plain Text" type="string">
	<cfparam name="attributes.postingPref" default="All Messages" type="string">

	<cfparam name="attributes.returnFA" default="" type="string">
	<cfparam name="attributes.statusType" default="" type="string">
	<cfparam name="attributes.activityLevel" default="both" type="string">
	<cfparam name="attributes.addNew" default="false" type="boolean">

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<cfif NOT attributes.addNew>
		<cfset user = new squid.User(application.dsn, attributes.user_id) />

		<cfset attributes.balance = user.getSwimBalance()>

		<cfif (attributes.success IS NOT "No")>
			<cfscript>
				attributes.status = user.getUserStatusID();
				attributes.statusType = user.getUserStatusID();
				attributes.first_name = user.getFirstName();
				attributes.middle_name = user.getMiddleName();
				attributes.last_name = user.getLastName();
				attributes.preferred_name = user.getPreferredName();
				attributes.address1 = user.getAddress1();
				attributes.address2 = user.getAddress2();
				attributes.city = user.getCity();
				attributes.state_id = user.getStateID();
				attributes.zip = user.getZIP();
				attributes.country = user.getCountry();
				attributes.email = user.getEmail();
				attributes.birthday = DateFormat(user.getBirthday(),"m/d/yyyy");
				attributes.phone_cell = user.getCellPhone();
				attributes.phone_day = user.getPhoneDay();
				attributes.phone_night = user.getPhoneNight();
				attributes.fax = user.getFax();
				attributes.phone_emergency = user.getEmergencyPhone();
				attributes.contact_emergency = user.getEmergencyContact();
				attributes.first_practice = dateformat(user.getFirstPractice(),"m/d/yyyy");
				attributes.intro_pass = user.getUsedIntroPass();
				attributes.usms_no = user.getUSMSNumber();
				attributes.usms_year = user.getUSMSYear();
				attributes.medical_conditions = user.getMedicalConditions();
				attributes.comments = user.getComments();
				attributes.picture = user.getPicture();
				attributes.picture_height = user.getPictureHeight();
				attributes.picture_width = user.getPictureWidth();
				attributes.profile_visible = user.getIsProfileVisible();
				attributes.date_expiration = DateFormat(user.getExpirationDate(),'mm/dd/yyyy');;
				attributes.emailPreferenceID = user.getEmailPreferenceID();
				attributes.posting_preference = user.getPostingPreferenceID();
				attributes.emailPref = user.getEmailPreference();
				attributes.postingPref = user.getPostingPreference();
				attributes.mailingListYN = user.getIsOnMailingList();
			</cfscript>
		</cfif>
	<cfelse>
		<cfset user = new squid.User(application.dsn, 0) />
		<cfset user.setEmailPreferenceID("Plain Text") />
		<cfset user.setEmailPreferenceID(1) />
		<cfset user.setPostingPreferenceID("All Messages") />
		<cfset user.setPostingPreferenceID(3) />
		<cfset user.setUserStatus("Member") />
		<cfset user.setUserStatusID(2) />
	</cfif>

	<cfset attributes.date_expiration = replace(attributes.date_expiration,"-","/","ALL")>
	<cfset attributes.birthday = replace(attributes.birthday,"-","/","ALL")>
	<cfset attributes.first_practice = replace(attributes.first_practice,"-","/","ALL")>

	<!--- Get states --->
	<cfif attributes.actionType IS "view">
		<cfinvoke
			component="#Request.lookup_cfc#"
			method="getStates"
			returnvariable="qryStates"
			dsn=#Request.DSN#
			stateTbl=#Request.stateTbl#
			state_id=#user.getStateID()#
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
			state_id=#user.getStateID()#
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

	<cfset variables.tabindex = 1>

	<!--- Set up editable fields list --->
	<cfscript>
		editableFields = "";
		viewableFields = "first_name,middle_name,last_name,preferred_name,address,email,birthday,phone,emergency,first_practice,intro_pass,usms,comments,picture,officer,emailPreferenceID,posting_preference,mailingListYN,balance,";

		if (attributes.user_id EQ Request.squid.user_id AND (CompareNoCase(attributes.actionType,"view") NEQ 0))
		{
			editableFields = editableFields & "first_name,middle_name,last_name,preferred_name,address,email,birthday,phone,emergency,first_practice,intro_pass,usms,medical,comments,picture,profile_visible,emailPreferenceID,posting_preference,mailingListYN,";
			viewableFields = viewableFields & "medical,status,balance,profile_visible,date_expiration,";
		}
		if (Secure("Update Members") AND (CompareNoCase(attributes.actionType,"view") NEQ 0))
		{
			editableFields = editableFields & "first_name,middle_name,last_name,preferred_name,address,email,birthday,phone,emergency,first_practice,intro_pass,usms,medical,comments,picture,status,profile_visible,date_expiration,emailPreferenceID,posting_preference,mailingListYN,";
			viewableFields = viewableFields & "medical,status,balance,profile_visible,date_expiration,";
		}
	</cfscript>
</cfsilent>

<cfoutput>
<script type="text/javascript">
	$(document).ready(function(){
		<cfif attributes.user_id NEQ request.squid.user_id>
			$('input[name="isUnsubscribed"]').on('click', function() {
					alert('Be sure you have #encodeForJavascript(attributes.preferred_name)#\'s permission when updating their unsubscribe status.');
				});
		</cfif>
	});
</script>
<cfif attributes.success IS "no">
	<h2>There were problems with your submission:</h2>
	<ul class="errorText">
		<cfloop list="#attributes.reason#" index="variables.theItem" delimiters="*">
			<li>#variables.theItem#</li>
		</cfloop>
	</ul>
	<p>Please make corrections below and re-submit the information.</p>
<cfelseif attributes.success IS "yes">
	<p class="errorText">
		Changes Saved.
	</p>
</cfif>

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
<cfif (user.getIsProfileVisible()) OR (attributes.user_id EQ Request.squid.user_id) OR (Secure("Update Members"))>
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
		<tr valign="top">
			<td>
				<strong>Swim Balance:</strong>
			</td>
			<td>
				#VAL(user.getSwimBalance())#
			<cfif attributes.user_id EQ Request.squid.user_id>
				<a href="#Request.self#?fuseaction=#XFA.buySwims#">Buy Swims</a>
			</cfif>
			</td>
		</tr>
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
		<cfloop from="1" to="#arrayLen(user.getOffices())#" index="i">
			<cfif user.getOffices()[i].profile>
				#user.getOffices()[i].officer_type#<br />
			</cfif>
		</cfloop>
			</td>
		</tr>
	</cfif>
	<cfif ListFindNoCase(viewableFields,"emailPreferenceID")>
		<tr valign="top">
			<td>
				<strong>E-mail Format:</strong>
			</td>
			<td>
			<cfif ListFindNoCase(editableFields,"emailPreferenceID")>
				<select name="emailPreferenceID" size="1" tabindex="#variables.tabindex#">
				<cfloop query="qryEmailPreferences">
					<option value="#qryEmailPreferences.preference_id#" <cfif attributes.emailPreferenceID EQ qryEmailPreferences.preference_id>selected="selected"</cfif>>#qryEmailPreferences.preference#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				<input type="hidden" name="emailPreferenceID" value="#attributes.emailPreferenceID#" />
				#attributes.emailPref#
			</cfif>
			</td>
		</tr>
	</cfif>
	<cfif listFindNoCase(editableFields,"emailPreferenceID")>
		<tr valign="top">
			<td>
				<strong>Unsubscribed?</strong>
			</td>
			<td>
				<input type="radio" name="isUnsubscribed" tabindex="#variables.tabIndex#" value="true" #user.getIsUnsubscribed() ? "checked": ""# /> Yes
				<input type="radio" name="isUnsubscribed" tabindex="#variables.tabIndex#" value="false" #NOT user.getIsUnsubscribed() ? "checked": ""# /> No
			</td>
		</tr>
	<cfelse>
		<input type="hidden" name="isUnsubscribed" value="#user.getIsUnsubscribed()#" />
	</cfif>
		<input type="hidden" name="isUnsubscribedPrevious" value="#user.getIsUnsubscribed()#" />
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
	<input type="hidden" name="username_old" value="#user.getEmail()#" />
</form>
</cfoutput>
