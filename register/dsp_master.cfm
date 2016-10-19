<!---
<fusedoc
	fuse="dsp_master.cfm" language="ColdFusion" specification="3.0">
	<responsibilities>
		I display the master regstration page.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="21 March 2004" type="Create" role="Architect">
	</properties>
	<io>
		<in>
			<structure name="XFA">
				<string name="next" />
			</structure>

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.last_name" default="" type="string">
	<cfparam name="attributes.first_name" default="" type="string">
	<cfparam name="attributes.initial" default="" type="string">
	<cfparam name="attributes.pref_name" default="" type="string">
	<cfparam name="attributes.dob" default="" type="string">
	<cfparam name="attributes.ath_sex" default="M" type="string">
	<cfparam name="attributes.Home_daytele" default="" type="string">
	<cfparam name="attributes.Home_email" default="" type="string">
	<cfparam name="attributes.Home_addr1" default="" type="string">
	<cfparam name="attributes.Home_addr2" default="" type="string">
	<cfparam name="attributes.Home_city" default="" type="string">
	<cfparam name="attributes.Home_state" default="CO" type="string">
	<cfparam name="attributes.Home_zip" default="" type="string">
	<cfparam name="attributes.Home_country" default="USA" type="string">
	<cfparam name="attributes.registrationType" default="both" type="string">

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<cfscript>
		// If exists, populate data
		if (VAL(Session.goldrush2009.registration_id) AND (NOT LEN(attributes.success)))
		{
			attributes.last_name = Session.goldrush2009.last_name;
			attributes.first_name = Session.goldrush2009.first_name;
			attributes.initial = Session.goldrush2009.initial;
			attributes.pref_name = Session.goldrush2009.pref_name;
			attributes.dob = Session.goldrush2009.dob;
			attributes.ath_sex = Session.goldrush2009.ath_sex;
			attributes.Home_daytele = Session.goldrush2009.Home_daytele;
			attributes.Home_email = Session.goldrush2009.Home_email;
			attributes.Home_addr1 = Session.goldrush2009.Home_addr1;
			attributes.Home_addr2 = Session.goldrush2009.Home_addr2;
			attributes.Home_city = Session.goldrush2009.Home_city;
			attributes.Home_state = Session.goldrush2009.Home_state;
			attributes.Home_zip = Session.goldrush2009.Home_zip;
			attributes.Home_country = Session.goldrush2009.Home_country;
			attributes.registrationType = Session.goldrush2009.registrationType;
		}

		attributes.dob = ReplaceNoCase(attributes.dob,"-","/","ALL");
	</cfscript>
	<cfset variables.tabindex = 1>
</cfsilent>

<cfif attributes.success IS "no">
	<h2>There were problems with your submission:</h2>
	<ul class="errorText">
		<cfloop list="#attributes.reason#" index="variables.theItem" delimiters="*">
			<li><cfoutput>#variables.theItem#</cfoutput></li>
		</cfloop>
	</ul>
	<p>Please make corrections below and re-submit the information.</p>
</cfif>

