<!---
<fusedoc
	fuse = "val_practices_edit.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="14 September 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>

			<number name="practice_id" scope="attributes" />
			<number name="coach_id" scope="attributes" />
			<number name="facility_id" scope="attributes" />
			<list name="members" scope="attributes" />
			<list name="guests" scope="attributes" />
			<list name="membersOld" scope="attributes" />
			<list name="guestsOld" scope="attributes" />
			<string name="date_start" scope="attributes" />
			<string name="date_end" scope="attributes" />
			<string name="date_practice" scope="attributes" />
			<string name="notes" scope="attributes" />
			<string name="inactiveVisibility" scope="attributes" />
			<string name="activeVisibility" scope="attributes" />
		</in>
		<out>
			<number name="practice_id" scope="formOrUrl" />
			<number name="coach_id" scope="formOrUrl" />
			<number name="facility_id" scope="formOrUrl" />
			<list name="members" scope="formOrUrl" />
			<list name="guests" scope="formOrUrl" />
			<list name="membersOld" scope="formOrUrl" />
			<list name="guestsOld" scope="formOrUrl" />
			<string name="date_start" scope="formOrUrl" />
			<string name="date_end" scope="formOrUrl" />
			<string name="date_practice" scope="formOrUrl" />
			<string name="notes" scope="formOrUrl" />
			<string name="inactiveVisibility" scope="formOrUrl" />
			<string name="activeVisibility" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.date_start" default="#Month(Now())#-1-#Year(Now())#" type="string">
<cfparam name="attributes.date_end" default="#DateFormat(Now(),"M-D-YYYY")#" type="string">
<cfparam name="attributes.coach_id" default=0 type="numeric">
<cfparam name="attributes.facility_id" default=0 type="numeric">
<cfparam name="attributes.members" default="" type="string">
<cfparam name="attributes.guests" default="" type="string">
<cfparam name="attributes.membersOld" default="" type="string">
<cfparam name="attributes.guestsOld" default="" type="string">
<cfparam name="attributes.date_practice" default="#DateFormat(Now(),"M-D-YYYY")#" type="string">
<cfparam name="attributes.notes" default="" type="string">
<cfparam name="attributes.activeVisibility" default="inline" type="string">
<cfparam name="attributes.inactiveVisibility" default="none" type="string">

<cfparam name="variables.success" default="Yes" type="boolean">
<cfparam name="variables.reason" default="" type="string">

<cfscript>
	attributes.date_start = Replace(attributes.date_start,"-","/","ALL");
	attributes.date_end = Replace(attributes.date_end,"-","/","ALL");
	attributes.date_practice = Replace(attributes.date_practice,"-","/","ALL");
</cfscript>

<cfinvoke
	component="#Request.lookup_cfc#"
	method="getUserStatuses"
	returnvariable="qryGuestStatus"
	dsn=#Request.DSN#
	user_statusTbl=#Request.user_statusTbl#
	status="Guest"
>

<cfinvoke
	component="#Request.lookup_cfc#"
	method="getUserStatuses"
	returnvariable="qryMemberStatus"
	dsn=#Request.DSN#
	user_statusTbl=#Request.user_statusTbl#
	status="Member"
>

<cfinvoke
	component="#Request.accounting_cfc#"
	method="updatePractice"
	returnvariable="strSuccess"
	formfields=#attributes#
	dsn=#Request.DSN#
	lookup_cfc=#Request.lookup_cfc#
	usersTbl=#Request.usersTbl#
	guest_status_id=#qryGuestStatus.user_status_id#
	member_status_id=#qryMemberStatus.user_status_id#
	practicesTbl=#Request.practicesTbl#
	transactionTbl=#Request.practice_transactionTbl#
	transaction_typeTbl=#Request.transaction_typeTbl#
	updating_user=#Request.squid.user_id#
>

<cfif NOT strSuccess.success>
	<cfscript>
		attributes.date_start = Replace(attributes.date_start,"/","-","ALL");
		attributes.date_end = Replace(attributes.date_end,"/","-","ALL");
		attributes.date_practice = Replace(attributes.date_practice,"/","-","ALL");

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
	if (VAL(attributes.practice_id) GT 0)
	{
		variables.reason = "Practice Updated&date_start=" & attributes.date_start & "&date_end=" & attributes.date_end;
	}
	else
	{
		variables.reason = "Practice Added&date_start=" & attributes.date_start & "&date_end=" & attributes.date_end;
	}
	variables.theFA = XFA.success;
</cfscript>
