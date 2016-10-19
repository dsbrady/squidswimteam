<!---
<fusedoc
	fuse = "val_update_content.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="13 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
				<string name="preview" />
			</structure>
			
			<string name="page" scope="attributes" />
			<number name="page_id" scope="attributes" />
			<string name="title" scope="attributes" />
			<string name="content" scope="attributes" />
			<string name="previewBtn" scope="attributes" />
			<string name="submitBtn" scope="attributes" />
			<string name="editBtn" scope="attributes" />
			<boolean name="from_preview" scope="attributes" />
		</in>
		<out>
			<string name="page" scope="formOrUrl" />
			<number name="page_id" scope="formOrUrl" />
			<string name="title" scope="formOrUrl" />
			<string name="content" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->

<cfparam name="attributes.page_id" default="0" type="numeric">
<cfparam name="attributes.page" default="Home" type="string">
<cfparam name="attributes.title" default="" type="string">
<cfparam name="attributes.content" default="" type="string">
<cfparam name="attributes.previewBtn" default="" type="string">
<cfparam name="attributes.submitBtn" default="" type="string">
<cfparam name="attributes.editBtn" default="" type="string">
<cfparam name="attributes.cancelBtn" default="" type="string">
<cfparam name="attributes.from_preview" default="false" type="boolean">

<cfparam name="strSuccess" default="#StructNew()#" type="struct">
<cfparam name="strSuccess.success" default="yes" type="boolean">
<cfparam name="strSuccess.reason" default="" type="string">

<!--- If previewing, set new XFA --->
<cfif LEN(attributes.previewBtn) GT 0>
	<cfset XFA.success = XFA.preview>
<cfelseif LEN(attributes.editBtn) GT 0>
	<cfset XFA.success = XFA.failure>
	<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.success#&page=#attributes.page#&from_preview=true">
</cfif>

<!--- If coming from preview, set form values equal to session values --->
<!--- Else Validate data --->
<cfif (attributes.from_preview) AND LEN(attributes.cancelBtn) EQ 0>
	<cfscript>
		attributes.page_id = Request.squid.content.page_id;
		attributes.page = Request.squid.content.page;
		attributes.title = Request.squid.content.title;
		attributes.content = Request.squid.content.content;
	</cfscript>
<cfelseif LEN(attributes.cancelBtn) EQ 0>
	<cfinvoke  
		component="#Request.content_cfc#" 
		method="validateContent" 
		returnvariable="strSuccess"
		formfields=#attributes#
		dsn=#Request.DSN#
		pageTbl=#Request.pageTbl#
		updating_user=#Request.squid.user_id#
	>
</cfif>

<cfif NOT strSuccess.success>
	<cfscript>
		variables.theURL = Request.self & "?fuseaction=" & XFA.failure;
		variables.theURL = variables.theURL & "&success=" & strSuccess.success & "&reason=" & strSuccess.reason;
	</cfscript>

	<cfloop collection="#attributes#" item="variables.theItem">
		<cfscript>
			if ((variables.theItem IS NOT "SubmitBtn") AND (variables.theItem IS NOT "PreviewBtn") AND (variables.theItem IS NOT "fieldnames") AND (variables.theItem IS NOT "fuseaction") AND (LEN(attributes[variables.theItem])))
			{
				variables.theURL = variables.theURL & "&" & variables.theItem & "=" & attributes[variables.theItem];
			}
		</cfscript>
	</cfloop>

	<cflocation addtoken="no" url="#variables.theURL#" /> 
</cfif>

<!--- If final submission, update database --->
<cfif LEN(attributes.submitBtn) GT 0>

	<cfinvoke  
		component="#Request.content_cfc#" 
		method="updateContent" 
		formfields=#attributes#
		dsn=#Request.DSN#
		pageTbl=#Request.pageTbl#
		updating_user=#Request.squid.user_id#
	>

	<!--- Kill session variables for content and set reason --->
	<cfscript>
		StructDelete(Session.squid,"content",true);
		variables.reason = attributes.page & " Page Updated.&page=" & attributes.page;
	</cfscript>
<cfelseif LEN(attributes.cancelBtn) GT 0>
	<!--- Kill session variables for content and set reason --->
	<cfscript>
		StructDelete(Session.squid,"content",true);
		variables.reason = attributes.page & " Changes Cancelled.&page=" & attributes.page;
	</cfscript>
<cfelse>
	<cfset Session.squid.content = StructNew()>
	<cfset Session.squid.content.title = strSuccess.title>
	<cfset Session.squid.content.content = strSuccess.content>
	<cfset Session.squid.content.page_id = attributes.page_id>
	<cfset Session.squid.content.page = attributes.page>
</cfif>

	
