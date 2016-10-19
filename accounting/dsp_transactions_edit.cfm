<!---
<fusedoc
	fuse = "dsp_transactions_edit.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the transaction update form.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="16 September 2003" type="Create">
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
			<number name="member_id" scope="attributes" />
			<number name="num_swims" scope="attributes" />
			<string name="date_transaction" scope="attributes" />
			<string name="notes" scope="attributes" />
			<string name="date_start" scope="attributes" />
			<string name="date_end" scope="attributes" />

			<boolean name="success" scope="formOrUrl" />
			<string name="reason" scope="formOrUrl" />
		</in>
		<out>
			<number name="transaction_id" scope="formOrUrl" />
			<number name="transaction_type_id" scope="formOrUrl" />
			<number name="member_id" scope="formOrUrl" />
			<number name="num_swims" scope="formOrUrl" />
			<string name="date_transaction" scope="formOrUrl" />
			<string name="notes" scope="formOrUrl" />
			<string name="date_start" scope="formOrUrl" />
			<string name="date_end" scope="formOrUrl" />
		</out>
	</io>

</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.member_id" default=0 type="numeric">
	<cfparam name="attributes.transaction_type_id" default=0 type="numeric">
	<cfparam name="attributes.num_swims" default=0 type="numeric">
	<cfparam name="attributes.date_transaction" default="#DateFormat(Now(),"M-D-YYYY")#" type="string">
	<cfparam name="attributes.notes" default="" type="string">
	<cfparam name="attributes.date_start" default="#Month(Now())#-1-#Year(Now())#" type="string">
	<cfparam name="attributes.date_end" default="#DateFormat(Now(),"M-D-YYYY")#" type="string">

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<cfscript>
		attributes.date_start = Replace(attributes.date_start,"-","/","ALL");
		attributes.date_end = Replace(attributes.date_end,"-","/","ALL");
		attributes.date_transaction = Replace(attributes.date_transaction,"-","/","ALL");
	</cfscript>

	<!--- Get Transaction Types --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getTransactionTypes"
		returnvariable="qryTransTypes"
		dsn=#Request.DSN#
		transaction_typeTbl=#Request.transaction_typeTbl#
		getPractices=false
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
		activityDays=#Request.activityDays#
	>

	<cfif (attributes.success IS NOT "No") AND VAL(attributes.transaction_id) GT 0>
		<!--- Get transaction info --->
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
			transaction_id=#VAL(attributes.transaction_id)#
		>

		<cfscript>
			attributes.member_id = qryTransactions.member_id;
			attributes.transaction_type_id = qryTransactions.transaction_type_id;
			attributes.num_swims = qryTransactions.num_swims;
			attributes.date_transaction = DateFormat(qryTransactions.date_transaction,"M/D/YYYY");
			attributes.notes = qryTransactions.notes;
		</cfscript>
	</cfif>

	<cfset variables.tabindex = 1>
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
<form name="transactionForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post" onsubmit="return validate(this);">
	<input type="hidden" name="transaction_id" value="#VAL(attributes.transaction_id)#" />
	<input type="hidden" name="date_start" value="#attributes.date_start#" />
	<input type="hidden" name="date_end" value="#attributes.date_end#" />
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
				> <a href="#Request.self#?fuseaction=#XFA.transactions#&date_start=#attributes.date_start#&date_end=#attributes.date_end#">Transactions</a>
				> <cfif VAL(attributes.transaction_id)>Update<cfelse>Add</cfif> Transaction
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Date:</strong>
			</td>
			<td>
				<input type="text" name="date_transaction" size="10" maxlength="10" tabindex="#variables.tabindex#" value="#attributes.date_transaction#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Type:</strong>
			</td>
			<td>
				<select name="transaction_type_id" size="1" tabindex="#variables.tabindex#" onchange="return changeType(this,this.form,'#ValueList(qryTransTypes.transaction_type_id)#','#ValueList(qryTransTypes.default_swims)#');" />
					<option value="0" <cfif attributes.transaction_type_id EQ 0>selected="selected"</cfif>>(Select Type)</option>
				<cfloop query="qryTransTypes">
					<option value="#qryTransTypes.transaction_type_id#" <cfif attributes.transaction_type_id EQ qryTransTypes.transaction_type_id>selected="selected"</cfif>>#qryTransTypes.transaction_type#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Member:</strong>
			</td>
			<td>
			<cfscript>
				if (qryMembers.RecordCount LT 10)
				{
					variables.selSize = qryMembers.RecordCount;
				}
				else
				{
					variables.selSize = 10;
				}
			</cfscript>

				<select name="member_id" size="#variables.selSize#" tabindex="#variables.tabindex#" />
				<cfloop query="qryMembers">
					<option value="#qryMembers.user_id#" <cfif attributes.member_id EQ qryMembers.user_id>selected="selected"</cfif>>#qryMembers.last_name#, #qryMembers.preferred_name#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Swims:</strong>
			</td>
			<td>
				<input type="text" name="num_swims" size="2" maxlength="3" tabindex="#variables.tabindex#" value="#attributes.num_swims#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Notes:</strong>
			</td>
			<td>
				<input type="text" name="notes" size="25" maxlength="255" tabindex="#variables.tabindex#" value="#attributes.notes#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2" align="center">
				<input type="submit" name="submitBtn" value="Save Transaction" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
				<input type="reset" name="resetBtn" value="Reset Form" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

