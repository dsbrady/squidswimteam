<!---
<fusedoc
	fuse = "val_feedback.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="26 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>
			
			<number name="officer_type_id" scope="attributes" />
			<string name="sender_name" scope="attributes" />
			<string name="sender_email" scope="attributes" />
			<string name="sender_phone" scope="attributes" />
			<string email="subject" scope="attributes" />
			<string name="content" scope="attributes" />
		</in>
		<out>
			<number name="officer_type_id" scope="formOrUrl" />
			<string name="sender_name" scope="formOrUrl" />
			<string name="sender_email" scope="formOrUrl" />
			<string name="sender_phone" scope="formOrUrl" />
			<string email="subject" scope="formOrUrl" />
			<string name="content" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.officer_type_id" default=0 type="numeric">
<cfparam name="attributes.sender_name" default="" type="string">
<cfparam name="attributes.sender_email" default="" type="string">
<cfparam name="attributes.sender_phone" default="" type="string">
<cfparam name="attributes.subject" default="" type="string">
<cfparam name="attributes.content" default="" type="string">

<cfparam name="variables.success" default="Yes" type="boolean">
<cfparam name="variables.reason" default="" type="string">

<cfset Cffp = createObject("component","cfformprotect.cffpVerify").init() />
<cfif Cffp.testSubmission(form)>

	<cfinvoke  
		component="#Request.feedback_cfc#" 
		method="sendFeedback" 
		returnvariable="strSuccess"
		formfields=#attributes#
		dsn=#Request.DSN#
		feedbackTbl=#Request.feedbackTbl#
		officerTypeTbl=#Request.officer_typeTbl#
		officerTbl=#Request.officerTbl#
		usersTbl=#Request.usersTbl#
		lookup_cfc=#Request.lookup_cfc#
	>
<cfelse>
	<cfset strSuccess.success = false />
	<cfset strSuccess.reason = "Your feedback appears to be spam. Please try again." />
</cfif>


<cfif NOT strSuccess.success>
	<cfscript>
		variables.theURL = request.theServer & "/" & Request.self & "?fuseaction=" & XFA.failure;
		variables.theURL = variables.theURL & "&success=" & strSuccess.success & "&reason=" & strSuccess.reason;
	</cfscript>

	<cfloop collection="#attributes#" item="variables.theItem">
		<cfscript>
			if ((variables.theItem IS NOT "SubmitBtn") AND (variables.theItem IS NOT "fieldnames") AND (variables.theItem IS NOT "fuseaction") AND (variables.theItem IS NOT "content") AND (LEN(attributes[variables.theItem])))
			{
				variables.theURL = variables.theURL & "&" & variables.theItem & "=" & urlEncodedFormat(attributes[variables.theItem]);
			}
		</cfscript>
	</cfloop>

	<cflocation addtoken="no" url="#variables.theURL#"> 
</cfif>

