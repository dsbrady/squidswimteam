<!---
<fusedoc
	fuse = "val_facilities_edit.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="9 September 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>

			<number name="facility_id" scope="attributes" />
			<string name="facility" scope="attributes" />
		</in>
		<out>
			<number name="facility_id" scope="formOrUrl" />
			<string name="facility" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.facility_id" default="0" type="numeric">
<cfparam name="attributes.facility" default="" type="string">

<cfparam name="variables.success" default="Yes" type="boolean">
<cfparam name="variables.reason" default="" type="string">

<cfinvoke
	component="#Request.accounting_cfc#"
	method="updateFacility"
	returnvariable="strSuccess"
	formfields=#attributes#
	dsn=#Request.DSN#
	facilityTbl=#Request.facilityTbl#
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

<cfscript>
	if (VAL(attributes.facility_id) GT 0)
	{
		variables.reason = "Facility Updated";
	}
	else
	{
		variables.reason = "Facility Added";
	}
	variables.theFA = XFA.success;
</cfscript>
