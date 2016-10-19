<!---
<fusedoc
	fuse = "act_login.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I go to the next fuse.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="3 June 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>

			<boolean name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
			<boolean name="success" scope="formOrUrl" default="Yes" />
			<string name="reason" scope="formOrUrl" />
		</out>
	</io>

</fusedoc>
--->

<!--- Go to the next page --->
<cflocation addtoken="no" url="#variables.baseHREF##Request.self#?fuseaction=#XFA.success#">
