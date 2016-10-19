<cfsilent>
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

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
		<cfoutput>#attributes.reason#</cfoutput>
	</p>
</cfif>

<cfoutput>
<table width="600" border="0" cellpadding="0" cellspacing="0" align="center">
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
			<td align="center">
				<a href="#Request.self#?fuseaction=#XFA.menu#">Main Menu</a>
			<cfif CompareNoCase(ListFirst(attributes.fuseaction,"."),"accounting") EQ 0>
				> <a href="#Request.self#?fuseaction=#XFA.acct_menu#">Accounting Menu</a>
			</cfif>
				> Transactions
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center">
			<form name="dateForm" action="#variables.baseHREF##Request.self#?fuseaction=#attributes.fuseaction#" method="post" onsubmit="return validate(this);">
				<table width="400">
					<tbody>
						<tr valign="top">
							<td align="center">
								<input type="text" name="date_start" size="10" maxlength="10" tabindex="1" value="#attributes.date_start#" />
							</td>
							<td>
								to
							</td>
							<td>
								<input type="text" name="date_end" size="10" maxlength="10" tabindex="2" value="#attributes.date_end#" />
							</td>
							<td>
								<input type="submit" name="submitBtn" tabindex="4" value="Get Transactions" />
							</td>
						</tr>
					</tbody>
				</table>
			</form>
			</td>
		</tr>
		<tr>
			<td>
			<cfif qTransactions.RecordCount>
				<table width="600" cellspacing="0" cellpadding="3" align="center" class="tableClass">
					<thead>
						<tr class="tableHead">
						<cfif (CompareNoCase(ListFirst(attributes.fuseaction,"."),"accounting") EQ 0) AND (Secure("Update Financials") OR Secure("Update Practices"))>
							<td>
								&nbsp;
							</td>
						</cfif>
							<td align="center">
								<strong>Date</strong>
							</td>
							<td align="center">
								<strong>Name</strong>
							</td>
							<td>
								<strong>Notes</strong>
							</td>
<!---
						<cfif (CompareNoCase(ListFirst(attributes.fuseaction,"."),"accounting") EQ 0) AND (Secure("Update Financials") OR Secure("Update Practices"))>
							<td>
								&nbsp;
							</td>
						</cfif>
 --->
						</tr>
					</thead>
					<tbody>
					<cfloop query="qTransactions">
						<tr class="tableRow#qTransactions.currentRow MOD 2#" valign="top">
						<cfif (CompareNoCase(ListFirst(attributes.fuseaction,"."),"accounting") EQ 0) AND (Secure("Update Financials") OR Secure("Update Practices"))>
							<cfset variables.querystring = "fuseaction=#XFA.delete#&transaction_id=#qTransactions.transaction_id#&date_start=#attributes.date_start#&date_end=#attributes.date_end#&transactionTbl=membershipTransactions&returnFA=#XFA.returnFA#" />
							<td align="center">
								<a href="#Request.self#?#variables.querystring#" onclick="return confirm('Delete #DateFormat(qTransactions.date_transaction,"M/D/YYYY")# transaction for #qTransactions.memberPref# #qTransactions.memberLast#?');">Delete</a>
							</td>
						</cfif>
							<td>
								#DateFormat(qTransactions.date_transaction,"M/D/YYYY")#
							</td>
							<td>
								#qTransactions.memberPref# #qTransactions.memberLast#
							</td>
							<td>
								#qTransactions.notes#
							</td>
<!---
						<cfif (CompareNoCase(ListFirst(attributes.fuseaction,"."),"accounting") EQ 0) AND (Secure("Update Financials") OR Secure("Update Practices"))>
							<cfset variables.querystring = "fuseaction=#XFA.edit#&transaction_id=#qTransactions.transaction_id#&date_start=#attributes.date_start#&date_end=#attributes.date_end#">
							<td align="center">
								<a href="#Request.self#?#variables.querystring#">Edit</a>
							</td>
						</cfif>
 --->
						</tr>
					</cfloop>
					</tbody>
				</table>
			<cfelse>
				There are no transactions.
			</cfif>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>

