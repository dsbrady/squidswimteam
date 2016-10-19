<!--- 
<fusedoc 
	fuse="dsp_housing.cfm" 
		language="ColdFusion" 
		specification="3.0">
	<responsibilities>
		I display the hosted housing form.
	</responsibilities>	
	<properties>
		<history author="Scott Brady" date="11 April 2004" type="Create" role="Architect">
	</properties>
	<io>
		<in>
			<structure name="XFA">
				<string name="next" />
			</structure>

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.paymentMethod" default="PayPal" type="string">
	<cfparam name="attributes.donation" default="" type="string">
	
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<cfscript>
		// If exists, populate data
		if ((attributes.success IS NOT "No"))
		{
			attributes.paymentMethod = Session.goldrush2009.paymentMethod;
			attributes.donation = DecimalFormat(VAL(Session.goldrush2009.donation));
		}
	</cfscript>
	<cfset variables.tabindex = 1>
</cfsilent>

<cfif attributes.success IS "no">
	<h2>There were problems with your submission:</h2>
	<ul class="errorText">
		<cfloop list="#attributes.reason#" index="variables.theItem" delimiters="*">
			<li><cfoutput>#variables.theItem#</cfoutput></li>
		</cfloop>
	</ul>
	<p>Please make corrections below and re-submit the information.</p>
</cfif>

<cfoutput>
<form name="inputForm" action="#variables.baseHREF##Request.self#/fuseaction/#XFA.next#.cfm" method="post">
<table border="0" cellpadding="0" cellspacing="0" align="center" width="500">
 	<thead>
		<tr>
			<td class="header1" colspan="2">
				#Request.page_title#
			</td>
		</tr>
		<tr>
			<td colspan="2">
				&nbsp;
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<a href="#Request.self#/fuseaction/#XFA.registration_menu#.cfm">Registration Menu</a>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td colspan="2">
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				<p>
					<strong>Please choose your payment method below.</strong>
				</p>
				<p>
					If you select "PayPal," you will be sent to PayPal's site to submit your payment information and will be
					returned to the SQUID site after completing your transaction.
				</p>
				<p>
					If you choose to pay by check, you must include your check with a copy
					of your USMS registration card by <b>#DateFormat(Session.goldrush2009.paymentDue,"m/d/yyyy")#</b>
					or your registration will be cancelled.  Instructions on sending a copy of your USMS card
					(and check, if applicable) will be provided via e-mail and the confirmation screen.
				</p>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td width="250">
				<strong>Payment Method<span class="errorText">*</span>:</strong>
			</td>
			<td width="250">
				<select name="paymentMethod" tabindex="#variables.tabindex#">
					<option value="PayPal" <cfif attributes.paymentMethod IS "PayPal">selected="seelcted"</cfif>>PayPal</option>
					<option value="check" <cfif attributes.paymentMethod IS "check">selected="seelcted"</cfif>>Check</option>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Registration Fee:</strong>
			</td>
			<td>
				US#DollarFormat(variables.registrationFee)#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Donation to <a href="http://www.igla.org/" target="_blank">IGLA</a> ($1 suggested):</strong>
			</td>
			<td>
				$<input type="text" name="donation" size="5" tabindex="#variables.tabindex#" value="#attributes.donation#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				<p>
					<strong>NOTE: Once you submit your payment, you will not be able to change your payment information. You will still
					be able to log in and change your swim meet information until #DateFormat(Request.fees.lateDeadline,"mmmm d, yyyy")#.</strong>
				</p>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td colspan="2" align="center">
				<input type="submit" name="submitBtn" value="Submit Registration" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
			<td>&nbsp;</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>
