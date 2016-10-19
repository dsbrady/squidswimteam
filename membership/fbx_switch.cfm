<!--- 
<fusedoc fuse="FBX_Switch.cfm">
	<responsibilities>
		I am the cfswitch statement that handles the fuseaction, delegating work to various fuses.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="9 May 2004" type="Create">
	</properties>
	<io>
		<in>
			<structure name="fuxebox">
				<string name="fuseaction" />
				<string name="circuit" />
			</structure>
		</in>
	</io>	
</fusedoc>
 --->

<cfswitch expression = "#fusebox.fuseaction#">
<!--- ----------------------------------------
FORM
----------------------------------------- --->
	<cfcase value="dsp_membershipForm,start,dsp_start,fusebox.defaultfuseaction">
	<!--- Displays membership form --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Membership Form";
			Request.js_validate = "membership/javascript/membershipForm.js";
			Request.template = "dsp_membershipForm.cfm";

			XFA.next = "membership.membershipPayment";

			Request.onLoad = Request.onLoad & "document.forms['inputForm'].elements['first_name'].focus();document.forms['inputForm'].elements['first_name'].select()";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

<!--- 1/13/2013 - not used any more
	<cfcase value="dsp_membershipConfirm">
	<!--- Displays Dues Payment Confirmation screen --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Membership Confirmation";

			Request.template = "dsp_membershipConfirm.cfm";

			XFA.dues = "membership.dsp_membershipConfirm";
			XFA.next = "membership.act_membershipForm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>
--->

	<cfcase value="membershipPayment">
	<!--- Displays Membership Payment screen --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Membership Confirmation / Payment";

			arrayAppend(request.jsOther,"/javascript/external/jquery/jquery-1.8.3.min.js");
			arrayAppend(request.jsOther,"/javascript/external/jquery/jquery-ui-1.9.2.custom.min.js");
			arrayAppend(request.jsOther,"/javascript/external/creditcard.js");
			arrayAppend(request.jsOther,"/javascript/creditCardCCV2.js");
			arrayAppend(request.jsOther,"membership/javascript/membershipPayment.js");
			arrayAppend(request.ssOther,"/styles/cupertino/jquery-ui-1.9.2.custom.min.css");

			Request.template = "dsp_membershipPayment.cfm";

			XFA.next = "membership.act_membershipPayment";
		</cfscript>

		<cfinclude template="#Request.template#" />
		<cfinclude template="/lib/creditCardCCV2.cfm" />
	</cfcase>

	<cfcase value="act_membershipPayment">
	<cfsilent>
		<cfset request.suppressLayout = true />
		<cfset request.template = "val_membershipPayment.cfm" />
		<cfset XFA.next = "membership.dsp_membershipFormResults" />
		
		<cfinclude template="#request.template#" />
	</cfsilent>
	</cfcase>

<!--- 1/13/2013 - not used any more
	<cfcase value="act_membershipForm">
	<cfsilent>
	<!--- Processes membership and sends on to PayPal --->
		<cfscript>
			XFA.paypalReturn = "membership.act_membershipFormReturn";

			Request.suppressLayout = true;
			
			memberCFC = CreateObject("component",Request.members_cfc);
			lookupCFC = CreateObject("component",Request.lookup_cfc);

			Request.template = "val_membershipForm.cfm";

			/* ************************************
			PAYPAL SETTINGS
			************************************ */
			Request.paypal_returnURL = Request.theServer & "/index.cfm%3Ffuseaction%26" & XFA.payPalReturn;
			Request.paypal_item = "SQUID+Membership";
			Request.paypal_itemNo = "";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="act_membershipFormReturn">
	<cfsilent>
	<!--- Processes swims after coming back from PayPal --->
		<cfscript>
			XFA.next = "membership.dsp_membershipFormResults";
			payPalCFC = CreateObject("component",Request.paypal_cfc);
			memberCFC = CreateObject("component",Request.members_cfc);
			lookupCFC = CreateObject("component",Request.lookup_cfc);

			Request.template = "act_membershipFormReturn.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>
