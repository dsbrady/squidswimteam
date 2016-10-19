<!---
<fusedoc
	fuse = "val_login.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate the login.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="27 May 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
				<string name="changePassword" />
			</structure>

			<string name="username" scope="attributes" />
			<string name="password" scope="attributes" />
			<string name="returnFA" scope="attributes" />

			<structure name="strUser">
				<number name="user_id" />
				<string name="username" />
				<string name="password" />
				<boolean name="tempPassword" />
				<number name="created_user" />
				<datetime name="created_date" />
				<number name="modified_user" />
				<datetime name="modified_date" />
				<number name="active_code" />
			</recordset>
		</in>
		<out>
			<string name="username" scope="formOrUrl" />
			<string name="password" scope="formOrUrl" />
			<string name="returnFA" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>

</fusedoc>
--->
<cfparam name="variables.success" default="Yes" type="boolean">
<cfparam name="variables.reason" default="" type="string">
<cfparam name="attributes.username" default="" type="string">
<cfparam name="attributes.password" default="" type="string">
<cfparam name="attributes.returnFA" default="" type="string">

<cfinvoke
	component="#Request.login_cfc#"
	method="checkLogin"
	returnvariable="strUser"
	user=#attributes.username#
	pass=#attributes.password#
	dsn=#Request.DSN#
	usersTbl=#Request.usersTbl#
>

<!--- First, see if the login was successful --->
<cfscript>
	if (NOT strUser.success)
	{
		variables.success = "No";
		variables.reason = strUser.reason;
	}
</cfscript>

<cfif NOT variables.success>
	<cflocation addtoken="No" url="#Request.self#?fuseaction=#XFA.failure#&username=#attributes.username#&returnFA=#attributes.returnFA#&success=#variables.success#&reason=#variables.reason#">
</cfif>

<!--- If they're successful, get User info --->
<cfinvoke
	component="#Request.login_cfc#"
	method="getUser"
	returnvariable="strUser"
	user=#strUser#
	dsn=#Request.DSN#
	usersTbl=#Request.usersTbl#
	developerTbl=#Request.developerTbl#
	testerTbl=#Request.testerTbl#
	preferenceTbl=#Request.preferenceTbl#
	objectsTbl=#Request.objectsTbl#
	officerTbl=#Request.officerTbl#
	officer_typeTbl=#Request.officer_typeTbl#
	officer_permissionTbl=#Request.officer_permissionTbl#
	user_statusTbl=#Request.user_statusTbl#
>

<!--- See if they are a member --->
<cfif strUser.statusType NEQ "Member">
	<cflocation addtoken="No" url="#Request.self#?fuseaction=#XFA.expired#&reason=Guest&first_name=#strUser.preferred_name#&user_id=#strUser.user_id#&username=#strUser.username#&created_date=#strUser.created_date#&created_user=#strUser.created_user#">
</cfif>

<!--- See if their membership has expired --->
<cfif DateCompare(strUser.date_expiration,Now()) LT 0>
	<cflocation addtoken="No" url="#Request.self#?fuseaction=#XFA.expired#&reason=Expired&date_expiration=#DateFormat(strUser.date_expiration,"MMMM D, YYYY")#&first_name=#strUser.preferred_name#&user_id=#strUser.user_id#&username=#strUser.username#&created_date=#strUser.created_date#&created_user=#strUser.created_user#">
</cfif>

<!--- Clear out session --->
<cfset tmp = StructClear(Session.squid)>

<!--- Set new session --->
<cflock scope="SESSION" timeout="30" type="EXCLUSIVE">
	<cfset Session.squid = strUser>
	<cfset Request.squid = StructCopy(Session.squid)>
</cflock>

<!--- See if the password is temporary --->
<cfscript>
	if (Request.squid.tempPassword)
	{
		XFA.success = XFA.changePassword & "&returnFA=" & attributes.returnFA;
	}
	else
	{
		XFA.success = attributes.returnFA;
	}
</cfscript>

