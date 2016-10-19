<cfquery name="q" datasource="squid">
	SELECT 
		u.email,
		iif(u.preferred_name IS NULL, u.first_name, u.preferred_name) AS firstName,
		u.last_name,
		SUM(pt.num_swims) AS balance,
		MAX(pt.date_transaction) AS lastTrans,
		p.preference
	FROM
		usersTbl u,
		practice_transactionTbl pt,
		preferenceTbl p
	WHERE
		u.user_id = pt.member_id
		AND u.email_preference = p.preference_id
		AND pt.active_code = 1
		AND u.email IS NOT NULL
		AND u.email <> ''
	GROUP BY
		pt.member_id,
		u.last_name,
		u.first_name,
		iif(u.preferred_name IS NULL, u.first_name, u.preferred_name),
		u.email,
		p.preference
	HAVING
		SUM(pt.num_swims) < 0
		AND MAX(pt.date_transaction) > <cfqueryparam value="#CreateODBCDate(CreateDate(2003,1,1))#" cfsqltype="CF_SQL_DATE">
	ORDER BY
		UCASE(u.last_name), UCASE(u.first_name)
</cfquery>

<cfdump var="#q#">
<cfabort>
<cfloop query="q">
<cfmail from="squid@squidswimteam.org" to="#q.email#" subject="Low SQUID Swim Balance" server="mail.squidswimteam.org">
#q.firstName#,

Your swim balance for SQUID is now #q.balance#.  

#Wrap("As you know, the money used for swims goes toward paying the coach and for the use of the pool.  Additionally, any other supplies we need to purchase (lane lines, replacement clocks, etc.) come from these funds.",50)#

#Wrap("To reconcile your balance for your past swims, you can either bring cash/check to practice or send a check to:",50)#

SQUID#chr(10)#PO Box 480921#chr(10)#Denver, CO 80218

#Wrap("As a reminder, each practice is $3.  If you have paid your 2004 membership to SQUID, you can pay $30 and get 11 swims.",50)#

If you have any questions about your balance, please let us know.

Scott Brady
Corey Parker
</cfmail>
</cfloop>
Mails sent to:<br />
<cfoutput>#ValueList(q.email,"<br />")#</cfoutput>
