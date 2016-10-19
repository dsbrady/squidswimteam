<!---
<fusedoc
	fuse = "act_buySwims_return.cfm.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I handle the return from PayPal and resubmit back to PayPal with the token 
		and process data
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="20 August 2004" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
		</in>
		<out>
			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<!--- Verify paypal --->
<cfset paypalContent = paypalCFC.verifyPayPal(URL.tx,Request.paypal_token) />

<!--- Parse paypal --->
<cfset stSuccess = paypalCFC.parsePayPalResponse(paypalContent) />

<!--- If it wasn't successful, error out --->
<cfif NOT stSuccess.paypal.success>
	<cfset success = "No" />
	<cfset reason = "There was a problem verifying your transaction. Please contact the Treasurer.*" />

	<cflocation addtoken="No" url="#Request.self#/fuseaction/#XFA.next#/success/#variables.success#/reason/#variables.reason#.cfm" />
</cfif>

<cfset stSuccess.paypal.username = ListFirst(URLDecode(stSuccess.paypal.custom),"|") />
<cfset stSuccess.paypal.user_id = ListLast(URLDecode(stSuccess.paypal.custom),"|") />

<!--- Update transaction --->
<cfset memberCFC.buySwimsConfirm(Request.dsn,Request.practice_transactionTbl,stSuccess.paypal,Request.squid.user_id) />

<!--- Set up e-mail content --->
<cfset qTrans = lookupCFC.getTransactions(stSuccess.paypal.item_number,Request.squid.user_id,0,Request.DSN,Request.usersTbl,Request.user_statusTbl,Request.practice_transactionTbl,Request.practicesTbl,Request.transaction_typeTbl,Request.facilityTbl) />
<cfset stEmail = memberCFC.buySwimsEmail(Request.dsn,Request.practice_transactionTbl,Request.usersTbl,qTrans,stSuccess.paypal) />

<!--- Send e-mail to user --->
<cfif LEN(trim(qTrans.memberEmail))>
<cfmail from="#Request.from_email#" to="#qTrans.memberEmail#" subject="SQUID Swims Purchase" server="mail.squidswimteam.org">
#stEmail.userMail#
</cfmail>
</cfif>

<!--- Send e-mail to squid --->
<cfmail from="#Request.from_email#" to="dsbrady@scottbrady.net,treasurer@squidswimteam.org" subject="SQUID Swims Purchase - #qTrans.memberpref# #qTrans.memberlast#" server="mail.squidswimteam.org">
#stEmail.squidMail#
</cfmail>

<!--- Redirect --->
<cflocation addtoken="No" url="#Request.self#/fuseaction/#XFA.next#/transaction_id/#stSuccess.paypal.item_number#/swimsCost/#stSuccess.paypal.payment_gross#.cfm">
