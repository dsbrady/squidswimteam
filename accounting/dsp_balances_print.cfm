<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!---
<fusedoc
	fuse = "dsp_balances_print.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I print the balances.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="21 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
		</in>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.statusType" default="Member" type="string">
	<cfparam name="attributes.activityLevel" default="Active" type="string">
	<cfset variables.linesPerColumn = 36>
	<!--- Get Balances --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getBalances"
		returnvariable="qryBalances"
		dsn=#Request.DSN#
		usersTbl=#Request.usersTbl#
		user_statusTbl=#Request.user_statusTbl#
		transactionTbl=#Request.practice_transactionTbl#
		transaction_typeTbl=#Request.transaction_typeTbl#
		activityDays=#Request.activityDays#
		statusType="#attributes.statusType#"
		activitySort=true
		activityLevel=#attributes.activityLevel#
	>

	<cfset variables.numPages = CEILING(qryBalances.RecordCount / (variables.linesPerColumn * 2))>
</cfsilent>
<html>
<head>
	<link rel="P3Pv1" href="<cfoutput>#Request.theServer#</cfoutput>/w3c/p3p.xml">
<!--- SES stuff --->
<CFIF IsDefined("variables.baseHref")>
    <cfoutput><base href="#variables.baseHref#"></cfoutput>
</CFIF>
	<title><cfoutput>#Request.page_title#</cfoutput></title>
<cfif Request.js_validate IS NOT "">
	<script src="<cfoutput>#Request.js_validate#</cfoutput>" type="text/javascript"></script>
</cfif>
	<script src="<cfoutput>#Request.js_default#</cfoutput>" type="text/javascript"></script>
	<link media="screen" rel="stylesheet" href="<cfoutput>#Request.ss_print#</cfoutput>">
	<link media="print" rel="stylesheet" href="<cfoutput>#Request.ss_print#</cfoutput>">
</head>
<cfoutput>
<body onload="#Request.onLoad#">
<cfloop from="1" to="#variables.numPages#" index="pageNum">
<table width="600" border="0" cellpadding="0" cellspacing="0" align="center">
	<thead>
		<tr>
			<td align="center">
				<h2>
					#Request.page_title# as of #DateFormat(now(),"MMM. D, YYYY")# - Page #pageNum# of #variables.numPages#
				</h2>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td align="left">
				<table width="550" cellspacing="0" cellpadding="3" align="center" class="tableClass">
					<thead>
						<tr class="tableHead">
							<td width="25" align="left">
								<strong>Balance</strong>
							</td>
							<td width="245">
								<strong>Name</strong>
							</td>
							<td width="30">
								&nbsp;
							</td>
							<td width="25" align="left">
								<strong>Balance</strong>
							</td>
							<td width="245">
								<strong>Name</strong>
							</td>
						</tr>
					</thead>
					<tbody>
					<cfset startRow = ((pageNum - 1) * (2 * variables.linesPerColumn)) + 1>
					<cfset endRow = startRow + variables.linesPerColumn - 1>
					<cfloop from="#startRow#" to="#endRow#" index="i">
						<tr valign="top" class="balanceText">
							<td class="balanceCell" align="center">
								<cfset count = i>
								<cfif qryBalances.RecordCount GTE count>
									<strong>#VAL(qryBalances.balance[count])#</strong>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td class="balanceCell" align="left">
								<cfif qryBalances.RecordCount GTE count>
									<strong>#qryBalances.preferred_name[count]# #qryBalances.last_name[count]#</strong>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td class="balanceCell">
								&nbsp;
							</td>
							<td class="balanceCell" align="center">
								<cfset count = i + variables.linesPerColumn>
								<cfif qryBalances.RecordCount GTE count>
									<strong>#VAL(qryBalances.balance[count])#</strong>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td class="balanceCell" align="left">
								<cfif qryBalances.RecordCount GTE count>
									<strong>#qryBalances.preferred_name[count]# #qryBalances.last_name[count]#</strong>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
						</tr>
					</cfloop>
					</tbody>
				</table>
			</td>
		</tr>
	</tbody>
</table>
<cfif pageNum LT variables.numPages>
<div id="pageBreak"></div>
</cfif>
</cfloop>
</cfoutput>
</body>
</html>
