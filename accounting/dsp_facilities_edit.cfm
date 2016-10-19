<!---
<fusedoc
	fuse = "dsp_facilities_edit.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the facility update form.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="9 September 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
				<string name="facilities" />
			</structure>

			<number name="facility_id" scope="attributes" />
			<string name="facility" scope="attributes" />
		</in>
		<out>
			<number name="facility_id" scope="formOrUrl" />
			<string name="facility" scope="formOrUrl" />
		</out>
	</io>

</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.facility" default="" type="string">

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<cfif (attributes.success IS NOT "No") AND VAL(attributes.facility_id) GT 0>
		<!--- Get facility info --->
		<cfinvoke
			component="#Request.lookup_cfc#"
			method="getFacilities"
			returnvariable="qryFacilities"
			facility_id=#attributes.facility_id#
			dsn=#Request.DSN#
			facilityTbl=#Request.facilityTbl#
			defaultsTbl=#Request.practice_defaultTbl#
		>

		<cfscript>
			attributes.facility = qryFacilities.facility;
		</cfscript>
	</cfif>

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
</cfif>

<cfoutput>
<form name="facilityForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post" onsubmit="return validate(this);">
	<input type="hidden" name="facility_id" value="#VAL(attributes.facility_id)#" />
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
			<td colspan="2" align="center">
				<a href="#Request.self#?fuseaction=#XFA.menu#">Main Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.acct_menu#">Accounting Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.facilities#">Facilities</a>
				> <cfif VAL(attributes.facility_id)>Update<cfelse>Add</cfif> Facility
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Facility:</strong>
			</td>
			<td>
				<input type="text" name="facility" size="35" maxlength="50" tabindex="#variables.tabindex#" value="#attributes.facility#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	<cfif VAL(attributes.facility_id) GT 0>
		<tr valign="top">
			<td>
				<strong>Default?</strong>
			</td>
			<td>
				#YesNoFormat(VAL(qryFacilities.defaultFac))#
				<br />
				( <a href="#Request.self#?fuseaction=#XFA.defaults#">Update Practice Defaults</a> )
			</td>
		</tr>
	</cfif>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2" align="center">
				<input type="submit" name="submitBtn" value="Save Facility" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
				<input type="reset" name="resetBtn" value="Reset Form" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

