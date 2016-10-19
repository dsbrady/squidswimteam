<!---
<fusedoc
	fuse = "val_defaults.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="12 September 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>

			<number name="coach_id" scope="attributes" />
			<number name="facility_id" scope="attributes" />
			<boolean name="sunday" scope="attributes" />
			<boolean name="monday" scope="attributes" />
			<boolean name="tuesday" scope="attributes" />
			<boolean name="wednesday" scope="attributes" />
			<boolean name="thursday" scope="attributes" />
			<boolean name="friday" scope="attributes" />
			<boolean name="saturday" scope="attributes" />
		</in>
		<out>
			<number name="coach_id" scope="formOrUrl" />
			<number name="facility_id" scope="formOrUrl" />
			<boolean name="sunday" scope="formOrUrl" />
			<boolean name="monday" scope="formOrUrl" />
			<boolean name="tuesday" scope="formOrUrl" />
			<boolean name="wednesday" scope="formOrUrl" />
			<boolean name="thursday" scope="formOrUrl" />
			<boolean name="friday" scope="formOrUrl" />
			<boolean name="saturday" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.coach_id" default="0" type="numeric">
<cfparam name="attributes.facility_id" default="0" type="numeric">
<cfparam name="attributes.sunday" default="0" type="boolean">
<cfparam name="attributes.monday" default="0" type="boolean">
<cfparam name="attributes.tuesday" default="0" type="boolean">
<cfparam name="attributes.wednesday" default="0" type="boolean">
<cfparam name="attributes.thursday" default="0" type="boolean">
<cfparam name="attributes.friday" default="0" type="boolean">
<cfparam name="attributes.saturday" default="0" type="boolean">

<cfparam name="variables.success" default="Yes" type="boolean">
<cfparam name="variables.reason" default="" type="string">

<cfinvoke
	component="#Request.accounting_cfc#"
	method="updateDefaults"
	returnvariable="strSuccess"
	formfields=#attributes#
	dsn=#Request.DSN#
	defaultsTbl=#Request.practice_defaultTbl#
	updating_user=#Request.squid.user_id#
>

<cfif NOT strSuccess.success>
	<cfscript>
		variables.theURL = Request.self & "?fuseaction=" & XFA.failure;
		variables.theURL = variables.theURL & "&success=" & strSuccess.success & "&reason=" & strSuccess.reason;
	</cfscript>

	<cfloop collection="#attributes#" item="variables.theItem">
		<cfscript>
			if ((variables.theItem IS NOT "SubmitBtn") AND (variables.theItem IS NOT "fieldnames") AND (variables.theItem IS NOT "fuseaction") AND (LEN(attributes[variables.theItem])))
			{
				variables.theURL = variables.theURL & "&" & variables.theItem & "=" & attributes[variables.theItem];
			}
		</cfscript>
	</cfloop>

	<cflocation addtoken="no" url="#variables.theURL#">
</cfif>

<cfset variables.reason = "Practice Defaults Updated">
