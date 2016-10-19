<!---
<fusedoc
	fuse = "dsp_coaches.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the coaches.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="11 September 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="edit" />
				<string name="delete" />
			</structure>
		</in>
		<out>
			<number name="coach_id" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.coach_id" default="0" type="numeric">
	<cfparam name="attributes.orderBy" default="u.last_name, u.first_name" type="string">

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get Coaches --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getCoaches"
		returnvariable="qryCoaches"
		coach_id=#attributes.coach_id#
		dsn=#Request.DSN#
		usersTbl=#Request.usersTbl#
		officerTbl=#Request.officerTbl#
		officer_typeTbl=#Request.officer_typeTbl#
		defaultsTbl=#Request.practice_defaultTbl#
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
				<a href="#Request.self#?fuseaction=#XFA.menu#">Main Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.acct_menu#">Accounting Menu</a>
				> Coaches
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center">
				<a href="#Request.self#?fuseaction=#XFA.add#">Add Coach</a>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
			<cfif qryCoaches.RecordCount>
				<table width="400" cellspacing="0" cellpadding="3" align="center">
					<tbody>
						<tr>
							<td>
								Coaches in <strong>bold</strong> are active.
								Coaches in <span style="color:red;">RED</span> are deactivated.
							</td>
						</tr>
					</tbody>
				</table>
				<table width="400" cellspacing="0" cellpadding="3" align="center" class="tableClass">
					<thead>
						<tr class="tableHead">
							<td>
								&nbsp;
							</td>
							<td>
								<strong>Coach</strong>
							</td>
							<td align="center">
								<strong>Default</strong>
							</td>
							<td>
								&nbsp;
							</td>
						</tr>
					</thead>
					<tbody>
					<cfloop query="qryCoaches">
						<cfscript>
							variables.rowClass = qryCoaches.currentRow MOD 2;
						</cfscript>
						<tr class="tableRow#variables.rowClass#">
							<td align="center">
								<a href="#Request.self#?fuseaction=#XFA.delete#&coach_id=#qryCoaches.user_id#" onclick="return confirm('Delete #qryCoaches.preferred_name# #qryCoaches.last_name#?');">Delete</a>
							</td>
							<td>
								<span style="<cfif LEN(qryCoaches.date_end)>color:red;<cfelse>font-weight:bold;</cfif>">
									#qryCoaches.preferred_name# #qryCoaches.last_name#
								</span>
							</td>
							<td align="center">
								<cfif VAL(qryCoaches.defaultCoach) GT 0>
									X
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td align="center">
								<a href="#Request.self#?fuseaction=#XFA.activation#&coach_id=#qryCoaches.user_id#&active=<cfif LEN(qryCoaches.date_end)>1<cfelse>0</cfif>"><cfif LEN(qryCoaches.date_end)>A<cfelse>Dea</cfif>ctivate</a>
							</td>
						</tr>
					</cfloop>
					</tbody>
				</table>
			<cfelse>
				There are no coaches.
			</cfif>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>

