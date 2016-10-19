<!--- Blank --->
	<cfparam name="Request.self" default="index.cfm" type="string">
	<cfscript>
		XFA.home = "home.dsp_content";
		XFA.membership = "home.dsp_content";
		XFA.visiting = "home.dsp_content";
		XFA.calendar = "home.calendar";
		XFA.workouts = "home.dsp_content";
		XFA.news = "home.dsp_news";
		XFA.gallery = "home.dsp_gallery";
		XFA.links = "home.dsp_content";
		XFA.members = "members.start";
		XFA.iframe = "home.dsp_iframe";
		XFA.sitemap = "home.dsp_sitemap";
		XFA.contact = "home.dsp_feedback";
		XFA.logout = "login.act_logout";
		XFA.error = "home.dsp_error";
		Request.webmaster_email = "squid@squidswimteam.org";
	</cfscript>
