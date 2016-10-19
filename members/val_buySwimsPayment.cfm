<!---
<fusedoc
	fuse = "val_buySwimsPayment.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I process the PayPal payment and swim purchase (if successful)
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="8 January 2013" type="Create" />
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>

		</in>
		<out>
			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.numSwims" default="0" type="numeric" />
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

<cfset swimsCost = attributes.numSwims * Request.pricePerSwim />
<cfset request.totalSwims = attributes.numSwims + (attributes.numSwims \ request.purchasedSwimsPerFreeSwim) />
<cfset transactionType = "Swim Purchase" />
<cfset request.paypal_item = "SQUID+Swims+Purchase" />
<cfif swimsCost LT 0>
	<cfset swimsCost = 0>
</cfif>
<!--- Get transaction type --->
<cfset qTransaction = request.lookupCFC.getTransactionTypes(Request.dsn,Request.transaction_typeTbl,0,false,variables.transactionType)>

<!--- Update database --->
<cfset stSuccess = request.membersCFC.buySwims(Request.dsn,Request.practice_transactionTbl,qTransaction.transaction_type_id,Request.squid.user_id,request.totalSwims,Request.squid.user_id) />

<cfset request.squidTransactionID = stSuccess.transaction_id />


<cfset request.stPaypal = structNew() />
<cfset request.stPaypal.paymentAction = "Sale" />
<cfset request.stPaypal.ipAddress = cgi.remote_addr />
<cfset request.stPaypal.desc = "SQUID Swim Purchase" />
<cfset request.stPaypal.invNumber = variables.stSuccess.transaction_id />
<cfset request.stPaypal.returnFMFDetails = 1 />
<cfset request.stPaypal.creditCardType = attributes.creditCardTypeID />
<cfset request.stPaypal.acct = attributes.creditCardNumber />
<cfset request.stPaypal.expDate = numberFormat(attributes.creditCardExpirationMonth,"00") & attributes.creditCardExpirationYear />
<cfset request.stPaypal.cvv2 = attributes.creditCardVerificationNumber />
<cfset request.stPaypal.amt = variables.swimsCost />
<cfset request.stPaypal.email = session.squid.email />
<cfset request.stPaypal.street = attributes.billingStreet />
<cfset request.stPaypal.city = attributes.billingCity />
<cfset request.stPaypal.state = attributes.billingState />
<cfset request.stPaypal.COUNTRYCODE = attributes.billingCountry />
<cfset request.stPaypal.ZIP = attributes.billingZip />
<cfset request.stPaypal.firstname = listFirst(attributes.nameOnCard," ") />
<cfset request.stPaypal.lastname = listRest(attributes.nameOnCard," ") />

<cfset request.objPayPal = createObject("component",request.paypal_cfc) />
<cfset request.stSuccess = request.objPayPal.doDirectPayment(application.stPayPalSettings,request.stPaypal) />

<!--- If it wasn't successful, error out --->
<cfif NOT request.stSuccess.isSuccessful>
	<cfset success = "No" />
	<cfset reason = "There was a problem verifying your transaction. Please contact the Treasurer.*" />

	<cflocation addtoken="false" url="#Request.self#?fuseaction=#XFA.next#&transaction_id=#request.stPaypal.invNumber#&success=#variables.success#&reason=#variables.reason#" />
</cfif>

<!--- Update transaction --->
<cfset request.membersCFC.buySwimsConfirm(Request.dsn,Request.practice_transactionTbl,session.squid.user_id,"PayPal Transaction ###request.stSuccess.stPaypalResults.transactionID#",session.squid.user_id,request.stPaypal.invNumber) />

<!--- Set up e-mail content --->
<cfset qTrans = request.lookupCFC.getPaypalPurchaseTransaction(request.stPayPal.invNumber,session.squid.user_id,request.DSN) />
<cfset stEmail = request.membersCFC.buySwimsEmail(request.dsn,request.practice_transactionTbl,request.usersTbl,qTrans,request.stSuccess.stPaypalResults) />

<!--- Send e-mail to user --->
<cfif LEN(trim(qTrans.memberEmail))>
<cfmail from="#Request.from_email#" to="#qTrans.memberEmail#" subject="#stEmail.subject#" server="mail.squidswimteam.org">
#stEmail.userMail#
</cfmail>
</cfif>

<!--- Send e-mail to squid --->
<cfmail from="#Request.from_email#" to="dsbrady@protonmail.com,treasurer@squidswimteam.org" subject="#stEmail.subject# - #qTrans.memberpref# #qTrans.memberlast#" server="mail.squidswimteam.org">
#stEmail.squidMail#
</cfmail>

<!--- Redirect --->
<cflocation addtoken="false" url="#Request.self#?fuseaction=#XFA.next#&transaction_id=#request.stPaypal.invNumber#&paypalTransactionID=#request.stSuccess.stPaypalResults.transactionID#&swimsCost=#variables.swimsCost#" />
