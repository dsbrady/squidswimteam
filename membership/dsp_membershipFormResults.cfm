<!---
<fusedoc
	fuse = "dsp_membershipFormResults.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the Pay Dues results screen.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="20 August 2004" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
			</structure>
			
		</in>
		<out>
		</out>
	</io>

</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.transaction_id" default="0" type="numeric" />
	
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get transaction details --->
	<cfset qTrans = lookupCFC.getMembershipTransactions(Request.dsn,Request.usersTbl,Request.membershipTransactionTbl,VAL(attributes.transaction_id)) />
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
					#qTrans.preferred_name#, we were unable to process your membership payment.  Please contact the treasurer for assistance.
				</td>
			</tr>
		</tbody>
	</table>
<cfelse>
	<cfset request.page_title = Request.page_title & "<br />Dues Paid" />
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
				#qTrans.preferred_name#, you have successfully paid your SQUID dues through <strong>#Year(qTrans.date_expiration)#</strong>.  
				The details of your transaction are below.
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
				<strong>Cost:</strong>
			</td>
			<td>
				#DollarFormat(qTrans.membershipFee)#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>PayPal Transaction ID:</strong>
			</td>
			<td>
				#attributes.paypalTransactionID#
			</td>
		</tr>
	<cfif NOT VAL(Request.squid.user_id)>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2" align="center">
				<a href="#Request.self#?fuseaction=#XFA.login#&username=#qTrans.username#">Log In</a>
			</td>
		</tr>
	</cfif>
	</tbody>
</table>
</cfif>
</cfoutput>

