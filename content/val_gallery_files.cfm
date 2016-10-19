<!---
<fusedoc
	fuse = "val_gallery_files.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="18 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>
			
			<number name="page_id" scope="attributes" />
			<string name="files" scope="attributes" />
			<string name="files_old" scope="attributes" />

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
			<number name="page_id" scope="formOrUrl" />
			<string name="files_old" scope="formOrUrl" />
			<string name="files" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.page_id" default=0 type="numeric">
<cfparam name="attributes.files_old" default="" type="string">
<cfparam name="attributes.files" default="" type="string">
<cfparam name="attributes.links_old" default="" type="string">
<cfparam name="attributes.links" default="" type="string">

<cfparam name="strSuccess" default="#StructNew()#" type="struct">
<cfparam name="strSuccess.success" default="yes" type="boolean">
<cfparam name="strSuccess.reason" default="" type="string">

<!--- If changing the files, do update --->
<cfif Compare(attributes.files,attributes.files_old) NEQ 0 OR Compare(attributes.links,attributes.links_old) NEQ 0>
	<cfinvoke  
		component="#Request.content_cfc#" 
		method="updateGalleryFiles" 
		returnvariable="strSuccess"
		formfields=#attributes#
		dsn=#Request.DSN#
		galleryTbl=#Request.galleryTbl#
		updating_user=#Request.squid.user_id#
	>
</cfif>

<cfset variables.reason = strSuccess.reason & "/page_id/" & attributes.page_id>

	
