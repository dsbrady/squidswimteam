<!---
<fusedoc
	fuse = "dsp_forgotten_password.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the forgotten password form.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="4 June 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
			</structure>

			<string name="username" scope="attributes" />
			<string name="returnFA" scope="attributes" />

			<boolean name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
			<string name="username" scope="formOrUrl" />
			<string name="returnFA" scope="formOrUrl" />
		</out>
	</io>

</fusedoc>
--->
<cfparam name="attributes.username" default="" type="string">
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
		<tr>
			<td width="75" rowspan="5">&nbsp;</td>
			<td colspan="2">
				<p>
					For security purposes, we are unable to retrieve your current password. When you
					request your password to be sent to you, we will change your password to a random,
					temporary one and will send that to you.
				</p>
				<p>
					Enter your e-mail address below and your new password will be sent to you.
				</p>
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<strong>E-mail:</strong>
			<cfoutput>
				<input type="text" name="username" size="25" maxlength="255" value="#attributes.username#" tabindex="1" />
			</cfoutput>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="submit" name="submit" value="Request Password" tabindex="2" class="buttonStyle" />
				&nbsp;&nbsp;&nbsp;
				<input type="reset" name="reset" value="Reset Form" tabindex="3" class="buttonStyle" />
			</td>
		</tr>
	</tbody>
</table>
</form>

