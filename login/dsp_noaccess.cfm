<!---
<fusedoc
	fuse = "dsp_noaccess.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the no access page.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="4 June 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
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
				You have requested access to a page for which you do not have access.
				If you feel this is an error, please contact <cfoutput><a href="mailto:#Request.admin_email#">#Request.admin_email#</a></cfoutput>.
			</td>
		</tr>
	</tbody>
</table>

