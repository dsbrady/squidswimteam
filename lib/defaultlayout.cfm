<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!---
<fusedoc fuse="defaultLayout" language="ColdFusion" specification="3.0">
	<responsibilities>
		I display the default layout.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="15 December 2002" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
		</in>
	</io>
</fusedoc>
--->
<!--
Site created by: Scott Brady
http://www.scottbrady.net

All graphics and content are the property of Colorado Whitewater Aquatics, DBA SQUID Swim Team and
may not be used without express written permission from Colorado Whitewater Aquatics.
-->
<cfparam name="attributes.page" default="Home" type="string">
<html>
<head>
	<link rel="P3Pv1" href="<cfoutput>#Request.theServer#</cfoutput>/w3c/p3p.xml" />
<!--- SES stuff --->
<CFIF IsDefined("variables.baseHref")>
    <cfoutput><base href="#variables.baseHref#" /></cfoutput>
</CFIF>
	<title><cfoutput>#Request.page_title#</cfoutput></title>
<cfif Request.js_validate IS NOT "">
	<script src="<cfoutput>#Request.js_validate#</cfoutput>" type="text/javascript"></script>
</cfif>
	<script src="<cfoutput>#Request.js_default#</cfoutput>" type="text/javascript"></script>
<cfif ArrayLen(Request.jsOther)>
	<cfloop from="1" to="#arrayLen(request.jsOther)#" index="jsCount">
		<script src="<cfoutput>#Request.jsOther[jsCount]#</cfoutput>" type="text/javascript"></script>
	</cfloop>
</cfif>
	<link media="screen" rel="stylesheet" href="<cfoutput>#Request.ss_main#</cfoutput>" />
<cfif Request.ss_template IS NOT "">
	<link media="screen" rel="stylesheet" href="<cfoutput>#Request.ss_template#</cfoutput>" />
</cfif>
<cfif ArrayLen(Request.ssOther)>
	<cfloop from="1" to="#arrayLen(request.ssOther)#" index="ssCount">
		<link media="screen" rel="stylesheet" href="<cfoutput>#Request.ssOther[ssCount]#</cfoutput>" />
	</cfloop>
</cfif>

	<script type="text/javascript">
	<cfoutput>
		validPasswordRE = '#jsStringFormat(request.validPasswordRegularExpression)#';
	</cfoutput>
	</script>

	</head>
