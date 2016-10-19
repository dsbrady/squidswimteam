<!---
<fusedoc
	fuse = "dsp_buySwims_results.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the Buy Swims results screen.
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
			
			<number name="numSwims" scope="attributes" />
		</in>
		<out>
			<number name="numSwims" scope="formOrUrl" />
		</out>
	</io>

</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.transaction_id" default="0" type="numeric" />
	<cfparam name="attributes.swimsCost" default="0" type="numeric" />
	
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get transaction details --->
	<cfset qTrans = lookupCFC.getTransactions(VAL(attributes.transaction_id),Request.squid.user_id,0,Request.DSN,Request.usersTbl,Request.user_statusTbl,Request.practice_transactionTbl,Request.practicesTbl,Request.transaction_typeTbl,Request.facilityTbl) />
</cfsilent>

<cfif attributes.success IS "no">
	<h2>There were problems with your submission:</h2>
	<ul class="errorText">
		<cfloop list="#attributes.reason#" index="variables.theItem" delimiters="*">
			<li><cfoutput>#variables.theItem#</cfoutput></li>
		</cfloop>
	</ul>
</cfif>

<cfoutput>
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
		<tr valign="top">
			<td colspan="2" align="center">
				<a href="#Request.self#/fuseaction/#XFA.menu#.cfm">Menu</a>
				> <a href="#Request.self#/fuseaction/#XFA.buySwims#.cfm">Buy Swims</a>
				> Completed
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				#Request.squid.preferred_name#, you have successfully purchased <strong>#VAL(qTrans.num_swims)#</strong>
				swims.  The details of your transaction are below.
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Your name:</strong>
			</td>
			<td>
				#qTrans.memberpref# #qTrans.memberlast#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Swims:</strong>
			</td>
			<td>
				#qTrans.num_swims#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Cost:</strong>
			</td>
			<td>
				#DollarFormat(attributes.swimsCost)#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>PayPal Transaction ID:</strong>
			</td>
			<td>
				#ListLast(qTrans.notes," ")#
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>

