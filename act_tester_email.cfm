<!---
<fusedoc
	fuse = "act_tester_email.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I go to the next fuse.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="1 September 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>

			<number name="return_email" scope="attributes" />
			<number name="subject" scope="attributes" />
			<number name="email_body" scope="attributes" />
		</in>
		<out>
			<number name="return_email" scope="formOrUrl" />
			<number name="subject" scope="formOrUrl" />
			<number name="email_body" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->

<!--- Go to the next page --->
<cflocation addtoken="no" url="#variables.baseHREF##Request.self#/fuseaction/#XFA.success#/success/yes/reason/E-mail%20Sent.cfm">