--->

	<cfcase value="dsp_membershipFormResults">
	<!--- Displays Pay Dues results screen (after PayPal) --->
		<cfscript>
			XFA.buySwims = "membership.dsp_membershipForm";
			XFA.login = "login.dsp_login";
			lookupCFC = CreateObject("component",Request.lookup_cfc);

			Request.template = "dsp_membershipFormResults.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="newMemberForm">
	<!--- Displays new member form --->
		<cfscript>
			Request.page_title = Request.page_title & " New Member Form";

			arrayAppend(request.jsOther,"/javascript/external/jquery/jquery-1.8.3.min.js");
			arrayAppend(request.jsOther,"/javascript/external/jquery/jquery-ui-1.9.2.custom.min.js");
			arrayAppend(request.jsOther,"/javascript/additionalFees.js");
			arrayAppend(request.ssOther,"/styles/cupertino/jquery-ui-1.9.2.custom.min.css");
			arrayAppend(request.jsOther,"membership/javascript/newMemberForm.js");
			arrayAppend(request.ssOther,"/styles/membership/newMemberForm.css");
			Request.template = "dsp_newMemberForm.cfm";

			XFA.next = "membership.newMemberPayment";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="newMemberPayment">
	<!--- Displays new member payment page --->
		<cfset Request.page_title = Request.page_title & " New Member Payment" />
		<cfset arrayAppend(request.jsOther,"/javascript/external/jquery/jquery-1.8.3.min.js") />
		<cfset arrayAppend(request.jsOther,"/javascript/external/jquery/jquery-ui-1.9.2.custom.min.js") />
		<cfset arrayAppend(request.jsOther,"/javascript/additionalFees.js") />
		<cfset arrayAppend(request.ssOther,"/styles/cupertino/jquery-ui-1.9.2.custom.min.css") />
		<cfset arrayAppend(request.ssOther,"/styles/membership/newMemberForm.css") />
		<cfset arrayAppend(request.jsOther,"/javascript/external/creditcard.js") />
		<cfset arrayAppend(request.jsOther,"/javascript/creditCardCCV2.js") />
		<cfset arrayAppend(request.jsOther,"membership/javascript/newMemberPayment.js") />
		<cfset Request.template = "dsp_newMemberPayment.cfm" />

		<cfset request.profileCFC = CreateObject("component",Request.profile_cfc) />
		
		<cfinclude template="val_newMemberForm.cfm" />
		<cfif NOT request.stSuccess.isSuccessful>
			<cfset XFA.next = "membership.newMemberForm" />
			<cfset variables.reason = arrayToList(request.stSuccess.aErrors,"*") />
			<cfset variables.URL = "#variables.baseHREF##Request.self#?fuseaction=#XFA.next#&success=#request.stSuccess.isSuccessful#&reason=#variables.reason#" />
			<cfloop collection="#form#" item="i">
				<cfif i NEQ "fieldNames">
					<cfset variables.URL = variables.URL & "&" & i & "=" & form[i] />
				</cfif>
			</cfloop>

			<cflocation addtoken="false" url="#variables.URL#" />
		<cfelse>
			<cfset XFA.next = "membership.newMemberSubmit" />
			<cfinclude template="#Request.template#" />
			<cfinclude template="/lib/creditCardCCV2.cfm" />
		</cfif>
	</cfcase>

	<cfcase value="newMemberSubmit">
	<cfsilent>
	<!--- Processes membership and PayPal payment --->
		<cfscript>
			XFA.tryAgain = "membership.newMemberForm";
			XFA.next = "membership.newMemberResults";

			request.suppressLayout = true;
			
			Request.template = "val_newMemberSubmit.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="newMemberResults">
	<!--- Displays new member form results --->
		<cfscript>
			XFA.login = "login.dsp_login";
			Request.page_title = Request.page_title & " New Member Results";

			arrayAppend(request.ssOther,"/styles/membership/newMemberForm.css");
			Request.template = "dsp_newMemberResults.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>


	<cfdefaultcase>
		<!---This will just display an error message and is useful in catching typos of fuseaction names while developing--->
		<cfoutput><p>This is the cfdefaultcase tag. I received a fuseaction called <strong>"#attributes.fuseaction#"</strong> and I don't know what to do with it.</p></cfoutput>
	</cfdefaultcase>

</cfswitch>