<cfoutput>
<body onload="#Request.onLoad#">
<div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = 'https://connect.facebook.net/en_US/sdk.js##xfbml=1&version=v5.0&appId=197893030785353';
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>
<div id="diver" style="position:absolute;left:0px;top:0px;height:171px;width:197px;z-index:1"><img src="images/diver.jpg" height="171" width="197" vspace="0" hspace="0" border="0" alt="Diver" /></div>
<div id="logo" style="position:absolute;left:197px;top:0px;height:107px;width:603px;z-index:1"><img src="images/logo.jpg" height="107" width="603" vspace="0" hspace="0" border="0" alt="SQUID Swim Team" /></div>
<div id="logoTile" style="position:absolute;left:800px;top:0px;height:107px;width:100%px;z-index:1;background:url('images/logo_tile.jpg');"></div>
<div id="ripple" style="position:absolute;left:197px;top:107px;height:64px;width:65px;z-index:1"><img src="images/ripple.jpg" height="64" width="65" vspace="0" hspace="0" border="0" alt="Splash" /></div>
<div id="menuHomeL" style="position:absolute;left:0px;top:171px;height:40px;width:197px;z-index:1"><a href="#Request.self#?fuseaction=#XFA.home#&page=Home"><img id="menuHome" src="images/menu_home.gif" height="40" width="103" vspace="0" hspace="0" border="0" alt="HOME" <cfif (CompareNoCase(attributes.fuseaction,XFA.home) NEQ 0) OR (CompareNoCase(attributes.page,"Home") NEQ 0)>onmouseover="return imgSwap(document.getElementById('menuHomeOval'),'images/menu_oval_on.gif');" onmouseout="return imgSwap(document.getElementById('menuHomeOval'),'images/menu_oval.gif');" </cfif>/><img id="menuHomeOval" src="images/menu_oval<cfif (CompareNoCase(attributes.fuseaction,XFA.home) EQ 0) AND (CompareNoCase(attributes.page,"Home") EQ 0)>_on</cfif>.gif" height="40" width="28" vspace="0" hspace="0" border="0" alt="HOME" <cfif (CompareNoCase(attributes.fuseaction,XFA.home) NEQ 0) OR (CompareNoCase(attributes.page,"Home") NEQ 0)>onmouseover="return imgSwap(this,'images/menu_oval_on.gif');" onmouseout="return imgSwap(this,'images/menu_oval.gif');" </cfif>/></a><img id="menuHomeLine" src="images/menu_line.gif" height="40" width="66" vspace="0" hspace="0" border="0" alt="" /></div>
<div id="menuCalendarL" style="position:absolute;left:0px;top:211px;height:40px;width:197px;z-index:1"><a href="https://www.facebook.com/groups/squidswimteam/events/" target="squidCalendar"><img id="menuCalendar" src="images/menu_calendar.gif" height="40" width="103" vspace="0" hspace="0" border="0" alt="CALENDAR" <cfif CompareNoCase(ListFirst(attributes.fuseaction,"."),"calendar") NEQ 0>onmouseover="return imgSwap(document.getElementById('menuCalendarOval'),'images/menu_oval_on.gif');" onmouseout="return imgSwap(document.getElementById('menuCalendarOval'),'images/menu_oval.gif');" </cfif> /><img id="menuCalendarOval" src="images/menu_oval<cfif CompareNoCase(ListFirst(attributes.fuseaction,"."),"calendar") EQ 0>_on</cfif>.gif" height="40" width="28" vspace="0" hspace="0" border="0" alt="CALENDAR" <cfif CompareNoCase(ListFirst(attributes.fuseaction,"."),"calendar") NEQ 0>onmouseover="return imgSwap(this,'images/menu_oval_on.gif');" onmouseout="return imgSwap(this,'images/menu_oval.gif');" </cfif>/></a><img id="menuCalendarLine" src="images/menu_line.gif" height="40" width="66" vspace="0" hspace="0" border="0" alt="" /></div>
<div id="menuMembershipL" style="position:absolute;left:0px;top:251px;height:40px;width:197px;z-index:1"><a href="#Request.self#?fuseaction=#XFA.membership#&page=Membership"><img id="menuMembership" src="images/menu_membership.gif" height="40" width="103" vspace="0" hspace="0" border="0" alt="MEMBERSHIP" <cfif (CompareNoCase(attributes.fuseaction,XFA.home) NEQ 0) OR (CompareNoCase(attributes.page,"Membership") NEQ 0)>onmouseover="return imgSwap(document.getElementById('menuMembershipOval'),'images/menu_oval_on.gif');" onmouseout="return imgSwap(document.getElementById('menuMembershipOval'),'images/menu_oval.gif');" </cfif>/><img id="menuMembershipOval" src="images/menu_oval<cfif (CompareNoCase(attributes.fuseaction,XFA.home) EQ 0) AND (CompareNoCase(attributes.page,"Membership") EQ 0)>_on</cfif>.gif" height="40" width="28" vspace="0" hspace="0" border="0" alt="MEMBERSHIP" <cfif (CompareNoCase(attributes.fuseaction,XFA.home) NEQ 0) OR (CompareNoCase(attributes.page,"Membership") NEQ 0)>onmouseover="return imgSwap(this,'images/menu_oval_on.gif');" onmouseout="return imgSwap(this,'images/menu_oval.gif');" </cfif>/></a><img id="menuMembershipLine" src="images/menu_line.gif" height="40" width="66" vspace="0" hspace="0" border="0" alt="" /></div>
<div id="menuVisitingL" style="position:absolute;left:0px;top:291px;height:40px;width:197px;z-index:1"><a href="#Request.self#?fuseaction=#XFA.visiting#&page=Visiting"><img id="menuVisiting" src="images/menu_visiting.gif" height="40" width="103" vspace="0" hspace="0" border="0" alt="VISITING" <cfif (CompareNoCase(attributes.fuseaction,XFA.home) NEQ 0) OR (CompareNoCase(attributes.page,"Visiting") NEQ 0)>onmouseover="return imgSwap(document.getElementById('menuVisitingOval'),'images/menu_oval_on.gif');" onmouseout="return imgSwap(document.getElementById('menuVisitingOval'),'images/menu_oval.gif');" </cfif>/><img id="menuVisitingOval" src="images/menu_oval<cfif (CompareNoCase(attributes.fuseaction,XFA.home) EQ 0) AND (CompareNoCase(attributes.page,"Visiting") EQ 0)>_on</cfif>.gif" height="40" width="28" vspace="0" hspace="0" border="0" alt="VISITING" <cfif (CompareNoCase(attributes.fuseaction,XFA.home) NEQ 0) OR (CompareNoCase(attributes.page,"Visiting") NEQ 0)>onmouseover="return imgSwap(this,'images/menu_oval_on.gif');" onmouseout="return imgSwap(this,'images/menu_oval.gif');" </cfif>/></a><img id="menuVisitingLine" src="images/menu_line.gif" height="40" width="66" vspace="0" hspace="0" border="0" alt="" /></div>
<div id="menuWorkoutsL" style="position:absolute;left:0px;top:331px;height:40px;width:197px;z-index:1"><a href="#Request.self#?fuseaction=#XFA.workouts#&page=Workouts"><img id="menuWorkouts" src="images/menu_workouts.gif" height="40" width="103" vspace="0" hspace="0" border="0" alt="WORKOUTS" <cfif (CompareNoCase(attributes.fuseaction,XFA.home) NEQ 0) OR (CompareNoCase(attributes.page,"Workouts") NEQ 0)>onmouseover="return imgSwap(document.getElementById('menuWorkoutsOval'),'images/menu_oval_on.gif');" onmouseout="return imgSwap(document.getElementById('menuWorkoutsOval'),'images/menu_oval.gif');" </cfif>/><img id="menuWorkoutsOval" src="images/menu_oval<cfif (CompareNoCase(attributes.fuseaction,XFA.home) EQ 0) AND (CompareNoCase(attributes.page,"Workouts") EQ 0)>_on</cfif>.gif" height="40" width="28" vspace="0" hspace="0" border="0" alt="WORKOUTS" <cfif (CompareNoCase(attributes.fuseaction,XFA.home) NEQ 0) OR (CompareNoCase(attributes.page,"Workouts") NEQ 0)>onmouseover="return imgSwap(this,'images/menu_oval_on.gif');" onmouseout="return imgSwap(this,'images/menu_oval.gif');" </cfif>/></a><img id="menuWorkoutsLine" src="images/menu_line.gif" height="40" width="66" vspace="0" hspace="0" border="0" alt="" /></div>
<!---
<div id="menuNewsL" style="position:absolute;left:0px;top:371px;height:40px;width:197px;z-index:1"><a href="#Request.self#?fuseaction=#XFA.news#"><img id="menuNews" src="images/menu_news.gif" height="40" width="103" vspace="0" hspace="0" border="0" alt="NEWS/EVENTS" <cfif (CompareNoCase(attributes.fuseaction,XFA.news) NEQ 0)>onmouseover="return imgSwap(document.getElementById('menuNewsOval'),'images/menu_oval_on.gif');" onmouseout="return imgSwap(document.getElementById('menuNewsOval'),'images/menu_oval.gif');" </cfif>/><img id="menuNewsOval" src="images/menu_oval<cfif (CompareNoCase(attributes.fuseaction,XFA.news) EQ 0)>_on</cfif>.gif" height="40" width="28" vspace="0" hspace="0" border="0" alt="NEWS/EVENTS" <cfif (CompareNoCase(attributes.fuseaction,XFA.news) NEQ 0)>onmouseover="return imgSwap(this,'images/menu_oval_on.gif');" onmouseout="return imgSwap(this,'images/menu_oval.gif');" </cfif>/></a><img id="menuNewsLine" src="images/menu_line.gif" height="40" width="66" vspace="0" hspace="0" border="0" alt="" /></div>
--->
<div id="menuGalleryL" style="position:absolute;left:0px;top:371px;height:40px;width:197px;z-index:1"><a href="https://www.facebook.com/groups/squidswimteam/photos/" target="squidGallery"><img id="menuGallery" src="images/menu_gallery.gif" height="40" width="103" vspace="0" hspace="0" border="0" alt="GALLERY" <cfif NOT (FindNoCase("home.dsp_gallery",attributes.fuseaction))>onmouseover="return imgSwap(document.getElementById('menuGalleryOval'),'images/menu_oval_on.gif');" onmouseout="return imgSwap(document.getElementById('menuGalleryOval'),'images/menu_oval.gif');" </cfif>/><img id="menuGalleryOval" src="images/menu_oval<cfif FindNoCase("home.dsp_gallery",attributes.fuseaction)>_on</cfif>.gif" height="40" width="28" vspace="0" hspace="0" border="0" alt="GALLERY" <cfif NOT (FindNoCase("home.dsp_gallery",attributes.fuseaction))>onmouseover="return imgSwap(this,'images/menu_oval_on.gif');" onmouseout="return imgSwap(this,'images/menu_oval.gif');" </cfif>/></a><img id="menuGalleryLine" src="images/menu_line.gif" height="40" width="66" vspace="0" hspace="0" border="0" alt="" /></div>
<div id="menuLinksL" style="position:absolute;left:0px;top:411px;height:40px;width:197px;z-index:1"><a href="#Request.self#?fuseaction=#XFA.links#"><img id="menuLinks" src="images/menu_links.gif" height="40" width="103" vspace="0" hspace="0" border="0" alt="LINKS" <cfif (CompareNoCase(attributes.fuseaction,XFA.links) NEQ 0)>onmouseover="return imgSwap(document.getElementById('menuLinksOval'),'images/menu_oval_on.gif');" onmouseout="return imgSwap(document.getElementById('menuLinksOval'),'images/menu_oval.gif');" </cfif>/><img id="menuLinksOval" src="images/menu_oval<cfif (CompareNoCase(attributes.fuseaction,XFA.links) EQ 0)>_on</cfif>.gif" height="40" width="28" vspace="0" hspace="0" border="0" alt="LINKS" <cfif (CompareNoCase(attributes.fuseaction,XFA.links) NEQ 0)>onmouseover="return imgSwap(this,'images/menu_oval_on.gif');" onmouseout="return imgSwap(this,'images/menu_oval.gif');" </cfif>/></a><img id="menuLinksLine" src="images/menu_line.gif" height="40" width="66" vspace="0" hspace="0" border="0" alt="" /></div>
<div id="menuMembersL" style="position:absolute;left:0px;top:451px;height:40px;width:197px;z-index:1"><a href="#Request.self#?fuseaction=#XFA.members#"><img id="menuMembers" src="images/menu_members.gif" height="40" width="103" vspace="0" hspace="0" border="0" alt="MEMBER AREA" <cfif NOT ListFindNoCase("members,content,accounting",GetToken(attributes.fuseaction,1,"."))>onmouseover="return imgSwap(document.getElementById('menuMembersOval'),'images/menu_oval_on.gif');" onmouseout="return imgSwap(document.getElementById('menuMembersOval'),'images/menu_oval.gif');" </cfif>/><img id="menuMembersOval" src="images/menu_oval<cfif ListFindNoCase("members,content,accounting",GetToken(attributes.fuseaction,1,"."))>_on</cfif>.gif" height="40" width="28" vspace="0" hspace="0" border="0" alt="MEMBER AREA" <cfif NOT ListFindNoCase("members,content,accounting",GetToken(attributes.fuseaction,1,"."))>onmouseover="return imgSwap(this,'images/menu_oval_on.gif');" onmouseout="return imgSwap(this,'images/menu_oval.gif');" </cfif>/></a><img id="menuMembersLine" src="images/menu_line.gif" height="40" width="66" vspace="0" hspace="0" border="0" alt="" /></div>
<div id="menuLoginL" style="position:absolute;left:0px;top:491px;height:40px;width:197px;z-index:1"><a href="#Request.self#?fuseaction=<cfif VAL(Session.squid.user_id) EQ 0>#XFA.members#<cfelse>#XFA.logout#</cfif>"><img id="menuLogin" src="images/menu_<cfif VAL(Session.squid.user_id) EQ 0>login<cfelse>logout</cfif>.gif" height="40" width="103" vspace="0" hspace="0" border="0" alt="<cfif VAL(Session.squid.user_id) EQ 0>LOGIN<cfelse>LOGOUT</cfif>" <cfif (CompareNoCase(GetToken(attributes.fuseaction,1,"."),"login") NEQ 0)>onmouseover="return imgSwap(document.getElementById('menuLoginOval'),'images/menu_oval_on.gif');" onmouseout="return imgSwap(document.getElementById('menuLoginOval'),'images/menu_oval.gif');" </cfif>/><img id="menuLoginOval" src="images/menu_oval<cfif (CompareNoCase(GetToken(attributes.fuseaction,1,"."),"login") EQ 0)>_on</cfif>.gif" height="40" width="28" vspace="0" hspace="0" border="0" alt="<cfif VAL(Session.squid.user_id) EQ 0>LOGIN<cfelse>LOGOUT</cfif>" <cfif (CompareNoCase(GetToken(attributes.fuseaction,1,"."),"login") NEQ 0)>onmouseover="return imgSwap(this,'images/menu_oval_on.gif');" onmouseout="return imgSwap(this,'images/menu_oval.gif');" </cfif>/></a><img id="menuLoginLine" src="images/menu_line.gif" height="40" width="66" vspace="0" hspace="0" border="0" alt="" /></div>
<div id="menuDonate" style="position:absolute;left:30px;top:531px;height:40px;width:197px;z-index:99">
	<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="squidDonate" style="display:inline;">
		<input type="hidden" name="cmd" value="_s-xclick" />
		<input type="hidden" name="hosted_button_id" value="2WTYPXWNA452S" />
		<input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!" title="Donate to SQUID via PayPal" width="92" height="26" />
		<img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1" />
	</form>
