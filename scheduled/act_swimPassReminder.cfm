<cfsilent>
	<!--- Send expired reminders and mark notification sent --->
	<cfset request.stFailures = structNew() />

	<!--- Send expiration notices --->
	<cfif request.qExpiredPasses.recordCount GT 0>
		<cfset request.stFailures.qFailedExpirationNotifications = request.scheduledCFC.sendSwimPassExpirationNotifications(request.dsn,request.from_email,"captains@squidswimteam.org,scott@spidermonkeytech.com",request.qExpiredPasses,request.pricePerSwim,"#Request.theServer#/#request.self#?fuseaction=#XFA.buySwims#") />
	<cfelse>
		<cfset request.stFailures.qFailedExpirationNotifications = queryNew("usersSwimPassID","integer") />
	</cfif>

	<!--- Send expiration warnings --->
	<cfif request.qExpiringPasses.recordCount GT 0>
		<cfset request.stFailures.qFailedExpirationWarnings = request.scheduledCFC.sendSwimPassExpirationWarnings(request.dsn,request.from_email,"captains@squidswimteam.org,scott@spidermonkeytech.com",request.qExpiringPasses,request.pricePerSwim,"#Request.theServer#/#request.self#?fuseaction=#XFA.buySwims#") />
	<cfelse>
		<cfset request.stFailures.qFailedExpirationWarningss = queryNew("usersSwimPassID","integer") />
	</cfif>

	<!--- Notify of failed attempts --->
	<cfif request.stFailures.qFailedExpirationNotifications.recordCount GT 0 OR request.stFailures.qFailedExpirationWarnings.recordCount GT 0>
		<cfset request.scheduledCFC.processSwimPassExpirationEmailFailures(request.from_email,"scott@spidermonkeytech.com",request.stFailures) />
	</cfif>
</cfsilent>

COMPLETE