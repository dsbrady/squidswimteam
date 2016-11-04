<cfoutput>

<form name="buySwims" id="buyswims" action="#request.self#" method="post">
	<input type="hidden" name="fuseaction" value="#XFA.next#" />
	<input type="hidden" name="email" value="#attributes.email#" />
	<input type="hidden" name="numSwims" value="#attributes.numSwims#" />
	<input type="hidden" name="creditCardTypeID" value="#attributes.creditCardTypeID#" />
	<input type="hidden" name="creditCardNumber" value="#attributes.creditCardNumber#" />
	<input type="hidden" name="creditCardExpirationMonth" value="#attributes.creditCardExpirationMonth#" />
	<input type="hidden" name="creditCardExpirationYear" value="#attributes.creditCardExpirationYear#" />
	<input type="hidden" name="creditCardVerificationNumber" value="#attributes.creditCardVerificationNumber#" />
	<input type="hidden" name="nameOnCard" value="#attributes.nameOnCard#" />
	<input type="hidden" name="billingStreet" value="#attributes.billingStreet#" />
	<input type="hidden" name="billingCity" value="#attributes.billingCity#" />
	<input type="hidden" name="billingState" value="#attributes.billingState#" />
	<input type="hidden" name="billingZip" value="#attributes.billingZip#" />
	<input type="hidden" name="billingCountry" value="#attributes.billingCountry#" />

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
						<a href="#Request.self#?fuseaction=#XFA.menu#">Menu</a>
					<cfelse>
						<a href="#Request.self#?fuseaction=#XFA.home#">Home</a>
					</cfif>
					> Buy Swims
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr valign="top">
				<td colspan="2">
					<p>
						Your swim purchase information is below.  If all of the information is correct, hit "Complete Purchase" below.
					</p>
				</td>
			</tr>
			<tr valign="top">
				<td>
					<strong>Email Address:</strong>
				</td>
				<td>
					#attributes.email#
				</td>
			</tr>
			<tr valign="top">
				<td>
					<strong>Member?</strong>
				</td>
				<td>
					#yesNoFormat(request.isMember)#
				</td>
			</tr>
			<tr valign="top">
				<td>
					<strong>Number of Swims:</strong>
				</td>
				<td>
					#attributes.numSwims#
				</td>
			</tr>
			<tr valign="top">
				<td>
					<strong>Free Swims:</strong>
				</td>
				<td>
					#request.freeSwims#
				</td>
			</tr>
			<tr valign="top">
				<td>
					<strong>Total Swims:</strong>
				</td>
				<td>
					#request.totalSwims#
				</td>
			</tr>
			<tr valign="top">
				<td>
					<strong>Total Cost:</strong>
				</td>
				<td>
					#dollarFormat(request.totalCost)#
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
								</td>
								<td>
									#attributes.creditCardTypeID#
								</td>
							</tr>
							<tr valign="top">
								<td>
									<strong>Card Number:</strong>
								</td>
								<td>
									#maskString(attributes.creditCardNumber, 0, 4)#
								</td>
							</tr>
							<tr valign="top">
								<td>
									<strong>Expiration:</strong>
								</td>
								<td>
									#numberFormat(attributes.creditCardExpirationMonth,"00")# / #attributes.creditCardExpirationYear#
								</td>
							</tr>
							<tr valign="top">
								<td>
									<strong>Card Verification Number:</strong>
								</td>
								<td>
									#repeatString("*", len(attributes.creditCardVerificationNumber))#
								</td>
							</tr>
							<tr valign="top">
								<td>
									<strong>Name on Card:</strong>
								</td>
								<td>
									#attributes.nameOnCard#
								</td>
							</tr>
							<tr valign="top">
								<td>
									<strong>Billing Address:</strong>
								</td>
								<td>
									#attributes.billingStreet#
								</td>
							</tr>
							<tr valign="top">
								<td>
									<strong>Billing City, State, ZIP:</strong>
								</td>
								<td>
									#attributes.billingCity#,
									#attributes.billingState#
									#attributes.billingZip#
								</td>
							</tr>
							<tr valign="top">
								<td>
									<strong>Billing Country:</strong>
								</td>
								<td>
									#attributes.billingCountry#
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
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr valign="top">
				<td colspan="2" align="center">
					<button type="submit" name="submitBtn" value="Complete PUrchase" class="buttonStyle">Complete Purchase</button>
					<a href="#request.self#?fuseaction=#XFA.home#" class="cancel">Cancel</a>
				</td>
			</tr>
		</tbody>
	</table>
</form>
</cfoutput>

