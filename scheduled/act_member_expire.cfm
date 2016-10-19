<!---
<fusedoc
	fuse = "act_member_expire.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I expire members.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="2 January 2004" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
		</in>
		<out>
		</out>
	</io>
</fusedoc>
--->
<cfinvoke
	component="#Request.scheduled_cfc#"
	method="expireMembers"
	returnvariable="strSuccess"
	dsn=#Request.DSN#
	usersTbl=#Request.usersTbl#
	user_statusTbl=#Request.user_statusTbl#
	lookup_cfc=#Request.lookup_cfc#
	from_email=#Request.from_email#
	memFA=#XFA.membership#
	unsubscribeURL="#Request.unsubscribeURL#"
	encryptionKey=#request.encryptionKey#
	encryptionAlgorithm=#request.encryptionAlgorithm#
	encryptionEncoding=#request.encryptionEncoding#
>

