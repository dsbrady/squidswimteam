<!---
<fusedoc
	fuse="dsp_housing.cfm"
		language="ColdFusion"
		specification="3.0">
	<responsibilities>
		I display the hosted housing form.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="11 April 2004" type="Create" role="Architect">
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
	<cfparam name="attributes.num_guests" default="0" type="numeric">
	<cfparam name="attributes.names" default="" type="string">
	<cfparam name="attributes.address" default="" type="string">
	<cfparam name="attributes.city" default="" type="string">
	<cfparam name="attributes.state" default="" type="string">
	<cfparam name="attributes.zip" default="" type="string">
	<cfparam name="attributes.country" default="" type="string">
	<cfparam name="attributes.phone_day" default="" type="string">
	<cfparam name="attributes.phone_evening" default="" type="string">
	<cfparam name="attributes.email" default="" type="string">
	<cfparam name="attributes.nights" default="" type="string">
	<cfparam name="attributes.car" default="" type="string">
	<cfparam name="attributes.near_location" default="" type="string">
	<cfparam name="attributes.smoke" default="" type="string">
	<cfparam name="attributes.allergies" default="" type="string">
	<cfparam name="attributes.needs" default="" type="string">
	<cfparam name="attributes.sleeping" default="" type="string">
	<cfparam name="attributes.sleeping_share" default="" type="string">
	<cfparam name="attributes.temperament" default="" type="string">

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<cfscript>
		// If exists, populate data
		if ((attributes.success IS NOT "No"))
		{
			attributes.num_guests = Session.goldrush2009.num_guests;
			if (LEN(Session.goldrush2009.housing_names))
			{
				attributes.names = Session.goldrush2009.housing_names;
			}
			else
			{
				attributes.names = Session.goldrush2009.pref_name & " " & Session.goldrush2009.last_name;
			}
			if (LEN(Session.goldrush2009.housing_address))
			{
				attributes.address = Session.goldrush2009.housing_address;
			}
			else
			{
				attributes.address = Session.goldrush2009.home_addr1;
			}
			if (LEN(Session.goldrush2009.housing_city))
			{
				attributes.city = Session.goldrush2009.housing_city;
			}
			else
			{
				attributes.city = Session.goldrush2009.home_city;
			}
			if (LEN(Session.goldrush2009.housing_state))
			{
				attributes.state = Session.goldrush2009.housing_state;
			}
			else
			{
				attributes.state = Session.goldrush2009.home_state;
			}
			if (LEN(Session.goldrush2009.housing_zip))
			{
				attributes.zip = Session.goldrush2009.housing_zip;
			}
			else
			{
				attributes.zip = Session.goldrush2009.home_zip;
			}
			if (LEN(Session.goldrush2009.housing_country))
			{
				attributes.country = Session.goldrush2009.housing_country;
			}
			else
			{
				attributes.country = Session.goldrush2009.home_country;
			}
			if (LEN(Session.goldrush2009.housing_email))
			{
				attributes.email = Session.goldrush2009.housing_email;
			}
			else
			{
				attributes.email = Session.goldrush2009.home_email;
			}
			if (LEN(Session.goldrush2009.phone_day))
			{
				attributes.phone_day = Session.goldrush2009.phone_day;
			}
			else
			{
				attributes.phone_day = Session.goldrush2009.home_daytele;
			}
			if (LEN(Session.goldrush2009.phone_evening))
			{
				attributes.phone_evening = Session.goldrush2009.phone_evening;
			}
			else
			{
				attributes.phone_evening = Session.goldrush2009.home_daytele;
			}
			attributes.nights = Session.goldrush2009.nights;
			attributes.car = Session.goldrush2009.car;
			attributes.near_location = Session.goldrush2009.near_location;
			attributes.smoke = Session.goldrush2009.smoke;
			attributes.allergies = Session.goldrush2009.allergies;
			attributes.needs = Session.goldrush2009.needs;
			attributes.sleeping = Session.goldrush2009.sleeping;
			attributes.sleeping_share = Session.goldrush2009.sleeping_share;
			attributes.temperament = Session.goldrush2009.temperament;
		}
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
	</thead>
	<tbody>
		<tr>
			<td colspan="2">
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
			<p>
				<strong>SQUID members and our friends will do our best to meet the housing
				needs of visiting swimmers during the weekend of the meet.  If you would like
				hosted housing, please complete the following hosted housing request form.</strong>
			</p>
			<p>
				<strong>If request is for two individuals wishing to stay with the same host, please
				enter both names in the "Name(s)" field. Please only submit one housing form per couple
				(even if both are submitting registration forms).</strong>
			</p>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Number of Guests<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<select name="num_guests" tabindex="#variables.tabindex#">
					<option value="1" <cfif VAL(attributes.num_guests) LTE 1>selected="seelcted"</cfif>>1</option>
					<option value="2" <cfif VAL(attributes.num_guests) EQ 2>selected="seelcted"</cfif>>2</option>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Name(s)<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<input type="text" name="names" size="20" maxlength="50" tabindex="#variables.tabindex#" value="#attributes.names#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Address<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<input type="text" name="address" size="20" maxlength="255" tabindex="#variables.tabindex#" value="#attributes.address#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>City<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<input type="text" name="city" size="20" maxlength="50" tabindex="#variables.tabindex#" value="#attributes.city#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>State<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<select name="state" tabindex="#variables.tabindex#">
					<option value="--" <cfif attributes.state IS "--">selected="selected"</cfif>>(Non-US)</option>
				<cfloop query="qStates">
					<option value="#qStates.state_code#" <cfif attributes.state IS qStates.state_code>selected="selected"</cfif>>#qStates.state_name#</option>
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
				<input type="text" name="zip" size="10" maxlength="10" tabindex="#variables.tabindex#" value="#attributes.zip#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Country<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<select name="country" tabindex="#variables.tabindex#">
					<option value="--" <cfif attributes.country IS "--">selected="selected"</cfif>>(Not listed)</option>
				<cfloop query="qCountries">
					<option value="#qCountries.cntry_code#" <cfif attributes.country IS qCountries.cntry_code>selected="selected"</cfif>>#qCountries.cntry_name#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Phone (day):</strong>
			</td>
			<td>
				<input type="text" name="phone_day" size="10" maxlength="20" tabindex="#variables.tabindex#" value="#attributes.phone_day#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Phone (evening):</strong>
			</td>
			<td>
				<input type="text" name="phone_evening" size="10" maxlength="20" tabindex="#variables.tabindex#" value="#attributes.phone_evening#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>E-mail<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<input type="text" name="email" size="20" maxlength="255" tabindex="#variables.tabindex#" value="#attributes.email#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Night(s) Requested<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<input type="checkbox" id="nights_Th" name="nights" value="Th" tabindex="#variables.tabindex#" <cfif ListFindNoCase(attributes.nights,"Th")>checked="checked"</cfif> />
				<label for="nights_Th">Thursday, October 8</label>
				<cfset variables.tabindex = variables.tabindex + 1>
				<br />
				<input type="checkbox" id="nights_F" name="nights" value="F" tabindex="#variables.tabindex#" <cfif ListFindNoCase(attributes.nights,"F")>checked="checked"</cfif> />
				<label for="nights_F">Friday, October 9</label>
				<cfset variables.tabindex = variables.tabindex + 1>
				<br />
				<input type="checkbox" id="nights_Sat" name="nights" value="Sat" tabindex="#variables.tabindex#" <cfif ListFindNoCase(attributes.nights,"Sat")>checked="checked"</cfif> />
				<label for="nights_Sat">Saturday, October 10</label>
				<cfset variables.tabindex = variables.tabindex + 1>
				<br />
				<input type="checkbox" id="nights_Sun" name="nights" value="Sun" tabindex="#variables.tabindex#" <cfif ListFindNoCase(attributes.nights,"Sun")>checked="checked"</cfif> />
				<label for="nights_Sun">Sunday, October 11</label>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				<strong>Will you have access to a car?<span class="errorText">*</span>:</strong>
			</td>
		</tr>
		<tr valign="top">
			<td>
				&nbsp;
			</td>
			<td>
				<select name="car" tabindex="#variables.tabindex#">
					<option value="0" <cfif NOT VAL(attributes.car)>selected="seclected"</cfif>>No</option>
					<option value="1" <cfif VAL(attributes.car)>selected="seclected"</cfif>>Yes</option>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>If not, who or where do you need to be near?</strong>
			</td>
		</tr>
		<tr valign="top">
			<td>
				&nbsp;
			</td>
			<td>
				<input type="text" name="near_location" size="20" maxlength="255" tabindex="#variables.tabindex#" value="#attributes.near_location#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Do you smoke?<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<select name="smoke" tabindex="#variables.tabindex#">
					<option value="0" <cfif NOT VAL(attributes.smoke)>selected="seclected"</cfif>>No</option>
					<option value="1" <cfif VAL(attributes.smoke)>selected="seclected"</cfif>>Yes</option>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Allergies/Phobias:</strong>
			</td>
			<td>
				<input type="text" name="allergies" size="20" maxlength="50" tabindex="#variables.tabindex#" value="#attributes.allergies#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Special Needs:</strong>
			</td>
			<td>
				<input type="text" name="needs" size="20" maxlength="255" tabindex="#variables.tabindex#" value="#attributes.needs#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				<strong>Preferred sleeping arrangement (check all that apply)<span class="errorText">*</span>:</strong>
			</td>
		</tr>
		<tr valign="top">
			<td>
				&nbsp;
			</td>
			<td>
				<input type="checkbox" id="sleeping_couch" name="sleeping" value="couch" tabindex="#variables.tabindex#" <cfif ListFindNoCase(attributes.sleeping,"couch")>checked="checked"</cfif> />
				<label for="sleeping_couch">Couch or futon is fine</label>
				<cfset variables.tabindex = variables.tabindex + 1>
				<br />
				<input type="checkbox" id="sleeping_own" name="sleeping" value="own" tabindex="#variables.tabindex#" <cfif ListFindNoCase(attributes.sleeping,"own")>checked="checked"</cfif> />
				<label for="sleeping_own">I really need my own bed.</label>
				<cfset variables.tabindex = variables.tabindex + 1>
				<br />
				<input type="checkbox" id="sleeping_share" name="sleeping" value="share" tabindex="#variables.tabindex#" <cfif ListFindNoCase(attributes.sleeping,"share")>checked="checked"</cfif> />
				<label for="sleeping_share">If housing space is scarce, I can share a bed with</label><br />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="sleeping_share" size="20" maxlength="50" tabindex="#variables.tabindex#" validationmsg="#attributes.sleeping_share#" />
				<cfset variables.tabindex = variables.tabindex + 1>
				<br />
				<input type="checkbox" id="sleeping_partner" name="sleeping" value="partner" tabindex="#variables.tabindex#" <cfif ListFindNoCase(attributes.sleeping,"partner")>checked="checked"</cfif> />
				<label for="sleeping_partner">Traveling with a partner, as indicated above, and would like to share bed with that person.</label>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				<strong>Finally, in order to match hosts and guests of similar temperament, which of the following best describes you?<span class="errorText">*</span>:</strong>
			</td>
		</tr>
		<tr valign="top">
			<td>
				&nbsp;
			</td>
			<td>
				<input type="checkbox" id="temperament_quiet" name="temperament" value="quiet" tabindex="#variables.tabindex#" <cfif ListFindNoCase(attributes.temperament,"quiet")>checked="checked"</cfif> />
				<label for="temperament_quiet">Quiet, refined, civilized; prefer to go to bed early.</label>
				<cfset variables.tabindex = variables.tabindex + 1>
				<br />
				<input type="checkbox" id="temperament_moderate" name="temperament" value="moderate" tabindex="#variables.tabindex#" <cfif ListFindNoCase(attributes.temperament,"moderate")>checked="checked"</cfif> />
				<label for="temperament_moderate">Reasonably early to bed before the meet; plan to party in moderation after meet.</label>
				<cfset variables.tabindex = variables.tabindex + 1>
				<br />
				<input type="checkbox" id="temperament_party" name="temperament" value="party" tabindex="#variables.tabindex#" <cfif ListFindNoCase(attributes.temperament,"party")>checked="checked"</cfif> />
				<label for="temperament_party">Not too concerned with getting to bed early; hope to party into the wee hours after meet.</label>
				<cfset variables.tabindex = variables.tabindex + 1>
				<br />
				<input type="checkbox" id="temperament_monster" name="temperament" value="monster" tabindex="#variables.tabindex#" <cfif ListFindNoCase(attributes.temperament,"monster")>checked="checked"</cfif> />
				<label for="temperament_monster">Party monster; might not make it home; don't wait up.</label>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2">
				SQUID will do its best to match you with a host for the weekend.
				If demand exceeds supply, the earliest requests will receive preference.
				Once matched, your host will contact you after #DateFormat(Request.housingResponseDeadline,"m/d/yyyy")#.
				If you have questions or if you have not been contacted about hosted housing by
				#DateFormat(DateAdd("D",2,Request.housingResponseDeadline),"m/d/yyyy")#,
				contact the hosted housing coordinator, Ryan Davidson, by sending an e-mail to:
				<a href="mailto:rtdavidson@gmail.com">rtdavidson@gmail.com</a>.
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2" align="center">
				<input type="submit" name="submitBtn" value="Save Changes" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
			<td>&nbsp;</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>
