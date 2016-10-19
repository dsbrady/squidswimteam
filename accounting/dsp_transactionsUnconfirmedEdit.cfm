<!---
<fusedoc
	fuse = "dsp_transactions_edit.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the transaction confirmation form.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="18 December 2004" type="Create" />
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
				<string name="transactions" />
			</structure>

			<number name="transaction_id" scope="attributes" />
			<number name="transaction_type_id" scope="attributes" />
			<string name="notes" scope="attributes" />

			<boolean name="success" scope="formOrUrl" />
			<string name="reason" scope="formOrUrl" />
		</in>
		<out>
			<number name="transaction_id" scope="formOrUrl" />
			<number name="transaction_type_id" scope="formOrUrl" />
			<string name="notes" scope="formOrUrl" />
		</out>
	</io>

</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.notes" default="" type="string" />

	<cfparam name="attributes.success" default="" type="string" />
	<cfparam name="attributes.reason" default="" type="string" />

	<cfif attributes.success IS NOT "No">
		<cfset attributes.notes = qTrans.notes />
	</cfif>

	<cfset variables.tabindex = 1 />
</cfsilent>

<cfif attributes.success IS "no">
	<h2>There were problems with your submission:</h2>
	<ul class="errorText">
		<cfloop list="#attributes.reason#" index="variables.theItem" delimiters="*">
			<li><cfoutput>#variables.theItem#</cfoutput></li>
		</cfloop>
	</ul>
	<p>Please make corrections below and re-submit the information.</p>
</cfif>

<cfoutput>
<form name="transactionForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post">
	<input type="hidden" name="transaction_id" value="#VAL(attributes.transaction_id)#" />
	<input type="hidden" name="transaction_type_id" value="#VAL(attributes.transaction_type_id)#" />
	<input type="hidden" name="user_id" value="#VAL(qTrans.member_id)#" />
	<input type="hidden" name="usersSwimPassID" value="#VAL(qTrans.usersSwimPassID)#" />
<table width="500" border="0" cellpadding="0" cellspacing="0" align="center">
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
				<a href="#Request.self#?fuseaction=#XFA.menu#">Main Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.acct_menu#">Accounting Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.transactions#">Unconfirmed PayPal Transactions</a>
				> Confirm PayPal Transaction
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				Enter the PayPal Transaction ID in the Notes Field below (example:  "PayPal Transaction 12345")
				and then confirm the transaction.
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Date:</strong>
			</td>
			<td>
				#DateFormat(qTrans.date_transaction,"m/d/yyyy")#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Type:</strong>
			</td>
			<td>
				#qTrans.transaction_type#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Member:</strong>
			</td>
			<td>
				#qTrans.preferred_name#
				#qTrans.last_name#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Notes:</strong>
			</td>
			<td>
				<input type="text" name="notes" size="25" maxlength="255" tabindex="#variables.tabindex#" value="#attributes.notes#" />
				<cfset variables.tabindex = variables.tabindex + 1 />
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2" align="center">
				<input type="submit" name="submitBtn" value="Confirm Transaction" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1 />
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

