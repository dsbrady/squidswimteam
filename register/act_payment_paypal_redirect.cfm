<!---
<fusedoc
	fuse = "act_payment_paypal_redirect.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I redirect to PayPal.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="16 April 2004" type="Create">
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
<cfset session.goldrush2009.totalFee = 1.00 />
<cfset paypalURL = "https://www.paypal.com/xclick/business=#Request.paypal_email#&item_name=#Request.paypal_item#&item_number=#URLEncodedFormat(Request.paypal_itemNo)#&amount=#Session.goldrush2009.totalFee#&no_note=1&currency_code=USD&custom=#Session.goldrush2009.registration_id#&return=#Request.paypal_returnURL#&rm=1">

<cflocation addtoken="No" url="#variables.paypalURL#">
