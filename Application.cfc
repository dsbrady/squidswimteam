<cfcomponent output="false">

	<!--- full path to the directory in which this Application.cfc resides --->
	<cfset variables.applicationPath = getDirectoryFromPath(getCurrentTemplatePath()) />

	<!--- application name --->
	<cfif (listLast(cgi.server_name,".") IS NOT "org" OR listFirst(cgi.script_name,"/") IS "dev")>
		<cfset this.name = "squidDev" />
	<cfelse>
		<cfset this.name = "squid" />
	</cfif>

	<!--- application settings --->
	<cfset this.applicationtimeout = createTimeSpan(0, 1, 0, 0) />
	<cfset this.clientManagement = false />
	<cfset this.sessionManagement = true />
	<cfset this.sessionTimeout = createTimeSpan(0, 1, 0, 0) />
	<cfset this.setClientCookies = true />

	<!--- mappings --->
	<cfset this.mappings["/squid"] = "#variables.applicationPath#components" />

	<cffunction name="onApplicationStart">
		<cfif (listLast(cgi.server_name,".") IS NOT "org" OR listFirst(cgi.script_name,"/") IS "dev")>
			<cfset application.environment = "development" />
			<cfset application.dsn = "squidSQL" />
		<cfelse>
			<cfset application.environment = "production" />
			<cfset application.dsn = "squidSQL" />
		</cfif>

	</cffunction>

<!---
	<cffunction name="onError">
        <cfargument name="exception" type="any" required="true" />
        <cfargument name="eventName" type="string" required="true" />
		<!--- immediately extend request timeout past current timeout --->
		<cfsetting requesttimeout="#createObject('java', 'coldfusion.runtime.RequestMonitor').getRequestTimeout() + 10#" />

		<cfset local.cferror = arguments.exception />

		<cfinclude template="error.cfm" />
	</cffunction>

	<cffunction name="onRequestEnd">
		<!--- fuck you AND your session, bots!!! --->
		<cfif request.isBot>
			<cfset session.setMaxInactiveInterval(javaCast("long", 2)) />
		</cfif>
	</cffunction>
 --->

	<cffunction name="onRequestStart">
		<!--- TODO: protect this --->
		<cfif structKeyExists(url, "reloadApplication") AND url.reloadApplication>
			<cfset onApplicationStart() />
		</cfif>
		<!--- TODO: protect this --->
		<cfif NOT structKeyExists(session, "squid") OR (structKeyExists(url, "reloadSession") AND url.reloadSession)>
			<cfset onSessionStart() />
		</cfif>
		<cfif CGI.remote_addr EQ "207.31.251.130">
			<cfabort>
		</cfif>
		<cfif getFileFromPath(getBaseTemplatePath()) NEQ "index.cfm">
			<cflocation addtoken="no" url="index.cfm" />
		</cfif>
	</cffunction>

	<cffunction name="onSessionStart">
		<cfset session.squid = {
			"user_id": 0,
			"user": new squid.User(application.dsn, 0)
		} />
	</cffunction>
</cfcomponent>