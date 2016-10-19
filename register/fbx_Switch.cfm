<!--- 
<fusedoc fuse="FBX_Switch.cfm">
	<responsibilities>
		I am the cfswitch statement that handles the fuseaction, delegating work to various fuses.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="15 December 2002" role="Architect">
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
START (menu, login, etc.)
----------------------------------------- --->
	<cfcase value="start,dsp_start,fusebox.defaultfuseaction">
		<cfsilent>
			<!--- This will display the start page --->
			<cfscript>
				Request.template = "dsp_start.cfm";
				
				XFA.registerNew = "home.dsp_master";
				XFA.registerReturn = "home.dsp_registrant_login";
				XFA.description = "home.dsp_meet_description/returnFA/home.dsp_start";
			</cfscript>
		</cfsilent>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_registration_menu">
		<cfsilent>
			<!--- This will display the menu --->
			<cfscript>
				Request.page_title = Request.page_title & "<br />Registration Menu";
				Request.template = "dsp_registration_menu.cfm";
				
				XFA.description = "home.dsp_meet_description/returnFA/home.dsp_registration_menu";
				XFA.master = "home.dsp_master";
				XFA.races = "home.dsp_races";
				XFA.excursions = "home.dsp_excursions";
				XFA.housing = "home.dsp_housing";
				XFA.payment = "home.dsp_payment";
//				XFA.waiver = "home.dsp_waiver";
				XFA.confirmation = "home.dsp_registration_confirmation";

				submitOK = false;
				if (Session.goldrush2009.master AND ((Session.goldrush2009.registrationType EQ "social") OR (Session.goldrush2009.races)))
				{
					submitOK = true;
				}
			</cfscript>
		</cfsilent>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_meet_description">
		<cfsilent>
			<!--- This will display the meet description --->
			<cfscript>
				Request.page_title = Request.page_title & "<br />Meet Description";
				Request.template = "dsp_meet_description.cfm";
				
			</cfscript>
		</cfsilent>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_registrant_login">
		<cfscript>
			Request.page_title = Request.page_title & "<br />Registrant Login";
			Request.js_validate = "javascript/login.js";
			Request.template = "dsp_login.cfm";
			Request.onLoad = Request.onLoad & "document.forms['inputForm'].elements['username'].focus();document.forms['inputForm'].elements['username'].select();";

			XFA.next ="home.act_registrant_login";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>
	
	<cfcase value="act_registrant_login">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = XFA.registration_menu;
			XFA.failure = "home.dsp_registrant_login";

			Request.suppressLayout = true;

			Request.validation_template = "val_registrant_login.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="act_end_session">
	<cfsilent>
	<!--- Ends Session --->
		<cfscript>
			Request.suppressLayout = true;
			Request.exitURL = Request.theServer & "/goldrush2009/";

			Request.template = "act_end_session.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

