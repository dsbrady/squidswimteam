<!---
<fusedoc
	fuse = "val_transactions_edit.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="16 September 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>

			<number name="transaction_id" scope="attributes" />
			<number name="transaction_type_id" scope="attributes" />
			<number name="member_id" scope="attributes" />
			<number name="num_swims" scope="attributes" />
			<string name="date_transaction" scope="attributes" />
			<string name="notes" scope="attributes" />
			<string name="date_start" scope="attributes" />
			<string name="date_end" scope="attributes" />
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

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.transaction_id" default=0 type="numeric">
<cfparam name="attributes.member_id" default=0 type="numeric">
<cfparam name="attributes.transaction_type_id" default=0 type="numeric">
<cfparam name="attributes.num_swims" default=0 type="numeric">
<cfparam name="attributes.date_transaction" default="#DateFormat(Now(),"M-D-YYYY")#" type="string">
<cfparam name="attributes.notes" default="" type="string">
<cfparam name="attributes.date_start" default="#Month(Now())#-1-#Year(Now())#" type="string">
<cfparam name="attributes.date_end" default="#DateFormat(Now(),"M-D-YYYY")#" type="string">

<cfparam name="variables.success" default="Yes" type="boolean">
<cfparam name="variables.reason" default="" type="string">

<cfscript>
	attributes.date_start = Replace(attributes.date_start,"-","/","ALL");
	attributes.date_end = Replace(attributes.date_end,"-","/","ALL");
	attributes.date_transaction = Replace(attributes.date_transaction,"-","/","ALL");
</cfscript>

<cfinvoke
	component="#Request.accounting_cfc#"
	method="updateTransaction"
	returnvariable="strSuccess"
	formfields=#attributes#
	dsn=#Request.DSN#
	transactionTbl=#Request.practice_transactionTbl#
	updating_user=#Request.squid.user_id#
 />

<cfif NOT strSuccess.success>
	<cfscript>
		variables.theURL = Request.self & "?fuseaction=" & XFA.failure;
		variables.theURL = variables.theURL & "&success=" & strSuccess.success & "&reason=" & strSuccess.reason;
	</cfscript>

	<cfloop collection="#attributes#" item="variables.theItem">
		<cfscript>
			if ((variables.theItem IS NOT "SubmitBtn") AND (variables.theItem IS NOT "fieldnames") AND (variables.theItem IS NOT "fuseaction") AND (LEN(attributes[variables.theItem])))
			{
				variables.theURL = variables.theURL & "&" & variables.theItem & "=" & attributes[variables.theItem];
			}
		</cfscript>
	</cfloop>

	<cflocation addtoken="no" url="#variables.theURL#">
</cfif>

<cfscript>
	if (VAL(attributes.transaction_id) GT 0)
	{
		variables.reason = "Transaction Updated&date_start=" & attributes.date_start & "&date_end=" & attributes.date_end;
	}
	else
	{
		variables.reason = "Transaction Added&date_start=" & attributes.date_start & "&date_end=" & attributes.date_end;
	}
	variables.theFA = XFA.success;
</cfscript>
