<!---
<fusedoc
	fuse = "dsp_transactionsUnconfirmed.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the unconfirmed PayPal transactions.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="18 December 2004" type="Create" />
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="edit" />
				<string name="delete" />
			</structure>
		</in>
		<out>
		</out>
	</io>
</fusedoc>
--->
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
				> <a href="#Request.self#?fuseaction=#XFA.acct_menu#">Accounting Menu</a>
				> Unconfirmed PayPal Transactions
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
			<cfif qTrans.RecordCount>
				<table width="600" cellspacing="0" cellpadding="3" align="center" class="tableClass">
					<thead>
						<tr class="tableHead">
							<td>
								&nbsp;
							</td>
							<td align="center">
								<strong>Date</strong>
							</td>
							<td align="center">
								<strong>Name</strong>
							</td>
							<td align="center">
								<strong>Type</strong>
							</td>
							<td>
								<strong>Notes</strong>
							</td>
							<td>
								&nbsp;
							</td>
						</tr>
					</thead>
					<tbody>
					<cfloop query="qTrans">
						<cfset variables.rowClass = qTrans.currentRow MOD 2 />
						<tr class="tableRow#variables.rowClass#" valign="top">
							<td align="center">
								<a href="#Request.self#?fuseaction=#XFA.delete#&transaction_id=#qTrans.transaction_id#&transaction_type_id=#qTrans.transaction_type_id#" onclick="return confirm('Delete #DateFormat(qTrans.date_transaction,"M/D/YYYY")# transaction for #qTrans.preferred_name# #qTrans.last_name#?');">Delete</a>
							</td>
							<td>
								#DateFormat(qTrans.date_transaction,"M/D/YYYY")#
							</td>
							<td>
								#qTrans.preferred_name# #qTrans.last_name#
							</td>
							<td>
								#qTrans.transaction_type#
							</td>
							<td>
								#qTrans.notes#
							</td>
							<td align="center">
								<a href="#Request.self#?fuseaction=#XFA.edit#&transaction_id=#qTrans.transaction_id#&transaction_type_id=#qTrans.transaction_type_id#">Edit</a>
							</td>
						</tr>
					</cfloop>
					</tbody>
				</table>
			<cfelse>
				There are no unconfirmed transactions.
			</cfif>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>

