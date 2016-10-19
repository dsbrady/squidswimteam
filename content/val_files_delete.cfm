<!---
<fusedoc
	fuse = "val_files_delete.cfm"
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
			<number name="file_id" scope="attributes" />
			<string name="filename" scope="attributes" />
		</in>
		<out>
			<number name="categoryID" scope="formOrUrl" />
			<number name="fileTypeID" scope="formOrUrl" />
			<number name="file_id" scope="formOrUrl" />
			<string name="filename" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.fileTypeID" default=0 type="numeric">
<cfparam name="attributes.categoryID" default=0 type="numeric">
<cfparam name="attributes.file_id" default=0 type="numeric">
<cfparam name="attributes.filename" default="" type="string">

<cfparam name="variables.success" default="Yes" type="boolean">
<cfparam name="variables.reason" default="" type="string">

<cfinvoke  
	component="#Request.content_cfc#" 
	method="deleteFile" 
	returnvariable="strSuccess"
	formfields=#attributes#
	dsn=#Request.DSN#
	fileTbl=#Request.fileTbl#
	updating_user=#Request.squid.user_id#
	filePath=#Request.content_file_path#
>

<cfif NOT strSuccess.success>
	<cfscript>
		variables.theURL = Request.self & "/fuseaction/" & XFA.failure;
		variables.theURL = variables.theURL & "/success/" & strSuccess.success & "/reason/" & strSuccess.reason;
		variables.theURL = variables.theURL & "/categoryID/" & attributes.categoryID;
		variables.theURL = variables.theURL & "/fileTypeID/" & attributes.fileTypeID;
	</cfscript>

	<cfset variables.theURL = variables.theURL & ".cfm">

	<cflocation addtoken="no" url="#variables.theURL#"> 
</cfif>

<cfset variables.reason = "File Deleted">
