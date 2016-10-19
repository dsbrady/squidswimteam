<!---
<fusedoc
	fuse = "act_payment_paypal_redirect.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I handle the return from PayPal and resubmit back to PayPal with the token
		and process data
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="17 April 2004" type="Create">
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
<cfset Request.paypal_token = "8CbmVDy5Y02br8MHkMGbG_ljthhjIFnr591AuXNRMxl9dTZDo9ohFuzLIXS">

<cfset txToken = URL.tx>
<cfset qryString = "cmd=_notify-synch&tx=" & variables.txToken & "&at=" & Request.paypal_token>

<cfhttp url="https://www.paypal.com/cgi-bin/webscr?#variables.qryString#" method="GET" resolveurl="No">
</cfhttp>

<cfset strSuccess = Request.registration_cfc.parsePayPalResponse(cfhttp.filecontent)>

<!--- If the session has ended, repopulate data --->
<cfif NOT VAL(Session.goldrush2009.registration_id)>
	<cfset attributes.paypalRegistrationIDBlast = VAL(strSuccess.paypal.registration_id)>
	<cfinclude template="#Request.loginTemplate#">
</cfif>

<cfset session.goldrush2009.paypal = strSuccess.paypal>

<cflocation addtoken="No" url="#Request.self#/fuseaction/#XFA.next#/returnFromPayPal/true.cfm">

