<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--- 
<fusedoc fuse="printablelayout.cfm" language="ColdFusion" specification="3.0">
	<responsibilities>
		I display the printable layout.
	</responsibilities>	
	<properties>
		<history author="Scott Brady" date="13 April 2004" type="Create">
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
	<link media="screen" rel="stylesheet" href="<cfoutput>#Request.ss_printable#</cfoutput>" />
<cfif Request.ss_template IS NOT "">
	<link media="screen" rel="stylesheet" href="<cfoutput>#Request.ss_template#</cfoutput>" />
</cfif>
</head>
<cfoutput>
<body onload="#Request.onLoad#">
<a name="top"></a>
<table width="600" border="0" cellspacing="0" cellpadding="0">
	<tr class="content" bgcolor="##ffffff">
		<td>
	<!--- ---------------------- --->
	<!--- Main content goes here --->
		#Fusebox.layout#
	<!--- End Main content goes here --->
	<!--- -------------------------- --->
	<br /><br />
	<p class="footer">
		&copy;2004 <cfif Year(Now()) GT 2004> - #Year(Now())#</cfif> SQUID Swim Team
		| <a href="#Request.self#/fuseaction/#XFA.contact#.cfm">Contact Us</a>
	</p>
		</td>
	</tr>
</table>
</body>
</cfoutput>
</html>
