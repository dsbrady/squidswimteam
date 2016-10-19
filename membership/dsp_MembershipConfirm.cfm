<!---
<fusedoc
	fuse = "dsp_MembershipConfirm.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the Dues Payment confirmation screen.
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
		</in>
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

	<cfparam name="attributes.success" default="" type="string" />
	<cfparam name="attributes.reason" default="" type="string" />

	<cfset variables.tabindex = 1 />

	<cfset attributes.birthday = Replace(attributes.birthday,"-","/","ALL") />

	<!--- Get Member Info --->
	<cfif VAL(Request.squid.user_id)>
		<cfset stMember = Request.squid />
	<cfelseif VAL(attributes.user_id)>
		<cfset loginCFC = CreateObject("component",Request.login_cfc) />
		<cfset stMember = StructNew() />
		<cfset stMember.user_id = attributes.user_id />
		<cfset stMember = variables.loginCFC.getUserInfo(stMember,Request.usersTbl,Request.preferenceTbl,Request.developerTbl,Request.testerTbl,Request.user_statusTbl,Request.DSN) />
	<cfelse>
		<cfset stMember = StructNew() />
		<cfset stMember.user_id = attributes.user_id />
	</cfif>

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
<form name="confirmForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post">
<cfloop collection="#attributes#" item="i">
	<input type="hidden" name="#i#" value="#attributes[i]#" />
</cfloop>
<table width="450" border="0" cellpadding="0" cellspacing="0" align="center">
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
				Please verify your information below. After clicking "Confirm Purchase,"
				you will be directed to PayPal's web site to complete your transaction. After completing your
				transaction on PayPal, you should be redirected to SQUID's site.  (If you are on PayPal's site for
				more than 20 minutes, your SQUID session will time out. If that occurs, or you do not receive a
				confirmation e-mail from SQUID, please
				<a href="#Request.self#?fuseaction=#XFA.contact#">contact us</a> to have your
				PayPal transaction confirmed.)
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
				<strong>First Name:</strong>
			</td>
			<td>
				#attributes.first_name#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Middle Name:</strong>
			</td>
			<td>
				#attributes.middle_name#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Last Name:</strong>
			</td>
			<td>
				#attributes.last_name#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Preferred Name:</strong>
			</td>
			<td>
				#attributes.preferred_name#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Address:</strong>
			</td>
			<td>
				#attributes.address1#
			<cfif LEN(TRIM(attributes.address2))>
				<br />
				#attributes.address2#
			</cfif>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>City, State, ZIP:</strong>
			</td>
			<td>
				#attributes.city#, #attributes.state_id# #attributes.zip#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Country:</strong>
			</td>
			<td>
				#attributes.country#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>E-mail Address:</strong>
			</td>
			<td>
				#attributes.email#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Cell Phone:</strong>
			</td>
			<td>
				#attributes.phone_cell#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Daytime Phone:</strong>
			</td>
			<td>
				#attributes.phone_day#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Evening Phone:</strong>
			</td>
			<td>
				#attributes.phone_night#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Fax:</strong>
			</td>
			<td>
				#attributes.fax#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Emergency Contact:</strong>
			</td>
			<td>
				#attributes.contact_emergency#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Emergency Phone:</strong>
			</td>
			<td>
				#attributes.phone_emergency#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>USMS Number:</strong>
			</td>
			<td>
				#attributes.usms_no#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Medical Conditions:</strong>
			</td>
			<td>
				#attributes.medical_conditions#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Birthday:</strong>
			</td>
			<td>
				#attributes.birthday#
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2" align="center">
				<input type="submit" name="submitBtn" value="Proceed to PayPal" tabindex="#variables.tabindex#" class="buttonStyle" />
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

