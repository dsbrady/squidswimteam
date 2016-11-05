<cfoutput>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
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
				<td colspan="2" align="center">
					<cfif session.squid.user.getUserID() GT 0>
						<a href="#Request.self#?fuseaction=#XFA.members#">Menu</a>
					<cfelse>
						<a href="#Request.self#?fuseaction=#XFA.home#">Home</a>
					</cfif>
					> Buy Swims
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr valign="top">
				<td colspan="2">
					<p>
						You have successfully purchased <strong>#attributes.totalSwims#</strong> swims.
						The details of your transaction are below.
					</p>
				</td>
			</tr>
			<cfif len(trim(attributes.name)) GT 0>
				<tr valign="top">
					<td>
						<strong>Name:</strong>
					</td>
					<td>
						#attributes.name#
					</td>
				</tr>
			</cfif>
			<tr valign="top">
				<td>
					<strong>Email Address:</strong>
				</td>
				<td>
					#attributes.email#
				</td>
			</tr>
			<tr valign="top">
				<td>
					<strong>Number of Swims:</strong>
				</td>
				<td>
					#attributes.numSwims#
				</td>
			</tr>
			<tr valign="top">
				<td>
					<strong>Free Swims:</strong>
				</td>
				<td>
					#attributes.totalSwims - attributes.numSwims#
				</td>
			</tr>
			<tr valign="top">
				<td>
					<strong>Total Swims:</strong>
				</td>
				<td>
					#attributes.totalSwims#
				</td>
			</tr>
			<tr valign="top">
				<td>
					<strong>Total Cost:</strong>
				</td>
				<td>
					#dollarFormat(attributes.cost)#
				</td>
			</tr>
			<tr valign="top">
				<td>
					<strong>PayPal Transaction ID:</strong>
				</td>
				<td>
					#attributes.payPalTransactionID#
				</td>
			</tr>
		</tbody>
	</table>
</form>
</cfoutput>

