<!---
<fusedoc
	fuse = "val_housing.cfm"
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
<cfparam name="attributes.num_guests" default="0" type="numeric">
<cfparam name="attributes.names" default="" type="string">
<cfparam name="attributes.address" default="" type="string">
<cfparam name="attributes.city" default="" type="string">
<cfparam name="attributes.state" default="" type="string">
<cfparam name="attributes.zip" default="" type="string">
<cfparam name="attributes.country" default="" type="string">
<cfparam name="attributes.phone_day" default="" type="string">
<cfparam name="attributes.phone_evening" default="" type="string">
<cfparam name="attributes.email" default="" type="string">
<cfparam name="attributes.nights" default="" type="string">
<cfparam name="attributes.car" default="" type="string">
<cfparam name="attributes.near_location" default="" type="string">
<cfparam name="attributes.smoke" default="" type="string">
<cfparam name="attributes.allergies" default="" type="string">
<cfparam name="attributes.needs" default="" type="string">
<cfparam name="attributes.sleeping" default="" type="string">
<cfparam name="attributes.sleeping_share" default="" type="string">
<cfparam name="attributes.temperament" default="" type="string">

<cfparam name="strSuccess" default="#StructNew()#" type="struct">
<cfparam name="strSuccess.success" default="yes" type="boolean">
<cfparam name="strSuccess.reason" default="" type="string">

<cfset strSuccess = Request.registration_cfc.valHousing(attributes)>

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

<!--- If session variable for housing is 0, insert into database and set new value --->
<cfif NOT VAL(Session.goldrush2009.housing)>
	<cfset strSuccess = Request.registration_cfc.addRegistrantHousing(Request.DSN,Request.registrant_housingTbl,Request.registrationTbl,Session.goldrush2009.registration_id,true)>
	<cfset attributes.housing = VAL(strSuccess.housing)>
<cfelse>
	<cfset attributes.housing = VAL(session.goldrush2009.housing)>
</cfif>

<!--- Update table --->
<cfset strSuccess = Request.registration_cfc.updateHousing(attributes,Request.DSN,Request.registrant_housingTbl,attributes.housing,Session.goldrush2009.registration_id)>

<!--- If ok, set session values  --->
<cfset strSuccess = Request.registration_cfc.setHousing(attributes)>

<cfset variables.success = "yes">
<cfset variables.reason = "Changes saved.">
