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
	Request.scheduled_cfc = Request.cfcPath & ".scheduled";
	request.swimPassReminderDays = 14;
</cfscript>

<!--- Should fusebox silently supress its own error messags? 
Default is FALSE --->
<cfset fusebox.supressErrors = false>

