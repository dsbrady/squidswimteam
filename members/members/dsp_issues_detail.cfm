<!---
<fusedoc
	fuse = "dsp_issues_detail.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the issue detail.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="15 June 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="issues" />
			</structure>
			
			<number name="issue_id" scope="attributes" />
			<number name="return_status_id" scope="attributes" />
			<number name="return_severity_id" scope="attributes" />
			<number name="return_assigned_to" scope="attributes" />
			<string name="return_orderBy" scope="attributes" />
		</in>
		<out>
			<number name="return_status_id" scope="formOrUrl" />
			<number name="return_severity_id" scope="formOrUrl" />
			<number name="return_assigned_to" scope="formOrUrl" />
			<string name="return_orderBy" scope="formOrUrl" />
		</out>
	</io>

</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.issue_id" default="0" type="numeric">
	<cfparam name="attributes.return_status_id" default="0" type="numeric">
	<cfparam name="attributes.return_assigned_to" default="0" type="numeric">
	<cfparam name="attributes.return_severity_id" default="0" type="numeric">
	<cfparam name="attributes.return_orderBy" default="i.status_id ASC, i.severity_id ASC" type="string">

	<!--- Get issue information --->
	<cfinvoke  
		component="#Request.issues_cfc#" 
		method="getIssues" 
		returnvariable="qryIssues"
		status_id=0
		assigned_to=0
		severity_id=0
		issue_id=#attributes.issue_id#
		dsn=#Request.DSN#
		usersTbl=#Request.usersTbl#
		issueTbl=#Request.issueTbl#
		issue_severityTbl=#Request.issue_severityTbl#
		issue_statusTbl=#Request.issue_statusTbl#
	>

	<cfinvoke  
		component="#Request.issues_cfc#" 
		method="getIssueComments" 
		returnvariable="qryComments"
		issue_id=#attributes.issue_id#
		dsn=#Request.DSN#
		usersTbl=#Request.usersTbl#
		issue_commentTbl=#Request.issue_commentTbl#
	>
</cfsilent>

<cfoutput>
<table width="500" border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td align="center" colspan="2">
				<h2>
					#Request.page_title#
				</h2>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr valign="top">
			<td align="center" colspan="2">
				<a href="#Request.self#/fuseaction/#XFA.menu#.cfm">Menu</a>
				> <a href="#Request.self#/fuseaction/#XFA.issues#/status_id/#attributes.return_status_id#/assigned_to/#attributes.return_assigned_to#/severity_id/#attributes.return_severity_id#/orderBy/#attributes.return_orderBy#.cfm">Issues/Bugs</a>
				> Issue Detail
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Status:</strong>
			</td>
			<td>
				#qryIssues.status#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Verified?</strong>
			</td>
			<td>
				#YesNoFormat(qryIssues.verified)#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Severity:</strong>
			</td>
			<td>
				#qryIssues.severity#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Submitted By:</strong>
			</td>
			<td>
				#qryIssues.submittedBy_name#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Assigned To:</strong>
			</td>
			<td>
				#qryIssues.assignedTo_name#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Assigned By:</strong>
			</td>
			<td>
				#qryIssues.assignedBy_name#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Description:</strong>
			</td>
			<td>
				#qryIssues.description#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Attachment:</strong>
			</td>
			<td>
			<cfif LEN(TRIM(qryIssues.attachment))>
				<a href="#Request.issues_folder#/#qryIssues.attachment#" target="attachmentWin">View</a><br />
			<cfelse>
				(None)
			</cfif>
			</td>
		</tr>
	<cfif qryComments.RecordCount GT 0>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				<strong>Comments:</strong>
			</td>
		</tr>
		<cfloop query="qryComments">
		<tr valign="top">
			<td colspan="2">
				#qryComments.comment#
				<br />
				<span style="font-style:italic;">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-- #qryComments.commenter# #DateFormat(qryComments.created_date,"M/D/YYYY")#
				</span>
			</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				<hr style="width:300px;" />
			</td>
		</tr>
		</cfloop>
	</cfif>
	</tbody>
</table>
</cfoutput>

