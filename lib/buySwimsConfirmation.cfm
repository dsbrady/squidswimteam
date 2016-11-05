<cfsilent>
	<!--- I display the buy swims confirmation content --->
	<cfparam name="attributes.numSwims" default="0" type="numeric" />
	<cfset swimsCost = attributes.numSwims * request.pricePerSwimMembers />
	<cfset additionalSwims = attributes.numSwims \ request.purchasedSwimsPerFreeSwim />
	<cfif swimsCost LT 0>
		<cfset swimsCost = 0>
	</cfif>
	<cfif structKeyExists(caller,"totalAmountDue")>
		<cfset caller.totalAmountDue += variables.swimsCost />
	</cfif>
</cfsilent>
<cfoutput>
	<div id="buySwimsConfirmationContainer">
		<div class="buySwimsLabel">
			Swims Purchasing:
		</div>
		<div class="buySwimsText">
			#attributes.numSwims#
		</div>
		<div class="buySwimsLabel">
			Free Swims:
		</div>
		<div class="buySwimsText">
			#variables.additionalSwims#
		</div>
		<div class="buySwimsLabel">
			Total Swims:
		</div>
		<div class="buySwimsText">
			#variables.additionalSwims + attributes.numSwims#
		</div>
		<div class="buySwimsLabel">
			Total Swims Cost:
		</div>
		<div class="buySwimsText">
			#dollarFormat(variables.swimsCost)#
		</div>
	</div>
</cfoutput>