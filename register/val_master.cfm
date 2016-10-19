<!---
<fusedoc
	fuse = "val_master.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="4 April 2004" type="Create">
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
<cfparam name="attributes.last_name" default="" type="string">
<cfparam name="attributes.first_name" default="" type="string">
<cfparam name="attributes.initial" default="" type="string">
<cfparam name="attributes.pref_name" default="" type="string">
<cfparam name="attributes.dob" default="" type="string">
<cfparam name="attributes.ath_sex" default="M" type="string">
<cfparam name="attributes.Home_daytele" default="" type="string">
<cfparam name="attributes.Home_email" default="" type="string">
<cfparam name="attributes.Home_addr1" default="" type="string">
<cfparam name="attributes.Home_addr2" default="" type="string">
<cfparam name="attributes.Home_city" default="" type="string">
<cfparam name="attributes.Home_state" default="CO" type="string">
<cfparam name="attributes.Home_zip" default="" type="string">
<cfparam name="attributes.Home_country" default="USA" type="string">
<cfparam name="attributes.registrationType" default="both" type="string">

<cfparam name="strSuccess" default="#StructNew()#" type="struct">
<cfparam name="strSuccess.success" default="yes" type="boolean">
<cfparam name="strSuccess.reason" default="" type="string">

<cfset strSuccess = Request.registration_cfc.valMaster(attributes)>

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

<!--- If registration id is 0, initialize in database and send out e-mail with password info --->
<cfif VAL(Session.goldrush2009.registration_id) EQ 0>
	<cfset strSuccess = Request.registration_cfc.initializeRegistration(attributes,Request.DSN,Request.registrationTbl,Request.athleteTbl,Request.from_email)>
</cfif>

<!--- If ok, set session values --->
<cfset strSuccess = Request.registration_cfc.setMaster(attributes)>

<!--- Next, update tables --->
<cfset strSuccess = Request.registration_cfc.updateMaster(Request.dsn,Request.registrationTbl,Request.athleteTbl)>

<cfset variables.success = "yes">
<cfset variables.reason = "Changes saved.">
