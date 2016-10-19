<!---
<fusedoc
	fuse = "dsp_balances.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the balances.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="21 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="print" />
			</structure>
		</in>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.statusType" default="Member" type="string">
	<cfparam name="attributes.activityLevel" default="Active" type="string">

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
		paymentConfirmed=true
	>

	<cfset variables.linesPerColumn = CEILING(qryBalances.RecordCount/2)>
</cfsilent>

<cfoutput>
<form name="printForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.print#" target="squidDebug" method="post" onsubmit="return validate(this,'#variables.baseHREF##Request.self#?fuseaction=#XFA.print#',#attributes.squidDebug#);">
<table width="600" border="0" cellpadding="0" cellspacing="0" align="center">
	<thead>
		<tr>
			<td align="center">
				<h2>
					#Request.page_title#
					<br />
					for
					<select name="activityLevel">
						<option value="All" <cfif attributes.activityLevel IS "All">selected="true"</cfif>>All</option>
						<option value="Active" <cfif attributes.activityLevel IS "Active">selected="true"</cfif>>Active</option>
						<option value="Inactive" <cfif attributes.activityLevel IS "Inactive">selected="true"</cfif>>Inactive</option>
					</select>
					<select name="statusType">
						<option value="All" <cfif attributes.statusType IS "All">selected="true"</cfif>>Members & Non-Members</option>
						<option value="Member" <cfif attributes.statusType IS "Member">selected="true"</cfif>>Members</option>
						<option value="Non-Member" <cfif attributes.statusType IS "Non-Member">selected="true"</cfif>>Non-Members</option>
					</select>
					<br />
					as of #DateFormat(now(),"MMM. D, YYYY")# <button type="button" name="goBtn" onclick="getData('#variables.baseHREF##request.self#?fuseaction=#attributes.fuseaction#',this.form);">Go</button>
					<br />
					<input type="submit" name="submitBtn" class="buttonStyle" value="Print" />
					<br />
					<span class="footer">(Print in Portrait mode)</span>
				</h2>
			</td>
		</tr>
		<tr valign="top">
			<td align="center">
				<a href="#Request.self#?fuseaction=#XFA.menu#">Main Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.acct_menu#">Accounting Menu</a>
				> Swim Balances
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td align="left">
				<table width="530" cellspacing="0" cellpadding="3" align="center" class="tableClass">
					<thead>
						<tr class="tableHead">
							<td width="25" align="left">
								<strong>Balance</strong>
							</td>
							<td width="225">
								<strong>Name</strong>
							</td>
							<td width="50">
								&nbsp;
							</td>
							<td width="25" align="left">
								<strong>Balance</strong>
							</td>
							<td width="225">
								<strong>Name</strong>
							</td>
						</tr>
					</thead>
					<tbody>
					<cfloop from="1" to="#variables.linesPerColumn#" index="i">
						<cfscript>
							variables.rowClass = i MOD 2;
						</cfscript>
						<tr valign="top" class="tableRow#variables.rowClass#">
							<td align="center">
								<cfset count = i>
								<cfif qryBalances.RecordCount GTE count>
									<strong>#VAL(qryBalances.balance[count])#</strong>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td align="left">
								<cfif qryBalances.RecordCount GTE count>
									<strong>#qryBalances.preferred_name[count]# #qryBalances.last_name[count]#</strong>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td>
								&nbsp;
							</td>
							<td align="center">
								<cfset count = i + variables.linesPerColumn>
								<cfif qryBalances.RecordCount GTE count>
									<strong>#VAL(qryBalances.balance[count])#</strong>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td align="left">
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
</form>
<iframe name="PageProcessing" id="PageProcessing" style="border:0;height:0px;width:0px;display:inline"></iframe>
</cfoutput>
