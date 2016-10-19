<!---
<fusedoc
	fuse = "val_issues_edit.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="23 October 2004" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>

			<number name="eventID" scope="attributes" />
			<number name="distanceID" scope="attributes" />
			<number name="strokeID" scope="attributes" />
			<number name="distanceTypeID" scope="attributes" />
			<number name="unitID" scope="attributes" />
			<string name="seedTime" scope="attributes" />
			<string name="eventDate" scope="attributes" />
			<string name="eventLocation" scope="attributes" />
		</in>
		<out>
			<number name="eventID" scope="formOrUrl" />
			<number name="distanceID" scope="formOrUrl" />
			<number name="strokeID" scope="formOrUrl" />
			<number name="distanceTypeID" scope="formOrUrl" />
			<number name="unitID" scope="formOrUrl" />
			<string name="seedTime" scope="formOrUrl" />
			<string name="eventDate" scope="formOrUrl" />
			<string name="eventLocation" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.eventID" default="0" type="numeric" />
<cfparam name="attributes.distanceID" default="0" type="numeric" />
<cfparam name="attributes.strokeID" default="0" type="numeric" />
<cfparam name="attributes.distanceTypeID" default="0" type="numeric" />
<cfparam name="attributes.unitID" default="0" type="numeric" />
<cfparam name="attributes.seedtime" default="" type="string" />
<cfparam name="attributes.eventDate" default="" type="string" />
<cfparam name="attributes.eventLocation" default="" type="string" />

<cfparam name="variables.success" default="Yes" type="boolean">
<cfparam name="variables.reason" default="" type="string">

<!--- Perform Update --->
<cfset attributes.user_id = Request.squid.user_id />
<cfset stSuccess = memberCFC.setUserEvent(attributes,Request.dsn,Request.userEventTbl,Request.squid.user_id) />

<cfif NOT stSuccess.success>
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

<cfset variables.reason = "Event Added." />
