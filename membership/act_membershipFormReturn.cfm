<!---
<fusedoc
	fuse = "act_membershipFormReturn.cfm"
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

	<cflocation addtoken="No" url="#Request.self#?fuseaction=#XFA.next#&success=#variables.success#&reason=#variables.reason#" />
</cfif>

<cfset stSuccess.paypal.user_id = ListLast(URLDecode(stSuccess.paypal.custom),"|") />
<cfset stSuccess.paypal.expirationYear = ListFirst(URLDecode(stSuccess.paypal.custom),"|") />
<cfset session.squid.date_expiration = CreateDateTime(stSuccess.paypal.expirationYear,12,31,23,59,59) />

<!--- Update Membership Info --->
<cfset memberCFC.payDuesConfirm(Request.dsn,Request.usersTbl,Request.user_statusTbl,lookupCFC,stSuccess.paypal) />

<!--- Set up e-mail content --->
<cfset qMember = lookupCFC.getMembers(Request.dsn,Request.usersTbl,Request.user_statusTbl,Request.practice_transactionTbl,Request.transaction_typeTbl,stSuccess.paypal.user_id) />
<cfset stEmail = memberCFC.payDuesEmail(Request.dsn,Request.usersTbl,qMember,stSuccess.paypal) />

<!--- Send e-mail to user --->
<cfif LEN(trim(qMember.email))>
<cfmail from="#Request.from_email#" to="#qMember.email#" subject="SQUID Membership Dues - #stSuccess.paypal.expirationYear#" server="mail.squidswimteam.org">
#stEmail.userMail#
</cfmail>
</cfif>

<!--- Send e-mail to squid --->
<cfmail from="#Request.from_email#" to="dsbrady@protonmail.com,treasurer@squidswimteam.org" subject="SQUID Membership Dues (#stSuccess.paypal.expirationYear#) - #qMember.preferred_name# #qMember.last_name#" server="mail.squidswimteam.org">
#stEmail.squidMail#
</cfmail>

<!--- Redirect --->
<cflocation addtoken="No" url="#Request.self#?fuseaction=#XFA.next#&transaction_id=#stSuccess.paypal.item_number#">

