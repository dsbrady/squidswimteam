<!--- 
<fusedoc 
	fuse="dsp_registration_confirmation.cfm" 
	language="ColdFusion" 
	specification="3.0">
	<responsibilities>
		I display the confirmation.
	</responsibilities>	
	<properties>
		<history author="Scott Brady" date="13 April 2004" type="Create" role="Architect">
	</properties>
	<io>
		<in>
			<structure name="XFA">
				<string name="printalbe" />
			</structure>
		</in>
	</io>
</fusedoc>
--->
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
					You are now registered for "Swim With an Altitude: 
					SQUID Long Course Challenge 2004." A copy of the
					information you have provided has been e-mailed to you.
				</p>
				<p>
					You can also view a <a href="#Request.self#/fuseaction/#XFA.printable#.cfm" target="challengeReceipt">printable version</a>
					of your information.
				</p>
			<cfif Session.goldrush2009.paymentMethod IS "PayPal">
				<p>
					<strong>Your payment from PayPal in the amount of US#DollarFormat(Session.goldrush2009.paypal.payment_gross)#
					has been successfully transimitted.</strong>
				</p>
			</cfif>
				<p style="font-weight:bold;">
				<cfif Session.goldrush2009.registrationType NEQ "social">
					REMINDER: You must submit
					<cfif NOT LEN(Session.goldrush2009.paypal_transaction)>
						a check made payable to "SQUID Swim Team" in the amount of
						US#DollarFormat(Session.goldrush2009.totalFee)#, a copy of your USMS/FINA card, and
					<cfelse>
						a copy of your USMS card
					</cfif>
						and a 
						<a href="#Request.waiverURL#" target="_blank">signed Liability Waiver</a> to:
					</p>
					<blockquote style="font-weight:bold;">
						SQUID Swim Team<br />
						P.O. Box 480912<br />
						Denver, CO 80248-0912<br />
					</blockquote>
					<p style="font-weight:bold;">
						If this has not been postmarked by #DateFormat(Session.goldrush2009.paymentDue,"m/d/yyyy")#,
						your registration may be cancelled.
					</p>
				<cfelseif NOT LEN(Session.goldrush2009.paypal_transaction)>
						REMINDER: You must submit
						a check made payable to "SQUID Swim Team" in the amount of
						US#DollarFormat(Session.goldrush2009.totalFee)# to:
					</p>
					<blockquote style="font-weight:bold;">
						SQUID Swim Team<br />
						P.O. Box 480912<br />
						Denver, CO 80248-0912<br />
					</blockquote>
					<p style="font-weight:bold;">
						If this has not been postmarked by #DateFormat(Session.goldrush2009.paymentDue,"m/d/yyyy")#,
						your registration may be cancelled.
					</p>
				</cfif>
			<cfif (VAL(Session.goldrush2009.housing))>
				<p>
					While SQUID makes every effort to provide hosted housing for all who request it, 
					we can not guarantee housing for you.  If you have not received information regarding 
					your housing request by #DateFormat(DateAdd("D",14,Request.housingResponseDeadline),"m/d/yyyy")#, 
					please contact us at <a href="mailto:#Request.from_email#">#Request.from_email#</a>.
				</p>
			</cfif>
				<p>
					For security reasons we recommend you <a href="#Request.self#/fuseaction/#XFA.end_session#.cfm">end your session</a> when you are finished.
				</p>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>
