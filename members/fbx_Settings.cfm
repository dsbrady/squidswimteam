<!---
<fusedoc fuse="FBX_Settings.cfm">
	<responsibilities>
		I set up the enviroment settings for this circuit. If this
		settings file is being inherited, then you can use CFSET to
		override a value set in a parent circuit or CFPARAM to accept a
		value set by a parent circuit
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="8 May 2002" type="Create" />
	</properties>
	<io>
		<in>
			<structure name="fusebox">
				<boolean name="isHomeCircuit"
					comments="Is the circuit currently executing the home circuit?" />
			</structure>
		</in>
		<out>
			<string name="self" scope="variables" />
			<string name="self" scope="request" />
			<string name="fusebox.layoutDir" />
			<string name="fusebox.layoutFile" />
			<boolean name="fusebox.suppressErrors" />
		</out>
	</io>
</fusedoc>
--->

<!---
Uncomment this if you wish to have code specific that only executes if the circuit running is the home circuit.
--->
<cfif fusebox.IsHomeCircuit>
	<!--- put settings here that you want to execute only when this is the application's home circuit (for example "<cfapplication>" )--->
<cfelse>
	<!--- put settings here that you want to execute only when this is not an application's home circuit --->
</cfif>

<!--- Useful constants --->
<cfscript>
	Request.page_title = Request.page_title & " Member Section";

	XFA.noaccess = "login.dsp_noaccess";
	XFA.login = "login.dsp_login";
	XFA.logout = "login.act_logout";
	XFA.menu = "members.dsp_start";

	Request.specialDealMinimumBalance = -10;
</cfscript>

<!--- If not logged in, go to login --->
<cfif (Request.squid.user_id EQ 0)>
	<cfset variables.returnFA = attributes.fuseaction>

	<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.login#&returnFA=#variables.returnFA#">
</cfif>


