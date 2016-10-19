<!---
<fusedoc
	fuse = "act_end_session.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I end the session.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="13 April 2004" type="Create" role="Architect">
	</properties>
	<io>
		<in>
			<string name="self" />
			<string name="exitURL" scope="Request" />
		</in>
	</io>

</fusedoc>
--->

<!--- Clear out session --->
<cfscript>
	StructDelete(Session,"goldrush2009");
</cfscript>

<!--- Go to the exit URL --->
<cflocation addtoken="no" url="#Request.exitURL#">
