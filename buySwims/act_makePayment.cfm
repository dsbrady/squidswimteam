<!--- First, let's see if they're a member and calculate accordingly --->
<cfif getUser().getUserID() EQ 0>
	<cfset request.isMember = false />
	<cfset request.squid.user = new squid.Users(request.dsn).getByEmailAddress(attributes.email) />
	<cfset request.isMember = request.squid.user.getUserStatus() IS "Member" />
<cfelse>
	<cfset request.isMember = true />
</cfif>

<!--- Calculate the number of free swims --->
<cfset request.freeSwims = 0 />
<cfif request.isMember>
	<cfset request.freeSwims = calculateFreeSwims(attributes.numSwims, request.purchasedSwimsPerFreeSwim) />
</cfif>

<cfset request.totalSwims = attributes.numSwims + request.freeSwims />
<cfset request.totalCost = attributes.numSwims * (request.isMember ? request.pricePerSwimMembers : request.pricePerSwimNonmembers) />

<cfset transactionTypeName = "Swim Purchase" />
<cfset request.paypal_item = "SQUID+Swims+Purchase" />
<cfif request.totalCost LT 0>
	<cfset request.totalCost = 0 />
</cfif>

<!--- Get the transaction type --->
<cfset transactionType = new squid.transactions.TransactionType(request.dsn).getByTransactionType(transactionTypeName) />

<!--- Insert the transaction as an unconfirmed transaction (we need the transaction ID to pass in to PayPal) --->
<cfset transaction = new squid.transactions.PracticeTransaction(request.dsn) />

<cfset transaction.insertTransaction(
	memberID = request.squid.user.getUserID(),
	swims = request.totalSwims,
	transactionType = transactionType,
	notes = "PayPal Pending",
	userID = request.squid.user.getUserID()
) />

<!--- Now, we need to make the PayPal call --->
<cfset payPalGateway = new squid.transactions.payPalGateway(request.dsn, application.stPayPalSettings) />
<cfset transactionSettings = {
	"paymentAction": "Sale",
	"ipAddress": cgi.remote_addr,
	"desc": "SQUID Swim Purchase",
	"invNumber": transaction.getTransactionID(),
	"returnFMFDetails": 1,
	"creditCardType": attributes.creditCardTypeID,
	"acct": attributes.creditCardNumber,
	"expDate": numberFormat(attributes.creditCardExpirationMonth,"00") & attributes.creditCardExpirationYear,
	"cvv2": attributes.creditCardVerificationNumber,
	"amt": request.totalCost,
	"email": attributes.email,
	"street": attributes.billingStreet,
	"city": attributes.billingCity,
	"state": attributes.billingState,
	"COUNTRYCODE": attributes.billingCountry,
	"ZIP": attributes.billingZip,
	"firstname": listFirst(attributes.nameOnCard, " "),
	"lastName": listRest(attributes.nameOnCard, " ")
} />

<cfset results = payPalGateway.makeDirectPayment(transactionSettings) />

<!--- If it wasn't successful, error out --->
<cfif NOT results.isSuccessful>
	<cfset getResponse().setFieldError("creditCardTypeID", "There was a problem verifying your transaction. Please contact the Treasurer.") />
<cfelse>
	<!--- Now, confirm the transaction --->
	<cfset transaction.setIsConfirmed(true) />
	<cfset transaction.setNotes("PayPal Transaction ###results.payPalResults.transactionID#") />
	<cfset transaction.setModifiedUserID(request.squid.user.getUserID()) />
	<cfset transaction.setModifiedDate(now()) />
	<cfset transaction.save() />

	<!--- Now send the emails --->
	<cfset transactionInfo = {
			"swims": request.totalSwims,
			"cost": request.totalCost,
			"payPalTransactionID": results.payPalResults.transactionID
		} />
	<cfset userEmail = new squid.email.BuySwims(request.dsn, application.mailSettings) />
	<cfset userEmail.buildUserEmail(request.squid.user, variables.transactionInfo) />
	<cfset userEmail.send() />

	<cfset adminEmail = new squid.email.BuySwims(request.dsn, application.mailSettings) />
	<cfset adminEmail.buildAdminEmail(request.squid.user, variables.transactionInfo) />
	<cfset adminEmail.send() />
</cfif>
