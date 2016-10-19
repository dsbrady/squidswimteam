<!---
<fusedoc fuse="FBX_Settings.cfm">
	<responsibilities>
		I set up the enviroment settings for this circuit. If this settings file is being inherited, then you can use CFSET to override a value set in a parent circuit or CFPARAM to accept a value set by a parent circuit
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="15 December 2002" role="Architect" />
	</properties>
	<io>
		<in>
			<structure name="fusebox">
				<boolean name="isHomeCircuit" comments="Is the circuit currently executing the home circuit" />
			</structure>
		</in>
		<out>
			<string name="self" scope="variables" />
			<string name="self" scope="request" />
			<string name="fusebox.layoutDir" />
			<string name="fusebox.layoutFile" />
			<boolean name="fusebox.suppressErrors" />
		</out>
	</io>
</fusedoc>
 --->

<!---
Uncomment this if you wish to have code specific that only executes if the circuit running is the home circuit.
--->
<cfif fusebox.IsHomeCircuit>
	<!--- put settings here that you want to execute only when this is the application's home circuit (for example "<cfapplication>" )--->
	<cfapplication name="squid" applicationtimeout="#CreateTimeSpan(0,0,20,0)#" clientmanagement="No" sessionmanagement="Yes" sessiontimeout="#CreateTimeSpan(0,0,20,0)#">

	<cfscript>
		XFA.start = "home.dsp_start";
		XFA.registration_menu = "home.dsp_registration_menu";
		XFA.contact = "home.dsp_contact";
		XFA.end_session = "home.act_end_session";
	</cfscript>
<cfelse>
	<!--- put settings here that you want to execute only when this is not an application's home circuit --->
</cfif>

<!--- In case no fuseaction was given, I'll set up one to use by default. --->
<cfparam name="attributes.fuseaction" default="home.dsp_start">

<!--- Useful constants --->
<cfparam name="Request.self" default="index.cfm" type="string">
<cfparam name="self" default="index.cfm" type="string">

<cfscript>
	Request.page_title = "2009 Rocky Mountain Autumn Gold Rush Short Course IGLA Swim Meet";
	Request.suppressLayout = False;
	Request.printableLayout = false;
	Request.onLoad = "";
	Request.js_validate = "";
	Request.ss_template = "";

/* Development
*/
	Request.DSN = "goldrush2009";
	Request.theServer = "http://" & CGI.server_name & "";
	Request.js_default = Request.theServer & "/goldrush2009/javascript/main.js";
	Request.ss_main = Request.theServer & "/goldrush2009/style.css";
	Request.ss_printable = Request.theServer & "/goldrush2009/styles/printable.css";
	variables.baseHREF = Request.theServer & "/goldrush2009/register/";
	Request.privacy_template = "lib/dsp_privacy.cfm";
	Request.images_folder = "/goldrush2009/images";
	Request.images_folder2 = "/goldrush2009/register/images";
	Request.from_email = "squid@squidswimteam.org";
	Request.submit_email = "dsbrady@protonmail.com";
	Request.admin_email = "squid@squidswimteam.org";
	Request.webmaster_email = "squid@squidswimteam.org";
	Request.paypal_email = "squid@squidswimteam.org";
	Request.customFunctions = "lib/customFunctions.cfm";
	Request.cfcPath = "squidswimteam.goldrush2009.register.cfc";
	Request.showError = true;
	Request.mailServer = "mail.squidswimteam.org";


/* Production
	Request.DSN = "goldrush2009";
	Request.theServer = "http://" & CGI.server_name & "";
	Request.js_default = Request.theServer & "/goldrush2009/javascript/main.js";
	Request.ss_main = Request.theServer & "/goldrush2009/style.css";
	Request.ss_printable = Request.theServer & "/goldrush2009/styles/printable.css";
	variables.baseHREF = Request.theServer & "/goldrush2009/register/";
	Request.privacy_template = "lib/dsp_privacy.cfm";
	Request.images_folder = "/goldrush2009/images";
	Request.images_folder2 = "/goldrush2009/register/images";
	Request.from_email = "squid@squidswimteam.org";
	Request.submit_email = "squid@squidswimteam.org,captain@squidswimteam.org,treasurer@squidswimteam.org,haydenpryor@msn.com,swimmin4fun@msn.com";
	Request.admin_email = "squid@squidswimteam.org";
	Request.webmaster_email = "squid@squidswimteam.org";
	Request.paypal_email = "squid@squidswimteam.org";
	Request.customFunctions = "lib/customFunctions.cfm";
	Request.cfcPath = "squidswimteam.goldrush2009.register.cfc";
	Request.showError = true;
	Request.mailServer = "mail.squidswimteam.org";
*/



