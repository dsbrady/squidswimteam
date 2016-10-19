<!---
<fusedoc
	fuse = "dsp_logout_results.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the logout results.
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
<table width="500" border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td align="center">
				<h2>
					<cfoutput>#Request.page_title#</cfoutput>
				</h2>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				You have successfully logged out.
			</td>
		</tr>
		<tr>
			<td>
				&nbsp;
			</td>
		</tr>
		<tr>
			<td align="center">
			<cfoutput>
				<a href="#Request.self#?fuseaction=#attributes.returnFA#">Return to the site</a>
			</cfoutput>
			</td>
		</tr>
	</tbody>
</table>
