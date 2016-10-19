<!--- 
<fusedoc 
	fuse="dsp_login.cfm" language="ColdFusion" specification="3.0">
	<responsibilities>
		I display the login page.
	</responsibilities>	
	<properties>
		<history author="Scott Brady" date="5 April 2004" type="Create" role="Architect">
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
	<cfparam name="attributes.username" default="" type="string">

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

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
<form name="inputForm" action="#variables.baseHREF##Request.self#/fuseaction/#XFA.next#.cfm" method="post" onsubmit="return validate(this);">
<table border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td class="header1" colspan="2">
				#Request.page_title#
			</td>
		</tr>
	</thead>
	<tbody>
		<tr valign="top">
			<td colspan="2">
				Enter your user name <cfif ListLast(attributes.fuseaction,".") IS "dsp_registrant_login">(your e-mail address)</cfif>
				and password below.
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>User Name:</strong>
			</td>
			<td>
				<input type="text" name="username" size="20" maxlength="30" tabindex="#variables.tabindex#" value="#attributes.username#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Password:</strong>
			</td>
			<td>
				<input type="password" name="password" size="15" maxlength="15" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center" colspan="2">
				<input type="submit" name="submitBtn" value="Login" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
			<td>&nbsp;</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>
