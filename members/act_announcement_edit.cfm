<!---
<fusedoc
	fuse = "act_issues_edit.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I go to the next fuse.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="10 August 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>

		</in>
		<out>
			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfif LEN(attributes.cancelBtn) GT 0>
	<cfset variables.reason = "Announcement Cancelled.">
<cfelse>
	<cfset variables.reason = "Announcement Saved.">
</cfif>

<!--- Go to the next page --->
<cflocation addtoken="no" url="#variables.baseHREF##Request.self#?fuseaction=#XFA.success#&success=yes&reason=Announcement%20Saved">

