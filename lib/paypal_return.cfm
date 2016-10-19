<!--- I handle the return from PayPal and resubmit back to PayPal with the token --->
<cfset Request.paypal_token = "8CbmVDy5Y02br8MHkMGbG_ljthhjIFnr591AuXNRMxl9dTZDo9ohFuzLIXS">
<cfset txToken = URL.tx>

<cfset qryString = "cmd=_notify-synch&tx=" & variables.txToken & "&at=" & Request.paypal_token>

<cfhttp url="https://www.paypal.com/cgi-bin/webscr?#variables.qryString#" method="GET" resolveurl="No">
</cfhttp>
<cfdump var="#cfhttp#">