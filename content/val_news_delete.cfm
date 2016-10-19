<!---
<fusedoc
	fuse = "val_news_delete.cfm"
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
			
			<number name="news_id" scope="attributes" />
			<string name="date_from" scope="attributes" />
			<string name="date_to" scope="attributes" />
		</in>
		<out>
			<number name="news_id" scope="formOrUrl" />
			<string name="date_from" scope="formOrUrl" />
			<string name="date_to" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.date_from" default="#DateFormat(Now(),"M-D-YYYY")#" type="string">
<cfparam name="attributes.date_to" default="#DateFormat(DateAdd("M",1,Now()),"M-D-YYYY")#" type="string">
<cfparam name="attributes.news_id" default=0 type="numeric">

<cfset attributes.date_from = Replace(attributes.date_from,"/","-","ALL")>	
<cfset attributes.date_to = Replace(attributes.date_to,"/","-","ALL")>	

<cfparam name="variables.success" default="Yes" type="boolean">
<cfparam name="variables.reason" default="" type="string">

<cfinvoke  
	component="#Request.content_cfc#" 
	method="deleteNews" 
	returnvariable="strSuccess"
	formfields=#attributes#
	dsn=#Request.DSN#
	newsTbl=#Request.newsTbl#
	updating_user=#Request.squid.user_id#
>

<cfif NOT strSuccess.success>
	<cfscript>
		variables.theURL = Request.self & "/fuseaction/" & XFA.failure;
		variables.theURL = variables.theURL & "/success/" & strSuccess.success & "/reason/" & strSuccess.reason;
		variables.theURL = variables.theURL & "/date_from/" & attributes.date_from;
		variables.theURL = variables.theURL & "/date_to/" & attributes.date_to;
	</cfscript>

	<cfset variables.theURL = variables.theURL & ".cfm">

	<cflocation addtoken="no" url="#variables.theURL#"> 
</cfif>

<cfset variables.reason = "News Deleted">
