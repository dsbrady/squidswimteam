<!---
<fusedoc
	fuse = "dsp_members_export.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the members to prepare for exporting.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="7 November 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="export" />
			</structure>
		</in>
		<out>
			<number name="membersList" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.statusType" default="All" type="string">
	<cfparam name="attributes.activityLevel" default="both" type="string">
	<cfparam name="attributes.getVisibleOnly" default=true type="boolean">
	<cfparam name="attributes.mailingListOnly" default="0" type="boolean" />

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get all members --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getMembers"
		returnvariable="qryAllMembers"
		dsn=#Request.DSN#
		usersTbl=#Request.usersTbl#
		user_statusTbl=#Request.user_statusTbl#
		transaction_typeTbl=#Request.transaction_typeTbl#
		transactionTbl=#Request.practice_transactionTbl#
		activityDays=#Request.activityDays#
		getVisibleOnly=#attributes.getVisibleOnly#
		mailingListOnly=#attributes.mailingListOnly#
	>

	<!--- Get based on activity level and status --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getMembersActivity"
		returnvariable="qryMembers"
		qrySource=#qryAllMembers#
		activityLevel=#attributes.activityLevel#
		exactStatusType=#attributes.statusType#
	>

	<!--- Get status types --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getUserStatuses"
		returnvariable="qryStatus"
		dsn=#Request.DSN#
		user_statusTbl=#Request.user_statusTbl#
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
				> Members Export
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
					<option value="#qryStatus.status#" <cfif CompareNoCase(attributes.statusType,qryStatus.status) EQ 0>selected="selected"</cfif>>#qryStatus.status#s</option>
				</cfloop>
				</select>
				<br />
				<input type="checkbox" name="mailingListOnly" value="1" <cfif attributes.mailingListOnly>checked="checked"</cfif> />
				Get Mailing List Only
				<input type="submit" name="submitBtn" value="Go" />
			</form>
			</td>
		</tr>
		<tr>
			<td>
			<cfif qryMembers.RecordCount>
				<form name="exportForm" action="#Request.self#?fuseaction=#XFA.export#" method="post" target="PageProcessing" onsubmit="return validate(this);">
				<p align="center">
					Select the members to export and click the "Export" button.
				</p>
				<p align="center">
					<input type="submit" name="submitBtn" value="Export" tabindex="#variables.tabindex#" class="buttonStyle" />
					<cfset variables.tabindex = variables.tabindex + 1>
				</p>
				<table cellspacing="0" cellpadding="3" align="center" class="tableClass" width="500">
					<thead>
						<tr class="tableHead">
							<td>
								<input type="checkbox" name="exportALL" value="Yes" tabindex="#variables.tabindex#" onclick="return selectAll(this.form,this);" checked="checked" />
								<cfset variables.tabindex = variables.tabindex + 1>
							</td>
							<td>
								<strong>Last Name</strong>
							</td>
							<td>
								<strong>First Name</strong>
							</td>
							<td>
								<strong>Type</strong>
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
								<input type="checkbox" name="exportMember" variables="#variables.tabindex#" value="#qryMembers.user_id#" checked="checked" />
								<cfset variables.tabindex = variables.tabindex + 1>
							</td>
							<td>
								#qryMembers.last_name#
							</td>
							<td>
								#qryMembers.preferred_name#
							</td>
							<td>
								#qryMembers.status#
							</td>
						</tr>
					</cfloop>
					</tbody>
				</table>
				<p align="center">
					<input type="submit" name="submitBtn" value="Export" tabindex="#variables.tabindex#" class="buttonStyle" />
					<cfset variables.tabindex = variables.tabindex + 1>
				</p>
				</form>
			<cfelse>
				There are no members matching your criteria.
			</cfif>
			</td>
		</tr>
	</tbody>
</table>
<iframe name="PageProcessing" id="PageProcessing" style="height:0px;width:0px;display:inline"></iframe>
</cfoutput>

