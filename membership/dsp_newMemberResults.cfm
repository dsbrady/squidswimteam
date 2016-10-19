<!---
<fusedoc
	fuse = "dsp_newMemberResults.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the new member results page.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="28 February 2013" type="Create">
	</properties>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.transaction_id" default="0" type="numeric" />
	<cfparam name="attributes.paypalTransactionID" default="" type="string" />
	<cfparam name="attributes.practiceTransactionID" default="0" type="numeric" />
	<cfparam name="attributes.totalCost" default="0" type="numeric" />
	<cfparam name="attributes.success" default="true" type="boolean" />
	<cfparam name="attributes.reason" default="" type="string" />
</cfsilent>

<cfoutput>
<cfif attributes.success IS "no">
	<cfset request.page_title = Request.page_title & "<br />Dues Payment Failure" />
	<table width="450" border="0" cellpadding="0" cellspacing="0" align="center">
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
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr valign="top">
				<td colspan="2">
					#attributes.reason#
				</td>
			</tr>
		</tbody>
	</table>
<cfelse>
	<!--- Get transaction details --->
	<cfset qTrans = request.lookupCFC.getMembershipTransactions(Request.dsn,Request.usersTbl,Request.membershipTransactionTbl,VAL(attributes.transaction_id)) />

	<cfif attributes.practiceTransactionID GT 0>
		<cfset qPracticeTransaction = request.lookupCFC.getPaypalPurchaseTransaction(VAL(attributes.practiceTransactionID),qTrans.member_id,request.DSN) />
	</cfif>
	<cfset request.page_title = Request.page_title & "<br />Membership Complete" />
<table width="450" border="0" cellpadding="0" cellspacing="0" align="center">
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
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				<p>
					#qTrans.preferred_name#, you have successfully signed up for SQUID and paid your dues through <strong>#Year(qTrans.date_expiration)#</strong>.  
				<cfif attributes.practiceTransactionID GT 0>
					Additionally, you have purchased #qPracticeTransaction.num_swims# swim<cfif qPracticeTransaction.num_swims NEQ 1>s</cfif>.
				</cfif>
					The details of your transaction are below.
				</p>
				<p>
					<a href="#Request.self#?fuseaction=#XFA.login#&username=#qTrans.email#">Login to your account</a>
				</p>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>User Name:</strong>
			</td>
			<td>
				#qTrans.email#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Your name:</strong>
			</td>
			<td>
				#qTrans.preferred_name# #qTrans.last_name#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Paid Through:</strong>
			</td>
			<td>
				#Year(qTrans.date_expiration)#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Dues:</strong>
			</td>
			<td>
				#DollarFormat(qTrans.membershipFee)#
			</td>
		</tr>
	<cfif attributes.practiceTransactionID GT 0>
		<tr valign="top">
			<td>
				<strong>Swims:</strong>
			</td>
			<td>
				#qPracticeTransaction.num_swims#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Swims Cost:</strong>
			</td>
			<td>
				#DollarFormat(attributes.totalCost - qTrans.membershipFee)#
			</td>
		</tr>
	</cfif>
		<tr valign="top">
			<td>
				<strong>PayPal Transaction ID:</strong>
			</td>
			<td>
				#attributes.paypalTransactionID#
			</td>
		</tr>
	</tbody>
</table>
</cfif>
</cfoutput>

