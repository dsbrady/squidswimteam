<!---
<fusedoc
	fuse = "dsp_forgotten_password_results.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the forgotten password results.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="4 June 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />

			<boolean name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
			<string name="returnFA" scope="attributes" />
		</in>
	</io>

</fusedoc>
--->
<cfparam name="attributes.success" default="Yes" type="boolean">
<cfparam name="attributes.reason" default="" type="string">
<cfparam name="attributes.returnFA" default="" type="string">

<table width="500" border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td align="center" colspan="2">
				<h2>
					<cfoutput>#Request.page_title#</cfoutput>
				</h2>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td width="75">&nbsp;</td>
			<td>
				You should receive your password via e-mail shortly.
			</td>
		</tr>
		<tr>
			<td colspan="2">
				&nbsp;
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="center">
			<cfoutput>
				<a href="#Request.self#?fuseaction=#XFA.login#&returnFA=#attributes.returnFA#">Login</a>
			</cfoutput>
			</td>
		</tr>
	</tbody>
</table>
</form>

