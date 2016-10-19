<cfsetting enablecfoutputonly="Yes">
<cfsilent>
<!---
<fusedoc
	fuse = "act_transactions_export.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I perform the export.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="6 March 2004" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
		</in>
	</io>
</fusedoc>
--->
<cfparam name="attributes.date_start" default="#Month(Now())#-1-#Year(Now())#" type="string">
<cfparam name="attributes.date_end" default="#DateFormat(Now(),"M-D-YYYY")#" type="string">
<cfparam name="attributes.member_id" default=0 type="numeric">
<cfparam name="attributes.getPractices" default=false type="boolean">

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
	getPractices=#attributes.getPractices#
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

<cfif ReFind("MSIE",cgi.HTTP_USER_AGENT)> 
	<cfheader name="Content-type" value="unknown"> 
<cfelse>
	<cfheader name="Content-type" value="application/msexcel"> 
</cfif>
	<!--- Suggest default filename for spreadsheet and download --->
	<cfheader name="content-disposition" value="attachment; filename=transactionList.xls"> 

	<!--- Set the content-type so Excel is invoked --->
	<CFCONTENT TYPE="application/msexcel" reset="yes">

</cfsilent>
<cfoutput>
<table border="1">
	<thead>
		<tr>
			<td colspan="5">
				<strong>#qryTransactions.memberPref# #qryTransactions.memberLast#'s Transactions for #attributes.date_start# - #attributes.date_end#</strong>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<strong>Beginning Balance</strong>
			</td>
			<td align="center">
				#qryBalanceBefore.balance#
			</td>
			<td colspan="2">
				&nbsp;
			</td>
		</tr>
		<tr>
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
		</tr>
	</thead>
	<tbody>
	<cfloop query="qryTransactions">
		<tr>
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
				#qryTransactions.transaction_type#
			</td>
			<td>
				#qryTransactions.notes#
			</td>
		</tr>
	</cfloop>
		<tr>
			<td colspan="2">
				<strong>Ending Balance</strong>
			</td>
			<td align="center">
				#qryBalanceAfter.balance#
			</td>
			<td colspan="2">
				&nbsp;
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>
