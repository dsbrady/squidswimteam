<!---
<fusedoc
	fuse = "val_races.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="11 April 2004" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>
			
		</in>
		<out>
			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.usms" default="" type="string">
<cfparam name="attributes.team_no" default=0 type="numeric">
<cfparam name="attributes.team_name" default="" type="string">
<cfparam name="attributes.team_short" default="" type="string">
<cfparam name="attributes.team_abbr" default="" type="string">
<cfparam name="Session.goldrush2009.aRaces" default="#ArrayNew(1)#" type="array">

<cfparam name="strSuccess" default="#StructNew()#" type="struct">
<cfparam name="strSuccess.success" default="yes" type="boolean">
<cfparam name="strSuccess.reason" default="" type="string">

<cfset strSuccess = Request.registration_cfc.valRaces(attributes)>

<cfif NOT strSuccess.success>
	<cfscript>
		variables.theURL = Request.self & "/fuseaction/" & XFA.failure;
	</cfscript>

	<cfloop collection="#attributes#" item="variables.theItem">
		<cfscript>
			if ((variables.theItem IS NOT "SubmitBtn") AND (variables.theItem IS NOT "PreviewBtn") AND (variables.theItem IS NOT "fieldnames") AND (variables.theItem IS NOT "fuseaction") AND (LEN(attributes[variables.theItem])))
			{
				variables.theURL = variables.theURL & "/" & variables.theItem & "/" & attributes[variables.theItem];
			}
		</cfscript>
	</cfloop>

	<cfscript>
		variables.theURL = variables.theURL & "/success/" & strSuccess.success & "/reason/" & strSuccess.reason;
	</cfscript>

	<cfset variables.theURL = variables.theURL & ".cfm">

	<cflocation addtoken="no" url="#variables.theURL#"> 
</cfif>

<!--- If team_no is -1, insert into database and set new value --->
<cfif VAL(attributes.team_no) EQ -1>
	<cfset strSuccess = Request.registration_cfc.addTeam(attributes,Request.DSN,Request.teamTbl,true)>
	<cfset attributes.team_no = strSuccess.team_no>
</cfif>

<!--- If ok, set session values --->
<cfset strSuccess = Request.registration_cfc.setRaces(attributes)>

<!--- Now insert races into entry table and update registration info --->
<cfset strSuccess = Request.registration_cfc.updateRaces(Request.DSN,Request.entryTbl,Request.registrationTbl,Request.athleteTbl)>

<cfset variables.success = "yes">
<cfset variables.reason = "Changes saved.">
