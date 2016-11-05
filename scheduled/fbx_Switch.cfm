<!---
<fusedoc fuse="FBX_Switch.cfm">
	<responsibilities>
		I am the cfswitch statement that handles the fuseaction, delegating work to various fuses.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="15 December 2002" role="Architect">
	</properties>
	<io>
		<in>
			<structure name="fuxebox">
				<string name="fuseaction" />
				<string name="circuit" />
			</structure>
		</in>
	</io>
</fusedoc>
 --->

<cfswitch expression = "#fusebox.fuseaction#">
<!--- ----------------------------------------
EXPIRATION
----------------------------------------- --->
	<cfcase value="act_member_expire">
	<cfsilent>
	<!--- Sets expired members to nonmembers --->
		<cfscript>
			Request.suppressLayout = true;

			Request.members_cfc = Request.cfcPath & ".members";
			Request.template = "act_member_expire.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

<!--- ----------------------------------------
SWIM BALANCES
----------------------------------------- --->
	<cfcase value="balanceReminders">
	<cfsilent>
	<!--- Sets expired members to nonmembers --->
		<cfscript>
			Request.suppressLayout = true;

			lookupCFC = CreateObject("component",Request.lookup_cfc);
			membersCFC = CreateObject("component","squidswimteam.cfc.members");
			qBalances = lookupCFC.getNegativeBalances(Request.dsn,Request.usersTbl,Request.preferenceTbl,Request.practice_transactionTbl,Request.activityDays);
			Request.template = "act_balanceReminder.cfm";
		</cfscript>

	</cfsilent>
		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="balanceNotifications">
	<cfsilent>
	<!--- Sends out balanceNotifications --->
		<cfset request.suppressLayout = true />

		<cfset request.replyToAddress = "treasurer@squidswimteam.org,scott@spidermonkeytech.com" />
		<cfset request.scheduledCFC = createObject("component",request.scheduled_cfc) />
		<cfset request.scheduledCFC.processBalanceNotifications(request.dsn,request.unsubscribeURL,request.encryptionKey,request.encryptionAlgorithm,request.encryptionEncoding,request.from_email,request.replyToAddress) />
		<cfset request.template = "act_balanceNotifications.cfm" />

	</cfsilent>
		<cfinclude template="#Request.template#">
	</cfcase>

<!--- ----------------------------------------
SWIM PASS REMINDERS
----------------------------------------- --->
	<cfcase value="swimPassReminders">
	<cfsilent>
	<!--- Sends out reminders for swim passes that are about to expire and those that have expired --->
		<cfscript>
			Request.suppressLayout = true;
			XFA.buySwims = "buySwims.home";

			request.reminderDays1 = 7;
			request.reminderDays2 = 3;
			lookupCFC = createObject("component",request.lookup_cfc);
			membersCFC = createObject("component","squidswimteam.cfc.members");
			request.scheduledCFC = createObject("component",request.scheduled_cfc);
			request.qExpiredPasses = lookupCFC.getExpiredSwimPasses(request.dsn);
			request.qExpiringPasses = lookupCFC.getExpiringSwimPasses(request.dsn,request.reminderDays1,request.reminderDays2);
			Request.template = "act_swimPassReminder.cfm";
		</cfscript>

	</cfsilent>
		<cfinclude template="#Request.template#">
	</cfcase>


	<cfdefaultcase>
		<!---This will just display an error message and is useful in catching typos of fuseaction names while developing--->
		<cfoutput><p>This is the cfdefaultcase tag. I received a fuseaction called <strong>"#attributes.fuseaction#"</strong> and I don't know what to do with it.</p></cfoutput>
	</cfdefaultcase>

</cfswitch>
