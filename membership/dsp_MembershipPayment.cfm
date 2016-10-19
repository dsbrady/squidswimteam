<!---
<fusedoc
	fuse = "dsp_MembershipPayment.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the Dues Payment screen.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="4 January 2013" type="Create" />
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
	<cfparam name="attributes.countryID" default="US" type="string" />
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

	<cfset request.nameOnCard = attributes.first_name & " " & attributes.last_name />
	<cfset request.billingStreet = attributes.address1 />
	<cfset request.billingCity = attributes.city />
	<cfset request.billingState = attributes.state_id />
	<cfset request.billingZip = attributes.zip />
	<cfset request.billingCountry = attributes.countryID />
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
<form name="confirmForm" id="confirmForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post">
<cfloop collection="#attributes#" item="i">
	<input type="hidden" name="#i#" id="#i#" value="#attributes[i]#" />
</cfloop>
<table width="600" border="0" cellpadding="0" cellspacing="0" align="center">
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
				Please verify your information below. If the information is correct, enter your
				payment information below to process your transaction.  Your payment will be processed
				through PayPal.
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td width="150">
				<strong>
					Pay Dues Through:
				</strong>
			</td>
			<td width="450">
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
		<tr>
			<td colspan="2">
				<fieldset>
					<legend>Payment Info</legend>
					<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
						<tr valign="top">
							<td>
								<strong>Credit Card Type:</strong>
							</td>
							<td>
								<select name="creditCardTypeID" id="creditCardTypeID" size="1">
									<option value="" selected="true">-- PLEASE SELECT --</option>
								<cfloop query="application.qCreditCardTypes">
									<option value="#application.qCreditCardTypes.shortName#">#application.qCreditCardTypes.shortName#</option>
								</cfloop>
								</select>
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Card Number:</strong>
							</td>
							<td>
								<input type="text" name="creditCardNumber" id="creditCardNumber" size="16" maxlength="16" value="" autocomplete="false" />
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Expiration:</strong>
							</td>
							<td>
								<select name="creditCardExpirationMonth" id="creditCardExpirationMonth" size="1">
								<cfloop from="1" to="12" index="monthNumber">
									<option value="#variables.monthNumber#">#numberFormat(variables.monthNumber,"00")#</option>
								</cfloop>
								</select>
								/
								<select name="creditCardExpirationYear" id="creditCardExpirationYear" size="1">
								<cfloop from="#year(now())#" to="#year(now()) + 10#" index="yearNumber">
									<option value="#variables.yearNumber#" >#numberFormat(variables.yearNumber,"00")#</option>
								</cfloop>
								</select>
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Card Verification Number:</strong>
							</td>
							<td>
								<input type="text" name="creditCardVerificationNumber" id="creditCardVerificationNumber" size="4" maxlength="4" value="" />
								(<span id="ccvNumberClick" class="clickable" onclick="showCCVNumberHelp();">What's this?</span>)
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Name on Card:</strong>
							</td>
							<td>
								<input type="text" name="nameOnCard" id="nameOnCard" size="15" maxlength="255" value="#request.nameOnCard#" />
							</td>
						</tr>
						<tr valign="top">
							<td colspan="2">
								<input type="checkbox" name="useContactAddress" id="useContactAddress" value="1" checked="true" />
								Use above address for billing address
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Billing Address:</strong>
							</td>
							<td>
								<input type="text" name="billingStreet" id="billingStreet" size="25" maxlength="255" value="#request.billingStreet#" />
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Billing City, State, ZIP:</strong>
							</td>
							<td>
								<input type="text" name="billingCity" id="billingCity" size="15" maxlength="50" value="#request.billingCity#" />
								<select name="billingState" id="billingState" size="1">
									<option value="" <cfif request.billingState IS 0>selected="true"</cfif>>(non-US)</option>
								<cfloop query="application.qStates">
									<option value="#application.qStates.state_id#" <cfif request.billingState IS application.qStates.state_id>selected="true"</cfif>>#application.qStates.state#</option>
								</cfloop>
								</select>
								<input type="text" name="billingZip" id="billingZip" size="10" maxlength="10" value="#request.billingZip#" />
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Billing Country:</strong>
							</td>
							<td>
								<select name="billingCountry" id="billingCountry" size="1">
								<cfloop query="application.qCountries">
									<option value="#application.qCountries.countryCode#" <cfif request.billingCountry IS application.qCountries.countryCode>selected="true"</cfif>>#application.qCountries.country#</option>
								</cfloop>
								</select>
							</td>
						</tr>
						<tr valign="top">
							<td colspan="2">
								<em>NOTE:  Your payment will be processed via PayPal.  This transaction is secure.  SQUID does not store any of your payment information.</em>
							</td>
						</tr>
					</table>
				</fieldset>
			</td>
		</tr>
		
		<tr valign="top">
			<td colspan="2" align="center">
				<input type="submit" name="submitBtn" id="submitBtn" value="Complete Transaction" tabindex="#variables.tabindex#" class="buttonStyle" />
			</td>
		</tr>
	</tbody>
</table>
</form>

</cfoutput>
