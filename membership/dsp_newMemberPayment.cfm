<cfsilent>
	<cfparam name="attributes.email" default="" type="string" />
	<cfparam name="attributes.password" default="" type="string" />
	<cfparam name="attributes.passwordConfirmation" default="" type="string" />
	<cfparam name="attributes.firstName" default="" type="string" />
	<cfparam name="attributes.middleName" default="" type="string" />
	<cfparam name="attributes.lastName" default="" type="string" />
	<cfparam name="attributes.preferredName" default="" type="string" />
	<cfparam name="attributes.address1" default="" type="string" />
	<cfparam name="attributes.address2" default="" type="string" />
	<cfparam name="attributes.city" default="" type="string" />
	<cfparam name="attributes.stateID" default="CO" type="string" />
	<cfparam name="attributes.zip" default="" type="string" />
	<cfparam name="attributes.country" default="USA" type="string" />
	<cfparam name="attributes.phone1" default="" type="string" />
	<cfparam name="attributes.phoneType1" default="cell" type="string" />
	<cfparam name="attributes.phone2" default="" type="string" />
	<cfparam name="attributes.phoneType2" default="daytime" type="string" />
	<cfparam name="attributes.mailingList" default="false" type="boolean" />
	<cfparam name="attributes.emergencyName" default="" type="string" />
	<cfparam name="attributes.emergencyPhone" default="" type="string" />
	<cfparam name="attributes.emergencyRelation" default="" type="string" />
	<cfparam name="attributes.liabilitySignature" default="" type="string" />
	<cfparam name="attributes.liabilitySignatureDate" default="" type="string" />
	<cfparam name="attributes.numSwims" default="0" type="numeric" />
	<cfparam name="attributes.user_id" default="0" type="numeric" />

	<cfparam name="attributes.success" default="" type="string" />
	<cfparam name="attributes.reason" default="" type="string" />

	<cfset request.nameOnCard = attributes.firstName & " " & attributes.lastName />
	<cfset request.billingStreet = attributes.address1 />
	<cfset request.billingCity = attributes.city />
	<cfset request.billingState = attributes.stateID />
	<cfset request.billingZip = attributes.zip />
	<cfset request.billingCountry = attributes.country />

	<cfset totalAmountDue = 0 />

	<cfquery name="recaptchaKey" datasource="squidsql">
		SELECT keyValue
		FROM appKey
		WHERE appName = 'reCAPTCHA v3'
			AND keyType = 'SITE'
	</cfquery>
</cfsilent>

<cfif attributes.success IS "no">
	<h2>There were problems with your submission:</h2>
	<ul class="errorText">
		<cfloop list="#attributes.reason#" index="variables.theItem" delimiters="*">
			<li>#variables.theItem#</li>
		</cfloop>
	</ul>
	<p>Please make corrections below and re-submit the information.</p>
</cfif>

<cfoutput>
	<script type="text/javascript">
		var recaptchaKey = '#recaptchaKey.keyValue#';
	</script>
<h2 class="pageTitle">
	#Request.page_title#
</h2>
<div id="welcomeText">
	<p>
		Please verify your information below. If the information is correct, enter your
		payment information below to process your transaction.  Your payment will be processed
		through PayPal.
	</p>
	<p>
		<span class="required">*</span> = required field
	</p>
