<!---
<fusedoc
	fuse = "val_logout.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I log out.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="4 June 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
			</structure>

			<string name="returnFA" scope="attributes" />

		</in>
		<out>
			<string name="returnFA" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>

</fusedoc>
--->
<cfparam name="variables.success" default="Yes" type="boolean">
<cfparam name="variables.reason" default="" type="string">
<cfparam name="attributes.returnFA" default="home.start" type="string">

<cfset session.squid = {
	"user_id": 0,
	"user": new squid.User(application.dsn, 0)
} />
