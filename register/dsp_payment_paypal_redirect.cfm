<!--- 
<fusedoc 
	fuse="dsp_payment_paypal_redirect.cfm" 
	language="ColdFusion" 
	specification="3.0"
>
	<responsibilities>
		I display the paypal redirection page.
	</responsibilities>	
	<properties>
		<history author="Scott Brady" date="16 April 2004" type="Create" role="Architect">
	</properties>
	<io>
		<in>
			<structure name="XFA">
				<string name="next" />
			</structure>
		</in>
	</io>
</fusedoc>
--->
<cfhtmlhead text="<meta http-equiv=""Refresh"" content=""#Request.refreshRate#"" />">
<cfoutput>
<table border="0" cellpadding="0" cellspacing="0" align="center" class="contentSmall">
 	<thead>
		<tr>
			<td class="header1">
				#Request.page_title#
			</td>
		</tr>
	</thead>
	<tbody>
		<tr valign="top">
			<td>
				<br />
				<p>
					You must now go to PayPal to submit your payment.  Click on the link
					below will take you to PayPal's site.  When you are finished, you will return
					here for your receipt/confirmation.
				</p>
<!--- 
				<p>
					<strong>Note:  Clicking on the link will open a new window.  Please leave this window open until you have returned from PayPal.</strong>
				</p>
 --->
				<p>
					<a href="#Request.self#/fuseaction/#XFA.next#.cfm">Proceed to Paypal</a>
				</p>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>
