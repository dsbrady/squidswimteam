<!---
<fusedoc
	fuse = "val_waiver.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="17 April 2004" type="Create">
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
<cfparam name="attributes.waiverName" default="" type="string">
<cfparam name="attributes.waiverText" default="" type="string">

<cfparam name="strSuccess" default="#StructNew()#" type="struct">
<cfparam name="strSuccess.success" default="yes" type="boolean">
<cfparam name="strSuccess.reason" default="" type="string">

<!--- Validate --->
<cfset strSuccess = Request.registration_cfc.valWaiver(attributes,Request.waiverText)>

<cfif NOT strSuccess.success>
	<cfscript>
		variables.theURL = Request.self & "/fuseaction/" & XFA.failure;
		variables.theURL = variables.theURL & "/success/" & strSuccess.success & "/reason/" & strSuccess.reason;
	</cfscript>

	<cfloop collection="#attributes#" item="variables.theItem">
		<cfscript>
			if ((variables.theItem IS NOT "SubmitBtn") AND (variables.theItem IS NOT "PreviewBtn") AND (variables.theItem IS NOT "fieldnames") AND (variables.theItem IS NOT "fuseaction") AND (LEN(attributes[variables.theItem])))
			{
				variables.theURL = variables.theURL & "/" & variables.theItem & "/" & attributes[variables.theItem];
			}
		</cfscript>
	</cfloop>

	<cfset variables.theURL = variables.theURL & ".cfm">

	<cflocation addtoken="no" url="#variables.theURL#"> 
</cfif>

<!--- If ok, set session values --->
<cfset strSuccess = Request.registration_cfc.setWaiver(attributes)>

<!--- Now update table --->
<cfset strSuccess = Request.registration_cfc.updateWaiver(attributes,Request.DSN,Request.registrationTbl,Session.goldrush2009.registration_id,Session.goldrush2009.waiverDate)>

<cfset variables.success = "yes">
<cfset variables.reason = "Waiver Signed.">
