<cfcomponent displayname="Issues Components" hint="CFC for Issues">
	<cffunction name="getIssues" access="public" displayname="Issue/Bug Info" hint="Gets Issue/Bug Info" output="No" returntype="query">
		<cfargument name="issue_id" required="no" type="numeric" default="0">
		<cfargument name="status_id" required="no" type="numeric" default="0">
		<cfargument name="assigned_to" required="no" type="numeric" default="0">
		<cfargument name="severity_id" required="no" type="numeric" default="0">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="usersTbl" required="no" type="string" default="usersTbl">
		<cfargument name="issueTbl" required="no" type="string" default="issueTbl">
		<cfargument name="issue_severityTbl" required="no" type="string" default="issue_severityTbl">
		<cfargument name="issue_statusTbl" required="no" type="string" default="issue_statusTbl">
		<cfargument name="orderBy" required="no" type="string" default="i.status_id ASC,i.severity_id ASC,i.issue_id ASC">

		<!--- Run query --->
		<cfquery name="qryIssues" datasource="#arguments.dsn#">
			SELECT
				i.issue_id,
				i.submitted_by,
				i.assigned_by,
				i.assigned_to,
				i.severity_id,
				i.status_id,
				i.attachment,
				i.verified,
				isev.severity,
				ist.status,
				sb.preferred_name + ' ' + sb.last_name AS submittedBy_name,
				ab.preferred_name + ' ' + ab.last_name AS assignedBy_name,
				at.preferred_name + ' ' + at.last_name AS assignedTo_name,
				i.description
			FROM
				#arguments.issueTbl# i,
				#arguments.issue_severityTbl# isev,
				#arguments.issue_statusTbl# ist,
				#arguments.usersTbl# sb,
				#arguments.usersTbl# ab,
				#arguments.usersTbl# at
			WHERE
				i.severity_id = isev.severity_id
				AND i.status_id = ist.status_id
				AND i.assigned_by = ab.user_id
				AND i.assigned_to = at.user_id
				AND i.submitted_by = sb.user_id
				AND i.active_code = 1
			<cfif VAL(arguments.issue_id) GT 0>
				AND i.issue_id = <cfqueryparam value="#VAL(arguments.issue_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			<cfif VAL(arguments.status_id) GT 0>
				AND i.status_id = <cfqueryparam value="#VAL(arguments.status_id)#" cfsqltype="CF_SQL_INTEGER">
			<cfelse>
				AND ist.status <> <cfqueryparam value="Deleted" cfsqltype="CF_SQL_VARCHAR">
			</cfif>
			<cfif VAL(arguments.severity_id) GT 0>
				AND i.severity_id = <cfqueryparam value="#VAL(arguments.severity_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			<cfif VAL(arguments.assigned_to) GT 0>
				AND i.assigned_to = <cfqueryparam value="#VAL(arguments.assigned_to)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
		ORDER BY
			#arguments.orderBy#
		</cfquery>

		<cfreturn qryIssues>
	</cffunction>

	<cffunction name="updateIssue" access="public" displayname="Updates Issue" hint="Updates Issue" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="detailFA" required="no" type="string" default="members.dsp_issues_detail">
		<cfargument name="updating_user" required="yes" type="numeric">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="issueTbl" required="no" type="string" default="issueTbl">
		<cfargument name="issue_commentTbl" required="yes" type="string">
		<cfargument name="issue_severityTbl" required="yes" type="string">
		<cfargument name="issue_statusTbl" required="yes" type="string">
		<cfargument name="usersTbl" required="no" type="string" default="usersTbl">
		<cfargument name="fromEmail" required="yes" type="string">
		<cfargument name="issues_path" required="yes" type="string">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>		

		<!--- Validate data --->
		<cfscript>
			if (NOT LEN(trim(arguments.formfields.description)))
			{
				var.success.success = "No";
				var.success.reason = "Please enter the description.*";
			}
		</cfscript>
		
		<cfif NOT var.success.success>
			<cfreturn var.success>
		</cfif>

		<cfset var.attachmentFile = "">
		<!--- See if there's a file to upload --->
		<cfif LEN(TRIM(arguments.formfields.attachment))>
			<!--- Delete old file --->
			<cfif LEN(TRIM(arguments.formfields.attachment_old)) AND FileExists("#arguments.issues_path#\#arguments.formfields.attachment_old#")>
				<cffile action="DELETE" file="#arguments.issues_path#\#arguments.formfields.attachment_old#">
			</cfif>

			<!--- Upload file --->
			<cffile action="UPLOAD" filefield="attachment" destination="#arguments.issues_path#" nameconflict="MAKEUNIQUE" accept="image/gif,image/jpeg,image/pjpeg,application/pdf">
			<cfset var.attachmentFile = CFFILE.serverFile>
		</cfif>

		<!--- Update database --->
		<cftransaction action="BEGIN">
			<cftry>
				<!--- Update --->
				<cfif arguments.formfields.issue_id GT 0>
					<cfquery name="qryUpdate" datasource="#arguments.dsn#">
						UPDATE
							#arguments.issueTbl#
						SET
							submitted_by = <cfqueryparam value="#arguments.formfields.submitted_by#" cfsqltype="CF_SQL_INTEGER">,
							assigned_to = <cfqueryparam value="#arguments.formfields.assigned_to#" cfsqltype="CF_SQL_INTEGER">,
							assigned_by = <cfqueryparam value="#arguments.formfields.assigned_by#" cfsqltype="CF_SQL_INTEGER">,
							severity_id = <cfqueryparam value="#arguments.formfields.severity_id#" cfsqltype="CF_SQL_INTEGER">,
							status_id = <cfqueryparam value="#arguments.formfields.status_id#" cfsqltype="CF_SQL_INTEGER">,
							description = <cfqueryparam value="#arguments.formfields.description#" cfsqltype="CF_SQL_LONGVARCHAR">,
							verified = <cfqueryparam value="#arguments.formfields.verified#" cfsqltype="CF_SQL_BIT">,
							attachment = <cfqueryparam value="#var.attachmentFile#" cfsqltype="CF_SQL_VARCHAR">,
							modified_user = <cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
							modified_date = GetDate()
						WHERE
							issue_id = <cfqueryparam value="#arguments.formfields.issue_id#" cfsqltype="CF_SQL_INTEGER">
					</cfquery>

					<cfset var.success.action = "Updated">
				<!--- Insert --->
				<cfelse>
					<cfquery name="qryInsert" datasource="#arguments.dsn#">
						INSERT INTO
							#arguments.issueTbl#
						(
							submitted_by,
							assigned_to,
							assigned_by,
							severity_id,
							status_id,
							description,
							attachment,
							created_user,
							modified_user
						)
						VALUES
						(
							<cfqueryparam value="#arguments.formfields.submitted_by#" cfsqltype="CF_SQL_INTEGER">,
							<cfqueryparam value="#arguments.formfields.assigned_to#" cfsqltype="CF_SQL_INTEGER">,
							<cfqueryparam value="#arguments.formfields.assigned_by#" cfsqltype="CF_SQL_INTEGER">,
							<cfqueryparam value="#arguments.formfields.severity_id#" cfsqltype="CF_SQL_INTEGER">,
							<cfqueryparam value="#arguments.formfields.status_id#" cfsqltype="CF_SQL_INTEGER">,
							<cfqueryparam value="#arguments.formfields.description#" cfsqltype="CF_SQL_LONGVARCHAR">,
							<cfqueryparam value="#var.attachmentFile#" cfsqltype="CF_SQL_VARCHAR">,
							<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
							<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">
						)
					</cfquery>
					
					<!--- Get new ID --->
					<cfquery name="qryNewID" datasource="#arguments.dsn#">
						SELECT
							MAX(i.issue_id) AS issue_id
						FROM
							#arguments.issueTbl# i
					</cfquery>
				
					<cfset arguments.formfields.issue_id = qryNewID.issue_id>				
					<cfset var.success.action = "Added">
				</cfif>
				<cfif LEN(TRIM(arguments.formfields.comment)) GT 0>
					<cfquery name="qryInsertComment" datasource="#arguments.dsn#">
						INSERT INTO
							#arguments.issue_commentTbl#
						(
							issue_id,
							comment,
							created_user,
							modified_user
						)
						VALUES
						(
							<cfqueryparam value="#VAL(arguments.formfields.issue_id)#" cfsqltype="CF_SQL_INTEGER">,
							<cfqueryparam value="#arguments.formfields.comment#" cfsqltype="CF_SQL_LONGVARCHAR">,
							<cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
							<cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">
						)
					</cfquery>
				</cfif>
				<cfcatch type="Any">
					<cftransaction action="ROLLBACK" />
					<cfscript>
						var.success.success = "No";
						var.success.reason = "There was a database error.*";
					</cfscript>
					<cfreturn var.success>
				</cfcatch>
			</cftry>
		</cftransaction>

		<cfif NOT var.success.success>
			<cfreturn var.success>
		</cfif>

		<!--- Get issue details --->
		<cfinvoke  
			component="#this#" 
			method="getIssues" 
			returnvariable="qryIssues"
			issue_id=#arguments.formfields.issue_id#
			status_id=#arguments.formfields.status_id#
			dsn=#arguments.DSN#
			usersTbl=#arguments.usersTbl#
			issueTbl=#arguments.issueTbl#
			issue_severityTbl=#arguments.issue_severityTbl#
			issue_statusTbl=#arguments.issue_statusTbl#
		>
		
		<cfinvoke  
			component="#this#" 
			method="getIssueComments" 
			returnvariable="qryComments"
			issue_id=#arguments.formfields.issue_id#
			dsn=#arguments.DSN#
			usersTbl=#arguments.usersTbl#
			issue_commentTbl=#arguments.issue_commentTbl#
		>

