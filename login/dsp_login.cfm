<!---
<fusedoc
	fuse = "dsp_login.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the login page.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="25 May 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="act_login" />
				<string name="forgotten_password" />
			</structure>

			<string name="username" scope="attributes" />
			<string name="returnFA" scope="attributes" />
		</in>
		<out>
			<string name="username" scope="formOrUrl" />
			<string name="password" scope="formOrUrl" />
			<string name="returnFA" scope="formOrUrl" />
		</out>
	</io>

</fusedoc>
--->
<cfparam name="attributes.username" default="" type="string">
<cfparam name="attributes.returnFA" default="#XFA.members#" type="string">

<cfparam name="attributes.success" default="Yes" type="string">
<cfparam name="attributes.reason" default="" type="string">

<cfif attributes.success IS "no">
	<h2>There were problems with your submission:</h2>
	<ul class="errorText">
		<cfloop list="#attributes.reason#" index="variables.theItem" delimiters="*">
			<li><cfoutput>#variables.theItem#</cfoutput></li>
		</cfloop>
	</ul>
	<p>Please make corrections below and re-submit the information.</p>
</cfif>

<!---
The SQUID Member section is currently offline for maintenance.  Please try again later.
<cfexit />
 --->

<cfoutput>
<form name="loginForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.act_login#" method="post">
	<input type="hidden" name="returnFA" value="#attributes.returnFA#" />
<table width="500" border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td align="center" colspan="3">
				<h2>
					#Request.page_title#
				</h2>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td colspan="3">
				You have requested access to a secure area. Please login to continue.
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr>
			<td width="100" rowspan="6">&nbsp;</td>
			<td width="100">
				<strong>E-mail:</strong>
			</td>
			<td width="300">
				<input type="text" name="username" size="25" maxlength="255" value="#attributes.username#" tabindex="1" />
			</td>
		</tr>
		<tr>
			<td>
				<strong>Password:</strong>
			</td>
			<td>
				<input type="password" name="password" size="10" maxlength="20" tabindex="2" />
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="submit" name="submit" value="Login" tabindex="3" class="buttonStyle" />
				&nbsp;&nbsp;&nbsp;
				<input type="reset" name="reset" value="Reset Form" tabindex="4" class="buttonStyle" />
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
			<cfoutput>
				<a href="#Request.self#?fuseaction=#XFA.newMemberSignup#">Not a member? Sign up</a> | 
				<a href="#Request.self#?fuseaction=#XFA.forgotten_password#&returnFA=#attributes.returnFA#">I don't know my password</a>
			</cfoutput>
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

