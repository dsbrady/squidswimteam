<cfsilent>
<cfparam name="error" default="#StructNew()#">
<cfparam name="error.diagnostics" default="nothing">
<cfparam name="error.mailTo" default="">
<cfparam name="error.dateTime" default="nothing">
<cfparam name="error.browser" default="nothing">
<cfparam name="error.generatedContent" default="nothing">
<cfparam name="error.remoteAddress" default="nothing">
<cfparam name="error.HTTPReferer" default="nothing">
<cfparam name="error.template" default="nothing">
<cfparam name="error.queryString" default="nothing">

<!--- Come up with Error Number --->
<cfscript>
	variables.errorNum = "SQUID" & NumberFormat(RandRange(1,99999),"00000") & DateFormat(Now(),"yyyymmdd") & TimeFormat(Now(),"HHmmss");
</cfscript>
<!--- Send e-mail --->
<cfif NOT request.showError AND NOT listFindNoCase(arrayToList(request.ignoreBrowsers),error.browser)>
	<cfmail server="mail.squidswimteam.org" from="#Request.webmaster_email#" to="#Request.webmaster_email#" subject="SQUID Web Site Error - #variables.errorNum#" type="HTML">
	<p>
	A user has encountered an error on the SQUID web site.  The error information is below:
	</p>

	<p>
	Error Number:	<strong>#variables.errorNum#</strong>
	</p>
	<p>
	Error Detail:	<strong>#error.diagnostics#</strong>
	</p>

	<p>
	Session:
	</p>
	<cfdump var="#session#">
	<p>
	Attributes:
	</p>
	<cfdump var="#attributes#">
	<p>
	Error:
	</p>
	<cfdump var="#error#">
	</cfmail>
</cfif>
</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<base href="http://www.squidswimteam.org/">
		<link rel="P3Pv1" href="http://www.squidswimteam.org/w3c/p3p.xml" />
		<TITLE>SQUID - Error</TITLE>
		<script src="javascript/default.js" type="text/javascript"></script>
		<link media="screen" rel="stylesheet" href="styles/main.css">
	</head>
