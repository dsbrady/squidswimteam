<cfif LEN(TRIM(attributes.returnFA)) EQ 0>
	<cfset attributes.returnFA = XFA.success>
</cfif>
<cfif NOT attributes.addNew>
	<cfset variables.reason = "Profile Updated">
<cfelse>
	<cfset variables.reason = "Member Added">
</cfif>

<!--- Go to the next page --->
<cflocation addtoken="no" url="#variables.baseHREF##Request.self#?fuseaction=#attributes.returnFA#&actionType=edit&success=yes&reason=#variables.reason#&user_id=#attributes.user_id#&activityLevel=#attributes.activityLevel#&statusType=#attributes.statusType#&returnFA=#attributes.fuseaction#">
