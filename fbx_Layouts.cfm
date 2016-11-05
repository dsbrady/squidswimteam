<!---
<fusedoc fuse="FBX_Layouts.cfm">
	<responsibilities>
		this file contains all the conditional logic for determining which layout file, if any, should be used for this circuit. It should result in the setting of the Fusebox public API variables fusebox.layoutdir and fusebox.layoutfile
	</responsibilities>
	<io>
		<out>
			<string name="fusebox.layoutDir" />
			<string name="fusebox.layoutFile" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="request.suppressLayout" default="false" type="boolean" />
<cfparam name="request.blankLayout" default="false" type="boolean" />
<cfparam name="request.modalLayout" default="false" type="boolean" />

<cfif request.suppressLayout>
	<cfset fusebox.layoutFile = "">
	<cfset fusebox.layoutDir = "">
<cfelseif request.blankLayout>
	<cfif structKeyExists(request, "_response")>
		<cfset fusebox.layoutFile = "blanklayout.cfm">
		<!--- if we're using the newfangled response stuff, update here --->
		<cfcontent reset="true" />
		<cfheader name="Content-Type" value="application/json" />
		<cfset fusebox.layout = serializeJson({
				"values" = request._response.getValues(),
				"fieldErrors" = request._response.getFieldErrors(),
				"statusCode" = request._response.getStatusCode(),
				"statusText" = request._response.getStatusText()
			}) />
	<cfelse>
		<cfset fusebox.layoutFile = "blanklayout.cfm">
	</cfif>
	<cfset fusebox.layoutDir = "lib/">
<cfelseif request.modalLayout>
	<cfset fusebox.layoutFile = "modalLayout.cfm">
	<cfset fusebox.layoutDir = "lib/">
<cfelse>
	<cfset fusebox.layoutFile = "defaultLayout.cfm">
	<cfset fusebox.layoutDir = "lib/">
</cfif>
