<!---
<fusedoc
	fuse = "val_files_upload.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="9 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>
			
			<number name="categoryID" scope="attributes" />
			<number name="fileTypeID" scope="attributes" />
			<number name="category_id" scope="attributes" />
			<number name="file_type_id" scope="attributes" />
			<string name="new_category" scope="attributes" />
		</in>
		<out>
			<number name="categoryID" scope="formOrUrl" />
			<number name="fileTypeID" scope="formOrUrl" />
			<number name="category_id" scope="formOrUrl" />
			<number name="file_type_id" scope="formOrUrl" />
			<string name="new_category" scope="formOrUrl" />
			<string name="filename" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.fileTypeID" default=0 type="numeric">
<cfparam name="attributes.categoryID" default=0 type="numeric">
<cfparam name="attributes.category_id" default=0 type="numeric">
<cfparam name="attributes.new_category" default="" type="string">
<cfparam name="attributes.file_type_id" default=0 type="numeric">
<cfparam name="attributes.filename" default="" type="string">

<cfparam name="variables.success" default="Yes" type="boolean">
<cfparam name="variables.reason" default="" type="string">

<cfinvoke  
	component="#Request.content_cfc#" 
	method="uploadFile" 
	returnvariable="strSuccess"
	formfields=#attributes#
	dsn=#Request.DSN#
	fileTbl=#Request.fileTbl#
	categoryTbl=#Request.file_categoryTbl#
	file_typeTbl=#Request.file_typeTbl#
	lookup_cfc = #Request.lookup_cfc#
	updating_user=#Request.squid.user_id#
	file_path=#Request.content_file_path#
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

<cfset variables.reason = "File Uploaded">
