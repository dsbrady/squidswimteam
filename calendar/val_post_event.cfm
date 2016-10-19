<!---
<fusedoc
	fuse = "v"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="5 January 2004" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>
			
			<number name="calendar_id" scope="attributes" />
			<number name="recurring_event_id" scope="attributes" />
			<number name="event_type_id" scope="attributes" />
			<number name="frequency_id" scope="attributes" />
			<string name="startDate" scope="attributes" />
			<string name="startTime" scope="attributes" />
			<string name="endTime" scope="attributes" />
			<string name="endDate" scope="attributes" />
			<string name="location" scope="attributes" />
			<string name="description" scope="attributes" />
			<boolean name="emailUsers" scope="attributes" />
			<boolean name="updateAll" scope="attributes" />
		</in>
		<out>
			<number name="calendar_id" scope="formOrUrl" />
			<number name="recurring_event_id" scope="formOrUrl" />
			<number name="event_type_id" scope="formOrUrl" />
			<number name="frequency_id" scope="formOrUrl" />
			<string name="startDate" scope="formOrUrl" />
			<string name="startTime" scope="formOrUrl" />
			<string name="endTime" scope="formOrUrl" />
			<string name="endDate" scope="formOrUrl" />
			<string name="location" scope="formOrUrl" />
			<string name="description" scope="formOrUrl" />
			<boolean name="emailUsers" scope="formOrUrl" />
			<boolean name="updateAll" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.calendar_id" default="0" type="numeric">
<cfparam name="attributes.recurring_event_id" default="0" type="numeric">
<cfparam name="attributes.event_type_id" default="1" type="numeric">
<cfparam name="attributes.theMonth" default="#Month(Now())#" type="string">
<cfparam name="attributes.theYear" default="#Year(Now())#" type="string">
<cfparam name="attributes.frequency_id" default="0" type="numeric">
<cfparam name="attributes.startDate" default="#DateFormat(Now(),"m/d/yyyy")#" type="string">
<cfparam name="attributes.startTime" default="#TimeFormat(Now(),"h:mm TT")#" type="string">
<cfparam name="attributes.endTime" default="" type="string">
<cfparam name="attributes.endDate" default="" type="string">
<cfparam name="attributes.location" default="" type="string">
<cfparam name="attributes.description" default="" type="string">
<cfparam name="attributes.emailUsers" default="false" type="boolean">
<cfparam name="attributes.updateAll" default="false" type="boolean">
<cfparam name="attributes.submitBtn" default="Save" type="string">

<cfparam name="variables.success" default="Yes" type="boolean">
<cfparam name="variables.reason" default="" type="string">

<cfif attributes.submitBtn EQ "Delete">
	<cfset strSuccess = Request.calendar_cfc.deleteEvent(attributes,Request.dsn,Request.calendarTbl,Request.calendar_recurringTbl)>
	<cfset variables.reason = "Event Deleted">
<cfelse>
	<cfset strSuccess = Request.calendar_cfc.postEvent(attributes,Request.dsn,Request.usersTbl,Request.user_statusTbl,Request.calendarTbl,Request.calendar_recurringTbl,Request.event_typeTbl,Request.frequencyTbl,Request.preferenceTbl,Request.squid.user_id)>
	<cfset variables.reason = "Event Submitted">
</cfif>

<cfif NOT strSuccess.success>
	<cfscript>
		variables.theURL = Request.self & "/fuseaction/" & XFA.failure;
		variables.theURL = variables.theURL & "/success/" & strSuccess.success & "/reason/" & strSuccess.reason;
	</cfscript>

	<cfset attributes.startDate = Replace(attributes.startDate,"/","-","ALL")>	
	<cfset attributes.endDate = Replace(attributes.endDate,"/","-","ALL")>	

	<cfloop collection="#attributes#" item="variables.theItem">
		<cfscript>
			if ((variables.theItem IS NOT "SubmitBtn") AND (variables.theItem IS NOT "fieldnames") AND (variables.theItem IS NOT "fuseaction") AND (LEN(attributes[variables.theItem])))
			{
				variables.theURL = variables.theURL & "/" & variables.theItem & "/" & attributes[variables.theItem];
			}
		</cfscript>
	</cfloop>

	<cfset variables.theURL = variables.theURL & ".cfm">

	<cflocation addtoken="no" url="#variables.theURL#"> 
</cfif>

