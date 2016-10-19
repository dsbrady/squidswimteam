<!---
<fusedoc
	fuse = "dsp_coaches_add.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the coach add form.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="11 September 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
				<string name="coaches" />
			</structure>

			<number name="coach_id" scope="attributes" />
		</in>
		<out>
			<number name="coach_id" scope="formOrUrl" />
		</out>
	</io>

</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.coach_id" default="0" type="numeric">

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get users who aren't already coaches --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getNonCoaches"
		returnvariable="qryNonCoaches"
		dsn=#Request.DSN#
		usersTbl=#Request.usersTbl#
		officerTbl=#Request.officerTbl#
		officer_typeTbl=#Request.officer_typeTbl#
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
</cfif>

<cfoutput>
<form name="coachForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post" onsubmit="return validate(this);">
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
				> <a href="#Request.self#?fuseaction=#XFA.coaches#">Coaches</a>
				> Add Coach
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
				if (qryNonCoaches.RecordCount LT 15)
				{
					variables.selSize = qryNonCoaches.RecordCount;
				}
				else
				{
					variables.selSize = 15;
				}
			</cfscript>
				<select name="coach_id" size="#variables.selSize#" tabindex="#variables.tabindex#" />
				<cfloop query="qryNonCoaches">
					<option value="#qryNonCoaches.user_id#">#qryNonCoaches.preferred_name# #qryNonCoaches.last_name#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2" align="center">
				<input type="submit" name="submitBtn" value="Add Coach" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

