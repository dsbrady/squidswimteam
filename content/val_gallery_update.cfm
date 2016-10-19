<!---
<fusedoc
	fuse = "val_gallery_update.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="15 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>
			
			<number name="page_id" scope="attributes" />
			<string name="title" scope="attributes" />
			<string name="title_old" scope="attributes" />

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
			<number name="page_id" scope="formOrUrl" />
			<string name="title" scope="formOrUrl" />
			<string name="title_old" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.page_id" default=0 type="numeric">
<cfparam name="attributes.title" default="" type="string">
<cfparam name="attributes.title_old" default="" type="string">

<cfparam name="strSuccess" default="#StructNew()#" type="struct">
<cfparam name="strSuccess.success" default="yes" type="boolean">
<cfparam name="strSuccess.reason" default="Changes Saved" type="string">

<!--- If changing the title, do insert/update --->
<cfif Compare(attributes.title,attributes.title_old) NEQ 0>
	<cfinvoke  
		component="#Request.content_cfc#" 
		method="validateGalleryPage"
		returnvariable="strSuccess"
		formfields=#attributes#
	>

	<cfinvoke  
		component="#Request.content_cfc#" 
		method="updateGalleryPage" 
		returnvariable="strSuccess"
		formfields=#attributes#
		dsn=#Request.DSN#
		pageTbl=#Request.pageTbl#
		updating_user=#Request.squid.user_id#
		lookup_cfc=#Request.lookup_cfc#
	>
	<cfset attributes.page_id = strSuccess.page_id>
</cfif>

<cfset variables.reason = strSuccess.reason & "/page_id/" & attributes.page_id>

	
