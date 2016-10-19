<!--- 
<fusedoc fuse="dsp_content.cfm" language="ColdFusion" specification="3.0">
	<responsibilities>
		I display the form for e-mailing all of the testers.
	</responsibilities>	
	<properties>
		<history author="Scott Brady" date="1 September 2003" type="Create" role="Architect">
	</properties>
	<io>
		<in>
			<structure name="XFA">
				<string name="next" />
			</structure>
		</in>
	</io>
</fusedoc>
--->
<cfparam name="attributes.return_email" default="" type="string">
<cfparam name="attributes.subject" default="" type="string">
<cfparam name="attributes.email_body" default="" type="string">

<cfparam name="attributes.success" default="" type="string">
<cfparam name="attributes.reason" default="" type="string">

<cfset variables.tabindex = 1>

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
<form id="emailForm" name="emailForm" action="#variables.baseHREF##Request.self#/fuseaction/#XFA.next#.cfm" method="post">
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
			<td>
				<strong>Your E-mail:</strong>
			</td>
			<td>
				<input type="text" name="return_email" size="35" value="#attributes.return_email#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Subject:</strong>
			</td>
			<td>
				<input type="text" name="subject" size="35" value="#attributes.subject#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Body:</strong>
			</td>
			<td>
				<textarea name="email_body" class="plain-text" rows="10" cols="40" tabindex="#variables.tabindex#">#attributes.email_body#</textarea>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="submitBtn" value="Send" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
				<input type="reset" name="resetBtn" value="Reset Values" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>


