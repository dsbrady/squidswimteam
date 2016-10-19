<!---
<fusedoc
	fuse = "dsp_defaults.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the practice defaults.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="12 September 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
			</structure>
		</in>
		<out>
			<number name="coach_id" scope="formOrUrl" />
			<number name="facility_id" scope="formOrUrl" />
			<boolean name="sunday" scope="formOrUrl" />
			<boolean name="monday" scope="formOrUrl" />
			<boolean name="tuesday" scope="formOrUrl" />
			<boolean name="wednesday" scope="formOrUrl" />
			<boolean name="thursday" scope="formOrUrl" />
			<boolean name="friday" scope="formOrUrl" />
			<boolean name="saturday" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get Defaults --->
	<cfinvoke
		component="#Request.accounting_cfc#"
		method="getDefaults"
		returnvariable="qryDefaults"
		dsn=#Request.DSN#
		defaultsTbl=#Request.practice_defaultTbl#
	>

	<!--- Get Coaches --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getCoaches"
		returnvariable="qryCoaches"
		dsn=#Request.DSN#
		usersTbl=#Request.usersTbl#
		officerTbl=#Request.officerTbl#
		officer_typeTbl=#Request.officer_typeTbl#
		defaultsTbl=#Request.practice_defaultTbl#
	>

	<!--- Get Facilities --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getFacilities"
		returnvariable="qryFacilities"
		dsn=#Request.DSN#
		facilityTbl=#Request.facilityTbl#
		defaultsTbl=#Request.practice_defaultTbl#
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
<form name="defaultForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post" onsubmit="return validate(this);">
<table width="600" border="0" cellpadding="0" cellspacing="0" align="center">
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
				<a href="#Request.self#?fuseaction=#XFA.menu#">Main Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.acct_menu#">Accounting Menu</a>
				> Practice Defaults
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Coach:</strong>
			</td>
			<td>
			<cfscript>
				if (qryCoaches.RecordCount LT 15)
				{
					variables.selSize = qryCoaches.RecordCount;
				}
				else
				{
					variables.selSize = 15;
				}
			</cfscript>
				<select name="coach_id" size="#variables.selSize#" tabindex="#variables.tabindex#" />
				<cfloop query="qryCoaches">
					<option value="#qryCoaches.user_id#" <cfif qryDefaults.coach_id EQ qryCoaches.user_id>selected="selected"</cfif>>#qryCoaches.preferred_name# #qryCoaches.last_name#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Facility:</strong>
			</td>
			<td>
			<cfscript>
				if (qryFacilities.RecordCount LT 5)
				{
					variables.selSize = qryFacilities.RecordCount;
				}
				else
				{
					variables.selSize = 5;
				}
			</cfscript>
				<select name="facility_id" size="#variables.selSize#" tabindex="#variables.tabindex#" />
				<cfloop query="qryFacilities">
					<option value="#qryFacilities.facility_id#" <cfif qryDefaults.facility_id EQ qryFacilities.facility_id>selected="selected"</cfif>>#qryFacilities.facility#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Practice Days:</strong>
			</td>
			<td>
				<input type="checkbox" name="sunday" tabindex="#variables.tabindex#" value="1" <cfif qryDefaults.sunday>checked="checked"</cfif> />
				Sunday
				<br />
				<cfset variables.tabindex = variables.tabindex + 1>
				<input type="checkbox" name="monday" tabindex="#variables.tabindex#" value="1" <cfif qryDefaults.monday>checked="checked"</cfif> />
				Monday
				<br />
				<cfset variables.tabindex = variables.tabindex + 1>
				<input type="checkbox" name="tuesday" tabindex="#variables.tabindex#" value="1" <cfif qryDefaults.tuesday>checked="checked"</cfif> />
				Tuesday
				<br />
				<cfset variables.tabindex = variables.tabindex + 1>
				<input type="checkbox" name="wednesday" tabindex="#variables.tabindex#" value="1" <cfif qryDefaults.wednesday>checked="checked"</cfif> />
				Wednesday
				<br />
				<cfset variables.tabindex = variables.tabindex + 1>
				<input type="checkbox" name="thursday" tabindex="#variables.tabindex#" value="1" <cfif qryDefaults.thursday>checked="checked"</cfif> />
				Thursday
				<br />
				<cfset variables.tabindex = variables.tabindex + 1>
				<input type="checkbox" name="friday" tabindex="#variables.tabindex#" value="1" <cfif qryDefaults.friday>checked="checked"</cfif> />
				Friday
				<br />
				<cfset variables.tabindex = variables.tabindex + 1>
				<input type="checkbox" name="saturday" tabindex="#variables.tabindex#" value="1" <cfif qryDefaults.saturday>checked="checked"</cfif> />
				Saturday
				<br />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2" align="center">
				<input type="submit" name="submitBtn" value="Update Defaults" tabindex="#variables.tabindex#" class="buttonStyle" />
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

