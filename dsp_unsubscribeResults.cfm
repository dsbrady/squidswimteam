<cfoutput>
<table width="550" border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td align="center">
				<h2>
					#Request.page_title#
				</h2>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr valign="top">
			<td>
			<cfif attributes.success>
				You have been removed from all future SQUID mailings.
			<cfelse>
				#attributes.reason#
			</cfif>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>
