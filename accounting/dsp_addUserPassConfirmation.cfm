<cfsilent>
	<cfset request.effectiveDate = attributes.effectiveDate />
	<cfif isDate(request.qMember.swimPassExpiration) AND dateCompare(attributes.effectiveDate,request.qMember.swimPassExpiration)>
		<cfset request.effectiveDate = dateAdd("d",1,request.qMember.swimPassExpiration) />
	</cfif>
	<cfset request.expirationDate = dateAdd(request.qSwimPass.expirationUnitAbbreviation,request.qSwimPass.expirationNumber,request.effectiveDate) />
	<cfset aFootnotes = arrayNew(1) />
	<cfif request.qSwimPass.swimPass CONTAINS "Student">
		<cfset arrayAppend(variables.aFootnotes,"NOTE: Make sure you have verified that they are a student.") />
	</cfif>
	<cfif dateCompare(request.effectiveDate,attributes.effectiveDate) NEQ 0>
		<cfset arrayAppend(variables.aFootnotes,"Effective date was adjusted due to #request.qMember.preferred_name#'s current swim pass expiration date.") />
	</cfif>
</cfsilent>
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
		Changes Saved.
	</p>
</cfif>
<cfoutput>
<form name="userPassForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post">
	<input type="hidden" name="swimPassID" value="#VAL(attributes.swimPassID)#" />
	<input type="hidden" name="selectedUserID" value="#VAL(attributes.selectedUserID)#" />
	<input type="hidden" name="effectiveDate" value="#request.effectiveDate#" />
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
				> <a href="#Request.self#?fuseaction=#XFA.previous#">Add User Swim Pass</a>
				> Confirmation
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="3">
				Please verify the swim pass information for the member below.
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
				#request.qSwimPass.swimPass#<cfif request.qSwimPass.swimPass CONTAINS "Student">*</cfif> (#dollarFormat(request.qSwimPass.price)#)
			</td>
			<td>
				&nbsp;
			</td>
		</tr>
	<cfif val(request.qMember.balance) NEQ 0>
		<tr valign="top">
			<td>
				<strong>Swim Balance Adjustment:</strong>
			</td>
			<td>
				#val(request.qMember.balance)# ($#trim(numberFormat(val(request.qMember.balance) * request.pricePerSwimMembers * -1,"999.99"))#)
			</td>
			<td>
				&nbsp;
			</td>
		</tr>
	</cfif>
		<tr valign="top">
			<td>
				<strong>Valid dates:</strong>
			</td>
			<td>
				#dateFormat(request.effectiveDate,"m/d/yyyy")# - #dateFormat(request.expirationDate,"m/d/yyyy")#<cfif dateCompare(request.effectiveDate,attributes.effectiveDate) NEQ 0>*<cfif request.qSwimPass.swimPass CONTAINS "Student">*</cfif></cfif>
			</td>
			<td>
				&nbsp;
			</td>
		</tr>
	<cfloop from="1" to="#arrayLen(variables.aFootnotes)#" index="footnoteIndex">
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3">
				<cfloop from="1" to="#footnoteIndex#" index="asteriskCount">*</cfloop>
				#variables.aFootnotes[footnoteIndex]#
			</td>
		</tr>
	</cfloop>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="3" align="center">
				<input type="submit" name="submitBtn" value="Confirm Swim Pass" class="buttonStyle" />
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

