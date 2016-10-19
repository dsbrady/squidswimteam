<!---
<fusedoc
	fuse = "val_change_password.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="3 June 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>
			
			<string name="password_old" scope="attributes" />
			<string name="password_confirm" scope="attributes" />
			<string name="password" scope="attributes" />
			<string name="returnFA" scope="attributes" />

			<structure name="strUser">
				<number name="user_id" />
			</recordset>
		</in>
		<out>
			<string name="password_old" scope="formOrUrl" />
			<string name="password_confirm" scope="formOrUrl" />
			<string name="password" scope="formOrUrl" />
			<string name="returnFA" scope="formOrUrl" />

			<structure name="strUser">
				<number name="user_id" />
			</recordset>

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>

</fusedoc>
--->
<cfparam name="variables.success" default="Yes" type="boolean">
<cfparam name="variables.reason" default="" type="string">
<cfparam name="attributes.password_old" default="" type="string">
<cfparam name="attributes.password" default="" type="string">
<cfparam name="attributes.password_confirm" default="" type="string">
<cfparam name="attributes.returnFA" default="" type="string">

<cfinvoke  
	component="#Request.password_cfc#" 
	method="changePassword" 
	returnvariable="strSuccess"
	pass_old=#attributes.password_old#
	pass=#attributes.password#
	pass_confirm=#attributes.password_confirm#
	user_id=#Request.squid.user_id#
	dsn=#Request.DSN#
	usersTbl=#Request.usersTbl#
	preferenceTbl=#Request.preferenceTbl#
	fromEmail=#Request.from_email#
>

<cfif NOT strSuccess.success>
	<cflocation url="#Request.self#?fuseaction=#XFA.failure#&returnFA=#attributes.returnFA#&success=#strSuccess.success#&reason=#strSuccess.reason#" />
<cfelse>
	<cflock scope="SESSION" type="EXCLUSIVE" timeout="30">
		<cfset Session.squid.tempPassword = 0>
		<cfset Session.squid.password = attributes.password>
	</cflock>
</cfif>


