<!---
<fusedoc fuse="FBX_Circuits.cfm" language="ColdFusion" specification="2.0">
	<responsibilities>
		I define the Circuits structure used with Fusebox 3.0
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="15 December 2002" role="Architect">
	</properties>
	<io>
		<in>
			<structure name="fusebox.circuits"></structure>
		</in>
		<out>
			<string name="fusebox.circuits.*" comments="set a variable for each circuit name" />
		</out>
	</io>
</fusedoc>
--->

<cfscript>
	Fusebox.circuits.home = "squid";
	Fusebox.circuits.members = "squid/members";
	Fusebox.circuits.admin = "squid/admin";
	Fusebox.circuits.login = "squid/login";
	Fusebox.circuits.accounting = "squid/accounting";
	Fusebox.circuits.content = "squid/content";
	Fusebox.circuits.calendar = "squid/calendar";
	Fusebox.circuits.scheduled = "squid/scheduled";
	Fusebox.circuits.meetAdmin = "squid/meetAdmin";
	Fusebox.circuits.membership = "squid/membership";
	Fusebox.circuits.survey = "squid/survey";
	Fusebox.circuits.surveyAdmin = "squid/survey/admin";
	Fusebox.circuits.utilities = "squid/utilities";
</cfscript>
