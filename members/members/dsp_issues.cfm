<!---
<fusedoc
	fuse = "dsp_issues.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the issues.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="5 June 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="edit" />
				<string name="detail" />
			</structure>

			<number name="status_id" scope="attributes" />
			<number name="assigned_to" scope="attributes" />
			<number name="severity_to" scope="attributes" />
		</in>
		<out>
			<number name="status_id" scope="formOrUrl" />
			<number name="assigned_to" scope="formOrUrl" />
			<number name="issue_id" scope="formOrUrl" />
			<number name="severity_id" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.status_id" default="0" type="numeric">
	<cfparam name="attributes.assigned_to" default="0" type="numeric">
	<cfparam name="attributes.severity_id" default="0" type="numeric">
	<cfparam name="attributes.orderBy" default="i.status_id ASC, i.severity_id ASC" type="string">

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get issues --->
	<cfinvoke
		component="#Request.issues_cfc#"
		method="getIssues"
		returnvariable="qryIssues"
		status_id=#attributes.status_id#
		assigned_to=#attributes.assigned_to#
		severity_id=#attributes.severity_id#
		dsn=#Request.DSN#
		usersTbl=#Request.usersTbl#
		issueTbl=#Request.issueTbl#
		issue_severityTbl=#Request.issue_severityTbl#
		issue_statusTbl=#Request.issue_statusTbl#
	>

	<!--- Get statuses --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getIssuesStatus"
		returnvariable="qryStatus"
		dsn=#Request.DSN#
		statusTbl=#Request.issue_statusTbl#
	>

	<!--- Get severities --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getIssuesSeverity"
		returnvariable="qrySeverity"
		dsn=#Request.DSN#
		severityTbl=#Request.issue_severityTbl#
	>

	<!--- Get developers --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getDevelopers"
		returnvariable="qryDevelopers"
		dsn=#Request.DSN#
		usersTbl=#Request.usersTbl#
		developerTbl=#Request.developerTbl#
	>
</cfsilent>

<cfif attributes.success IS "no">
	<h2>There were problems with your submission:</h2>
	<ul class="errorText">
		<cfloop list="#attributes.reason#" index="variables.theItem" delimiters="*">
			<li><cfoutput>#variables.theItem#</cfoutput></li>
		</cfloop>
	</ul>
	<p>Please make corrections below and re-submit the information.</p>
<cfelseif attributes.success IS "yes">
	<p class="errorText">
		<cfoutput>#attributes.reason#</cfoutput>
	</p>
</cfif>

<cfoutput>
<form name="issuesForm" action="#variables.baseHREF##Request.self#?fuseaction=#attributes.fuseaction#" method="get">
<table width="600" border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td align="center">
				<h2>
					#Request.page_title#
				</h2>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr valign="top">
			<td align="center">
				<a href="#Request.self#?fuseaction=#XFA.menu#">Menu</a>
				> Issues/Bugs
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center">
				<a href="#Request.self#?fuseaction=#XFA.edit#">Add Issue</a>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr valign="top">
			<td>
				<table>
					<tbody>
						<tr>
							<td>
								Show:
							</td>
							<td>
								<select name="status_id">
									<option value="0" <cfif attributes.status_id EQ 0>selected="selected"</cfif>>All Statuses</option>
								<cfloop query="qryStatus">
									<option value="#qryStatus.status_id#" <cfif attributes.status_id EQ qryStatus.status_id>selected="selected"</cfif>>#qryStatus.status#</option>
								</cfloop>
								</select>
							</td>
							<td>
								<select name="severity_id">
									<option value="0" <cfif attributes.severity_id EQ 0>selected="selected"</cfif>>All Severities</option>
								<cfloop query="qrySeverity">
									<option value="#qrySeverity.severity_id#" <cfif attributes.severity_id EQ qrySeverity.severity_id>selected="selected"</cfif>>#qrySeverity.severity#</option>
								</cfloop>
								</select>
							</td>
						</tr>
						<tr>
							<td>
								Assigned To:
							</td>
							<td>
								<select name="assigned_to">
									<option value="0" <cfif attributes.assigned_to EQ 0>selected="selected"</cfif>>All Developers</option>
								<cfloop query="qryDevelopers">
									<option value="#qryDevelopers.user_id#" <cfif attributes.assigned_to EQ qryDevelopers.user_id>selected="selected"</cfif>>#qryDevelopers.developer#</option>
								</cfloop>
								</select>
							</td>
							<td align="center">
								<input type="submit" name="submitBtn" value="Search" class="buttonStyle" />
							</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
			<cfif qryIssues.RecordCount>
				<table border="1" bordercolor="rgb(0,127,255)" cellspacing="0" cellpadding="3" align="center">
					<thead>
						<tr class="tableHead">
							<td>
								&nbsp;
							</td>
							<td align="center">
								##
							</td>
							<td>
								Status
							</td>
							<td>
								Verified?
							</td>
							<td>
								Severity
							</td>
							<td>
								Description
							</td>
							<td>
								Assigned To
							</td>
							<td>
								Submitted By
							</td>
						</tr>
					</thead>
					<tbody>
					<cfloop query="qryIssues">
						<cfscript>
							rowClass = qryIssues.CurrentRow MOD 2;
						</cfscript>
						<tr class="tableRow#rowClass#">
							<td>
								<a href="#Request.self#?fuseaction=#XFA.edit#&issue_id=#qryIssues.issue_id#">Edit</a>
							</td>
							<td align="center">
								#qryIssues.issue_id#
							</td>
							<td>
								#qryIssues.status#
							</td>
							<td>
								#YesNoFormat(qryIssues.verified)#
							</td>
							<td>
								#qryIssues.severity#
							</td>
							<td>
								<a href="#Request.self#?fuseaction=#XFA.detail#&issue_id=#qryIssues.issue_id#&return_status_id=#attributes.status_id#&return_assigned_to=#attributes.assigned_to#&return_severity_id=#attributes.severity_id#&return_order_by=#attributes.orderBy#">#TruncString(qryIssues.description,35)#</a>
							</td>
							<td>
								#qryIssues.assignedto_name#
							</td>
							<td>
								#qryIssues.submittedby_name#
							</td>
						</tr>
					</cfloop>
					</tbody>
				</table>
			<cfelse>
				There are no current issues matching your criteria.
			</cfif>
			</td>
		</tr>

	</tbody>
</table>
</form>
</cfoutput>