</div>
<form name="paymentForm" id="paymentForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post">
	<input type="hidden" name="user_id" value="#attributes.user_id#" />
	<input type="hidden" class="js-recaptcha-response" name="g-recaptcha-response" value="" />

	<fieldset>
		<legend>Dues Info</legend>
		<div class="duesContainer">
			<div class="duesLabel">
				Pay Dues Through:
			</div>
			<div class="duesInfo">
				#session.squid.stDues.membershipYear[session.squid.stDues.duesIndex]#
			</div>
		</div>
		<div class="duesContainer">
			<div class="duesLabel">
				Dues:
			</div>
			<div class="duesInfo">
				#DollarFormat(session.squid.stDues.fee[session.squid.stDues.duesIndex])#
				<cfset totalAmountDue += session.squid.stDues.fee[session.squid.stDues.duesIndex] />
			</div>
		</div>
		<span id="additionalFeesClick" class="clickable" onclick="showAdditionalFees();">Additional Fees</span>
	</fieldset>
	<fieldset>
		<legend>Buy Swims</legend>
		<div class="duesContainer">
			<cfmodule template="#request.siteRoot#lib/buySwimsConfirmation.cfm" numSwims="#attributes.numSwims#">
			<input type="hidden" name="numSwims" value="#attributes.numSwims#" />
		</div>
	</fieldset>
	<fieldset>
		<legend>Contact Info</legend>
		<div class="contactContainer">
			<div class="contactLabel">
				<label for="email" class="contact">E-mail Address:</label>
			</div>
			<div class="contactInput">
				#attributes.email#
				<input type="hidden" name="email" id="email" value="#attributes.email#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="password" class="contact">Password:</label>
			</div>
			<div class="contactInput">
				#repeatString("*",len(attributes.password))#
				<input type="hidden" name="password" id="password" value="#attributes.password#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="firstName">First Name:</label>
			</div>
			<div class="contactInput">
				#attributes.firstName#
				<input type="hidden" name="firstName" id="firstName" value="#attributes.firstName#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="middleName">Middle Name:</label>
			</div>
			<div class="contactInput">
			<cfif len(trim(attributes.middleName)) GT 0>
				#attributes.middleName#
			<cfelse>
				(Not provided)
			</cfif>
				<input type="hidden" name="middleName" id="middleName" value="#attributes.middleName#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="lastName">Last Name:</label>
			</div>
			<div class="contactInput">
				#attributes.lastName#
				<input type="hidden" name="lastName" id="lastName" value="#attributes.lastName#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="preferredName">Preferred Name:</label>
			</div>
			<div class="contactInput">
			<cfif len(trim(attributes.preferredName)) GT 0>
				#attributes.preferredName#
			<cfelse>
				(Not provided)
			</cfif>
				<input type="hidden" name="preferredName" id="preferredName" value="#attributes.preferredName#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="address1">Address:</label>
			</div>
			<div class="contactInput">
			<cfif len(trim(attributes.address1)) GT 0 OR len(trim(attributes.address2)) GT 0>
				#attributes.address1#
				<br />
				#attributes.address2#
			<cfelse>
				(Not provided)
			</cfif>
				<input type="hidden" name="address1" id="address1" value="#attributes.address1#" />
				<input type="hidden" name="address2" id="address2" value="#attributes.address2#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="city">City:</label>
			</div>
			<div class="contactInput">
			<cfif len(trim(attributes.city)) GT 0>
				#attributes.city#
			<cfelse>
				(Not provided)
			</cfif>
				<input type="hidden" name="city" id="city" value="#attributes.city#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="stateID">State:</label>
			</div>
			<div class="contactInput">
			<cfif len(trim(attributes.stateID)) GT 0>
				#attributes.stateID#
			<cfelse>
				(Not provided)
			</cfif>
				<input type="hidden" name="stateID" id="stateID" value="#attributes.stateID#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="zip">ZIP/Postal Code:</label>
			</div>
			<div class="contactInput">
			<cfif len(trim(attributes.zip)) GT 0>
				#attributes.zip#
			<cfelse>
				(Not provided)
			</cfif>
				<input type="hidden" name="zip" id="zip" value="#attributes.zip#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="country">Country:</label>
			</div>
			<div class="contactInput">
			<cfif len(trim(attributes.country)) GT 0>
				#attributes.country#
			<cfelse>
				(Not provided)
			</cfif>
				<input type="hidden" name="country" id="country" value="#attributes.country#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="phone1">Phone:</label>
			</div>
			<div class="contactInput">
			<cfif len(trim(attributes.phone1)) GT 0>
				#attributes.phone1# (#attributes.phoneType1#)
			<cfelse>
				(Not provided)
			</cfif>
				<input type="hidden" name="phone1" id="phone1" value="#attributes.phone1#" />
				<input type="hidden" name="phoneType1" id="phoneType1" value="#attributes.phoneType1#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="phone2">Phone:</label>
			</div>
			<div class="contactInput">
			<cfif len(trim(attributes.phone2)) GT 0>
				#attributes.phone2# (#attributes.phoneType2#)
			<cfelse>
				(Not provided)
			</cfif>
				<input type="hidden" name="phone2" id="phone2" value="#attributes.phone2#" />
				<input type="hidden" name="phoneType2" id="phoneType2" value="#attributes.phoneType2#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="mailingList">
					E-mail list?
				</label>
			</div>
			<div class="contactInput">
				#yesNoFormat(attributes.mailingList)#
				<input type="hidden" name="mailingList" id="mailingList" value="#attributes.mailingList#" />
			</div>
		</div>
	</fieldset>

	<fieldset>
		<legend>Emergency Contact</legend>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="emergencyName">Name:</label>
			</div>
			<div class="contactInput">
			<cfif len(trim(attributes.emergencyName)) GT 0>
				#attributes.emergencyName#
			<cfelse>
				(Not provided)
			</cfif>
				<input type="hidden" name="emergencyName" id="emergencyName" value="#attributes.emergencyName#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="emergencyPhone">Phone:</label>
			</div>
			<div class="contactInput">
			<cfif len(trim(attributes.emergencyPhone)) GT 0>
				#attributes.emergencyPhone#
			<cfelse>
				(Not provided)
			</cfif>
				<input type="hidden" name="emergencyPhone" id="emergencyPhone" value="#attributes.emergencyPhone#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="emergencyRelation">Relationship:</label>
			</div>
			<div class="contactInput">
			<cfif len(trim(attributes.emergencyRelation)) GT 0>
				#attributes.emergencyRelation#
			<cfelse>
				(Not provided)
			</cfif>
				<input type="hidden" name="emergencyRelation" id="emergencyRelation" value="#attributes.emergencyRelation#" />
			</div>
		</div>
	</fieldset>

