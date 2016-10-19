<cfif CGI.remote_addr EQ "207.31.251.130">
	<cfabort>
</cfif>
<cfif GetFileFromPath(GetBaseTemplatePath()) NEQ "index.cfm">
	<cflocation addtoken="no" url="index.cfm">
</cfif>