</div>
<div id="menuTileL" style="position:absolute;left:0px;top:531px;height:140px;width:197px;z-index:1;background:url('images/menu_tile.gif');"></div>
<div id="menuBottomL" style="position:absolute;left:0px;top:671px;height:69px;width:197px;z-index:1;background:url('images/menu_bottom.gif');"></div>
<div id="laneLines" style="position:absolute;left:255px;top:155px;height:56px;width:597px;z-index:1;background:url('images/laneline.gif');"></div>
<div id="laneLinesTile" style="position:absolute;left:255px;top:211px;height:425px;width:597px;z-index:1;background:url('images/laneline_tile.gif');"></div>
<div id="laneLineBottom" style="position:absolute;left:255px;top:636px;height:56px;width:597px;z-index:1;background:url('images/laneline_bottom.gif');"></div>
<div id="mainContent" style="position:absolute;left:200px;top:120px;min-height:400px;width:597px;z-index:2;">
	<!--- ---------------------- --->
	<!--- Main content goes here --->
		<cfoutput>#Fusebox.layout#</cfoutput>
	<!--- End Main content goes here --->
	<!--- -------------------------- --->
	<p class="footer">
		&copy;2003 <cfif Year(Now()) GT 2003> - #Year(Now())#</cfif> SQUID Swim Team
		| <a href="#Request.self#?fuseaction=#XFA.contact#">Contact Us</a>
		| <a href="#Request.self#?fuseaction=#XFA.sitemap#">Site Map</a>
		<br />
		PO Box 7558, Denver, CO 80207-1558
		<br />
		Site Developed by <a href="http://www.scottbrady.net/" target="_blank">Scott Brady</a>
		and <a href="http://www.alansuel.com/" target="_blank">Alan Suel</a>
	</p>
</div>
<cfif fusebox.circuit IS "home" AND structKeyExists(attributes, "page") AND attributes.page IS "Home">
	<div class="fb-page" style="position:absolute;left:850px;top:120px;width:350px;height:600px;" data-href="https://www.facebook.com/squidswimteam/" data-tabs="timeline" data-small-header="false" data-width="350" data-height="600" data-adapt-container-width="true" data-hide-cover="false" data-show-facepile="false"><blockquote cite="https://www.facebook.com/squidswimteam/" class="fb-xfbml-parse-ignore"><a href="https://www.facebook.com/squidswimteam/">SQUID Swim Team</a></blockquote></div>
</cfif>
</body>
</cfoutput>
</html>
