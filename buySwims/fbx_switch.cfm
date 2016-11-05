<cfswitch expression = "#fusebox.fuseaction#">
	<cfcase value="home,fusebox.defaultfuseaction">
		<cfparam name="attributes.email" default="" type="string">
		<cfparam name="attributes.numSwims" default="10" type="numeric" />
		<cfparam name="attributes.nameOnCard" default="#getUser().getUserID() GT 0 ? '#getUser().getFirstName()# #getUser().getLastName()#' : ''#" type="string" />
		<cfparam name="attributes.billingStreet" default="#getUser().getAddress1()#" type="string" />
		<cfparam name="attributes.billingCity" default="#getUser().getCity()#" type="string" />
		<cfparam name="attributes.billingState" default="#getUser().getStateID()#" type="string" />
		<cfparam name="attributes.billingZip" default="#getUser().getZip()#" type="string" />
		<cfparam name="attributes.billingCountry" default="#getUser().getCountry()#" type="string" />

		<cfparam name="attributes.errors" default="{}" type="string" />
		<cfparam name="attributes.values" default="{}" type="string" />

		<cfset request.errors = deserializeJSON(decodeString(attributes.errors)) />
		<cfset request.values = deserializeJSON(decodeString(attributes.values)) />

		<cfif NOT structIsEmpty(request.values)>
			<cfloop collection="#request.values#" item="key">
				<cfset attributes[key] = request.values[key] />
			</cfloop>
		</cfif>

		<!--- TODO: move this into the main layout so it's always available --->
		<cfset arrayAppend(request.jsOther,"#request.siteRoot#/javascript/external/jquery/jquery-3.1.1.min.js") />
		<cfset arrayAppend(request.jsOther,"#request.siteRoot#/javascript/external/jquery/validate/jquery.validate.min.js") />
		<cfset arrayAppend(request.jsOther,"#request.siteRoot#/javascript/external/jquery/validate/additional-methods.min.js") />
		<cfset arrayAppend(request.jsOther,"#request.siteRoot#/javascript/external/creditcard.js") />
		<cfset arrayAppend(request.jsOther,"#request.siteRoot#/javascript/buySwims.js") />

		<cfset arrayAppend(request.jsOther,"#request.siteRoot#/javascript/external/fancybox/jquery.fancybox.pack.js") />
		<cfset arrayAppend(request.ssOther,"#request.siteRoot#/styles/external/fancybox/jquery.fancybox.css") />

		<cfset request.page_title = Request.page_title & "<br />Buy Swims" />

		<cfset XFA.checkUsername = "#fusebox.circuit#.ajaxUsernameCheck" />
		<cfset XFA.inlineLogin = "login.inlineLogin" />
		<cfset XFA.next = "#fusebox.circuit#.confirmation" />
		<cfset XFA.payDues = "membership.start" />

		<cfinclude template="frm_step1.cfm" />
	</cfcase>
	<cfcase value="confirmation">
		<cfparam name="attributes.email" default="" type="string">
		<cfparam name="attributes.numSwims" default="10" type="numeric" />
		<cfparam name="attributes.nameOnCard" default="#getUser().getUserID() GT 0 ? '#getUser().getFirstName()# #getUser().getLastName()#' : ''#" type="string" />
		<cfparam name="attributes.billingStreet" default="#getUser().getAddress1()#" type="string" />
		<cfparam name="attributes.billingCity" default="#getUser().getCity()#" type="string" />
		<cfparam name="attributes.billingState" default="#getUser().getStateID()#" type="string" />
		<cfparam name="attributes.billingZip" default="#getUser().getZip()#" type="string" />
		<cfparam name="attributes.billingCountry" default="#getUser().getCountry()#" type="string" />

		<cfset request.page_title = Request.page_title & "<br />Buy Swims Confirmation / Payment" />

		<cfset XFA.back = "#fusebox.circuit#.home" />
		<cfset XFA.next = "#fusebox.circuit#.makePayment" />

		<cfinclude template="act_validateSwims.cfm" />
		<cfif getResponse().hasFieldErrors()>
			<cfset values = {
				"email": attributes.email,
				"numSwims": attributes.numSwims,
				"nameOnCard": attributes.nameOnCard,
				"billingStreet": attributes.billingStreet,
				"billingCity": attributes.billingCity,
				"billingState": attributes.billingState,
				"billingZip": attributes.billingZip,
				"billingCountry": attributes.billingCountry
			} />
			<cflocation url="#request.self#?fuseaction=#fusebox.circuit#.home&errors=#encodeString(serializeJSON(getResponse().getFieldErrors()))#&values=#encodeString(serializeJSON(values))#" addtoken="false" />
		</cfif>
		<cfinclude template="frm_confirmation.cfm" />
	</cfcase>
	<cfcase value="makePayment">
		<cfparam name="attributes.email" default="" type="string">
		<cfparam name="attributes.numSwims" default="10" type="numeric" />
		<cfparam name="attributes.nameOnCard" default="#getUser().getUserID() GT 0 ? '#getUser().getFirstName()# #getUser().getLastName()#' : ''#" type="string" />
		<cfparam name="attributes.billingStreet" default="#getUser().getAddress1()#" type="string" />
		<cfparam name="attributes.billingCity" default="#getUser().getCity()#" type="string" />
		<cfparam name="attributes.billingState" default="#getUser().getStateID()#" type="string" />
		<cfparam name="attributes.billingZip" default="#getUser().getZip()#" type="string" />
		<cfparam name="attributes.billingCountry" default="#getUser().getCountry()#" type="string" />

		<cfset request.suppressLayout = true />
		<cfset XFA.success = "#fusebox.circuit#.thanks" />
		<cfset XFA.failure = "#fusebox.circuit#.home" />

		<cfinclude template="act_makePayment.cfm" />
		<cfset values = {
			"email": attributes.email,
			"numSwims": attributes.numSwims,
			"totalSwims": request.totalSwims,
			"cost": request.totalCost,
			"name": "#request.squid.user.getPreferredName()# #request.squid.user.getLastName()#",
			"nameOnCard": attributes.nameOnCard,
			"billingStreet": attributes.billingStreet,
			"billingCity": attributes.billingCity,
			"billingState": attributes.billingState,
			"billingZip": attributes.billingZip,
			"billingCountry": attributes.billingCountry
		} />
		<cfif getResponse().hasFieldErrors()>
			<cflocation url="#request.self#?fuseaction=#XFA.failure#&errors=#encodeString(serializeJSON(getResponse().getFieldErrors()))#&values=#encodeString(serializeJSON(values))#" addtoken="false" />
		<cfelse>
			<cfset values["payPalTransactionID"] = results.payPalResults.transactionID />
			<cflocation url="#request.self#?fuseaction=#XFA.success#&values=#encodeString(serializeJSON(values))#" addtoken="false" />
		</cfif>
	</cfcase>
	<cfcase value="modalCVV2Help">
		<cfset request.blankLayout = "true" />
		<cfinclude template="dsp_cvv2Help.cfm" />
	</cfcase>
	<cfcase value="thanks">
		<cfparam name="attributes.values" default="{}" type="string" />

		<cfset request.values = deserializeJSON(decodeString(attributes.values)) />

		<cfif NOT structIsEmpty(request.values)>
			<cfloop collection="#request.values#" item="key">
				<cfset attributes[key] = request.values[key] />
			</cfloop>
		</cfif>

		<cfset request.page_title = Request.page_title & "<br />Buy Swims Successful!" />

		<cfinclude template="dsp_thanks.cfm" />
	</cfcase>
	<cfdefaultcase>
		<!---This will just display an error message and is useful in catching typos of fuseaction names while developing--->
		<cfoutput><p>This is the cfdefaultcase tag. I received a fuseaction called <strong>"#attributes.fuseaction#"</strong> and I don't know what to do with it.</p></cfoutput>
	</cfdefaultcase>

</cfswitch>
