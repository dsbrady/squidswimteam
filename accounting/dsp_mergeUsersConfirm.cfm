<cfif attributes.success IS "no">
	<h2>There were problems with your submission:</h2>
	<ul class="errorText">
		<cfloop list="#attributes.reason#" index="variables.theItem" delimiters="*">
			<li><cfoutput>#variables.theItem#</cfoutput></li>
		</cfloop>
	</ul>
	<p>Please make corrections below and re-submit the information.</p>
<cfelseif attributes.success IS "yes">
	<p class="errorText">
		<cfoutput>#attributes.reason#</cfoutput>
	</p>
</cfif>

<cfoutput>
<form name="mergeUserForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post" style="display:inline;">
	<input type="hidden" name="primaryUserID" value="#attributes.primaryUserID#" />
	<input type="hidden" name="secondaryUsers" value="#attributes.secondaryUsers#" />
	<input type="hidden" name="last_name" value="#attributes.last_name#" />
	<input type="hidden" name="first_name" value="#attributes.first_name#" />
	<input type="hidden" name="middle_name" value="#attributes.middle_name#" />
	<input type="hidden" name="preferred_name" value="#attributes.preferred_name#" />
	<input type="hidden" name="username" value="#attributes.username#" />
	<input type="hidden" name="email" value="#attributes.email#" />
	<input type="hidden" name="phone_cell" value="#attributes.phone_cell#" />
	<input type="hidden" name="phone_day" value="#attributes.phone_day#" />
	<input type="hidden" name="phone_night" value="#attributes.phone_night#" />
	<input type="hidden" name="fax" value="#attributes.fax#" />
	<input type="hidden" name="address1" value="#attributes.address1#" />
	<input type="hidden" name="address2" value="#attributes.address2#" />
	<input type="hidden" name="city" value="#attributes.city#" />
	<input type="hidden" name="state_id" value="#attributes.state_id#" />
	<input type="hidden" name="zip" value="#attributes.zip#" />
	<input type="hidden" name="country" value="#attributes.country#" />
	<input type="hidden" name="status" value="#attributes.status#" />
	<input type="hidden" name="date_expiration" value="#attributes.date_expiration#" />
<table width="600" border="0" cellpadding="0" cellspacing="0" align="center">
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
			<td align="center" colspan="2">
				<a href="#Request.self#?fuseaction=#XFA.menu#">Main Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.acct_menu#">Accounting Menu</a>
				> Merge User Accounts Confirmation
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2">
				You are about to merge the following information (and all transactions) into the primary user you selected.  Click "Merge Users" to perform the merge or "Cancel" to start over.
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td>
				<strong>Last Name:</strong>
			</td>
			<td>
				#attributes.last_name#
			</td>
		</tr>
		<tr>
			<td>
				<strong>First Name:</strong>
			</td>
			<td>
				#attributes.first_name#
			</td>
		</tr>
		<tr>
			<td>
				<strong>Middle Name:</strong>
			</td>
			<td>
				#attributes.middle_name#
			</td>
		</tr>
		<tr>
			<td>
				<strong>Preferred Name:</strong>
			</td>
			<td>
				#attributes.preferred_name#
			</td>
		</tr>
		<tr>
			<td>
				<strong>Userame:</strong>
			</td>
			<td>
				#attributes.username#
			</td>
		</tr>
		<tr>
			<td>
				<strong>E-mail:</strong>
			</td>
			<td>
				#attributes.email#
			</td>
		</tr>
		<tr>
			<td>
				<strong>Cell:</strong>
			</td>
			<td>
				#attributes.phone_cell#
			</td>
		</tr>
		<tr>
			<td>
				<strong>Day:</strong>
			</td>
			<td>
				#attributes.phone_day#
			</td>
		</tr>
		<tr>
			<td>
				<strong>Evening:</strong>
			</td>
			<td>
				#attributes.phone_night#
			</td>
		</tr>
		<tr>
			<td>
				<strong>Fax:</strong>
			</td>
			<td>
				#attributes.fax#
			</td>
		</tr>
		<tr>
			<td>
				<strong>Address 1:</strong>
			</td>
			<td>
				#attributes.address1#
			</td>
		</tr>
		<tr>
			<td>
				<strong>Address 2:</strong>
			</td>
			<td>
				#attributes.address2#
			</td>
		</tr>
		<tr>
			<td>
				<strong>City:</strong>
			</td>
			<td>
				#attributes.city#
			</td>
		</tr>
		<tr>
			<td>
				<strong>State:</strong>
			</td>
			<td>
				#attributes.state_id#
			</td>
		</tr>
		<tr>
			<td>
				<strong>ZIP:</strong>
			</td>
			<td>
				#attributes.zip#
			</td>
		</tr>
		<tr>
			<td>
				<strong>Country:</strong>
			</td>
			<td>
				#attributes.country#
			</td>
		</tr>
		<tr>
			<td>
				<strong>Status:</strong>
			</td>
			<td>
				#attributes.status#
			</td>
		</tr>
		<tr>
			<td>
				<strong>Expires:</strong>
			</td>
			<td>
				#attributes.date_expiration#
			</td>
		</tr>
		<tr>
			<td colspan="2">
				&nbsp;
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="submitBtn" value="Merge Users" />
				&nbsp;&nbsp;&nbsp;
				<input type="button" name="cancelBtn" value="Cancel" onclick="location.href='#Request.self#?fuseaction=#xfa.cancel#';" />
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

