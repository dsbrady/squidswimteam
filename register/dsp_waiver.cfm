<!--- 
<fusedoc 
	fuse="dsp_waiver.cfm" 
		language="ColdFusion" 
		specification="3.0">
	<responsibilities>
		I display the liability waiver.
	</responsibilities>	
	<properties>
		<history author="Scott Brady" date="17 April 2004" type="Create" role="Architect">
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
	<cfparam name="attributes.waiverName" default="" type="string">
	<cfparam name="attributes.waiverDate" default="" type="string">
	
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<cfscript>
		// If exists, populate data
		if ((attributes.success IS NOT "No"))
		{
			attributes.waiverName = Session.goldrush2009.waiverName;
			attributes.waiverDate = DateFormat(Session.goldrush2009.waiverDate,"mmmm d, yyyy");
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
<form name="inputForm" action="#variables.baseHREF##Request.self#/fuseaction/#XFA.next#.cfm" method="post" onsubmit="return validate(this);">
<table border="0" cellpadding="0" cellspacing="0" align="center" width="500">
 	<thead>
		<tr>
			<td class="header1" colspan="2">
				#Request.page_title#
			</td>
		</tr>
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
	</thead>
	<tbody>
		<tr>
			<td colspan="2">
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
			<cfif (NOT LEN(Session.goldrush2009.waiverName))>
				<p>
					<strong>In order to register, you MUST sign the following liability waiver by entering your name into the
					box below.  Neglecting to sign the waiver will prevent you from registering for the SQUID Long-Course Challenge.</strong>
				</p>
				<p>
					<textarea name="waiverText" rows="10" cols="50" tabindex="#variables.tabindex#">#Request.waiverText#</textarea>
					<cfset variables.tabindex = variables.tabindex + 1>
				</p>
				<p>
					Please signify your acceptance of the above waiver by entering your full name
					into the following box:
					<br />
					<input type="text" name="waiverName" size="25" maxlength="50" tabindex="#variables.tabindex#" value="#attributes.waiverName#" />
					<cfset variables.tabindex = variables.tabindex + 1>
				</p>
			<cfelse>
				<p>
					You have already signed the following liability waiver:
				</p>
				<p>
					<strong>#Session.goldrush2009.waiverText#</strong>
				</p>
				<p>
					Signed by:  <strong>#Session.goldrush2009.waiverName#</strong><br />
					On: <strong>#DateFormat(Session.goldrush2009.waiverDate,"mmmm d, yyyy")#</strong>
				</p>
			</cfif>
			</td>
		</tr>
	<cfif (NOT LEN(Session.goldrush2009.waiverName))>
		<tr>
			<td colspan="2">
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td colspan="2" align="center">
				<input type="submit" name="submitBtn" value="I Agree" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
			<td>&nbsp;</td>
		</tr>
	</cfif>
	</tbody>
</table>
</form>
</cfoutput>
