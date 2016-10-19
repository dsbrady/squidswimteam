<!---
<fusedoc
	fuse = "act_balanceReminder.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I e-mail swimmers with a negative balance.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="18 October 2004" type="Create">
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
<!--- Send e-mail --->
<cfloop query="qBalances">
	<!--- Get unsubscribe content --->
	<cfset unsubscribeContent = membersCFC.getUnsubscribeContent(request.dsn,qBalances.user_id,request.unsubscribeURL,request.encryptionKey,request.encryptionAlgorithm,request.encryptionEncoding) />
<cfmail from="#Request.from_email#" to="#qBalances.email#" subject="Low SQUID Swim Balance" server="mail.squidswimteam.org">
#qBalances.firstName#,

Your swim balance for SQUID is now #qBalances.balance#.  (This is an automated reminder.)

#Wrap("As you know, the money used for swims goes toward paying the coach and for the use of the pool.  Additionally, any other supplies we need to purchase (lane lines, replacement clocks, etc.) come from these funds.",50)#

#Wrap("To reconcile your balance for your past swims, you can either bring cash/check to practice or you can pay online via PayPal. To pay online, please log in to the SQUID web site and view your Profile.",50)#

#Wrap("As a reminder, each practice is $5.",50)#

If you have any questions about your balance, please let us know.

Your friendly neighborhood SQUID Captains

#unsubscribeContent.text#
</cfmail>
</cfloop>

