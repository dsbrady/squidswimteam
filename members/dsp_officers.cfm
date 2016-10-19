<!---
<fusedoc
	fuse = "dsp_officers.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the officers.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="30 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="edit" />
			</structure>
		</in>
		<out>
			<number name="officer_type_id" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get current officers --->
	<cfinvoke  
		component="#Request.lookup_cfc#" 
		method="getOfficers"
		returnvariable="qryOfficers"
		dsn=#Request.DSN#
		officer_typeTbl=#Request.officer_typeTbl#
		officerTbl=#Request.officerTbl#
		usersTbl=#Request.usersTbl#
		officer_type_id=0
		displayCoaches=false
		displayInactive=false
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
				> Officers
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
</cfoutput>
			<cfif qryOfficers.RecordCount>
				<table cellspacing="0" cellpadding="3" align="center" class="tableClass">
					<thead>
						<tr class="tableHead">
							<td>
								&nbsp;
							</td>
							<td>
								<strong>Officer</strong>
							</td>
							<td>
								<strong>Members</strong>
							</td>
						</tr>
					</thead>
					<tbody>
					<cfset variables.rowClass = 1>
					<cfoutput query="qryOfficers" group="officer_type">
						<tr class="tableRow#variables.rowClass#" valign="top">
							<td>
								<a href="#Request.self#?fuseaction=#XFA.edit#&officer_type_id=#qryOfficers.officer_type_id#">Edit</a>
							</td>
							<td>
								#qryOfficers.officer_type#
							</td>
							<td>
							<cfoutput>
								<cfif LEN(qryOfficers.preferred_name) GT 0>#qryOfficers.preferred_name#<cfelse>#qryOfficers.first_name#</cfif> #qryOfficers.last_name#<br />
							</cfoutput>
							</td>
						</tr>
						<cfif variables.rowClass EQ 1>
							<cfset variables.rowClass = 0>
						<cfelse>
							<cfset variables.rowClass = 1>
						</cfif>
					</cfoutput>
					</tbody>
				</table>
			<cfelse>
				There are no officers.
			</cfif>
			</td>
		</tr>
	</tbody>
</table>

