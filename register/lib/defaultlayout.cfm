<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!---
<fusedoc fuse="defaultLayout.cfm" language="ColdFusion" specification="3.0">
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
	<link media="screen" rel="stylesheet" href="<cfoutput>#Request.ss_main#</cfoutput>" />
<cfif Request.ss_template IS NOT "">
	<link media="screen" rel="stylesheet" href="<cfoutput>#Request.ss_template#</cfoutput>" />
</cfif>
</head>
<cfoutput>
<body onload="#Request.onLoad#">
<div id="innerodd" onclick="location.href='/goldrush2009/';" style="cursor:pointer;">
<div id="odd"></div></div>
<div id="ctr">
<div class="chapter">Denver, CO &raquo; October 9, 10 & 11, 2009</div>
<div class="content">
	<!--- ---------------------- --->
	<!--- Main content goes here --->
		#Fusebox.layout#
	<!--- End Main content goes here --->
	<!--- -------------------------- --->
</div>
</div>
</body>
</cfoutput>
</html>
