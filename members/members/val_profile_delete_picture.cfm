<!---
<fusedoc
	fuse = "val_profile_delete_picture.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="1 September 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>
		</in>
		<out>
			<number name="user_id" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfset attributes.user_id = Request.squid.user_id>

<cfparam name="attributes.returnFA" default="" type="string">
<cfparam name="attributes.statusType" default="" type="string">
<cfparam name="attributes.activityLevel" default="both" type="string">
<cfparam name="attributes.addNew" default="false" type="boolean">

<cfparam name="variables.success" default="Yes" type="boolean">
<cfparam name="variables.reason" default="" type="string">

<cfinvoke  
	component="#Request.profile_cfc#" 
	method="deletePhoto" 
	returnvariable="strSuccess"
	user_id="#attributes.user_id#"
	image_component="#Request.image_cfc#"
	dsn=#Request.DSN#
	usersTbl=#Request.usersTbl#
	updating_user=#Request.squid.user_id#
	image_path=#Request.member_picture_path#
	image_name=#Request.squid.picture#
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

<!--- Set session values --->
<cfinvoke  
	component="#Request.login_cfc#" 
	method="getUser" 
	returnvariable="Session.squid"
	user=#Session.squid#
	dsn=#Request.DSN#
	usersTbl=#Request.usersTbl#
	developerTbl=#Request.developerTbl#
	preferenceTbl=#Request.preferenceTbl#
	testerTbl=#Request.testerTbl#
	objectsTbl=#Request.objectsTbl#
	officerTbl=#Request.officerTbl#
	officer_typeTbl=#Request.officer_typeTbl#
	officer_permissionTbl=#Request.officer_permissionTbl#
	user_statusTbl=#Request.user_statusTbl#
>
<cfset Request.squid = StructCopy(Session.squid)>


