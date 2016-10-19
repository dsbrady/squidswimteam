<!---
<fusedoc
	fuse = "dsp_transactions.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the transactions.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="16 September 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="edit" />
				<string name="delete" />
			</structure>

			<string name="date_start" scope="attributes" />
			<string name="date_end" scope="attributes" />
			<number name="member_id" scope="formOrUrl" />
		</in>
		<out>
			<number name="transaction_id" scope="formOrUrl" />
			<string name="date_start" scope="formOrUrl" />
			<string name="date_end" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.date_start" default="#Month(Now())#-1-#Year(Now())#" type="string">
	<cfparam name="attributes.date_end" default="#DateFormat(Now(),"M-D-YYYY")#" type="string">
	<cfparam name="attributes.member_id" default=0 type="numeric">
	<cfparam name="attributes.transactionCategory" default="credit" type="string" />

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<cfscript>
		attributes.date_start = Replace(attributes.date_start,"-","/","ALL");
		attributes.date_end = Replace(attributes.date_end,"-","/","ALL");
	</cfscript>

	<!--- Get Transactions --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getTransactions"
		returnvariable="qryTransactions"
		dsn=#Request.DSN#
		transactionTbl=#Request.practice_transactionTbl#
		practiceTbl=#Request.practicesTbl#
		transaction_typeTbl=#Request.transaction_typeTbl#
		usersTbl=#Request.usersTbl#
		user_statusTbl=#Request.user_statusTbl#
		facilityTbl=#Request.facilityTbl#
		date_start=#attributes.date_start#
		date_end=#attributes.date_end#
		member_id=#attributes.member_id#
		transactionCategory=#attributes.transactionCategory#
	>

	<!--- Get balance before --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getMembers"
		returnvariable="qryBalanceBefore"
		user_id=#attributes.member_id#
		dsn=#Request.DSN#
		usersTbl=#Request.usersTbl#
		user_statusTbl=#Request.user_statusTbl#
		transactionTbl=#Request.practice_transactionTbl#
		transaction_typeTbl=#Request.transaction_typeTbl#
		activityDays=#Request.activityDays#
		balanceDate=#DateAdd("D",-1,attributes.date_start)#
	>

	<!--- Get balance after --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getMembers"
		returnvariable="qryBalanceAfter"
		user_id=#attributes.member_id#
		dsn=#Request.DSN#
		usersTbl=#Request.usersTbl#
		user_statusTbl=#Request.user_statusTbl#
		transactionTbl=#Request.practice_transactionTbl#
		transaction_typeTbl=#Request.transaction_typeTbl#
		activityDays=#Request.activityDays#
		balanceDate=#attributes.date_end#
	>

	<!--- Get members and guests --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getMembers"
		returnvariable="qryMembers"
		dsn=#Request.DSN#
		usersTbl=#Request.usersTbl#
		user_statusTbl=#Request.user_statusTbl#
		transactionTbl=#Request.practice_transactionTbl#
		transaction_typeTbl=#Request.transaction_typeTbl#
		activityLevel="both"
	>
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
	<cfif CompareNoCase(ListFirst(attributes.fuseaction,"."),"accounting") EQ 0>
		<tr valign="top">
			<td align="center">
				<a href="#Request.self#?fuseaction=#XFA.edit#&date_start=#attributes.date_start#&date_end=#attributes.date_end#">Add Transaction</a>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</cfif>
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
								<select name="transactionCategory" tabindex="3" size="1">
									<option value="all" <cfif attributes.transactionCategory EQ "all">selected="true"</cfif>>All Types</option>
									<option value="debit" <cfif attributes.transactionCategory EQ "debit">selected="true"</cfif>>Debits</option>
									<option value="credit" <cfif attributes.transactionCategory EQ "credit">selected="true"</cfif>>Credits</option>
								</select>
							</td>
						</tr>
						<tr valign="top">
							<td colspan="4">
								<select name="member_id" size="1" tabindex="4">
									<option value="0" <cfif attributes.member_id EQ 0>selected="selected"</cfif>>(All Members)</option>
								<cfloop query="qryMembers">
									<option value="#qryMembers.user_id#" <cfif attributes.member_id EQ qryMembers.user_id>selected="selected"</cfif>>#qryMembers.last_name#, #qryMembers.preferred_name#</option>
								</cfloop>
								</select>
								&nbsp;&nbsp;&nbsp;
								<input type="submit" name="submitBtn" tabindex="4" value="Get Transactions" />
							</td>
						</tr>
					</tbody>
				</table>
			</form>
			</td>
		</tr>
	<cfif qryTransactions.RecordCount>
		<tr valign="top">
			<td align="center">
				<a href="#Request.self#?fuseaction=#XFA.export#&transactionCategory=#attributes.transactionCategory#&member_id=#VAL(attributes.member_id)#&date_start=#attributes.date_start#&date_end/=#attributes.date_end#">Export Transactions</a>
			</td>
		</tr>
		<tr valign="top">
			<td align="center">
				&nbsp;
			</td>
		</tr>
	</cfif>
		<tr valign="top">
			<td>
				<strong>Beginning Balance:</strong> #qryBalanceBefore.balance#
			<cfif attributes.member_id EQ Request.squid.user_id>
				<a href="#Request.self#?fuseaction=#XFA.buySwims#">Buy Swims</a>
			</cfif>
			</td>
		</tr>
		<tr>
			<td>
			<cfif qryTransactions.RecordCount>
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
							<td align="center">
								<strong>Swims</strong>
							</td>
							<td>
								<strong>Type</strong>
							</td>
							<td>
								<strong>Notes</strong>
							</td>
						<cfif (CompareNoCase(ListFirst(attributes.fuseaction,"."),"accounting") EQ 0) AND (Secure("Update Financials") OR Secure("Update Practices"))>
							<td>
								&nbsp;
							</td>
						</cfif>
						</tr>
					</thead>
					<tbody>
					<cfloop query="qryTransactions">
						<cfscript>
							variables.rowClass = qryTransactions.currentRow MOD 2;
						</cfscript>
						<tr class="tableRow#variables.rowClass#" valign="top">
						<cfif (CompareNoCase(ListFirst(attributes.fuseaction,"."),"accounting") EQ 0) AND (Secure("Update Financials") OR Secure("Update Practices"))>
							<cfif VAL(qryTransactions.practice_id)>
								<cfset variables.querystring = "fuseaction=#XFA.practice_delete#&practice_id=#qryTransactions.practice_id#&date_start=#attributes.date_start#&date_end=#attributes.date_end#">
							<cfelse>
								<cfset variables.querystring = "fuseaction=#XFA.delete#&transaction_id=#qryTransactions.transaction_id#&date_start=#attributes.date_start#&date_end=#attributes.date_end#">
							</cfif>
							<td align="center">
								<a href="#Request.self#?#variables.querystring#" onclick="return confirm('Delete #DateFormat(qryTransactions.date_transaction,"M/D/YYYY")# transaction for #qryTransactions.memberPref# #qryTransactions.memberLast#?');">Delete</a>
							</td>
						</cfif>
							<td>
								#DateFormat(qryTransactions.date_transaction,"M/D/YYYY")#
							</td>
							<td>
								#qryTransactions.memberPref# #qryTransactions.memberLast#
							</td>
							<td align="center">
								#qryTransactions.num_swims#
							</td>
							<td>
							<cfif qryTransactions.transaction_type IS "Swim Pass Purchase">
								#qryTransactions.swimPass#
							</cfif>
								#qryTransactions.transaction_type#
							</td>
							<td>
								#qryTransactions.notes#
							</td>
						<cfif (CompareNoCase(ListFirst(attributes.fuseaction,"."),"accounting") EQ 0) AND (Secure("Update Financials") OR Secure("Update Practices"))>
							<cfif VAL(qryTransactions.practice_id)>
								<cfset variables.querystring = "fuseaction=#XFA.practice_edit#&practice_id=#qryTransactions.practice_id#&date_start=#attributes.date_start#&date_end=#attributes.date_end#">
							<cfelse>
								<cfset variables.querystring = "fuseaction=#XFA.edit#&transaction_id=#qryTransactions.transaction_id#&date_start=#attributes.date_start#&date_end=#attributes.date_end#">
							</cfif>
							<td align="center">
								<a href="#Request.self#?#variables.querystring#">Edit</a>
							</td>
						</cfif>
						</tr>
					</cfloop>
					</tbody>
				</table>
			<cfelse>
				There are no transactions.
			</cfif>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Ending Balance:</strong> #qryBalanceAfter.balance#
			<cfif attributes.member_id EQ Request.squid.user_id>
				<a href="#Request.self#?fuseaction=#XFA.buySwims#">Buy Swims</a>
			</cfif>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>

