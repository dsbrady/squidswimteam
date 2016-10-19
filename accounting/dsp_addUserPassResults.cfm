<cfoutput>
<table width="600" border="0" cellpadding="0" cellspacing="0" align="center">
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
		<tr valign="top">
			<td colspan="3" align="center">
				<a href="#Request.self#?fuseaction=#XFA.menu#">Main Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.acct_menu#">Accounting Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.next#">Add User Swim Pass</a>
				> Results
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="3">
				You have successfully applied the following swim pass.
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td width="200">
				<strong>Member:</strong>
			</td>
			<td width="150">
				#request.qMember.preferred_name# #request.qMember.last_name#
			</td>
			<td width="250">
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Swim Pass:</strong>
			</td>
			<td>
				#request.qSwimPass.swimPass#
			</td>
			<td>
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Valid dates:</strong>
			</td>
			<td>
				#dateFormat(request.qSwimPass.activeDate,"m/d/yyyy")# - #dateFormat(request.qSwimPass.expirationDate,"m/d/yyyy")#
			</td>
			<td>
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td colspan="3">
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td colspan="3" align="center">
				<a href="#Request.self#?fuseaction=#XFA.next#">Add another pass</a>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>