<!--- ----------------------------------------
REGISTRATION
----------------------------------------- --->
	<cfcase value="dsp_master">
		<cfscript>
			Request.page_title = Request.page_title & "<br />Master Registration";
			Request.js_validate = "javascript/master.js";
			Request.template = "dsp_master.cfm";
			Request.onLoad = Request.onLoad & "document.forms['inputForm'].elements['first_name'].focus();document.forms['inputForm'].elements['first_name'].select();";

			qStates = Request.lookup_cfc.getStates(Request.DSN,"stateTbl");
			qCountries = Request.lookup_cfc.getCountries(Request.DSN,"countryTbl");
			XFA.next ="home.act_master";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>
	
	<cfcase value="act_master">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = XFA.registration_menu;
			XFA.failure = "home.dsp_master";

			Request.suppressLayout = true;

			Request.validation_template = "val_master.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="dsp_waiver">
		<cfscript>
			Request.page_title = Request.page_title & "<br />Mandatory Liability Waiver";
			Request.js_validate = "javascript/waiver.js";
			Request.template = "dsp_waiver.cfm";
			if (NOT LEN(Session.goldrush2009.waiverName))
			{
				Request.onLoad = Request.onLoad & "document.forms['inputForm'].elements['waiverText'].focus();";
			}

			XFA.next ="home.act_waiver";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>
	
	<cfcase value="act_waiver">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = XFA.registration_menu;
			XFA.failure = "home.dsp_waiver";

			Request.suppressLayout = true;

			Request.validation_template = "val_waiver.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="dsp_races">
		<cfscript>
			Request.page_title = Request.page_title & "<br />Meet Events Registration";
			Request.js_validate = "javascript/races.js";
			Request.template = "dsp_races.cfm";
			Request.onLoad = Request.onLoad & "document.forms['inputForm'].elements[0].focus();";

			qRaces = Request.lookup_cfc.getRaces(Request.DSN,Request.eventTbl,Request.strokeTbl);
			qTeams = Request.lookup_cfc.getTeams(Request.DSN,Request.teamTbl);
			XFA.next ="home.act_races";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>
	
	<cfcase value="act_races">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = XFA.registration_menu;
			XFA.failure = "home.dsp_races";

			Request.suppressLayout = true;

			Request.validation_template = "val_races.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="dsp_excursions">
		<cfscript>
			Request.page_title = Request.page_title & "<br />Sunday Excursions";
			Request.template = "dsp_excursions.cfm";
			Request.onLoad = Request.onLoad & "document.forms['inputForm'].elements['excursion'][0].focus();";

			qExcursions = Request.lookup_cfc.getExcursions(Request.DSN,Request.excursionTbl);
			XFA.next ="home.act_excursions";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>
	
	<cfcase value="act_excursions">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = XFA.registration_menu;
			XFA.failure = "home.dsp_excursions";

			Request.suppressLayout = true;

			Request.validation_template = "val_excursions.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="dsp_housing">
		<cfscript>
			Request.page_title = Request.page_title & "<br />Hosted Housing Request";
			Request.template = "dsp_housing.cfm";
			Request.onLoad = Request.onLoad & "document.forms['inputForm'].elements['num_guests'].focus();";
			Request.js_validate = "javascript/housing.js";

			qStates = Request.lookup_cfc.getStates(Request.DSN,"stateTbl");
			qCountries = Request.lookup_cfc.getCountries(Request.DSN,"countryTbl");

			XFA.next ="home.act_housing";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>
	
	<cfcase value="act_housing">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = XFA.registration_menu;
			XFA.failure = "home.dsp_housing";

			Request.suppressLayout = true;

			Request.validation_template = "val_housing.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="dsp_payment">
		<cfscript>
			Request.page_title = Request.page_title & "<br />Submit Payment";
			Request.template = "dsp_payment.cfm";
			Request.onLoad = Request.onLoad & "document.forms['inputForm'].elements['paymentMethod'].focus();";

			registrationFee = Request.lookup_cfc.getRegistrationFee(Request.fees,ListFirst(Session.goldrush2009.registrationType,"_"),IIF(ListLen(session.goldrush2009.registrationType,"_") GT 1,true,false));
			XFA.next ="home.act_payment";

			submitOK = false;
			if (Session.goldrush2009.master AND ((Session.goldrush2009.registrationType EQ "social") OR (Session.goldrush2009.races)))
			{
				submitOK = true;
			}
		</cfscript>

		<cfif NOT variables.submitOK>
			<cflocation addtoken="No" url="#Request.self#/fuseaction/#XFA.registration_menu#.cfm">
		</cfif>
		<cfinclude template="#Request.template#">
	</cfcase>
	
	<cfcase value="act_payment">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "home.dsp_registration_confirmation";
			XFA.failure = "home.dsp_payment";
			XFA.paypal = "home.dsp_payment_paypal_redirect";

			Request.suppressLayout = true;

			registrationFee = Request.lookup_cfc.getRegistrationFee(Request.fees,ListFirst(Session.goldrush2009.registrationType,"_"),IIF(ListLen(session.goldrush2009.registrationType,"_") GT 1,true,false));
			Request.validation_template = "val_payment.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="dsp_registration_confirmation">
		<cfscript>
			Request.page_title = Request.page_title & "<br />Registration Submitted";
			Request.template = "dsp_registration_confirmation.cfm";

			XFA.printable = "home.dsp_registration_confirmation_printable";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>
	
	<cfcase value="dsp_registration_confirmation_printable">
		<cfscript>
			Request.page_title = Request.page_title & "<br />Registration Information";
			Request.template = "dsp_registration_confirmation_printable.cfm";

			variables.teamName = Request.lookup_cfc.getTeams(Request.dsn,Request.teamTbl,Session.goldrush2009.team_no).team_name;

			qRaces = Request.lookup_cfc.getRaces(Request.dsn,Request.eventTbl,Request.strokeTbl,Request.entryTbl,Session.goldrush2009.athlete_no);
			variables.excursion = "";
			if (Session.goldrush2009.excursion)
			{
				variables.excursion = Request.lookup_cfc.getExcursions(Request.dsn,Request.excursionTbl,Session.goldrush2009.excursion).name;
			}
			
			variables.nights = "";
			if (ListLen(Session.goldrush2009.nights))
			{
				if (ListFindNoCase(Session.goldrush2009.nights,"Th"))
				{
					variables.nights = ListAppend(variables.nights," Thursday");
				}
				if (ListFindNoCase(Session.goldrush2009.nights,"F"))
				{
					variables.nights = ListAppend(variables.nights," Friday");
				}
				if (ListFindNoCase(Session.goldrush2009.nights,"Sat"))
				{
					variables.nights = ListAppend(variables.nights," Saturday");
				}
				if (ListFindNoCase(Session.goldrush2009.nights,"Sun"))
				{
					variables.nights = ListAppend(variables.nights," Sunday");
				}
			}
			
			variables.sleeping = "";
			if (ListLen(Session.goldrush2009.sleeping))
			{
				if (ListFindNoCase(Session.goldrush2009.sleeping,"couch"))
				{
					variables.sleeping = ListAppend(variables.sleeping," Couch");
				}
				if (ListFindNoCase(Session.goldrush2009.sleeping,"own"))
				{
					variables.sleeping = ListAppend(variables.sleeping," Own bed");
				}
				if (ListFindNoCase(Session.goldrush2009.sleeping,"share"))
				{
					variables.sleeping = ListAppend(variables.sleeping," Share with " & Session.goldrush2009.sleeping_share);
				}
				if (ListFindNoCase(Session.goldrush2009.sleeping,"partner"))
				{
					variables.sleeping = ListAppend(variables.sleeping," With partner");
				}
			}
			
			variables.temperament = "";
			if (ListLen(Session.goldrush2009.temperament))
			{
				if (ListFindNoCase(Session.goldrush2009.temperament,"quiet"))
				{
					variables.temperament = ListAppend(variables.temperament," Quiet");
				}
				if (ListFindNoCase(Session.goldrush2009.temperament,"moderate"))
				{
					variables.temperament = ListAppend(variables.temperament," Party reasonably");
				}
				if (ListFindNoCase(Session.goldrush2009.temperament,"party"))
				{
					variables.temperament = ListAppend(variables.temperament," Party some");
				}
				if (ListFindNoCase(Session.goldrush2009.temperament,"monster"))
				{
					variables.temperament = ListAppend(variables.temperament," Party monster");
				}
			}

			Request.suppressLayout = true;
			Request.printableLayout = true;
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

