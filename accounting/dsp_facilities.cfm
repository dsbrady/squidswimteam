<!---
<fusedoc
	fuse = "dsp_facilities.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the facilities.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="9 September 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="edite" />
				<string name="delete" />
			</structure>
		</in>
		<out>
			<number name="facility_id" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.facility_id" default="0" type="numeric">
	<cfparam name="attributes.orderBy" default="f.facility DESC" type="string">

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get Facilities --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getFacilities"
		returnvariable="qryFacilities"
		facility_id=#attributes.facility_id#
		dsn=#Request.DSN#
		facilityTbl=#Request.facilityTbl#
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
				> Facilities
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center">
				<a href="#Request.self#?fuseaction=#XFA.edit#">Add Facility</a>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
			<cfif qryFacilities.RecordCount>
				<table width="500" cellspacing="0" cellpadding="3" align="center" class="tableClass">
					<thead>
						<tr class="tableHead">
							<td>
								&nbsp;
							</td>
							<td>
								<strong>Facility</strong>
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
					<cfloop query="qryFacilities">
						<cfscript>
							variables.rowClass = qryFacilities.currentRow MOD 2;
						</cfscript>
						<tr class="tableRow#variables.rowClass#">
							<td align="center">
								<a href="#Request.self#?fuseaction=#XFA.delete#&facility_id=#qryFacilities.facility_id#" onclick="return confirm('Delete #qryFacilities.facility#?');">Delete</a>
							</td>
							<td>
								#qryFacilities.facility#
							</td>
							<td align="center">
								<cfif VAL(qryFacilities.defaultFac) GT 0>
									X
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td>
								<a href="#Request.self#?fuseaction=#XFA.edit#&facility_id=#qryFacilities.facility_id#">Edit</a>
							</td>
						</tr>
					</cfloop>
					</tbody>
				</table>
			<cfelse>
				There are no facilities.
			</cfif>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>

