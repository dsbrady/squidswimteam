<!---
<fusedoc
	fuse = "dsp_change_password.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the password change form.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="3 June 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
			</structure>

			<string name="returnFA" scope="attributes" />
			<boolean name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
			<string name="password_old" scope="formOrUrl" />
			<string name="password" scope="formOrUrl" />
			<string name="password_confirm" scope="formOrUrl" />
			<string name="returnFA" scope="formOrUrl" />
		</out>
	</io>

</fusedoc>
--->
<cfparam name="Request.squid.user_id" default="0" type="numeric">
<cfparam name="Request.squid.tempPassword" default="0" type="boolean">
<cfparam name="attributes.returnFA" default="" type="string">

<cfparam name="attributes.success" default="Yes" type="boolean">
<cfparam name="attributes.reason" default="" type="string">

<cfif attributes.success IS "no">
	<h3>There were problems with your submission:</h3>
	<ul class="errorText">
		<cfloop list="#attributes.reason#" index="variables.theItem" delimiters="*">
			<li><cfoutput>#variables.theItem#</cfoutput></li>
		</cfloop>
	</ul>
	<p>Please make corrections below and re-submit the information.</p>
</cfif>

<cfoutput>
<form name="passwordForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post" onsubmit="return validate(this);">
	<input type="hidden" name="returnFA" value="#attributes.returnFA#" />
</cfoutput>
<table width="500" border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td align="center" colspan="3">
				<h2>
					<cfoutput>#Request.page_title#</cfoutput>
				</h2>
			</td>
		</tr>
	</thead>
	<tbody>
	<cfif Request.squid.tempPassword>
		<tr>
			<td colspan="3">
				Your password is temporary and needs to be changed. Use the following
				form to change your password.
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
	</cfif>
		<tr>
			<td width="75" rowspan="5">&nbsp;</td>
			<td width="200">
				<strong>Old Password:</strong>
			</td>
			<td width="225">
				<input type="password" name="password_old" size="10" maxlength="20" tabindex="1" />
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>New Password:</strong>
			</td>
			<td>
				<input type="password" name="password" size="10" maxlength="20" tabindex="2" />
			</td>
		</tr>
		<tr>
			<td>
				<strong>Re-type New Password:</strong>
			</td>
			<td>
				<input type="password" name="password_confirm" size="10" maxlength="20" tabindex="3" />
			</td>
		</tr>
		<tr class="plain_text_small" valign="top">
			<td colspan="3">
				(Passwords may contain only numbers, letters, commas, and underscores.  Must contain at least 1 number.)
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<input type="submit" name="submit" value="Change Password" tabindex="4" class="buttonStyle" />
				&nbsp;&nbsp;&nbsp;
				<input type="reset" name="reset" value="Reset Form" tabindex="5" class="buttonStyle" />
			</td>
		</tr>
	</tbody>
</table>
</form>

