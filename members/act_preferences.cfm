<!---
<fusedoc
	fuse = "act_preferences.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I go to the next fuse.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="25 July 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>
			
			<number name="user_id" scope="attributes" />
			<number name="email_preference" scope="attributes" />
			<number name="posting_preference" scope="attributes" />
		</in>
		<out>
			<number name="user_id" scope="formOrUrl" />
			<number name="email_preference" scope="formOrUrl" />
			<number name="posting_preference" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->

<!--- Go to the next page --->
<cflocation addtoken="no" url="#variables.baseHREF##Request.self#?fuseaction=#XFA.success#&success=yes">