<cfoutput>
<form name="inputForm" action="#variables.baseHREF##Request.self#/fuseaction/#XFA.next#.cfm" method="post" onsubmit="return validate(this);">
<table border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td class="header1" colspan="2">
				#Request.page_title#
			</td>
		</tr>
	<cfif VAL(Session.goldrush2009.registration_id)>
		<tr>
			<td colspan="2">
				&nbsp;
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<a href="#Request.self#/fuseaction/#XFA.registration_menu#.cfm">Registration Menu</a>
			</td>
		</tr>
	</cfif>
	</thead>
	<tbody>
		<tr>
			<td colspan="2">
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				Fields marked with <span class="errorText">*</span> are required.
				<strong>If you are swimming in the meet, your name must match your USMS/FINA registration card
				EXACTLY.</strong>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>First Name<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<input type="text" name="first_name" size="20" maxlength="20" tabindex="#variables.tabindex#" value="#attributes.first_name#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Middle Initial:</strong>
			</td>
			<td>
				<input type="text" name="initial" size="1" maxlength="1" tabindex="#variables.tabindex#" value="#attributes.initial#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Last Name<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<input type="text" name="last_name" size="20" maxlength="20" tabindex="#variables.tabindex#" value="#attributes.last_name#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Preferred Name:</strong>
			</td>
			<td>
				<input type="text" name="pref_name" size="20" maxlength="20" tabindex="#variables.tabindex#" value="#attributes.pref_name#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Date of Birth<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<input type="text" name="dob" size="10" maxlength="10" tabindex="#variables.tabindex#" value="#attributes.dob#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Sex<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<input type="radio" name="ath_sex" tabindex="#variables.tabindex#" value="M" <cfif attributes.ath_sex IS "M">checked="checked"</cfif> />
				Male
				&nbsp;&nbsp;&nbsp;
				<input type="radio" name="ath_sex" tabindex="#variables.tabindex#" value="F" <cfif attributes.ath_sex IS "F">checked="checked"</cfif> />
				Female
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Telephone<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<input type="text" name="Home_daytele" size="20" maxlength="20" tabindex="#variables.tabindex#" value="#attributes.Home_daytele#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>E-mail<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<input type="text" name="Home_email" size="20" maxlength="30" tabindex="#variables.tabindex#" value="#attributes.Home_email#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Address<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<input type="text" name="Home_addr1" size="20" maxlength="30" tabindex="#variables.tabindex#" value="#attributes.Home_addr1#" />
				<cfset variables.tabindex = variables.tabindex + 1>
				<br />
				<input type="text" name="Home_addr2" size="20" maxlength="30" tabindex="#variables.tabindex#" value="#attributes.Home_addr2#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>City<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<input type="text" name="Home_city" size="20" maxlength="30" tabindex="#variables.tabindex#" value="#attributes.Home_city#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>State:</strong>
			</td>
			<td>
				<select name="Home_state" tabindex="#variables.tabindex#">
					<option value="--" <cfif attributes.Home_state IS "--">selected="selected"</cfif>>(Non-US)</option>
				<cfloop query="qStates">
					<option value="#qStates.state_code#" <cfif attributes.Home_state IS qStates.state_code>selected="selected"</cfif>>#qStates.state_name#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>ZIP/Postal Code:</strong>
			</td>
			<td>
				<input type="text" name="Home_zip" size="10" maxlength="10" tabindex="#variables.tabindex#" value="#attributes.Home_zip#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Country<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<select name="Home_country" tabindex="#variables.tabindex#">
					<option value="--" <cfif attributes.Home_country IS "--">selected="selected"</cfif>>(Not listed)</option>
				<cfloop query="qCountries">
					<option value="#qCountries.cntry_code#" <cfif attributes.Home_country IS qCountries.cntry_code>selected="selected"</cfif>>#qCountries.cntry_name#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Registration Type<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<select name="registrationType" tabindex="#variables.tabindex#">
					<option value="both" <cfif attributes.registrationType IS "Both">selected="selected"</cfif>>Swim Meet and Social Events (#DollarFormat(Request.lookup_cfc.getRegistrationFee(Request.fees,"both"))#)</option>
					<option value="meet" <cfif attributes.registrationType IS "meet">selected="selected"</cfif>>Swim Meet only (#DollarFormat(Request.lookup_cfc.getRegistrationFee(Request.fees,"meet"))#)</option>
					<option value="social" <cfif attributes.registrationType IS "social">selected="selected"</cfif>>Social Events only (#DollarFormat(Request.lookup_cfc.getRegistrationFee(Request.fees,"social"))#)</option>
					<option value="meetPicnic" <cfif attributes.registrationType IS "meetPicnic">selected="selected"</cfif>>Meet and Awards Picnic only (#DollarFormat(Request.lookup_cfc.getRegistrationFee(Request.fees,"meetPicnic"))#)</option>
					<option value="picnic" <cfif attributes.registrationType IS "picnic">selected="selected"</cfif>>Awards Picnic only (#DollarFormat(Request.lookup_cfc.getRegistrationFee(Request.fees,"picnic"))#)</option>
				<cfif IsDefined("Session.squid.permissions") AND ListFindNoCase(Session.squid.permissions,"Update Swim Meet")>
					<option value="both_Early" <cfif ListFirst(attributes.registrationType,"_") IS "both" AND ListLen(attributes.registrationType,"_") GT 1>selected="selected"</cfif>>Swim Meet and Social Events (#DollarFormat(Request.lookup_cfc.getRegistrationFee(Request.fees,"both",true))#)</option>
					<option value="meet_Early" <cfif ListFirst(attributes.registrationType,"_") IS "meet" AND ListLen(attributes.registrationType,"_") GT 1>selected="selected"</cfif>>Swim Meet only (#DollarFormat(Request.lookup_cfc.getRegistrationFee(Request.fees,"meet",true))#)</option>
					<option value="social_Early" <cfif ListFirst(attributes.registrationType,"_") IS "social" AND ListLen(attributes.registrationType,"_") GT 1>selected="selected"</cfif>>Social Events only (#DollarFormat(Request.lookup_cfc.getRegistrationFee(Request.fees,"social",true))#)</option>
					<option value="picnic_Early" <cfif ListFirst(attributes.registrationType,"_") IS "picnic" AND ListLen(attributes.registrationType,"_") GT 1>selected="selected"</cfif>>Awards Picnic only (#DollarFormat(Request.lookup_cfc.getRegistrationFee(Request.fees,"picnic",true))#)</option>
				</cfif>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center">
				<input type="submit" name="submitBtn" value="Save Changes" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
			<td>&nbsp;</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>
