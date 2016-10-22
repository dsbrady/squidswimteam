<cfcomponent displayname="PayPal Component" hint="CFC for PayPal">
	<cffunction name="verifyPaypal" access="public" displayname="verifyPaypal" hint="Submits verification token to PayPal" output="No" returntype="string">
		<cfargument name="txToken" required="yes" type="string" />
		<cfargument name="paypalToken" required="yes" type="string" />

		<cfset var qrystring = "cmd=_notify-synch&tx=" & txToken & "&at=" & paypalToken />

		<cfhttp url="https://www.paypal.com/cgi-bin/webscr?#qryString#" method="GET" resolveurl="No" />

		<cfreturn cfhttp.filecontent />
	</cffunction>

	<cffunction name="parsePayPalResponse" access="public" displayname="parsePayPalResponse" hint="Parses Response from PayPal" output="No" returntype="struct">
		<cfargument name="content" required="Yes" type="string">

		<cfscript>
			var success = StructNew();
			success.success = "Yes";
			success.reason = "";
			success.paypal = StructNew();
		</cfscript>

		<cfif LEFT(arguments.content,7) IS "SUCCESS">
			<!--- Successful, so process --->
			<cfloop list="#arguments.content#" index="i" delimiters="#CHR(10)#">
				<cfset success.paypal[ListFirst(i,"=")] = ListLast(i,"=")>
			</cfloop>

			<cfset success.paypal.success = true />
		<cfelse>
			<!--- Failure --->
			<cfset success.paypal.success = false />
		</cfif>

		<cfreturn success />
	</cffunction>

	<cffunction name="doDirectPayment" access="public" hint="Submits Payment to Paypal" output="false" returntype="struct">
		<cfargument name="stPaypalSettings" required="true" type="struct" />
		<cfargument name="stPaymentData" required="true" type="struct" />

		<cfset var local = structNew() />
		<cfset local.stResults = structNew() />
		<cfset local.stResults.isSuccessful = true />
		<cfset local.stResults.aErrors = arrayNew(1) />

		<cfhttp method="get" url="#arguments.stPaypalSettings.apiURL#" result="local.stPayPalResults">
			<cfhttpparam type="url" name="user" value="#arguments.stPaypalSettings.apiUsername#" />
			<cfhttpparam type="url" name="pwd" value="#arguments.stPaypalSettings.apiPassword#" />
			<cfhttpparam type="url" name="signature" value="#arguments.stPaypalSettings.apiSignature#" />
			<cfhttpparam type="url" name="version" value="#arguments.stPaypalSettings.apiVersion#" />
			<cfhttpparam type="url" name="method" value="DoDirectPayment" />
			<cfhttpparam type="url" name="paymentAction" value="#arguments.stPaymentData.paymentAction#" />
			<cfhttpparam type="url" name="ipAddress" value="#arguments.stPaymentData.ipAddress#" />
			<cfhttpparam type="url" name="returnFMFDetails" value="#arguments.stPaymentData.returnFMFDetails#" />
			<cfhttpparam type="url" name="creditCardType" value="#arguments.stPaymentData.creditCardType#" />
			<cfhttpparam type="url" name="acct" value="#arguments.stPaymentData.acct#" />
			<cfhttpparam type="url" name="expDate" value="#arguments.stPaymentData.expDate#" />
			<cfhttpparam type="url" name="amt" value="#arguments.stPaymentData.amt#" />
			<cfhttpparam type="url" name="email" value="#arguments.stPaymentData.email#" />
			<cfhttpparam type="url" name="street" value="#arguments.stPaymentData.street#" />
			<cfhttpparam type="url" name="city" value="#arguments.stPaymentData.city#" />
			<cfhttpparam type="url" name="state" value="#arguments.stPaymentData.state#" />
			<cfhttpparam type="url" name="COUNTRYCODE" value="#arguments.stPaymentData.countryCode#" />
			<cfhttpparam type="url" name="ZIP" value="#arguments.stPaymentData.zip#" />
			<cfhttpparam type="url" name="firstname" value="#arguments.stPaymentData.firstName#" />
			<cfhttpparam type="url" name="lastname" value="#arguments.stPaymentData.lastName#" />
			<cfhttpparam type="url" name="desc" value="#arguments.stPaymentData.desc#" />
		</cfhttp>
		<cfset local.stResults.stPayPalResults = convertResponseToStruct(local.stPayPalResults.fileContent) />

		<cfif local.stResults.stPayPalResults.ack DOES NOT CONTAIN "Success">
			<cfset local.stResults.isSuccessful = false />
			<cfset arrayAppend(local.stResults.aErrors,"There was a problem processing your payment. If you feel this is an error, please contact us.") />
		</cfif>

		<cfreturn local.stResults />
	</cffunction>

	<cffunction name="convertResponseToStruct" access="private" hint="Converts the paypal response to a struct" output="false" returntype="struct">
		<cfargument name="filecontent" required="true" type="string" />

		<cfset var local = structNew() />
		<cfset local.stResults = structNew() />

		<cfloop list="#arguments.fileContent#" index="local.item" delimiters="&">
			<cfset local.stResults[listFirst(local.item,"=")] = urlDecode(listRest(local.item,"=")) / >
		</cfloop>

		<cfreturn local.stResults />
	</cffunction>
</cfcomponent>