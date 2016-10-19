<!---
<fusedoc
	fuse = "val_issues_edit.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="5 June 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>
			
			<number name="issue_id" scope="attributes" />
			<number name="status_id" scope="attributes" />
			<number name="severity_id" scope="attributes" />
			<number name="assigned_to" scope="attributes" />
			<number name="submitted_by" scope="attributes" />
			<number name="assigned_by" scope="attributes" />
			<string name="description" scope="attributes" />
		</in>
		<out>
			<number name="issue_id" scope="formOrUrl" />
			<number name="status_id" scope="formOrUrl" />
			<number name="assigned_to" scope="formOrUrl" />
			<number name="severity_id" scope="formOrUrl" />
			<number name="submitted_by" scope="formOrUrl" />
			<number name="assigned_by" scope="formOrUrl" />
			<string name="description" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.issue_id" default="0" type="numeric">
<cfparam name="attributes.status_id" default="1" type="numeric">
<cfparam name="attributes.assigned_to" default="1" type="numeric">
<cfparam name="attributes.severity_id" default="1" type="numeric">
<cfparam name="attributes.submitted_by" default="#Request.squid.user_id#" type="numeric">
<cfparam name="attributes.assigned_by" default="#Request.squid.user_id#" type="numeric">
<cfparam name="attributes.description" default="" type="string">
<cfparam name="attributes.verified" default="no" type="boolean">
<cfparam name="attributes.comment" default="" type="string">

<cfparam name="variables.success" default="Yes" type="boolean">
<cfparam name="variables.reason" default="" type="string">

<!--- Update DB --->
<cfinvoke  
	component="#Request.issues_cfc#" 
	method="updateIssue" 
	returnvariable="strSuccess"
	formfields=#attributes#
	updating_user=#Request.squid.user_id#
	detailFA=#XFA.detail#
	dsn=#Request.DSN#
	issueTbl=#Request.issueTbl#
	issue_commentTbl=#Request.issue_commentTbl#
	issue_severityTbl=#Request.issue_severityTbl#
	issue_statusTbl=#Request.issue_statusTbl#
	usersTbl=#Request.usersTbl#
	fromEmail=#Request.from_email#
	issues_path=#Request.issues_path#
>

<cfif NOT strSuccess.success>
	<cfscript>
		variables.theURL = Request.self & "/fuseaction/" & XFA.failure;
		variables.theURL = variables.theURL & "/success/" & strSuccess.success & "/reason/" & strSuccess.reason;
	</cfscript>

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