<!--- Generate e-mail content --->
<cfoutput>
<cfsavecontent variable="var.success.emailContent">
SQUID Issue ###arguments.formfields.issue_id# has been #lcase(var.success.action)#.
To view this issue go to: 
#Request.theServer#/index.cfm/fuseaction/#arguments.detailFA#/issue_id/#arguments.formfields.issue_id#.cfm

ISSUE DETAILS:
Issue ##:		#arguments.formfields.issue_id#
Status:		#qryIssues.status#
Verified?	#YesNoFormat(qryIssues.verified)#
Severity:	#qryIssues.severity#
Submitted By:	#qryIssues.submittedBy_name#
Assigned To:	#qryIssues.assignedTo_name#
Assigned By:	#qryIssues.assignedBy_name#

Description:
#qryIssues.description#

<cfif qryComments.RecordCount GT 0>Comments:
<cfloop query="qryComments">
#qryComments.comment#
	-- #UCASE(qryComments.commenter)# #DateFormat(qryComments.created_date,"M/D/YYYY")#
--------------------------------------
</cfloop>
</cfif>
</cfsavecontent>
</cfoutput>

		<!--- Send e-mails to developer and submitter --->
		<cfinvoke  
			component="#this#" 
			method="sendIssueEmail" 
			user_id=#arguments.formfields.assigned_to#
			subject="SQUID Issue ###arguments.formfields.issue_id# #var.success.action#"
			emailContent=#var.success.emailContent#
			fromEmail=#arguments.fromEmail#
			dsn=#arguments.DSN#
			usersTbl=#arguments.usersTbl#
			issueTbl=#arguments.issueTbl#
		>
		
		<cfreturn var.success>
	</cffunction>

	<cffunction name="sendIssueEmail" access="public" displayname="Issue Email" hint="Sends Issue Email" output="No">
		<cfargument name="user_id" required="Yes" type="numeric">
		<cfargument name="subject" required="yes" type="string">
		<cfargument name="emailContent" required="yes" type="string">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="issueTbl" required="no" type="string" default="issueTbl">
		<cfargument name="usersTbl" required="no" type="string" default="usersTbl">
		<cfargument name="fromEmail" required="yes" type="string">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>		

		<!--- Get e-mail address and name --->
		<cfquery name="qryUser" datasource="#arguments.dsn#">
			SELECT
				u.email,
				u.preferred_name
			FROM
				#arguments.usersTbl# u
			WHERE
				u.user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>
		
<cfmail from="#arguments.fromEmail#" to="#qryUser.email#" subject="#arguments.subject#" server="mail.squidswimteam.org">
#qryUser.preferred_name#,

#arguments.emailContent#
</cfmail>
	</cffunction>

	<cffunction name="getIssueComments" access="public" displayname="Issue/Bug Comments" hint="Gets Issue/Bug Comments" output="No" returntype="query">
		<cfargument name="issue_id" required="no" type="numeric" default="0">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="issue_commentTbl" required="yes" type="string">
		<cfargument name="usersTbl" required="yes" type="string">

		<!--- Run query --->
		<cfquery name="qryComments" datasource="#arguments.dsn#">
			SELECT
				c.comment,
				c.created_user,
				c.created_date,
				u.preferred_name + ' ' + u.last_name AS commenter
			FROM
				#arguments.issue_commentTbl# c,
				#arguments.usersTbl# u
			WHERE
				c.created_user = u.user_id
				AND c.active_code = 1
				AND c.issue_id = <cfqueryparam value="#VAL(arguments.issue_id)#" cfsqltype="CF_SQL_INTEGER">
			ORDER BY
				c.created_date DESC
		</cfquery>

		<cfreturn qryComments>
	</cffunction>

</cfcomponent>