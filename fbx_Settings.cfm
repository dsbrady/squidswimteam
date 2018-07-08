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

	<cfscript>
		XFA.home = "home.dsp_content";
		XFA.membership = "home.dsp_content";
		XFA.visiting = "home.dsp_content";
		XFA.calendar = "calendar.dsp_start";
		XFA.workouts = "home.dsp_content";
		XFA.news = "home.dsp_news";
		XFA.gallery = "home.dsp_gallery";
		XFA.links = "home.dsp_links";
		XFA.members = "members.start";
		XFA.iframe = "home.dsp_iframe";
		XFA.sitemap = "home.dsp_sitemap";
		XFA.contact = "home.dsp_feedback";
		XFA.logout = "login.act_logout";
		XFA.error = "home.dsp_error";
		XFA.membershipSignup = "membership.dsp_start";
		XFA.unsubscribe = "home.act_unsubscribe";
		XFA.minutes = "members.dsp_minutes";
		XFA.newMemberSignup = "membership.newMemberForm";
	</cfscript>
<cfelse>
	<!--- put settings here that you want to execute only when this is not an application's home circuit --->
</cfif>

<!--- In case no fuseaction was given, I'll set up one to use by default. --->
<cfparam name="attributes.fuseaction" default="home.dsp_content">

<!--- Useful constants --->
<cfparam name="Request.self" default="index.cfm" type="string">
<cfparam name="self" default="index.cfm" type="string">

<cfscript>
	Request.page_title = "SQUID";
	Request.suppressLayout = False;
	Request.onLoad = "preloader('images/menu_oval_on.gif');";
	Request.js_validate = "";
	Request.ss_template = "";
	Request.ssOther = ArrayNew(1);
	Request.jsOther = ArrayNew(1);

	request.pricePerSwimMembers = 7;
	request.pricePerSwimNonMembers = 7.50;
	request.purchasedSwimsPerFreeSwim = 10;

	if (application.environment == "development")
	{
	/* Development */
		request.siteRoot = "/dev/";
		Request.DSN = "squidSQL";
		Request.theServer = "https://" & CGI.server_name & "/dev";
		Request.js_default = Request.theServer & "/javascript/default.js";
		Request.ss_main = Request.theServer & "/styles/main.css";
		variables.baseHREF = Request.theServer & "/";
		Request.privacy_template = "lib/dsp_privacy.cfm";
		Request.images_folder = "/images";
		Request.member_picture_folder = "/members/photos";
		Request.member_picture_path = "d:\inetpub\squidswimteam\members\photos";
		Request.from_email = "dsbrady@protonmail.com";
		Request.admin_email = "dsbrady@protonmail.com";
		Request.webmaster_email = "dsbrady@protonmail.com";
		Request.customFunctions = "lib/customFunctions.cfm";
		Request.cfcPath = "cfc";
		Request.imageinfo_path = "/lib/imageinfo.cfm";
		Request.announcement_folder = "/members/attachments";
		Request.announcement_path = "c:\data\inetpub\wwwroot\squidswimteam\members\attachments";
		Request.issues_folder = "/members/attachments";
		Request.issues_path = "c:\data\inetpub\wwwroot\squidswimteam\members\attachments";
		Request.announceHtmlEditPath = Request.theServer & "/lib/announceHtmlEdit";
		Request.contentHtmlEditPath = Request.theServer & "/lib/contentHtmlEdit";
		Request.content_file_folder = "/files";
		Request.content_file_path = "c:\data\inetpub\wwwroot\squidswimteam\files";
		Request.showError = true;
		Request.isSecure = true;
		request.htmlEditor = "https://cdnjs.cloudflare.com/ajax/libs/froala-editor/2.7.5/js/froala_editor.min.js";
		request.htmlEditorConfig = request.theServer & "/lib/ckeditor_config.js";
<link href='https://cdnjs.cloudflare.com/ajax/libs/froala-editor/2.7.5/css/froala_editor.min.css' rel='stylesheet' type='text/css' />
<link href='https://cdnjs.cloudflare.com/ajax/libs/froala-editor/2.7.5/css/froala_style.min.css' rel='stylesheet' type='text/css' />

<!-- Include JS file. -->
<script type='text/javascript' src='https://cdnjs.cloudflare.com/ajax/libs/froala-editor/2.7.5/js/froala_editor.min.js'></script>
	}
	else
	{
		/* Production */
		request.siteRoot = "/";
		Request.DSN = "squidSQL";
		Request.theServer = "https://www.squidswimteam.org";
		Request.js_default = Request.theServer & "/javascript/default.js";
		Request.ss_main = Request.theServer & "/styles/main.css";
		variables.baseHREF = Request.theServer & "/";
		Request.privacy_template = "lib/dsp_privacy.cfm";
		Request.images_folder = "/images";
		Request.member_picture_folder = "/members/photos";
		Request.member_picture_path = "d:\inetpub\squidswimteam\members\photos";
		Request.from_email = "squid@squidswimteam.org";
		Request.admin_email = "squid@squidswimteam.org";
		Request.adminEmailPassword = "Squ1d*sw1m";
		Request.webmaster_email = "squid@squidswimteam.org";
		Request.customFunctions = "lib/customFunctions.cfm";
		Request.cfcPath = "squidswimteam.cfc";
		Request.imageinfo_path = "/lib/imageinfo.cfm";
		Request.announcement_folder = "/members/attachments";
		Request.announcement_path = "d:\inetpub\squidswimteam\members\attachments";
		Request.issues_folder = "/members/attachments";
		Request.issues_path = "d:\inetpub\squidswimteam\members\attachments";
		Request.announceHtmlEditPath = Request.theServer & "/lib/announceHtmlEdit";
		Request.contentHtmlEditPath = Request.theServer & "/lib/contentHtmlEdit";
		Request.content_file_folder = "/files";
		Request.content_file_path = "d:\inetpub\squidswimteam\files";
		Request.showError = false;
		Request.isSecure = true;
		request.htmlEditor = "https://cdn.ckeditor.com/4.8.0/standard/ckeditor.js";
		request.htmlEditorConfig = "/lib/ckeditor_config.js";
	}