<cfoutput>
<body onload="preloader('images/menu_oval_on.gif');">
<div id="diver" style="position:absolute;left:0px;top:0px;height:171px;width:197px;z-index:1"><img src="images/diver.jpg" height="171" width="197" vspace="0" hspace="0" border="0" alt="Diver" /></div>
<div id="logo" style="position:absolute;left:197px;top:0px;height:107px;width:603px;z-index:1"><img src="images/logo.jpg" height="107" width="603" vspace="0" hspace="0" border="0" alt="SQUID Swim Team" /></div>
<div id="logoTile" style="position:absolute;left:800px;top:0px;height:107px;width:100%px;z-index:1;background:url('images/logo_tile.jpg');"></div>
<div id="ripple" style="position:absolute;left:197px;top:107px;height:64px;width:65px;z-index:1"><img src="images/ripple.jpg" height="64" width="65" vspace="0" hspace="0" border="0" alt="Splash" /></div>
<div id="menuHomeL" style="position:absolute;left:0px;top:171px;height:40px;width:197px;z-index:1"><a href="#Request.self#?fuesaction=#XFA.home#&page=Home"><img id="menuHome" src="images/menu_home.gif" height="40" width="103" vspace="0" hspace="0" border="0" alt="HOME" onmouseover="return imgSwap(document.getElementById('menuHomeOval'),'images/menu_oval_on.gif');" onmouseout="return imgSwap(document.getElementById('menuHomeOval'),'images/menu_oval.gif');" /><img id="menuHomeOval" src="images/menu_oval.gif" height="40" width="28" vspace="0" hspace="0" border="0" alt="HOME" onmouseover="return imgSwap(this,'images/menu_oval_on.gif');" onmouseout="return imgSwap(this,'images/menu_oval.gif');" /></a><img id="menuHomeLine" src="images/menu_line.gif" height="40" width="66" vspace="0" hspace="0" border="0" alt="" /></div>
<div id="menuMembershipL" style="position:absolute;left:0px;top:211px;height:40px;width:197px;z-index:1"><a href="#Request.self#?fuesaction=#XFA.membership#&page=Membership"><img id="menuMembership" src="images/menu_membership.gif" height="40" width="103" vspace="0" hspace="0" border="0" alt="MEMBERSHIP" onmouseover="return imgSwap(document.getElementById('menuMembershipOval'),'images/menu_oval_on.gif');" onmouseout="return imgSwap(document.getElementById('menuMembershipOval'),'images/menu_oval.gif');" /><img id="menuMembershipOval" src="images/menu_oval.gif" height="40" width="28" vspace="0" hspace="0" border="0" alt="MEMBERSHIP" onmouseover="return imgSwap(this,'images/menu_oval_on.gif');" onmouseout="return imgSwap(this,'images/menu_oval.gif');" /></a><img id="menuMembershipLine" src="images/menu_line.gif" height="40" width="66" vspace="0" hspace="0" border="0" alt="" /></div>
<div id="menuVisitingL" style="position:absolute;left:0px;top:251px;height:40px;width:197px;z-index:1"><a href="#Request.self#?fuesaction=#XFA.visiting#&page=Visiting"><img id="menuVisiting" src="images/menu_visiting.gif" height="40" width="103" vspace="0" hspace="0" border="0" alt="VISITING" onmouseover="return imgSwap(document.getElementById('menuVisitingOval'),'images/menu_oval_on.gif');" onmouseout="return imgSwap(document.getElementById('menuVisitingOval'),'images/menu_oval.gif');" /><img id="menuVisitingOval" src="images/menu_oval.gif" height="40" width="28" vspace="0" hspace="0" border="0" alt="VISITING" onmouseover="return imgSwap(this,'images/menu_oval_on.gif');" onmouseout="return imgSwap(this,'images/menu_oval.gif');" /></a><img id="menuVisitingLine" src="images/menu_line.gif" height="40" width="66" vspace="0" hspace="0" border="0" alt="" /></div>
<div id="menuWorkoutsL" style="position:absolute;left:0px;top:291px;height:40px;width:197px;z-index:1"><a href="#Request.self#?fuesaction=#XFA.workouts#&page=Workouts"><img id="menuWorkouts" src="images/menu_workouts.gif" height="40" width="103" vspace="0" hspace="0" border="0" alt="WORKOUTS" onmouseover="return imgSwap(document.getElementById('menuWorkoutsOval'),'images/menu_oval_on.gif');" onmouseout="return imgSwap(document.getElementById('menuWorkoutsOval'),'images/menu_oval.gif');" /><img id="menuWorkoutsOval" src="images/menu_oval.gif" height="40" width="28" vspace="0" hspace="0" border="0" alt="WORKOUTS" onmouseover="return imgSwap(this,'images/menu_oval_on.gif');" onmouseout="return imgSwap(this,'images/menu_oval.gif');" /></a><img id="menuWorkoutsLine" src="images/menu_line.gif" height="40" width="66" vspace="0" hspace="0" border="0" alt="" /></div>
<div id="menuNewsL" style="position:absolute;left:0px;top:331px;height:40px;width:197px;z-index:1"><a href="#Request.self#?fuesaction=#XFA.news#"><img id="menuNews" src="images/menu_news.gif" height="40" width="103" vspace="0" hspace="0" border="0" alt="NEWS/EVENTS" onmouseover="return imgSwap(document.getElementById('menuNewsOval'),'images/menu_oval_on.gif');" onmouseout="return imgSwap(document.getElementById('menuNewsOval'),'images/menu_oval.gif');" /><img id="menuNewsOval" src="images/menu_oval.gif" height="40" width="28" vspace="0" hspace="0" border="0" alt="NEWS/EVENTS" onmouseover="return imgSwap(this,'images/menu_oval_on.gif');" onmouseout="return imgSwap(this,'images/menu_oval.gif');" /></a><img id="menuNewsLine" src="images/menu_line.gif" height="40" width="66" vspace="0" hspace="0" border="0" alt="" /></div>
<div id="menuGalleryL" style="position:absolute;left:0px;top:371px;height:40px;width:197px;z-index:1"><a href="#Request.self#?fuesaction=#XFA.gallery#"><img id="menuGallery" src="images/menu_gallery.gif" height="40" width="103" vspace="0" hspace="0" border="0" alt="GALLERY" onmouseover="return imgSwap(document.getElementById('menuGalleryOval'),'images/menu_oval_on.gif');" onmouseout="return imgSwap(document.getElementById('menuGalleryOval'),'images/menu_oval.gif');" /><img id="menuGalleryOval" src="images/menu_oval.gif" height="40" width="28" vspace="0" hspace="0" border="0" alt="GALLERY" onmouseover="return imgSwap(this,'images/menu_oval_on.gif');" onmouseout="return imgSwap(this,'images/menu_oval.gif');" /></a><img id="menuGalleryLine" src="images/menu_line.gif" height="40" width="66" vspace="0" hspace="0" border="0" alt="" /></div>
<div id="menuLinksL" style="position:absolute;left:0px;top:411px;height:40px;width:197px;z-index:1"><a href="#Request.self#?fuesaction=#XFA.links#&page=Links"><img id="menuLinks" src="images/menu_links.gif" height="40" width="103" vspace="0" hspace="0" border="0" alt="LINKS" onmouseover="return imgSwap(document.getElementById('menuLinksOval'),'images/menu_oval_on.gif');" onmouseout="return imgSwap(document.getElementById('menuLinksOval'),'images/menu_oval.gif');" /><img id="menuLinksOval" src="images/menu_oval.gif" height="40" width="28" vspace="0" hspace="0" border="0" alt="LINKS" onmouseover="return imgSwap(this,'images/menu_oval_on.gif');" onmouseout="return imgSwap(this,'images/menu_oval.gif');" /></a><img id="menuLinksLine" src="images/menu_line.gif" height="40" width="66" vspace="0" hspace="0" border="0" alt="" /></div>
<div id="menuMembersL" style="position:absolute;left:0px;top:451px;height:40px;width:197px;z-index:1"><a href="#Request.self#?fuesaction=#XFA.members#"><img id="menuMembers" src="images/menu_members.gif" height="40" width="103" vspace="0" hspace="0" border="0" alt="MEMBER AREA" onmouseover="return imgSwap(document.getElementById('menuMembersOval'),'images/menu_oval_on.gif');" onmouseout="return imgSwap(document.getElementById('menuMembersOval'),'images/menu_oval.gif');" /><img id="menuMembersOval" src="images/menu_oval.gif" height="40" width="28" vspace="0" hspace="0" border="0" alt="MEMBER AREA" onmouseover="return imgSwap(this,'images/menu_oval_on.gif');" onmouseout="return imgSwap(this,'images/menu_oval.gif');" /></a><img id="menuMembersLine" src="images/menu_line.gif" height="40" width="66" vspace="0" hspace="0" border="0" alt="" /></div>
<div id="menuLoginL" style="position:absolute;left:0px;top:491px;height:40px;width:197px;z-index:1"><a href="#Request.self#?fuesaction=#XFA.members#"><img id="menuLogin" src="images/menu_login.gif" height="40" width="103" vspace="0" hspace="0" border="0" alt="LOGIN" onmouseover="return imgSwap(document.getElementById('menuLoginOval'),'images/menu_oval_on.gif');" onmouseout="return imgSwap(document.getElementById('menuLoginOval'),'images/menu_oval.gif');" /><img id="menuLoginOval" src="images/menu_oval.gif" height="40" width="28" vspace="0" hspace="0" border="0" alt="LOGIN" onmouseover="return imgSwap(this,'images/menu_oval_on.gif');" onmouseout="return imgSwap(this,'images/menu_oval.gif');" /></a><img id="menuLoginLine" src="images/menu_line.gif" height="40" width="66" vspace="0" hspace="0" border="0" alt="" /></div>
<div id="menuBottomL" style="position:absolute;left:0px;top:631px;height:69px;width:197px;z-index:1;background:url('images/menu_bottom.gif');"></div>
<div id="laneLines" style="position:absolute;left:255px;top:155px;height:56px;width:597px;z-index:1;background:url('images/laneline.gif');"></div>
<div id="laneLinesTile" style="position:absolute;left:255px;top:211px;height:425px;width:597px;z-index:1;background:url('images/laneline_tile.gif');"></div>
<div id="laneLineBottom" style="position:absolute;left:255px;top:636px;height:56px;width:597px;z-index:1;background:url('images/laneline_bottom.gif');"></div>
<div id="mainContent" style="position:absolute;left:200px;top:120px;height:400px;width:597px;z-index:2;">
	<!--- ---------------------- --->
	<!--- Main content goes here --->
<table width="500" border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td align="center" colspan="2">
				<h2>
					SQUID - Error
				</h2>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td width="100">&nbsp;</td>
			<td width="350">
			<p>
				Oops! There was a problem with our site.
				The site administrator has been notified.
				If you would like to inquire about this error, please reference this error number:
				<strong>#variables.errorNum#</strong>
			</p>
			<p>
				Please use the navigation links to continue browsing. If you continue to have difficulties,
				please <a href="index.cfm?fuesaction=home.dsp_feedback">Contact Us</a>
			</p>
			</td>
		</tr>
	</tbody>
</table>
<cfif request.showError>
	<cfdump var="#error#">
</cfif>
	<!--- End Main content goes here --->
	<!--- -------------------------- --->
	<p class="footer">
		&copy;2003 <cfif Year(Now()) GT 2003> - #Year(Now())#</cfif> SQUID Swim Team
		| <a href="index.cfm?fuesaction=home.dsp_feedback">Contact Us</a>
		| <a href="index.cfm?fuesaction=home.dsp_sitemap">Site Map</a>
	</p>
</div>
</body>
</cfoutput>
</html>
