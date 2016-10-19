<!---
<fusedoc
	fuse = "dsp_membershipForm.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the membership form.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="28 September 2004" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
			</structure>

			<number name="user_id" scope="attributes" />

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
			<number name="user_id" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.user_id" default="#Request.squid.user_id#" type="numeric" />
	<cfparam name="attributes.first_name" default="" type="string" />
	<cfparam name="attributes.middle_name" default="" type="string" />
	<cfparam name="attributes.last_name" default="" type="string" />
	<cfparam name="attributes.preferred_name" default="" type="string" />
	<cfparam name="attributes.address1" default="" type="string" />
	<cfparam name="attributes.address2" default="" type="string" />
	<cfparam name="attributes.city" default="" type="string" />
	<cfparam name="attributes.state_id" default="CO" type="string" />
	<cfparam name="attributes.zip" default="" type="string" />
	<cfparam name="attributes.country" default="" type="string" />
	<cfparam name="attributes.email" default="" type="string" />
	<cfparam name="attributes.email_format" default="plain" type="string" />
	<cfparam name="attributes.birthday" default="" type="string" />
	<cfparam name="attributes.phone_cell" default="" type="string" />
	<cfparam name="attributes.phone_day" default="" type="string" />
	<cfparam name="attributes.phone_night" default="" type="string" />
	<cfparam name="attributes.fax" default="" type="string" />
	<cfparam name="attributes.contact_emergency" default="" type="string" />
	<cfparam name="attributes.phone_emergency" default="" type="string" />
	<cfparam name="attributes.usms_no" default="" type="string" />
	<cfparam name="attributes.medical_conditions" default="" type="string" />

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get Member Info --->
	<cfset accessOK = true />

	<cfif VAL(Request.squid.user_id)>
		<cfset stMember = Request.squid />
	<cfelseif VAL(attributes.user_id)>
		<cfset loginCFC = CreateObject("component",Request.login_cfc) />
		<cfset stMember = StructNew() />
		<cfset stMember.user_id = attributes.user_id />
		<cfset stMember = variables.loginCFC.getUserInfo(stMember,Request.usersTbl,Request.preferenceTbl,Request.developerTbl,Request.testerTbl,Request.user_statusTbl,Request.DSN) />

		<!--- Make sure the info matches --->
		<cfif DateCompare(stMember.created_date,attributes.created_date) NEQ 0 OR stMember.created_user NEQ attributes.created_user OR stMember.username NEQ attributes.username>
			<cfset accessOK = false />
		</cfif>
	</cfif>

	<cfif (attributes.success IS NOT "No" AND VAL(attributes.user_id))>
		<cfset attributes.first_name = stMember.first_name />
		<cfset attributes.middle_name = stMember.middle_name />
		<cfset attributes.last_name = stMember.last_name />
		<cfset attributes.preferred_name = stMember.preferred_name />
		<cfset attributes.phone_cell = stMember.phone_cell />
		<cfset attributes.email = stMember.email />
		<cfset attributes.address1 = stMember.address1 />
		<cfset attributes.address2 = stMember.address2 />
		<cfset attributes.city = stMember.city />
		<cfset attributes.state_id = stMember.state_id />
		<cfset attributes.zip = stMember.zip />
		<cfset attributes.country = stMember.country />
		<cfset attributes.phone_day = stMember.phone_day />
		<cfset attributes.phone_night = stMember.phone_night />
		<cfset attributes.fax = stMember.fax />
		<cfset attributes.contact_emergency = stMember.contact_emergency />
		<cfset attributes.phone_emergency = stMember.phone_emergency />
		<cfset attributes.birthday = DateFormat(stMember.birthday,"m/d/yyyy") />
		<cfset attributes.usms_no = stMember.usms_number />
		<cfset attributes.email_format = stMember.emailPref />
		<cfset attributes.medical_conditions = stMember.medical_conditions />
	</cfif>

	<cfset attributes.birthday = Replace(attributes.birthday,"-","/","ALL") />

	<!--- Get states --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getStates"
		returnvariable="qStates"
		dsn=#Request.DSN#
		stateTbl=#Request.stateTbl#
		state_id=#attributes.state_id#
	>

	<cfset variables.tabindex = 1 />
</cfsilent>

<cfoutput>
<cfif attributes.success IS "no">
	<h2>There were problems with your submission:</h2>
	<ul class="errorText">
		<cfloop list="#attributes.reason#" index="variables.theItem" delimiters="*">
			<li>#variables.theItem#</li>
		</cfloop>
	</ul>
	<p>Please make corrections below and re-submit the information.</p>
<cfelseif NOT variables.accessOK>
	<h2>Access Denied</h2>
	<p class="errorText">
		The information provided does not match this user's information.
	</p>
	<p>
		If you feel this is an error, please <a href="#Request.self#?fuseaction=#XFA.contact#">Contact Us</a>.
	</p>
	<cfexit />
