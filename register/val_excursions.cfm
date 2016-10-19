<!---
<fusedoc
	fuse = "val_excursions.cfm"
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
<cfparam name="attributes.excursion" default=0 type="numeric">

<cfparam name="strSuccess" default="#StructNew()#" type="struct">
<cfparam name="strSuccess.success" default="yes" type="boolean">
<cfparam name="strSuccess.reason" default="" type="string">

<!--- If ok, set session values --->
<cfset strSuccess = Request.registration_cfc.setExcursion(attributes)>

<!--- Now update table --->
<cfset strSuccess = Request.registration_cfc.updateExcursion(Request.DSN,Request.registrationTbl,VAL(attributes.excursion),Session.goldrush2009.registration_id)>

<cfset variables.success = "yes">
<cfset variables.reason = "Changes saved.">
