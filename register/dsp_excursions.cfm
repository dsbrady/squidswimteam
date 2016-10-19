<!--- 
<fusedoc 
	fuse="dsp_excursions.cfm" language="ColdFusion" specification="3.0">
	<responsibilities>
		I display the master regstration page.
	</responsibilities>	
	<properties>
		<history author="Scott Brady" date="11 April 2004" type="Create" role="Architect">
	</properties>
	<io>
		<in>
			<structure name="XFA">
				<string name="next" />
			</structure>

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.excursion" default="0" type="numeric">
	
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<cfscript>
		// If exists, populate data
		if ((attributes.success IS NOT "No"))
		{
			attributes.excursion = Session.goldrush2009.excursion;
		}
	</cfscript>
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
<form name="inputForm" action="#variables.baseHREF##Request.self#/fuseaction/#XFA.next#.cfm" method="post">
<table border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td class="header1" colspan="2">
				#Request.page_title#
			</td>
		</tr>
	<cfif VAL(Session.goldrush2009.registration_id)>
		<tr>
			<td colspan="2">
				&nbsp;
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<a href="#Request.self#/fuseaction/#XFA.registration_menu#.cfm">Registration Menu</a>
			</td>
		</tr>
	</cfif>
	</thead>
	<tbody>
		<tr>
			<td colspan="2">
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				<strong>Please select an excursion to attend below (or select to not attend one). </strong>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td width="50">
				<input type="radio" name="excursion" tabindex="#variables.tabindex#" value="0" <cfif VAL(attributes.excursion) EQ 0>checked="checked"</cfif> />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
			<td>
				No Excursion Selected
			</td>
		</tr>
	<cfloop query="qExcursions">
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td>
				<input type="radio" name="excursion" tabindex="#variables.tabindex#" value="#qExcursions.excursion_id#" <cfif VAL(attributes.excursion) EQ qExcursions.excursion_id>checked="checked"</cfif> />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
			<td>
				<strong>#UCASE(qExcursions.name)#</strong>
				<br />
				#qExcursions.description#
			</td>
		</tr>
	</cfloop>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2" align="center">
				<input type="submit" name="submitBtn" value="Save Changes" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
			<td>&nbsp;</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>
