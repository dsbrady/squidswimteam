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
			<number name="totalSwims" scope="formOrUrl" />
			<number name="swimsCost" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.numSwims" default="0" type="numeric" />

<!--- Determine final number of swims and cost --->
<cfif variables.currentBalance GT Request.specialDealMinimumBalance OR DateCompare(Now(),CreateDate(2006,3,1)) LT 0>
	<cfswitch expression="#attributes.numSwims \ 10#">
		<cfcase value="0">
			<cfset freeSwims = 0 />
		</cfcase>
		<cfcase value="1">
			<cfset freeSwims = 1 />
		</cfcase>
		<cfcase value="2">
			<cfset freeSwims = 3 />
		</cfcase>
		<cfcase value="3">
			<cfset freeSwims = 5 />
		</cfcase>
		<cfdefaultcase>
			<cfset freeSwims = 8 />
		</cfdefaultcase>
	</cfswitch>
	<cfif attributes.numSwims GT 40>
		<cfset freeSwims = variables.freeswims + (attributes.numSwims - 40) \ 10 />
	</cfif>
<cfelse>
	<cfset freeSwims = attributes.numSwims \ 10 />
</cfif>

<cfset totalSwims = attributes.numSwims +  variables.freeSwims />
<cfset swimsCost = attributes.numSwims * Request.pricePerSwim />

<!--- Get transaction type --->
<cfset qTransaction = lookupCFC.getTransactionTypes(Request.dsn,Request.transaction_typeTbl,0,false,"Swim Purchase")>

<!--- Update database --->
<cfset stSuccess = memberCFC.buySwims(Request.dsn,Request.practice_transactionTbl,qTransaction.transaction_type_id,Request.squid.user_id,variables.totalSwims,Request.squid.user_id) />

<cfset Request.paypal_itemNo = stSuccess.transaction_id />

<!--- Redirect --->
<cfset paypalURL = "https://www.paypal.com/xclick/?business=#Request.from_email#&item_name=#Request.paypal_item#&item_number=#URLEncodedFormat(Request.paypal_itemNo)#&amount=#variables.swimsCost#&no_note=1&currency_code=USD&custom=#Request.squid.username#|#Request.squid.user_id#&return=#Request.paypal_returnURL#&rm=1">

<cflocation addtoken="No" url="#variables.paypalURL#">
