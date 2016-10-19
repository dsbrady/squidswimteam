<!---
<fusedoc fuse="FBX_Settings.cfm">
	<responsibilities>
		I set up the enviroment settings for this circuit. If this
		settings file is being inherited, then you can use CFSET to
		override a value set in a parent circuit or CFPARAM to accept a
		value set by a parent circuit
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="9 May 2004" type="Create">
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
	<cfscript>
		XFA.logout = "login.act_logout";
	</cfscript>
</cfif>

<!--- Useful constants --->
<cfset Request.membershipFee = 30 />

<!--- Dues --->
<cfif NOT structKeyExists(session.squid,"stDues")>
	<cfset session.squid.stDues = structNew() />
	<cfset session.squid.stDues.startDate = arrayNew(1) />
	<cfset session.squid.stDues.endDate = arrayNew(1) />
	<cfset session.squid.stDues.fee = arrayNew(1) />
	<cfset session.squid.stDues.membershipYear = arrayNew(1) />

	<cfset arrayAppend(session.squid.stDues.startDate,createDate(year(now()),1,1)) />
	<cfset arrayAppend(session.squid.stDues.startDate,createDate(year(now()),7,1)) />
	<cfset arrayAppend(session.squid.stDues.startDate,createDate(year(now()),12,1)) />

	<cfset arrayAppend(session.squid.stDues.endDate,createDate(year(now()),7,1)) />
	<cfset arrayAppend(session.squid.stDues.endDate,createDate(year(now()),12,1)) />
	<cfset arrayAppend(session.squid.stDues.endDate,createDate(year(now()) + 1,1,1)) />

	<cfset arrayAppend(session.squid.stDues.fee,30) />
	<cfset arrayAppend(session.squid.stDues.fee,15) />
	<cfset arrayAppend(session.squid.stDues.fee,30) />

	<cfset arrayAppend(session.squid.stDues.membershipYear,year(now())) />
	<cfset arrayAppend(session.squid.stDues.membershipYear,year(now())) />
	<cfset arrayAppend(session.squid.stDues.membershipYear,year(now()) + 1) />

	<!--- Determine current dues index --->
	<cfset session.squid.stDues.duesIndex = 0 />
	<cfloop from="1" to="#arrayLen(session.squid.stDues.startDate)#" index="i">
	<cfif dateCompare(session.squid.stDues.startDate[i],now()) LT 0 AND dateCompare(session.squid.stDues.endDate[i],now()) GTE 0>
			<cfset session.squid.stDues.duesIndex = i />
			<cfbreak />
		</cfif>
	</cfloop>
</cfif>

<!--- Insert Privacy Policy Header --->
<cfheader name="P3P" value="policyref=""http://www.squidswimteam.org/w3c/p3p.xml""">

<!--- Should fusebox silently supress its own error messags?
Default is FALSE --->
<cfset fusebox.supressErrors = false>

