<!---
<fusedoc
	fuse = "dsp_preferences.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the preferences.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="25 July 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
			</structure>
			
			<number name="user_id" scope="attributes" />
			<number name="email_preference" scope="attributes" />
			<number name="posting_preference" scope="attributes" />
		</in>
		<out>
			<number name="user_id" scope="formOrUrl" />
			<number name="email_preference" scope="formOrUrl" />
			<number name="posting_preference" scope="formOrUrl" />
		</out>
	</io>

</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.email_preference" default="0" type="numeric">
	<cfparam name="attributes.posting_preference" default="0" type="numeric">
	<cfparam name="attributes.calendar_preference" default="0" type="numeric">
	
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<cfif (attributes.success IS NOT "No")>
		<cfscript>
			attributes.email_preference = Request.squid.email_preference;
			attributes.posting_preference = Request.squid.posting_preference;
			attributes.calendar_preference = Request.squid.calendar_preference;
		</cfscript>
	</cfif>

	<!--- Get E-mail Preferences --->
	<cfinvoke  
		component="#Request.lookup_cfc#"
		method="getPreferences" 
		returnvariable="qryEmailPreferences"
		dsn=#Request.DSN#
		preferenceTbl=#Request.preferenceTbl#
		preference_type="EMAIL"
	>

	<!--- Get Posting Preferences --->
	<cfinvoke  
		component="#Request.lookup_cfc#"
		method="getPreferences" 
		returnvariable="qryPostingPreferences"
		dsn=#Request.DSN#
		preferenceTbl=#Request.preferenceTbl#
		preference_type="POSTING"
	>

	<!--- Get Calendar Preferences --->
	<cfinvoke  
		component="#Request.lookup_cfc#"
		method="getPreferences" 
		returnvariable="qryCalPreferences"
		dsn=#Request.DSN#
		preferenceTbl=#Request.preferenceTbl#
		preference_type="CALENDAR"
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
		Changes Saved.
	</p>
</cfif>

<cfoutput>
<form name="preferencesForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post">
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
			<td colspan="2" align="center">
				<a href="#Request.self#?fuseaction=#XFA.menu#">Menu</a>
				> Preferences
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				Make any changes below and click "Save Preferences" to save your changes.
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>E-Mail Format:</strong>
			</td>
			<td>
				<select name="email_preference" size="1" tabindex="#variables.tabindex#">
				<cfloop query="qryEmailPreferences">
					<option value="#qryEmailPreferences.preference_id#" <cfif attributes.email_preference EQ qryEmailPreferences.preference_id>selected="selected"</cfif>>#qryEmailPreferences.preference#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Announcement Receipt Format:</strong>
			</td>
			<td>
				<select name="posting_preference" size="1" tabindex="#variables.tabindex#">
				<cfloop query="qryPostingPreferences">
					<option value="#qryPostingPreferences.preference_id#" <cfif attributes.posting_preference EQ qryPostingPreferences.preference_id>selected="selected"</cfif>>#qryPostingPreferences.preference#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Calendar E-mail Receipt Format:</strong>
			</td>
			<td>
				<select name="calendar_preference" size="1" tabindex="#variables.tabindex#">
				<cfloop query="qryCalPreferences">
					<option value="#qryCalPreferences.preference_id#" <cfif attributes.calendar_preference EQ qryCalPreferences.preference_id>selected="selected"</cfif>>#qryCalPreferences.preference#</option>
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
				<input type="submit" name="submitBtn" value="Save Preferences" tabindex="#variables.tabindex#" class="buttonStyle" />
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