<!--- ----------------------------------------
PAYPAL
----------------------------------------- --->
	<cfcase value="dsp_payment_paypal_redirect">
		<cfscript>
			Request.page_title = Request.page_title & "<br />Proceed to PayPal";
			Request.template = "dsp_payment_paypal_redirect.cfm";
			Request.refreshRate = 300;

			XFA.next ="home.act_payment_paypal_redirect";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>
	
	<cfcase value="act_payment_paypal_redirect">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			Request.suppressLayout = true;

			Request.template = "act_payment_paypal_redirect.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="act_payment_paypal_return">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			Request.suppressLayout = true;
			XFA.next = "home.act_payment";

			Request.template = "act_payment_paypal_return.cfm";
			Request.loginTemplate = "val_registrant_login.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

<!--- ----------------------------------------
RESULTS
----------------------------------------- --->
	<cfcase value="dsp_results">
		<cfscript>
			Request.page_title = " SQUID Long Course Challenge 2004<br />Meet Results";
			Request.template = "dsp_results.cfm";

			XFA.splits ="home.dsp_splits";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>
	
	<cfcase value="dsp_splits">
		<cfscript>
			Request.page_title = " SQUID Long Course Challenge 2004<br />Meet Results (Splits)";
			Request.template = "dsp_splits.cfm";

			XFA.results ="home.dsp_results";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>
	





















	<cfdefaultcase>
		<!---This will just display an error message and is useful in catching typos of fuseaction names while developing--->
		<cfoutput>This is the cfdefaultcase tag. I received a fuseaction called <strong>"#attributes.fuseaction#"</strong> and I don't know what to do with it.</cfoutput>
	</cfdefaultcase>

</cfswitch>
