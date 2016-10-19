<cfcomponent displayname="Feedback Components" hint="CFC for Feedback">
	<cffunction name="sendFeedback" access="public" displayname="Send Feedback" hint="Sends Feedback" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="feedbackTbl" required="yes" type="string">
		<cfargument name="officerTypeTbl" required="yes" type="string">
		<cfargument name="officerTbl" required="yes" type="string">
		<cfargument name="usersTbl" required="yes" type="string">
		<cfargument name="lookup_cfc" required="yes" type="string">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>		

		<!--- Validate data --->
		<cfscript>
			if (VAL(arguments.formfields.officer_type_id) EQ 0)
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please select whom you wish to contact*";
			}
			if (LEN(TRIM(arguments.formfields.sender_name)) EQ 0)
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter your name.*";
			}
			if (LEN(TRIM(arguments.formfields.sender_email)) EQ 0)
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter your e-mail address.*";
			}
			if (LEN(TRIM(arguments.formfields.content)) EQ 0)
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter your message.*";
			}
		</cfscript>

		<cfif NOT var.success.success>
			<cfreturn var.success>
		</cfif>

		<cftransaction>
			<!--- Get officer info --->
			<cfset lookupCFC = CreateObject("component", lookup_cfc) />
			<cfset qOfficerInfo = lookupCFC.getOfficers(dsn,officerTypeTbl,officerTbl,usersTbl,formfields.officer_type_id,true,false) />

			<!--- Insert into database --->
			<cfquery name="qryInsert" datasource="#arguments.DSN#">
				INSERT INTO
					#arguments.feedbackTbl#
				(
					officer_type_id,
					sender_name,
					sender_email,
					sender_phone,
					subject,
					content
				)
				VALUES
				(
					<cfqueryparam value="#arguments.formfields.officer_type_id#" cfsqltype="CF_SQL_INTEGER">,
					<cfqueryparam value="#arguments.formfields.sender_name#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#arguments.formfields.sender_email#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#arguments.formfields.sender_phone#" cfsqltype="CF_SQL_VARCHAR" null="#IIF(LEN(TRIM(arguments.formfields.sender_phone)),DE("No"),DE("Yes"))#">,
					<cfqueryparam value="#arguments.formfields.subject#" cfsqltype="CF_SQL_VARCHAR" null="#IIF(LEN(TRIM(arguments.formfields.subject)),DE("No"),DE("Yes"))#">,
					<cfqueryparam value="#arguments.formfields.content#" cfsqltype="CF_SQL_LONGVARCHAR">
				)
			</cfquery>
		</cftransaction>

		<!--- Send e-mail --->
<cfmail from="squid@squidswimteam.org" to="#ValueList(qOfficerInfo.email)#" subject="SQUID Feedback -- #arguments.formfields.subject#" server="mail.squidswimteam.org">
<cfmailparam name = "Reply-To" value = "#arguments.formfields.sender_name# <#arguments.formfields.sender_email#>">
#arguments.formfields.sender_name# has submitted the SQUID Feedback Form with the following information:

Sent to:		#qOfficerInfo.officer_type#
E-mail Address:		#arguments.formfields.sender_email#
Phone:			#arguments.formfields.sender_phone#
Subject:		#arguments.formfields.subject#

Message:
#arguments.formfields.content#
</cfmail>

		<cfreturn var.success>
	</cffunction>
</cfcomponent>