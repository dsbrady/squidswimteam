<!---
<fusedoc
	fuse = "val_tester_email.cfm"
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

			<number name="return_email" scope="attributes" />
			<number name="subject" scope="attributes" />
			<number name="email_body" scope="attributes" />
		</in>
		<out>
			<number name="return_email" scope="formOrUrl" />
			<number name="subject" scope="formOrUrl" />
			<number name="email_body" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.return_email" default="" type="string">
<cfparam name="attributes.subject" default="" type="string">
<cfparam name="attributes.email_body" default="" type="string">

<cfparam name="variables.success" default="Yes" type="boolean">
<cfparam name="variables.reason" default="" type="string">

<!--- Get all testers --->
<cfinvoke
	component="#Request.lookup_cfc#"
	method="getTesters"
	returnvariable="qryTesters"
	dsn=#Request.DSN#
	testerTbl=#Request.testerTbl#
	usersTbl=#Request.usersTbl#
>

<!--- Send e-mail --->
<cfloop query="qryTesters">
<cfmail server="mail.squidswimteam.org" from="squid@squidswimteam.org" subject="#attributes.subject#" to="#qryTesters.email#">
	<cfmailparam name = "Reply-To" value = "#attributes.return_email#">
#qryTesters.tester#,

#attributes.email_body#

Your login info:
Username:		#qryTesters.username#
Password:		#qryTesters.password#
</cfmail>
</cfloop>

