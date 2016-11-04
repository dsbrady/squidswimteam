<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<link rel="P3Pv1" href="<cfoutput>#Request.theServer#</cfoutput>/w3c/p3p.xml" />
<!--- SES stuff --->
<cfif isDefined("variables.baseHref")>
    <cfoutput><base href="#variables.baseHref#" /></cfoutput>
</cfif>
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

	<style>
		body {
			height: auto;
			width: auto;
		}
	</style>
	</head>
<cfoutput>
<body onload="#Request.onLoad#">
<div id="mainContent">
	<cfoutput>#Fusebox.layout#</cfoutput>
</div>
</body>
</cfoutput>
</html>