/* ************************************
DATABASE SETTINGS
************************************ */

	Request.agegroupTbl = "agegroup";
	Request.AltScoringTbl = "AltScoring";
	Request.AthleteTbl = "Athlete";
	Request.DivisionsTbl = "Divisions";
	Request.DualteamsTbl = "Dualteams";
	Request.EntryTbl = "Entry";
	Request.EventTbl = "Event";
	Request.infoRequestsTbl = "infoRequests";
	Request.MeetTbl = "Meet";
	Request.MultiageTbl = "Multiage";
	Request.RecordsTbl = "Records";
	Request.RecordsbyEventTbl = "RecordsbyEvent";
	Request.RecordTagsTbl = "RecordTags";
	Request.RegionsTbl = "Regions";
	Request.RelayTbl = "Relay";
	Request.RelayNamesTbl = "RelayNames";
	Request.ScoringTbl = "Scoring";
	Request.ScoringImprovementTbl = "ScoringImprovement";
	Request.SessionTbl = "Session";
	Request.SessitemTbl = "Sessitem";
	Request.SplitTbl = "Split";
	Request.StdLanesTbl = "StdLanes";
	Request.TagNamesTbl = "TagNames";
	Request.TeamTbl = "Team";
	Request.TimeStdTbl = "TimeStd";
	Request.stateTbl = "stateTbl";
	Request.countryTbl = "countryTbl";
	Request.registrationTbl = "registrationTbl";
	Request.strokeTbl = "strokeTbl";
	Request.excursionTbl = "excursionTbl";
	Request.registrant_housingTbl = "registrant_housingTbl";

/* ************************************
PAYPAL SETTINGS
************************************ */
	Request.paypal_verifyURL = Request.theServer & "/lib/paypal_verify.cfm";
	Request.paypal_returnURL = Request.theServer & "/goldrush2009/register/index.cfm/fuseaction/home.act_payment_paypal_return.cfm";
	Request.paypal_item = "2009+Gold+Rush+Registration";
	Request.paypal_itemNo = "goldrush2009";
	Request.paypal_token = "8CbmVDy5Y02br8MHkMGbG_ljthhjIFnr591AuXNRMxl9dTZDo9ohFuzLIXS";

/* ************************************
OTHER SETTINGS
************************************ */
	Request.registration_cfc = CreateObject("component",Request.cfcPath & ".registration");
	Request.lookup_cfc = CreateObject("component",Request.cfcPath & ".lookup_queries");
	Request.errorPage = "error/dsp_error.cfm";
	Request.errorPageHTML = "error/dsp_error.html";
	Request.fees = StructNew();
	Request.fees.earlyDeadline = CreateDate(2009,9,18);
	Request.fees.lateDeadline = CreateDate(2009,10,1);
	Request.fees.earlyIGLAFee = 50;
	Request.fees.lateIGLAFee = 60;
	Request.fees.earlyCOMSAFee = 25;
	Request.fees.lateCOMSAFee = 30;
	Request.fees.earlyMeetAndPicnicFee = 32;
	Request.fees.lateMeetAndPicnicFee = 37;
	Request.fees.earlySOCIALFee = 25;
	Request.fees.lateSOCIALFee = 30;
	Request.fees.earlyPicnicFee = 7;
	Request.fees.latePicnicFee = 12;
	Request.housingResponseDeadline = CreateDate(2009,10,3);
	Request.paymentDaysDue = 7;
	Request.sanctioning = "32-04-09-S";
	Request.waiverText = "I, the undersigned participant, intending to be legally bound, hereby certify that I am physically fit and have not been otherwise informed by a physician. I acknowledge that I am aware of all the risks inherent in Masters Swimming (training and competition), including possible permanent disability or death, and agree to assume all of those risks.   AS A CONDITION OF MY PARTICIPATION IN THE MASTERS SWIMMING PROGRAM OR ANY ACTIVITIES INCIDENT THERETO, I HEREBY WAIVE ANY AND ALL RIGHTS TO CLAIMS FOR LOSS OR DAMAGES, INCLUDING ALL CLAIMS FOR LOSS OR DAMAGES CAUSED BY THE NEGLIGENCE, ACTIVE OR PASSIVE, OF THE FOLLOWING: UNITED STATES MASTERS SWIMMING, INC., COLORADO MASTERS SWIMMING ASSOCIATION, COLORADO SQUID SWIM TEAM, NORTH JEFFERSON RECREATION DISTRICT, THE CLUBS, HOST FACILITIES, MEET SPONSORS, MEET COMMITTEES, OR ANY INDIVIDUALS OFFICIATING AT THE MEETS OR SUPERVISING SUCH ACTIVITIES.  In addition, I agree to abide by and be governed by the rules of USMS.";
	Request.waiverURL = Request.theServer & "/goldrush2009/pdf/waiver.pdf";
</cfscript>

<!--- Initialize session variables, if they don't exist --->
<cflock scope="SESSION" timeout="30" type="EXCLUSIVE">
	<cfscript>
		if (NOT StructKeyExists(Session,"goldrush2009"))
		{
			Request.registration_cfc.initializeSession();
		}
	</cfscript>
</cflock>

<!--- Insert Privacy Policy Header --->
<cfheader name="P3P" value="policyref=""#Request.theServer#/w3c/p3p.xml""">

<!--- Include custom functions --->
<cfinclude template="#Request.customFunctions#">

<!--- Global error handling --->
<cfif NOT Request.showError>
	<cferror type="EXCEPTION"
			 template="#Request.errorPage#"
			 exception="any">

	<cferror type="REQUEST"
			 template="#Request.errorPageHTML#"
			 exception="any">
</cfif>

<!--- Should fusebox silently supress its own error messags?
Default is FALSE --->
<cfset fusebox.supressErrors = false>
