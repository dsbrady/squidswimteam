	<cfparam name="attributes.email" default="" type="string" />
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
	<cfparam name="attributes.creditCardTypeID" default="" type="string" />
	<cfparam name="attributes.creditCardNumber" default="" type="string" />
	<cfparam name="attributes.creditCardExpirationMonth" default="0" type="numeric" />
	<cfparam name="attributes.creditCardExpirationYear" default="0" type="numeric" />
	<cfparam name="attributes.creditCardVerificationNumber" default="" type="string" />
	<cfparam name="attributes.nameOnCard" default="" type="string" />
	<cfparam name="attributes.billingStreet" default="" type="string" />
	<cfparam name="attributes.billingCity" default="" type="string" />
	<cfparam name="attributes.billingState" default="" type="string" />
	<cfparam name="attributes.billingZip" default="" type="string" />
	<cfparam name="attributes.billingCountry" default="" type="string" />
	<cfparam name="attributes.numSwims" default="0" type="numeric" />
	<cfparam name="attributes.user_id" default="0" type="numeric" />

	<!--- Enter user into memberApplicationTable --->
	<cfset request.memberApplicationID = request.membersCFC.insertMemberApplication(request.dsn,attributes).memberApplicationID />

	<!--- Enter into user table --->
	<cfset request.newUserID = request.membersCFC.addUserFromMembershipApplication(request.dsn,attributes,request.lookupCFC,session.squid.stDues,request.memberApplicationID) />

	<!--- Enter into membershipTransaction table --->
	<cfset request.membershipTransactionID = request.membersCFC.insertMemberApplicationTransaction(request.dsn,attributes,session.squid.stDues,request.newUserID) />
	<cfset request.practiceTransactionID = 0 />
	<cfset request.totalAmountDue = session.squid.stDues.fee[session.squid.stDues.duesIndex] />
	<cfset request.paypalDescription = "SQUID Membership" />

	<!--- If they're buying swims, add that into the practiceTransaction table --->
	<cfif attributes.numSwims GT 0>
		<cfset request.swimsCost = attributes.numSwims * request.pricePerSwimMembers />
		<cfset request.totalSwims = attributes.numSwims + (attributes.numSwims \ request.purchasedSwimsPerFreeSwim) />
		<cfif request.swimsCost LT 0>
			<cfset request.swimsCost = 0>
		</cfif>
		<cfset request.totalAmountDue += request.swimsCost />
		<cfset request.practiceTransactionType = "Swim Purchase" />
		<!--- Get the transaction type --->
		<cfset practiceTransactionType = new squid.transactions.TransactionType(request.dsn).getByTransactionType(request.practiceTransactionType) />

		<!--- Insert the practice transaction as an unconfirmed transaction (we need the transaction ID to pass in to PayPal) --->
		<cfset practiceTransaction = new squid.transactions.PracticeTransaction(request.dsn) />

		<cfset practiceTransaction.insertTransaction(
			memberID = request.newUserID,
			swims = request.totalSwims,
			transactionType = practiceTransactionType,
			notes = "PayPal Pending",
			userID = request.newUserID
		) />

		<cfset request.practiceTransactionID = practiceTransaction.getTransactionID() />
		<cfset request.paypalDescription &= " & Swim Purchase" />
	<cfelse>
		<cfset request.totalSwims = 0 />
	</cfif>

	<!--- Process PayPal --->
	<cfset request.stPaypal = structNew() />
	<cfset request.stPaypal.paymentAction = "Sale" />
	<cfset request.stPaypal.ipAddress = cgi.remote_addr />
	<cfset request.stPaypal.desc = request.paypalDescription />
	<cfset request.stPaypal.invNumber = request.membershipTransactionID />
	<cfset request.stPaypal.returnFMFDetails = 1 />
	<cfset request.stPaypal.creditCardType = attributes.creditCardTypeID />
	<cfset request.stPaypal.acct = attributes.creditCardNumber />
	<cfset request.stPaypal.expDate = numberFormat(attributes.creditCardExpirationMonth,"00") & attributes.creditCardExpirationYear />
	<cfset request.stPaypal.cvv2 = attributes.creditCardVerificationNumber />
	<cfset request.stPaypal.amt = request.totalAmountDue />
	<cfset request.stPaypal.email = attributes.email />
	<cfset request.stPaypal.street = attributes.billingStreet />
	<cfset request.stPaypal.city = attributes.billingCity />
	<cfset request.stPaypal.state = attributes.billingState />
	<cfset request.stPaypal.COUNTRYCODE = attributes.billingCountry />
	<cfset request.stPaypal.ZIP = attributes.billingZip />
	<cfset request.stPaypal.firstname = listFirst(attributes.nameOnCard," ") />
	<cfset request.stPaypal.lastname = listRest(attributes.nameOnCard," ") />

	<cfset request.objPayPal = createObject("component",request.paypal_cfc) />
	<cfset request.stSuccess = request.objPayPal.doDirectPayment(application.stPayPalSettings,request.stPaypal) />

	<!--- If it wasn't successful, error out and remove previously inserted data --->
	<cfif NOT request.stSuccess.isSuccessful>
		<cfset request.membersCFC.removeMemberApplicationData(request.dsn,request.newUserID,request.membershipTransactionID,request.memberApplicationID,request.practiceTransactionID) />
		<cfset success = "No" />
		<cfset reason = "There was a problem processing your payment. Please <a href=""#request.self#?fuseaction=#xfa.tryAgain#"">fill out the application again</a> or contact the Treasurer." />

		<cflocation addtoken="false" url="#Request.self#?fuseaction=#XFA.next#&success=#variables.success#&reason=#variables.reason#" />
	</cfif>

	<!--- Update Membership and transaction Info --->
	<cfset request.membersCFC.payDuesConfirm(Request.dsn,Request.usersTbl,Request.user_statusTbl,request.lookupCFC,request.newUserID,session.squid.stDues.membershipYear[session.squid.stDues.duesIndex],"PayPal Transaction ###request.stSuccess.stPaypalResults.transactionID#",request.stPaypal.invNumber) />

	<cfif val(request.practiceTransactionID) GT 0>
		<cfset practiceTransaction.setIsConfirmed(true) />
		<cfset practiceTransaction.setNotes("PayPal Transaction ###request.stSuccess.stPaypalResults.transactionID#") />
		<cfset practiceTransaction.setModifiedUserID(request.newUserID) />
		<cfset practiceTransaction.setModifiedDate(now()) />
		<cfset practiceTransaction.save() />
	</cfif>

	<!--- Set up e-mail content --->
	<cfset qMember = request.lookupCFC.getMembers(Request.dsn,Request.usersTbl,Request.user_statusTbl,Request.practice_transactionTbl,Request.transaction_typeTbl,request.newUserID) />
	<cfset stEmail = request.membersCFC.payDuesEmail(Request.dsn,Request.usersTbl,qMember,request.stSuccess.stPaypalResults,session.squid.stDues.membershipYear[session.squid.stDues.duesIndex],request.totalSwims) />

	<!--- Send e-mail to user --->
	<cfif LEN(trim(qMember.email))>
	<cfmail from="#Request.from_email#" to="#qMember.email#" subject="SQUID Membership Sign-up - #session.squid.stDues.membershipYear[session.squid.stDues.duesIndex]#" server="mail.squidswimteam.org">
	#stEmail.userMail#
	</cfmail>
	</cfif>

	<!--- Send e-mail to squid --->
	<cfmail from="#Request.from_email#" to="dsbrady@protonmail.com,treasurer@squidswimteam.org" subject="SQUID Membership Sign-Up (#session.squid.stDues.membershipYear[session.squid.stDues.duesIndex]#) - #qMember.preferred_name# #qMember.last_name#" server="mail.squidswimteam.org">
	#stEmail.squidMail#
	</cfmail>

	<!--- Redirect --->
	<cflocation addtoken="false" url="#Request.self#?fuseaction=#XFA.next#&transaction_id=#request.stPaypal.invNumber#&practiceTransactionID=#request.practiceTransactionID#&paypalTransactionID=#request.stSuccess.stPaypalResults.transactionID#&totalCost=#request.totalAmountDue#" />