/* ************************************
DATABASE SETTINGS
************************************ */

	Request.announcementTbl = "announcements";
	Request.announcement_statusTbl = "announcementStatuses";
	Request.calendarTbl = "calendar";
	Request.calendar_recurringTbl = "calendarRecurring";
	Request.frequencyTbl = "frequencies";
	Request.event_typeTbl = "eventTypes";
	Request.officerTbl = "officers";
	Request.officer_permissionTbl = "officerPermissions";
	Request.officer_typeTbl = "officerTypes";
	Request.objectsTbl = "objects";
	Request.stateTbl = "states";
	Request.submission_typeTbl = "submissionTypes";
	Request.usersTbl = "users";
	Request.user_statusTbl = "userStatuses";
	Request.developerTbl = "developers";
	Request.testerTbl = "testers";
	Request.issueTbl = "issues";
	Request.issue_statusTbl = "issueStatuses";
	Request.issue_severityTbl = "issueSeverities";
	Request.preferenceTbl = "preferences";
	Request.facilityTbl = "facilities";
	Request.practicesTbl = "practices";
	Request.practice_transactionTbl = "practiceTransactions";
	Request.practice_defaultTbl = "practiceDefaults";
	Request.transaction_typeTbl = "transactionTypes";
	Request.fileTbl = "files";
	Request.file_typeTbl = "fileTypes";
	Request.file_categoryTbl	 = "fileCategories";
	Request.pageTbl = "pages";
	Request.newsTbl = "news";
	Request.galleryTbl = "gallery";
	Request.feedbackTbl = "feedback";
	Request.linksTbl = "links";
	Request.link_categoryTbl = "linkCategories";
	Request.issue_commentTbl = "issueComments";
	Request.membershipTransactionTbl = "membershipTransactions";
	Request.distanceTbl = "distances";
	Request.strokeTbl = "strokes";
	Request.userEventTbl = "userEvents";
	Request.distanceUnitTbl = "distanceUnits";
	Request.distanceTypeTbl = "distanceTypes";
	Request.surveyTbl = "surveys";
	Request.surveyUserTbl = "surveyUsers";
	Request.surveyResponseTbl = "surveyResponses";
	Request.surveyQuestionTbl = "surveyQuestions";
	Request.questionTypeTbl = "questionTypes";
	Request.questionChoiceTbl = "questionChoices";

/* ************************************
OTHER SETTINGS
************************************ */
	Request.activityDays = 90;
	Request.renewalDays = 90;
	Request.profile_cfc = Request.cfcPath & ".profile";
	Request.image_cfc = Request.cfcPath & ".image";
	Request.login_cfc = Request.cfcPath & ".login";
	Request.lookup_cfc = Request.cfcPath & ".lookup_queries";
	Request.members_cfc = Request.cfcPath & ".members";
	Request.end_of_time = CreateDate(2399,12,31);
	Request.errorPage = "error/dsp_error.cfm";
	Request.errorPageHTML = "error/dsp_error.html";
	Request.paypal_cfc = Request.cfcPath & ".paypal";
	Request.meetRegistrationCFC = CreateObject("component","squidswimteam.goldrush2009.register.cfc.registration");
	Request.survey_cfc = Request.cfcPath & ".survey";
	Request.accounting_cfc = Request.cfcPath & ".accounting";
	Request.announce_cfc = Request.cfcPath & ".announcements";
	Request.calendar_cfc = CreateObject("component",Request.cfcPath & ".calendar");
	Request.surveyCFC = CreateObject("component",Request.survey_cfc);
	Request.lookupCFC = CreateObject("component",Request.lookup_cfc);
	Request.jsonCFC = CreateObject("component","cfc.json");
	Request.utilitiesCFC = CreateObject("component","cfc.utilities");
	Request.membersCFC = CreateObject("component",Request.members_cfc);
	request.objTrainingResources = createObject("component",request.cfcPath & ".trainingResources");

	Request.paypal_token = "8CbmVDy5Y02br8MHkMGbG_ljthhjIFnr591AuXNRMxl9dTZDo9ohFuzLIXS";

	Request.encryptionKey = "NPx3dVXXRtwYmlqR9m+arQ==";
	Request.encryptionAlgorithm = "AES";
	Request.encryptionEncoding = "HEX";

	Request.unsubscribeURL = "#Request.theServer#/#Request.self#?fuseaction=#XFA.unsubscribe#&uid=";

	Request.yahooLibrary = Request.theServer & "/lib/yui";
	Request.jsonParser = request.theServer & "/javascript/external/json/json.js";

	Request.ignoreBrowsers = arrayNew(1);
	arrayAppend(request.ignoreBrowsers,"Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)");
	arrayAppend(request.ignoreBrowsers,"Mozilla/5.0 (compatible; Exabot-Images/3.0; +http://www.exabot.com/go/robot)");
	arrayAppend(request.ignoreBrowsers,"Mozilla/5.0 (compatible; SiteBot/0.1; +http://www.sitebot.org/robot/)");

	Request.validPasswordRegularExpression = "^[A-Za-z\d ,]{8,255}$";
	Request.validPasswordDescription = "At least 8 characters and only numbers, letters, commas, spaces, and underscores.";
