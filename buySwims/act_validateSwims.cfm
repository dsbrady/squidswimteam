<!--- act_eventDatesValidate.cfm --->
<cfsilent>
	<cfif NOT isValid("email", attributes.email)>
		<cfset getResponse().setFieldError("email", "Enter a valid email address.") />
	</cfif>

	<cfif NOT isValid("integer", attributes.numSwims) OR attributes.numSwims LT 10 OR attributes.numSwims GT 100>
		<cfset getResponse().setFieldError("numSwims", "Select a number of swims to purchase.") />
	</cfif>

	<cfif NOT listFindNoCase(valueList(application.qCreditCardTypes.shortName), attributes.creditCardTypeID)>
		<cfset getResponse().setFieldError("creditCardTypeID", "Select a credit card type.") />
	</cfif>

	<cfif NOT isValid("creditcard", attributes.creditCardNumber)>
		<cfset getResponse().setFieldError("creditCardNumber", "Enter a valid credit card number.") />
	</cfif>

	<cfif NOT isValid("integer", attributes.creditCardExpirationMonth) OR NOT isValid("integer", attributes.creditCardExpirationYear)>
		<cfset getResponse().setFieldError("creditCardExpirationMonth", "Select a valid card expiration month and year.") />
	<cfelse>
		<cftry>
			<cfset expiration = parseDateTime(attributes.creditCardExpirationYear & "-" & attributes.creditCardExpirationMonth & "-01") />
			<cfset expiration = dateAdd("m", 1, expiration) />

			<cfif dateCompare(now(), expiration) GTE 0>
				<cfset getResponse().setFieldError("creditCardExpirationMonth", "Select a card expiration after today.") />
			</cfif>
			<cfcatch type="any">
				<cfset getResponse().setFieldError("creditCardExpirationMonth", "Select a valid card expiration month and year.") />
			</cfcatch>
		</cftry>
	</cfif>

	<cfif NOT isValid("integer", attributes.creditCardVerificationNumber)>
		<cfset getResponse().setFieldError("creditCardNumber", "Enter a valid card verification number.") />
	<cfelse>
		<cfif (attributes.creditCardTypeID IS "AMEX" AND len(attributes.creditCardVerificationNumber) NEQ 4) OR len(attributes.creditCardVerificationNumber) NEQ 3>
			<cfset getResponse().setFieldError("creditCardNumber", "Enter a valid card verification number.") />
		</cfif>
	</cfif>

	<cfif len(attributes.nameOnCard) EQ 0>
		<cfset getResponse().setFieldError("nameOnCard", "Enter the name on the card.") />
	</cfif>

	<cfif len(attributes.billingStreet) EQ 0>
		<cfset getResponse().setFieldError("billingStreet", "Enter the billing address.") />
	</cfif>

	<cfif len(attributes.billingCity) EQ 0>
		<cfset getResponse().setFieldError("billingCity", "Enter the billing city.") />
	</cfif>

	<cfif len(attributes.billingState) EQ 0>
		<cfset getResponse().setFieldError("billingState", "Select the billing state.") />
	</cfif>

	<cfif len(attributes.billingZip) EQ 0>
		<cfset getResponse().setFieldError("billingZip", "Enter the billing ZIP/Postal Code.") />
	</cfif>

	<cfif len(attributes.billingCountry) EQ 0>
		<cfset getResponse().setFieldError("billingCountry", "Select the billing country.") />
	</cfif>

	<cfif NOT getResponse().hasFieldErrors()>
		<cfset getResponse().setStatusText("OK") />

		<!--- If they're not logged in, see if they're a member --->
		<cfif getUser().getUserID() EQ 0>
			<cfset request.isMember = false />
			<cfset user = new squid.Users(request.dsn).getByEmailAddress(attributes.email) />
			<!--- If they weren't found, we need to send an error message back --->
			<cfif user.getUserID() EQ 0>
				<cfset getResponse().setFieldError("email", "The email address you entered was not found in our system. Please <a href='#request.self#?fuseaction=#xfa.contact#&sender_email=#attributes.email#&officer_type_id=2'>contact us</a> for assistance.") />
			<cfelse>
				<cfset request.isMember = variables.user.getUserStatus() IS "Member" />
			</cfif>
		<cfelse>
			<cfset request.isMember = true />
		</cfif>

		<cfif NOT getResponse().hasFieldErrors()>
			<!--- Calculate the number of free swims --->
			<cfset request.freeSwims = 0 />
			<cfif request.isMember>
				<cfset request.freeSwims = calculateFreeSwims(attributes.numSwims, request.purchasedSwimsPerFreeSwim) />
			</cfif>

			<cfset request.totalSwims = attributes.numSwims + request.freeSwims />
			<cfset request.totalCost = attributes.numSwims * (request.isMember ? request.pricePerSwimMembers : request.pricePerSwimNonmembers) />
		</cfif>
	</cfif>
</cfsilent>
