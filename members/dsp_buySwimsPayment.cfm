<!---
<fusedoc
	fuse = "dsp_buySwimsPayment.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the Buy Swims confirmation / payment screen.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="13 January 2013" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
			</structure>

			<number name="numSwims" scope="attributes" />
		</in>
		<out>
			<number name="numSwims" scope="formOrUrl" />
		</out>
	</io>

</fusedoc>
--->
<cfsilent>
	<cfset variables.tabindex = 1>

	<cfset request.nameOnCard = session.squid.first_name & " " & session.squid.last_name />
	<cfset request.billingStreet = session.squid.address1 />
	<cfset request.billingCity = session.squid.city />
	<cfset request.billingState = session.squid.state_id />
	<cfset request.billingZip = session.squid.zip />
	<cfset request.billingCountry = session.squid.country />
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
<form name="buySwimsForm" id="buySwimsForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post">
	<input type="hidden" name="numSwims" value="#VAL(attributes.numSwims)#" />
	<input type="hidden" name="address1" id="address1" value="#session.squid.address1#" />
	<input type="hidden" name="city" id="city" value="#session.squid.city#" />
	<input type="hidden" name="state" id="state" value="#session.squid.state_id#" />
	<input type="hidden" name="zip" id="zip" value="#session.squid.zip#" />
	<input type="hidden" name="country" id="country" value="#session.squid.country#" />
<table width="600" border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td align="center" colspan="3">
				<h2>
					#Request.page_title#
				</h2>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr valign="top">
			<td colspan="3" align="center">
				<a href="#Request.self#?fuseaction=#XFA.menu#">Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.buySwims#">Buy Swims</a>
				> Confirmation
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="3">
				Please verify the number of swims you wish to purchase below. If the information is correct, enter your
				payment information below to process your transaction.  Your payment will be processed
				through PayPal.
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3">
				<cfmodule template="#request.siteRoot#lib/buySwims.cfm" numSwims="#attributes.numSwims#">
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3">
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
								Use profile address for billing address
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
			<td colspan="3" align="center">
				<input type="submit" name="submitBtn" id="submitBtn" value="Complete Transaction" tabindex="#variables.tabindex#" class="buttonStyle" />
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

