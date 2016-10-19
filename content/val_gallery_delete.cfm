<!---
<fusedoc
	fuse = "val_gallery_delete.cfm"
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

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
			<number name="page_id" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.page_id" default=0 type="numeric">

<cfparam name="strSuccess" default="#StructNew()#" type="struct">
<cfparam name="strSuccess.success" default="yes" type="boolean">
<cfparam name="strSuccess.reason" default="" type="string">

<cfinvoke  
	component="#Request.content_cfc#" 
	method="deleteGalleryPage" 
	returnvariable="strSuccess"
	formfields=#attributes#
	dsn=#Request.DSN#
	galleryTbl=#Request.galleryTbl#
	pageTbl=#Request.pageTbl#
	updating_user=#Request.squid.user_id#
>

<cfset variables.reason = strSuccess.reason>

	
