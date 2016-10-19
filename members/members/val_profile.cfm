<!---
<fusedoc
	fuse = "val_profile.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="5 June 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>

			<number name="user_id" scope="attributes" />
			<string name="username" scope="attributes" />
			<string name="first_name" scope="attributes" />
			<string name="middle_name" scope="attributes" />
			<string name="last_name" scope="attributes" />
			<string name="preferred_name" scope="attributes" />
			<string name="address1" scope="attributes" />
			<string name="address2" scope="attributes" />
			<string name="city" scope="attributes" />
			<string name="state_id" scope="attributes" />
			<string name="zip" scope="attributes" />
			<string name="country" scope="attributes" />
		</in>
		<out>
			<number name="user_id" scope="formOrUrl" />
			<string name="username" scope="formOrUrl" />
			<string name="username_old" scope="formOrUrl" />
			<string name="first_name" scope="formOrUrl" />
			<string name="first_name_old" scope="formOrUrl" />
			<string name="middle_name" scope="formOrUrl" />
			<string name="middle_name_old" scope="formOrUrl" />
			<string name="last_name" scope="formOrUrl" />
			<string name="last_name_old" scope="formOrUrl" />
			<string name="preferred_name" scope="formOrUrl" />
			<string name="preferred_name_old" scope="formOrUrl" />
			<string name="address1" scope="formOrUrl" />
			<string name="address1_old" scope="formOrUrl" />
			<string name="address2" scope="formOrUrl" />
			<string name="address2_old" scope="formOrUrl" />
			<string name="city" scope="formOrUrl" />
			<string name="city_old" scope="formOrUrl" />
			<string name="state_id" scope="formOrUrl" />
			<string name="state_id_old" scope="formOrUrl" />
			<string name="zip" scope="formOrUrl" />
			<string name="zip_old" scope="formOrUrl" />
			<string name="country" scope="formOrUrl" />
			<string name="country_old" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.user_id" default="#Request.squid.user_id#" type="numeric">
<cfparam name="attributes.username" default="" type="string">
<cfparam name="attributes.username_old" default="" type="string">
<cfparam name="attributes.first_name" default="" type="string">
<cfparam name="attributes.first_name_old" default="" type="string">
<cfparam name="attributes.middle_name" default="" type="string">
<cfparam name="attributes.middle_name_old" default="" type="string">
<cfparam name="attributes.last_name" default="" type="string">
<cfparam name="attributes.last_name_old" default="" type="string">
<cfparam name="attributes.preferred_name" default="" type="string">
<cfparam name="attributes.preferred_name_old" default="" type="string">
<cfparam name="attributes.address1" default="" type="string">
<cfparam name="attributes.address1_old" default="" type="string">
<cfparam name="attributes.address2" default="" type="string">
<cfparam name="attributes.address2_old" default="" type="string">
<cfparam name="attributes.city" default="" type="string">
<cfparam name="attributes.city_old" default="" type="string">
<cfparam name="attributes.state_id" default="CO" type="string">
<cfparam name="attributes.state_id_old" default="" type="string">
<cfparam name="attributes.zip" default="" type="string">
<cfparam name="attributes.zip_old" default="" type="string">
<cfparam name="attributes.country" default="" type="string">
<cfparam name="attributes.country_old" default="" type="string">
<cfparam name="attributes.email" default="" type="string">
<cfparam name="attributes.birthday" default="" type="string">
<cfparam name="attributes.phone_cell" default="" type="string">
<cfparam name="attributes.phone_day" default="" type="string">
<cfparam name="attributes.phone_night" default="" type="string">
<cfparam name="attributes.fax" default="" type="string">
<cfparam name="attributes.contact_emergency" default="" type="string">
<cfparam name="attributes.phone_emergency" default="" type="string">
<cfparam name="attributes.first_practice" default="" type="string">
<cfparam name="attributes.intro_pass" default="0" type="boolean">
<cfparam name="attributes.usms_no" default="" type="string">
<cfparam name="attributes.usms_year" default="" type="string">
<cfparam name="attributes.medical_conditions" default="" type="string">
<cfparam name="attributes.comments" default="" type="string">
<cfparam name="attributes.picture" default="" type="string">
<cfparam name="attributes.picture_width" default="" type="string">
<cfparam name="attributes.picture_height" default="" type="string">
<cfparam name="attributes.officer_type_id" default="" type="string">
<cfparam name="attributes.profile_visible" default="0" type="boolean">
<cfparam name="attributes.date_expiration" default="" type="string">
<cfparam name="attributes.email_preference" default="1" type="numeric">
<cfparam name="attributes.posting_preference" default="3" type="numeric">
<cfparam name="attributes.calendar_preference" default="6" type="numeric">
<cfparam name="attributes.mailingListYN" default="0" type="boolean" />

<cfparam name="attributes.returnFA" default="" type="string">
<cfparam name="attributes.statusType" default="" type="string">
<cfparam name="attributes.activityLevel" default="both" type="string">
<cfparam name="attributes.addNew" default="false" type="boolean">

<cfparam name="variables.success" default="Yes" type="boolean">
<cfparam name="variables.reason" default="" type="string">

<cfinvoke
	component="#Request.profile_cfc#"
	image_component="#Request.image_cfc#"
	method="updateProfile"
	returnvariable="strSuccess"
	formfields=#attributes#
	dsn=#Request.DSN#
	usersTbl=#Request.usersTbl#
	updating_user=#Request.squid.user_id#
	image_path=#Request.member_picture_path#
	image_name=#attributes.username_old#
	imageField="picture"
>

<cfif NOT strSuccess.success>
	<cfscript>
		attributes.date_expiration = Replace(attributes.date_expiration,"/","-","ALL");
		attributes.birthday = Replace(attributes.birthday,"/","-","ALL");
		attributes.first_practice = Replace(attributes.first_practice,"/","-","ALL");

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

<!--- If changed current user, set session values --->
<cfif attributes.user_id EQ Request.squid.user_id>
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
</cfif>