</cfscript>

<!--- If the site should be secure and the request is not, force it --->
<cfif request.isSecure AND cgi.https IS NOT "on">
	<cflocation addtoken="false" url="#Request.theServer#/?#cgi.query_string#" />
</cfif>

<!--- Get session variables, if they exist --->
<cfset request.squid = duplicate(session.squid) />

<cfif (request.squid.user_id EQ 1 OR application.environment EQ "development")>
	<cfset request.showError = true />
</cfif>

<cfif NOT structKeyExists(application,"qStates")>
	<cfset application.qStates = request.lookupCFC.getStates(dsn=request.dsn,stateTbl=request.stateTbl) />
</cfif>

<cfif NOT structKeyExists(application,"qCountries")>
	<cfset application.qCountries = request.lookupCFC.getCountries(dsn=request.dsn) />
</cfif>

<cfif NOT structKeyExists(application,"qCreditCardTypes")>
	<cfset application.qCreditCardTypes = request.lookupCFC.getCreditCardTypes(dsn=request.dsn) />
</cfif>

<cfif NOT structKeyExists(application,"stPaypalSettings")>
	<cfset application.stPayPalSettings = structNew() />

	<cfif application.environment IS "development">
		<!--- Certificate apparently isn't in CF's store, so commenting out and using prod (ugh)
		<cfset application.stPayPalSettings.apiUsername = "paypalSandbox_api1.squidswimteam.org" />
		<cfset application.stPayPalSettings.apiPassword = "X3V9Z3DDSNXW6CZF" />
		<cfset application.stPayPalSettings.apiSignature = "An5ns1Kso7MWUdW4ErQKJJJ4qi4-AyexxKECJo43UKDFxtXxP4mLKceT" />
		<cfset application.stPayPalSettings.apiVersion = "94.0" />
		<cfset application.stPayPalSettings.apiUrl = "https://api-3t.sandbox.paypal.com/nvp" />
		 --->
		<cfset application.stPayPalSettings.apiUsername = "squid_api1.squidswimteam.org" />
		<cfset application.stPayPalSettings.apiPassword = "D5UENRLRZSLPRBKC" />
		<cfset application.stPayPalSettings.apiSignature = "ArCg8AlipMRoK3B6iQptTvxThjrjA7ygfQn8bPNQ5j7IWC-9jdEDLANx" />
		<cfset application.stPayPalSettings.apiVersion = "94.0" />
		<cfset application.stPayPalSettings.apiUrl = "https://api-3t.paypal.com/nvp" />
		<cfset application.stPayPalSettings.verificationURL = "https://www.paypal.com/cgi-bin/webscr" />
	<cfelse>
		<cfset application.stPayPalSettings.apiUsername = "squid_api1.squidswimteam.org" />
		<cfset application.stPayPalSettings.apiPassword = "D5UENRLRZSLPRBKC" />
		<cfset application.stPayPalSettings.apiSignature = "ArCg8AlipMRoK3B6iQptTvxThjrjA7ygfQn8bPNQ5j7IWC-9jdEDLANx" />
		<cfset application.stPayPalSettings.apiVersion = "94.0" />
		<cfset application.stPayPalSettings.apiUrl = "https://api-3t.paypal.com/nvp" />
		<cfset application.stPayPalSettings.verificationURL = "https://www.paypal.com/cgi-bin/webscr" />
	</cfif>
</cfif>

<!--- Insert Privacy Policy Header --->
<cfheader name="P3P" value="policyref=""#Request.theServer#/w3c/p3p.xml""">

<!--- Include custom functions --->
<cfinclude template="#Request.customFunctions#">

<!--- Global error handling --->
	<cferror type="EXCEPTION"
			 template="#Request.errorPage#"
			 exception="any">

	<cferror type="REQUEST"
			 template="#Request.errorPageHTML#"
			 exception="any">

<!--- Should fusebox silently supress its own error messags?
Default is FALSE --->
<cfset fusebox.supressErrors = false>