</cfif>

<form name="inputForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post" onsubmit="return validate(this);">
	<input type="hidden" name="user_id" value="#attributes.user_id#" />
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
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				<p>
					There are two methods for paying dues to SQUID.  You can pay via check
					or PayPal.  To pay via check, please use <a href="http://www.squidswimteam.org/files/newSwimmerForm.pdf" target="_blank">this form</a>. To pay via
					PayPal, please fill out the following form and proceed to the next step.
				</p>
			<cfif attributes.user_id EQ 0>
				<p>
					<strong>If you are a past or current member of SQUID, please <a href="http://squidswimteam.org/index.cfm?fuseaction=members.start">login</a> to pay your dues. Using this form to pay your dues will create a duplicate account, and 
					you will lose your membership history.</strong>
				</p>
			</cfif>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td>
			<strong>
					Pay Dues Through:
				</strong>
			</td>
			<td>
				#session.squid.stDues.membershipYear[session.squid.stDues.duesIndex]#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>
					Payment Due:
				</strong>
			</td>
			<td>
				#DollarFormat(session.squid.stDues.fee[session.squid.stDues.duesIndex])#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>E-mail Address:</strong>
			</td>
			<td>
				<input type="text" name="email" size="25" maxlength="255" value="#attributes.email#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
				<em>(This will be your user name)</em>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>First Name:</strong>
			</td>
			<td>
				<input type="text" name="first_name" size="20" maxlength="50" value="#attributes.first_name#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Middle Name:</strong>
			</td>
			<td>
				<input type="text" name="middle_name" size="20" maxlength="50" value="#attributes.middle_name#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Last Name:</strong>
			</td>
			<td>
				<input type="text" name="last_name" size="20" maxlength="50" value="#attributes.last_name#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Preferred Name:</strong>
			</td>
			<td>
				<input type="text" name="preferred_name" size="20" maxlength="50" value="#attributes.preferred_name#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Address:</strong>
			</td>
			<td>
				<input type="text" name="address1" size="20" maxlength="50" value="#attributes.address1#" tabindex="#variables.tabindex#" /><br />
				<cfset variables.tabindex = variables.tabindex + 1>
				<input type="text" name="address2" size="20" maxlength="50" value="#attributes.address2#" tabindex="#variables.tabindex#" /><br />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>City, State, ZIP:</strong>
			</td>
			<td>
				<input type="text" name="city" size="15" maxlength="50" value="#attributes.city#" tabindex="#variables.tabindex#" />,
				<cfset variables.tabindex = variables.tabindex + 1>
				<select name="state_id" size="1" tabindex="#variables.tabindex#">
				<cfloop query="qStates">
					<option value="#qStates.state_id#" <cfif attributes.state_id IS qStates.state_id>selected="selected"</cfif>>#qStates.state#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
				<input type="text" name="zip" size="10" maxlength="10" value="#attributes.zip#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Country:</strong>
			</td>
			<td>
				<select name="country" id="country" size="1" tabindex="#variables.tabindex#">
				<cfloop query="application.qCountries">
					<option value="#application.qCountries.countryCode#" <cfif attributes.country IS application.qCountries.countryCode OR attributes.country IS application.qCountries.threeLetterCountryCode>selected="true"</cfif>>#application.qCountries.country#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Cell Phone:</strong>
			</td>
			<td>
				<input type="text" name="phone_cell" size="15" maxlength="50" value="#attributes.phone_cell#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Daytime Phone:</strong>
			</td>
			<td>
				<input type="text" name="phone_day" size="15" maxlength="50" value="#attributes.phone_day#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Evening Phone:</strong>
			</td>
			<td>
				<input type="text" name="phone_night" size="15" maxlength="50" value="#attributes.phone_night#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Fax:</strong>
			</td>
			<td>
				<input type="text" name="fax" size="15" maxlength="50" value="#attributes.fax#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Emergency Contact:</strong>
			</td>
			<td>
				<input type="text" name="contact_emergency" size="20" maxlength="50" value="#attributes.contact_emergency#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Emergency Phone:</strong>
			</td>
			<td>
				<input type="text" name="phone_emergency" size="15" maxlength="50" value="#attributes.phone_emergency#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>USMS Number:</strong>
			</td>
			<td>
				<input type="text" name="usms_no" size="10" maxlength="15" value="#attributes.usms_no#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Medical Conditions:</strong>
			</td>
			<td>
				<input type="text" name="medical_conditions" size="20" maxlength="255" value="#attributes.medical_conditions#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Birthday:</strong>
			</td>
			<td>
				<input type="text" name="birthday" size="10" maxlength="10" value="#attributes.birthday#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2" align="center">
				<input type="submit" name="submitBtn" value="Next Step" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
				<input type="reset" name="resetBtn" value="Reset Form" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

