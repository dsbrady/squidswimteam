<cflocation addtoken="false" url="https://www.facebook.com/groups/squidswimteam/events/" />
<!---
<!---
Uncomment this if you wish to have code specific that only executes if the circuit running is the home circuit.
--->
<cfif fusebox.IsHomeCircuit>
	<!--- put settings here that you want to execute only when this is the application's home circuit (for example "<cfapplication>" )--->
<cfelse>
	<!--- put settings here that you want to execute only when this is not an application's home circuit --->
</cfif>

<!--- Useful constants --->
<cfscript>
	Request.page_title = Request.page_title & " Calendar";

	XFA.noaccess = "login.dsp_noaccess";
	XFA.login = "login.dsp_login";
	XFA.logout = "login.act_logout";
	XFA.menu = "calendar.dsp_start";

	Request.noLogin = "calendar.start,calendar.dsp_start";
</cfscript>

<!--- If not logged in, go to login --->
<cfif (Request.squid.user_id EQ 0) AND (NOT ListFindNoCase(Request.noLogin,attributes.fuseaction))>
	<cfset variables.returnFA = attributes.fuseaction>

	<cflocation addtoken="no" url="#Request.self#/fuseaction/#XFA.login#/returnFA/#variables.returnFA#.cfm">
<!--- Else if not authorized, report that --->
<cfelseif Request.squid.user_id EQ 469>
	<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
</cfif>

 --->
