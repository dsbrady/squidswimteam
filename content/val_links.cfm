<!---
<fusedoc
	fuse = "val_links.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="4 November 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>
			
			<number name="categoryID" scope="attributes" />
			<string name="links" scope="attributes" />
			<string name="links_old" scope="attributes" />

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
			<number name="categoryID" scope="formOrUrl" />
			<string name="links_old" scope="formOrUrl" />
			<string name="links" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.categoryID" default=0 type="numeric">
<cfparam name="attributes.links_old" default="" type="string">
<cfparam name="attributes.links" default="" type="string">

<cfparam name="strSuccess" default="#StructNew()#" type="struct">
<cfparam name="strSuccess.success" default="yes" type="boolean">
<cfparam name="strSuccess.reason" default="" type="string">

<cfinvoke  
	component="#Request.content_cfc#" 
	method="updateLinks" 
	returnvariable="strSuccess"
	formfields=#attributes#
	dsn=#Request.DSN#
	linksTbl=#Request.linksTbl#
	updating_user=#Request.squid.user_id#
>

<cfset variables.success = strSuccess.success>
<cfset variables.reason = strSuccess.reason & "/categoryID/" & attributes.categoryID>
<cfif NOT variables.success>
	<cfset XFA.success = XFA.failure>
</cfif>

	
