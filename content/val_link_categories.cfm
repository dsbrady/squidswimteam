<!---
<fusedoc
	fuse = "val_link_categories.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="3 November 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>
			
			<string name="categories" scope="attributes" />
			<string name="categories_old" scope="attributes" />

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
			<string name="categories_old" scope="formOrUrl" />
			<string name="categories" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.categories_old" default="" type="string">
<cfparam name="attributes.categories" default="" type="string">

<cfparam name="strSuccess" default="#StructNew()#" type="struct">
<cfparam name="strSuccess.success" default="yes" type="boolean">
<cfparam name="strSuccess.reason" default="" type="string">

<cfinvoke  
	component="#Request.content_cfc#" 
	method="updateLinkCategories" 
	returnvariable="strSuccess"
	formfields=#attributes#
	dsn=#Request.DSN#
	link_categoryTbl=#Request.link_categoryTbl#
	updating_user=#Request.squid.user_id#
>


<cfset variables.success = strSuccess.success>
<cfset variables.reason = strSuccess.reason>
<cfif NOT variables.success>
	<cfset XFA.success = XFA.failure>
</cfif>

	
