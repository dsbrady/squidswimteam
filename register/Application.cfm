<cfif GetFileFromPath(GetBaseTemplatePath()) NEQ "index.cfm">
	<cflocation addtoken="no" url="index.cfm">
</cfif>