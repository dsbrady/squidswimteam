<iframe src="http://sbrady.globalcloud.net/donorDrive/index.cfm?fuseaction=donateSimple.participant&participantID=1000&palette=light&isEmbedded=1" height="700" width="700"></iframe>
<cfabort>
<cfquery name="qU" datasource="squid">
SELECT
	user_id,
	password,
	passwordSalt
FROM
	usersTbl
</cfquery>

<cfloop query="qU">
<cfset salt = RandRange(1000,9999)>
<cfquery name="qUpdate" datasource="squid">
	UPDATE
		usersTbl
	SET
		passwordOld = password,
		password = <cfqueryparam value="#hash(qU.password & salt)#" cfsqltype="CF_SQL_VARCHAR">,
		passwordSalt = <cfqueryparam value="#salt#" cfsqltype="CF_SQL_VARCHAR">
	WHERE
		user_id = <cfqueryparam value="#VAL(qU.user_id)#" cfsqltype="CF_SQL_INTEGER">
</cfquery>
</cfloop>

<cfquery name="qU" datasource="squid">
SELECT
	user_id,
	passwordOld,
	password,
	passwordSalt
FROM
	usersTbl
</cfquery>

<cfdump var="#qU#">