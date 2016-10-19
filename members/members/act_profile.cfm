<!---
<fusedoc
	fuse = "act_profile.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I go to the next fuse.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="5 June 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>

			<number name="user_id" scope="attributes" />
			<boolean name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
			<number name="user_id" scope="formOrUrl" />
			<boolean name="success" scope="formOrUrl" default="Yes" />
			<string name="reason" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
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
