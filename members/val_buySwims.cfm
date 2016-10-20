<!---
<fusedoc
	fuse = "val_buySwims.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I process the swims and direct them to PayPal.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="20 August 2004" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>

			<number name="numSwims" scope="attributes" />
		</in>
		<out>
			<number name="numSwims" scope="formOrUrl" />
			<number name="swimsCost" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfif val(attributes.swimPassID) GT 0>
	<cfset swimsCost = val(request.qSwimPass.price) - (request.qMember.balance * request.pricePerSwimMembers) />
	<cfset transactionType = "Swim Pass Purchase" />
	<cfset request.paypal_item = "SQUID+Swims+Pass+Purchase" />
<cfelse>
	<cfset swimsCost = attributes.numSwims * request.pricePerSwimMembers />
	<cfset request.totalSwims = attributes.numSwims + (attributes.numSwims \ request.purchasedSwimsPerFreeSwim) />
	<cfset transactionType = "Swim Purchase" />
	<cfset request.paypal_item = "SQUID+Swims+Purchase" />
</cfif>
<cfif swimsCost LT 0>
	<cfset swimsCost = 0>
</cfif>
<!--- Get transaction type --->
<cfset qTransaction = lookupCFC.getTransactionTypes(Request.dsn,Request.transaction_typeTbl,0,false,variables.transactionType)>
<!--- Update database --->
<cfif val(attributes.swimPassID) GT 0>
	<cfset stSuccess = memberCFC.buySwimPass(Request.dsn,Request.practice_transactionTbl,qTransaction.transaction_type_id,Request.squid.user_id,0,Request.squid.user_id,request.qMember.balance,attributes.swimPassID,variables.cfcLookup,attributes.activeDate) />
<cfelse>
	<cfset stSuccess = memberCFC.buySwims(Request.dsn,Request.practice_transactionTbl,qTransaction.transaction_type_id,Request.squid.user_id,request.totalSwims,Request.squid.user_id) />
</cfif>

<cfset request.paypal_itemNo = stSuccess.transaction_id />

<!--- Redirect --->
<cfset paypalURL = "https://www.paypal.com/xclick/?business=#Request.from_email#&item_name=#Request.paypal_item#&item_number=#URLEncodedFormat(Request.paypal_itemNo)#&amount=#variables.swimsCost#&no_note=1&currency_code=USD&custom=#Request.squid.username#|#Request.squid.user_id#&return=#Request.paypal_returnURL#&rm=1">

<cflocation addtoken="No" url="#variables.paypalURL#">
