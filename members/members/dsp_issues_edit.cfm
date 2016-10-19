<!---
<fusedoc
	fuse = "dsp_issues_edit.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the issue edit form.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="5 June 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
				<string name="issues" />
			</structure>
			
			<number name="issue_id" scope="attributes" />
			<number name="status_id" scope="attributes" />
			<number name="severity_id" scope="attributes" />
			<number name="assigned_to" scope="attributes" />
			<number name="submitted_by" scope="attributes" />
			<number name="assigned_by" scope="attributes" />
			<string name="description" scope="attributes" />
			<boolean name="verified" scope="attributes" />

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
			<number name="issue_id" scope="formOrUrl" />
			<number name="status_id" scope="formOrUrl" />
			<number name="assigned_to" scope="formOrUrl" />
			<number name="severity_id" scope="formOrUrl" />
			<number name="submitted_by" scope="formOrUrl" />
			<number name="assigned_by" scope="formOrUrl" />
			<string name="description" scope="formOrUrl" />
			<boolean name="verified" scope="formOrUrl" />
		</out>
	</io>

</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.issue_id" default="0" type="numeric">
	<cfparam name="attributes.status_id" default="1" type="numeric">
	<cfparam name="attributes.assigned_to" default="1" type="numeric">
	<cfparam name="attributes.severity_id" default="1" type="numeric">
	<cfparam name="attributes.submitted_by" default="#Request.squid.user_id#" type="numeric">
	<cfparam name="attributes.assigned_by" default="#Request.squid.user_id#" type="numeric">
	<cfparam name="attributes.description" default="" type="string">
	<cfparam name="attributes.attachment" default="" type="string">
	<cfparam name="attributes.verified" default="no" type="boolean">
	<cfparam name="attributes.comment" default="" type="string">
	
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<cfif attributes.issue_id GT 0>
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

		<cfscript>
			if (attributes.success IS NOT "No")
			{
				attributes.status_id = qryIssues.status_id;
				attributes.assigned_to = qryIssues.assigned_to;
				attributes.severity_id = qryIssues.severity_id;
				attributes.submitted_by = qryIssues.submitted_by;
				attributes.assigned_by = qryIssues.assigned_by;
				attributes.description = qryIssues.description;
				attributes.verified = qryIssues.verified;
			}
			attributes.attachment = qryIssues.attachment;
		</cfscript>
	</cfif>


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

	<!--- Get testers --->
	<cfinvoke  
		component="#Request.lookup_cfc#"
		method="getTesters" 
		returnvariable="qryTesters"
		dsn=#Request.DSN#
		usersTbl=#Request.usersTbl#
		testerTbl=#Request.testerTbl#
	>

	<cfset variables.tabindex = 1>
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
<form name="issuesForm" action="#variables.baseHREF##Request.self#/fuseaction/#XFA.next#.cfm" method="post" onsubmit="return validate(this);" enctype="multipart/form-data">
	<input type="hidden" name="issue_id" value="#attributes.issue_id#" />
<table width="550" border="0" cellpadding="0" cellspacing="0" align="center">
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
				> <a href="#Request.self#/fuseaction/#XFA.issues#.cfm">Issues/Bugs</a>
				> Update Issues/Bugs
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
				<select name="status_id" tabindex="#variables.tabindex#">
				<cfloop query="qryStatus">
					<option value="#qryStatus.status_id#" <cfif attributes.status_id EQ qryStatus.status_id>selected="selected"</cfif>>#qryStatus.status#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	<cfif VAL(attributes.issue_id) GT 0>
		<tr valign="top">
			<td>
				<strong>Verified?</strong>
			</td>
			<td>
			<cfif Secure("Verify Issues")>
				<select name="verified" tabindex="#variables.tabindex#">
					<option value="No" <cfif NOT attributes.verified>selected="selected"</cfif>>No</option>
					<option value="Yes" <cfif attributes.verified>selected="selected"</cfif>>Yes</option>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				<input type="hidden" name="verified" value="#attributes.verified#" />
				#YesNoFormat(attributes.verified)#
			</cfif>
			</td>
		</tr>
	</cfif>
		<tr valign="top">
			<td>
				<strong>Severity:</strong>
			</td>
			<td>
				<select name="severity_id" tabindex="#variables.tabindex#">
				<cfloop query="qrySeverity">
					<option value="#qrySeverity.severity_id#" <cfif attributes.severity_id EQ qrySeverity.severity_id>selected="selected"</cfif>>#qrySeverity.severity#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Submitted By:</strong>
			</td>
			<td>
				<select name="submitted_by" tabindex="#variables.tabindex#">
				<cfloop query="qryTesters">
					<option value="#qryTesters.user_id#" <cfif attributes.submitted_by EQ qryTesters.user_id>selected="selected"</cfif>>#qryTesters.tester#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Assign To:</strong>
			</td>
			<td>
				<select name="assigned_to" tabindex="#variables.tabindex#">
				<cfloop query="qryDevelopers">
					<option value="#qryDevelopers.user_id#" <cfif attributes.assigned_to EQ qryDevelopers.user_id>selected="selected"</cfif>>#qryDevelopers.developer#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Assigned By:</strong>
			</td>
			<td>
				<select name="assigned_by" tabindex="#variables.tabindex#">
					<option value="0" <cfif attributes.assigned_by EQ 0>selected="selected"</cfif>>Select Tester</option>
				<cfloop query="qryTesters">
					<option value="#qryTesters.user_id#" <cfif attributes.assigned_by EQ qryTesters.user_id>selected="selected"</cfif>>#qryTesters.tester#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Description:</strong>
			</td>
			<td>
				<textarea name="description" cols="50" rows="6" wrap="soft" tabindex="#variables.tabindex#">#attributes.description#</textarea>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Add Comment:</strong>
			</td>
			<td>
				<textarea name="comment" cols="50" rows="6" wrap="soft" tabindex="#variables.tabindex#"></textarea>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Attachment:</strong>
				<input type="hidden" name="attachment_old" value="#attributes.attachment#" />
			</td>
			<td>
			<cfif LEN(attributes.attachment) GT 0>
				<a href="#Request.issues_folder#/#attributes.attachment#" target="attachmentWin">View Current</a><br />
			</cfif>
				<input type="file" name="attachment" size="25" maxlength="255" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><em>(GIF, JPG, or PDF files only)</em></td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="submitBtn" value="Save" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
				<input type="reset" name="resetBtn" value="Reset Values" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

