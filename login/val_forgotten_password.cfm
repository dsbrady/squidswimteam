<!---
<fusedoc
	fuse = "val_forgotten_password.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate the forgotten password.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="4 June 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>

			<string name="username" scope="attributes" />
			<string name="returnFA" scope="attributes" />

		</in>
		<out>
			<string name="username" scope="formOrUrl" />
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
<cfparam name="attributes.returnFA" default="" type="string">

<cfinvoke
	component="#Request.password_cfc#"
	method="forgottenPassword"
	returnvariable="strSuccess"
	user_name=#attributes.username#
	dsn=#Request.DSN#
	usersTbl=#Request.usersTbl#
	preferenceTbl=#Request.preferenceTbl#
	fromEmail=#Request.from_email#
>

<cfif NOT strSuccess.success>
	<cflocation url="#Request.self#?fuseaction=#XFA.failure#&returnFA=#attributes.returnFA#&success+#strSuccess.success#&reason=#strSuccess.reason#">
</cfif>


