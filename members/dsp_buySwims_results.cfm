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
<cfoutput>
<cfif attributes.success IS "no">
	<cfset request.page_title = Request.page_title & "<br />Payment Failure" />
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
					#session.squid.preferred_name#, we were unable to process your payment.  Please contact the treasurer for assistance.
				</td>
			</tr>
		</tbody>
	</table>
<cfelse>
	<cfset request.page_title = Request.page_title & "<br />Buy Swims Completed" />
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
			<td colspan="2" align="center">
				<a href="#Request.self#?fuseaction=#XFA.menu#">Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.buySwims#">Buy Swims</a>
				> Completed
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				#Request.squid.preferred_name#, you have successfully purchased
				<strong>#VAL(request.qTrans.num_swims)#</strong> swims.
				The details of your transaction are below.
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
				#request.qTrans.memberpref# #request.qTrans.memberlast#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Swims:</strong>
			</td>
			<td>
				#request.qTrans.num_swims#
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
				#ListLast(request.qTrans.notes," ")#
			</td>
		</tr>
	</tbody>
</table>
</cfif>
</cfoutput>