<!--- 1/9/2013: removing this, but only commenting it out in case they change their minds
	<fieldset>
		<legend>Visitor Information</legend>

		<div class="contactContainer">
			<div class="contactLabel">
				Visitor?
			</div>
			<div class="contactInput">
				#yesNoFormat(attributes.isVisitor)#
				<input type="hidden" name="isVisitor" id="isVisitor" value="#attributes.isVisitor#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="visitingTeam">Team:</label>
			</div>
			<div class="contactInput">
			<cfif len(trim(attributes.visitingTeam)) GT 0>
				#attributes.visitingTeam#
			<cfelse>
				(Not provided)
			</cfif>
				<input type="hidden" name="visitingTeam" id="visitingTeam" value="#attributes.visitingTeam#" />
			</div>
			<div class="contactLabel">
				<label for="visitingTeam">City/state:</label>
			</div>
			<div class="visitingCityState">
			<cfif len(trim(attributes.visitingCityState)) GT 0>
				#attributes.visitingCityState#
			<cfelse>
				(Not provided)
			</cfif>
				<input type="hidden" name="visitingCityState" id="visitingCityState" value="#attributes.visitingCityState#" />
			</div>
		</div>
	</fieldset>
--->

	<fieldset>
		<legend>Liability Waiver</legend>
		<div class="liabilityContainer">
			I, the undersigned participant, intending to be legally bound, hereby certify that I am physically fit and have not been otherwise informed by a physician.
			I ackowledge that I am aware of all the risks inherent in Masters swimming (training and competition), including possible permanent disability or death,
			and agree to assume all of those risks. As a condition of my participation in the Masters Swimming Program or any activities hereto, I hereby waive any
			and all rights to claims for loss or damages, including all claims for loss or damages caused by the negligence, active or passive, of Colorado
			SQUID Swim Team, or any individuals supervising such activities.
		</div>
		<div class="liabilityContainer">
			<div class="contactLabel">
				<label for="liabilitySignature">Signature:</label>
			</div>
			<div class="contactInput">
				#attributes.liabilitySignature#<br />
				#attributes.liabilitySignatureDate#
				<input type="hidden" name="liabilitySignature" id="liabilitySignature" value="#attributes.liabilitySignature#" />
				<input type="hidden" name="liabilitySignatureDate" id="liabilitySignatureDate" value="#attributes.liabilitySignatureDate#" />
			</div>
		</div>
	</fieldset>
	<fieldset>
		<legend>Payment Info</legend>
		<div class="contactContainer">
			<div class="paymentLabel">
				Total Payment:
			</div>
			<div class="paymentInput">
				#dollarFormat(variables.totalAmountDue)#
			</div>
		</div>
		<div class="contactContainer">
			<div class="paymentLabel">
				<label for="creditCardTypeID"><span class="required">*</span> Credit Card Type:</label>
			</div>
			<div class="paymentInput">
				<select name="creditCardTypeID" id="creditCardTypeID" size="1">
					<option value="" selected="true">-- PLEASE SELECT --</option>
				<cfloop query="application.qCreditCardTypes">
					<option value="#application.qCreditCardTypes.shortName#">#application.qCreditCardTypes.shortName#</option>
				</cfloop>
				</select>
			</div>
		</div>
		<div class="contactContainer">
			<div class="paymentLabel">
				<label for="creditCardNumber"><span class="required">*</span> Card Number:</label>
			</div>
			<div class="paymentInput">
				<input type="text" name="creditCardNumber" id="creditCardNumber" size="16" maxlength="16" value="" autocomplete="false" />
			</div>
		</div>
		<div class="contactContainer">
			<div class="paymentLabel">
				<label for="creditCardExpirationMonth"><span class="required">*</span> Expiration:</label>
			</div>
			<div class="paymentInput">
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
			</div>
		</div>
		<div class="contactContainer">
			<div class="paymentLabel">
				<label for="creditCardVerificationNumber"><span class="required">*</span> Card Verfication Number:</label>
			</div>
			<div class="paymentInput">
				<input type="text" name="creditCardVerificationNumber" id="creditCardVerificationNumber" size="4" maxlength="4" value="" />
				(<span id="ccvNumberClick" class="clickable" onclick="showCCVNumberHelp();">What's this?</span>)
			</div>
		</div>
		<div class="contactContainer">
			<div class="paymentLabel">
				<label for="nameOnCard"><span class="required">*</span> Name on Card:</label>
			</div>
			<div class="paymentInput">
				<input type="text" name="nameOnCard" id="nameOnCard" size="15" maxlength="255" value="#request.nameOnCard#" />
			</div>
		</div>
		<div class="contactContainer">
			<div>
				<input type="checkbox" name="useContactAddress" id="useContactAddress" value="1" checked="true" />
				<label for="useContactAddress">Use above address for billing address</label>
			</div>
		</div>
		<div class="contactContainer">
			<div class="paymentLabel">
				<label for="billingStreet"><span class="required">*</span> Billing Address:</label>
			</div>
			<div class="paymentInput">
				<input type="text" name="billingStreet" id="billingStreet" size="25" maxlength="255" value="#request.billingStreet#" />
			</div>
		</div>
		<div class="contactContainer">
			<div class="paymentLabel">
				<label for="billingCity"><span class="required">*</span> Billing City, State, ZIP:</label>
			</div>
			<div class="paymentInput">
				<input type="text" name="billingCity" id="billingCity" size="15" maxlength="50" value="#request.billingCity#" />
				<select name="billingState" id="billingState" size="1">
					<option value="" <cfif request.billingState IS 0>selected="true"</cfif>>(non-US)</option>
				<cfloop query="application.qStates">
					<option value="#application.qStates.state_id#" <cfif request.billingState IS application.qStates.state_id>selected="true"</cfif>>#application.qStates.state#</option>
				</cfloop>
				</select>
				<input type="text" name="billingZip" id="billingZip" size="10" maxlength="10" value="#request.billingZip#" />
			</div>
		</div>
		<div class="contactContainer">
			<div class="paymentLabel">
				<label for="billingCountry"><span class="required">*</span> Billing Country:</label>
			</div>
			<div class="paymentInput">
				<select name="billingCountry" id="billingCountry" size="1">
				<cfloop query="application.qCountries">
					<option value="#application.qCountries.countryCode#" <cfif request.billingCountry IS application.qCountries.countryCode>selected="true"</cfif>>#application.qCountries.country#</option>
				</cfloop>
				</select>
			</div>
		</div>
		<div class="contactContainer">
			<div>
				<em>NOTE:  Your payment will be processed via PayPal.  This transaction is secure.  SQUID does not store any of your payment information.</em>
			</div>
		</div>
	</fieldset>
	<div id="nextStepButtonContainer">
		<button type="button" id="submitBtn" name="submitBtn" value="Complete Transaction">Complete Transaction</button>
	</div>
</form>
<cfinclude template="#request.siteRoot#lib/additionalFees.cfm" />
</cfoutput>