<!--- TODO: when entering an email address, look to see if there's a user with that address and prompt them to login --->

<cfoutput>

<script type="text/javascript">
	var checkUsernameXFA = '#XFA.checkUsername#';
</script>

<form name="buySwims" id="buyswims" action="#request.self#" method="post">
	<input type="hidden" name="fuseaction" value="#XFA.next#" />
	<input type="hidden" name="fullName" id="fullname" value="#getUser().getFirstName()# #getUser().getLastName()#"
	<input type="hidden" name="address1" id="address1" value="#getUser().getAddress1()#" />
	<input type="hidden" name="city" id="city" value="#getUser().getCity()#" />
	<input type="hidden" name="state" id="state" value="#getUser().getStateID()#" />
	<input type="hidden" name="zip" id="zip" value="#getUser().getZip()#" />
	<input type="hidden" name="country" id="country" value="#getUser().getCountry()#" />

	<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
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
					<cfif session.squid.user.getUserID() GT 0>
						<a href="#Request.self#?fuseaction=#XFA.members#">Menu</a>
					<cfelse>
						<a href="#Request.self#?fuseaction=#XFA.home#">Home</a>
					</cfif>
					> Buy Swims
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<cfif NOT structIsEmpty(request.errors)>
				<tr>
					<td colspan="2" class="errorText">
						<h3>There were problems with your submission</h3>
						<p>Please make corrections below and re-submit the form.</p>
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
			</cfif>
			<tr valign="top">
				<td colspan="2">
					<p>
						To purchase individual swims and pay via PayPal, select the number of of swims you'd like to purchase and enter your payment info.
					</p>
					<cfif session.squid.user.getUserID() GT 0>
						<p class="members">
							Each swim is <strong>#dollarFormat(request.pricePerSwimMembers)#</strong>.  For every 10 swims you purchase, you will receive an additional
							swim at no charge.
						</p>
					<cfelse>
						<p class="nonmembers">
							Each swim is <strong>#dollarFormat(request.pricePerSwimNonmembers)#</strong> for non-members.
						</p>
						<p class="nonmembers">
							Members who have paid their dues pay <strong>#dollarFormat(request.pricePerSwimMembers)#</strong> and receive an additional swim for every 10 swims they purchase. If your membership is current, please <a href="#request.self#?fuseaction=#XFA.inlineLogin#&returnFA=#attributes.fuseaction#" class="login">login</a> before buying swims.  If your membership is not current but would like to pay your dues, you can <a href="#request.self#?fuseaction=#XFA.payDues#">pay them online</a>.  To buy swims as a non-member, please complete the following form.
						</p>
					</cfif>
					</p>
				</td>
			</tr>
			<tr valign="top" class="nonmembers">
				<td>
					<label for="emailaddress">
						<strong>Email Address:</strong>
					</label>
					<cfif structKeyExists(request.errors,"email")>
						<br /><span class="errorText">#request.errors.email#</span>
					</cfif>
				</td>
				<td>
					<cfif session.squid.user.getUserID() EQ 0>
						<input type="text" name="email" id="email" size="50" placeholder="name@example.com" value="#attributes.email#" />
					<cfelse>
						<input type="hidden" name="email" id="email" value="#getUser().getEmail()#" />
					</cfif>
				</td>
			</tr>
			<tr valign="top">
				<td>
					<label for="numswims">
						<strong>Number of Swims:</strong>
					</label>
					<cfif structKeyExists(request.errors,"numSwims")>
						<br /><span class="errorText">#request.errors.numSwims#</span>
					</cfif>
				</td>
				<td>
					<select name="numSwims" size="1" id="numswims">
						<cfloop from="10" to="100" index="i">
							<option value="#i#" <cfif attributes.numSwims EQ i>selected="true"</cfif>>#i#</option>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<fieldset>
						<legend>Payment Info</legend>
						<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
							<tr valign="top">
								<td>
									<strong>Credit Card Type:</strong>
									<cfif structKeyExists(request.errors,"creditCardTypeID")>
										<br /><span class="errorText">#request.errors.creditCardTypeID#</span>
									</cfif>
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
									<cfif structKeyExists(request.errors,"creditCardNumber")>
										<br /><span class="errorText">#request.errors.creditCardNumber#</span>
									</cfif>
								</td>
								<td>
									<input type="text" name="creditCardNumber" id="creditCardNumber" size="16" maxlength="19" value="" autocomplete="false" />
								</td>
							</tr>
							<tr valign="top">
								<td>
									<strong>Expiration:</strong>
									<cfif structKeyExists(request.errors,"creditCardExpirationMonth")>
										<br /><span class="errorText">#request.errors.creditCardExpirationMonth#</span>
									</cfif>
									<cfif structKeyExists(request.errors,"creditCardExpirationYear")>
										<br /><span class="errorText">#request.errors.creditCardExpirationYear#</span>
									</cfif>
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
									(<a class="cvv-help" href="#request.self#?fuseaction=#fusebox.circuit#.modalCvv2help" tabindex="-1">What's this?</a>)
									<cfif structKeyExists(request.errors,"creditCardVerificationNumber")>
										<br /><span class="errorText">#request.errors.creditCardVerificationNumber#</span>
									</cfif>
								</td>
								<td>
									<input type="text" name="creditCardVerificationNumber" id="creditCardVerificationNumber" size="4" maxlength="4" value="" />
								</td>
							</tr>
							<tr valign="top">
								<td>
									<strong>Name on Card:</strong>
									<cfif structKeyExists(request.errors,"nameOnCard")>
										<br /><span class="errorText">#request.errors.nameOnCard#</span>
									</cfif>
								</td>
								<td>
									<input type="text" name="nameOnCard" id="nameOnCard" size="15" maxlength="255" value="#attributes.nameOnCard#" />
								</td>
							</tr>
							<cfif getUser().getUserID() GT 0>
								<tr valign="top">
									<td colspan="2">
										<!--- TODO: move the hidden fields above into data elements on the checkbox --->
										<input type="checkbox" name="useContactAddress" id="usecontactaddress" value="1" checked="true" />
										Use profile address for billing address
									</td>
								</tr>
							</cfif>
							<tr valign="top">
								<td>
									<strong>Billing Address:</strong>
									<cfif structKeyExists(request.errors,"billingStreet")>
										<br /><span class="errorText">#request.errors.billingStreet#</span>
									</cfif>
								</td>
								<td>
									<input type="text" name="billingStreet" id="billingStreet" size="25" maxlength="255" value="#attributes.billingStreet#" />
								</td>
							</tr>
							<tr valign="top">
								<td>
									<strong>Billing City, State, ZIP:</strong>
									<cfif structKeyExists(request.errors,"billingCity")>
										<br /><span class="errorText">#request.errors.billingCity#</span>
									</cfif>
									<cfif structKeyExists(request.errors,"billingState")>
										<br /><span class="errorText">#request.errors.billingState#</span>
									</cfif>
									<cfif structKeyExists(request.errors,"billingZip")>
										<br /><span class="errorText">#request.errors.billingZip#</span>
									</cfif>
								</td>
								<td>
									<input type="text" name="billingCity" id="billingCity" size="15" maxlength="50" value="#attributes.billingCity#" />
									<select name="billingState" id="billingState" size="1">
										<option value="" <cfif attributes.billingCountry IS 0>selected="true"</cfif>>(non-US)</option>
									<cfloop query="application.qStates">
										<option value="#application.qStates.state_id#" <cfif attributes.billingState IS application.qStates.state_id>selected="true"</cfif>>#application.qStates.state#</option>
									</cfloop>
									</select>
									<input type="text" name="billingZip" id="billingZip" size="10" maxlength="10" value="#attributes.billingZip#" />
								</td>
							</tr>
							<tr valign="top">
								<td>
									<strong>Billing Country:</strong>
									<cfif structKeyExists(request.errors,"billingCountry")>
										<br /><span class="errorText">#request.errors.billingCountry#</span>
									</cfif>
								</td>
								<td>
									<select name="billingCountry" id="billingCountry" size="1">
									<cfloop query="application.qCountries">
										<option value="#application.qCountries.countryCode#" <cfif attributes.billingCountry IS application.qCountries.countryCode>selected="true"</cfif>>#application.qCountries.country#</option>
									</cfloop>
									</select>
								</td>
							</tr>
							<tr valign="top">
								<td colspan="2">
									<em>NOTE:  You will be able to confirm your payment information on the next screen.</em>
								</td>
							</tr>
			<!--- TODO: this goes on the confirmation screen
							<tr valign="top">
								<td colspan="2">
									<em>NOTE:  Your payment will be processed via PayPal.  This transaction is secure.  SQUID does not store any of your payment information.</em>
								</td>
							</tr>
			 --->
						</table>
					</fieldset>
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr valign="top">
				<td colspan="2" align="center">
					<button type="submit" name="submitBtn" value="Next Step" class="buttonStyle">Next Step</button>
				</td>
			</tr>
		</tbody>
	</table>
</form>
</cfoutput>

