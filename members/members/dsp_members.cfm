<!---
<fusedoc
	fuse = "dsp_members.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the members.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="5 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="edit" />
			</structure>
		</in>
		<out>
			<number name="member_id" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.statusType" default="Member" type="string">
	<cfparam name="attributes.activityLevel" default="Active" type="string">
	<cfparam name="attributes.getVisibleOnly" default=true type="boolean">

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<cfif Secure("Update Members")>
		<cfset attributes.getVisibleOnly = false>
	</cfif>

	<!--- Get all members --->
	<cfset qryAllMembers = variables.lookupCFC.getMembers(Request.dsn,Request.usersTbl,Request.user_statusTbl,Request.practice_transactionTbl,Request.transaction_typeTbl,0,Request.activityDays,"All",false,false,"",attributes.getVisibleOnly,Now(),false) />

	<!--- Get based on activity level and status --->
	<cfset qryMembers = variables.lookupCFC.getMembersActivity(qryAllMembers,attributes.activityLevel,attributes.statusType,attributes.StatusType) />

	<!--- Get status types --->
	<cfset qryStatus = variables.lookupCFC.getUserStatuses(Request.dsn,Request.user_statusTbl,"",0) />
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
				<a href="#Request.self#/fuseaction=#XFA.menu#">Menu</a>
				> Members
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center">
				<a href="#Request.self#?fuseaction=#XFA.edit#&user_id=0&activityLevel=#attributes.activityLevel#&statusType=#attributes.statusType#&returnFA=#attributes.fuseaction#&addNew=Yes&actionType=edit">Add Member</a>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="center">
			<form name="memberForm" action="#Request.self#?fuseaction=#attributes.fuseaction#" method="post">
				Display
				<select name="activityLevel">
					<option value="both" <cfif CompareNoCase(attributes.activityLevel,"both") EQ 0>selected="selected"</cfif>>Active and Inactive</option>
					<option value="active" <cfif CompareNoCase(attributes.activityLevel,"active") EQ 0>selected="selected"</cfif>>Active</option>
					<option value="inactive" <cfif CompareNoCase(attributes.activityLevel,"inactive") EQ 0>selected="selected"</cfif>>Inactive</option>
				</select>
				<select name="statusType">
					<option value="All" <cfif CompareNoCase(attributes.statusType,"All") EQ 0>selected="selected"</cfif>>All Types</option>
			<cfloop query="qryStatus">
				<cfif Secure("Update Members") OR CompareNoCase(qryStatus.status,"Deactivated User") NEQ 0>
					<option value="#qryStatus.status#" <cfif CompareNoCase(attributes.statusType,qryStatus.status) EQ 0>selected="selected"</cfif>>#qryStatus.status#s</option>
				</cfif>
			</cfloop>
				</select>
				<input type="submit" name="submitBtn" value="Go" />
			</form>
			</td>
		</tr>
		<tr>
			<td>
			<cfif qryMembers.RecordCount>
				<table cellspacing="0" cellpadding="3" align="center" class="tableClass">
					<thead>
						<tr class="tableHead">
							<td>
								<strong>Last Name</strong>
							</td>
							<td>
								<strong>First Name</strong>
							</td>
							<td>
								<strong>Type</strong>
							</td>
							<td>
								<strong>E-mail</strong>
							</td>
							<td>
								&nbsp;
							</td>
						</tr>
					</thead>
					<tbody>
					<cfloop query="qryMembers">
						<cfscript>
							variables.rowClass = qryMembers.currentRow MOD 2;
						</cfscript>
						<tr class="tableRow#variables.rowClass#">
							<td>
								#qryMembers.last_name#
							</td>
							<td>
							<cfif len(trim(qryMembers.preferred_name))>
								#qryMembers.preferred_name#
							<cfelse>
								#qryMembers.first_name#
							</cfif>
							</td>
							<td>
								#qryMembers.status#
							</td>
							<td>
								<a href="mailto:#qryMembers.email#">#qryMembers.email#</a>
							</td>
							<td>
								<a href="#Request.self#?fuseaction=#XFA.edit#&user_id=#qryMembers.user_id#&activityLevel=#attributes.activityLevel#&statusType=#attributes.statusType#&returnFA=#attributes.fuseaction#">View</a>
								<cfif Secure("Update Members") OR (qryMembers.user_id EQ Request.squid.user_id)>
									/ <a href="#Request.self#?fuseaction=#XFA.edit#&user_id=#qryMembers.user_id#&activityLevel=#attributes.activityLevel#&statusType=#attributes.statusType#&actionType=edit&returnFA=#attributes.fuseaction#">Edit</a>
								</cfif>
							</td>
						</tr>
					</cfloop>
					</tbody>
				</table>
			<cfelse>
				There are no members matching your criteria.
			</cfif>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>

