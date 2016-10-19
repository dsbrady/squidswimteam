<!---
<fusedoc
	fuse = "dsp_buySwims_confirm.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the Buy Swims confirmation screen.
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
	<cfset variables.tabindex = 1>
	<cfset swimsCost = attributes.numSwims * Request.pricePerSwim />
	<cfset additionalSwims = attributes.numSwims \ request.purchasedSwimsPerFreeSwim />
	<cfif swimsCost LT 0>
		<cfset swimsCost = 0>
	</cfif>
</cfsilent>
<cfif attributes.success IS "no">
	<h2>There were problems with your submission:</h2>
	<ul class="errorText">
		<cfloop list="#attributes.reason#" index="variables.theItem" delimiters="*">
			<li><cfoutput>#variables.theItem#</cfoutput></li>
		</cfloop>
	</ul>
	<p>Please make corrections below and re-submit the information.</p>
<cfelseif attributes.success IS "yes">
	<p class="errorText">
		Changes Saved.
	</p>
</cfif>
<cfoutput>
<form name="buySwimsForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post">
	<input type="hidden" name="numSwims" value="#VAL(attributes.numSwims)#" />
<table width="450" border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td align="center" colspan="3">
				<h2>
					#Request.page_title#
				</h2>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr valign="top">
			<td colspan="3" align="center">
				<a href="#Request.self#?fuseaction=#XFA.menu#">Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.buySwims#">Buy Swims</a>
				> Confirmation
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="3">
				Please verify the number of swims you wish to purchase below. After clicking "Confirm Purchase,"
				you will be directed to PayPal's web site to complete your transaction. After completing your
				transaction on PayPal, you should be redirected to SQUID's site.  (If you are on PayPal's site for
				more than 20 minutes, your SQUID session will time out. If that occurs, please
				<a href="#Request.self#?fuseaction=#XFA.contact#">contact us</a> to have your
				PayPal transaction confirmed.)
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
<!--- Removed 2/19/2012
<cfif val(attributes.swimPassID) GT 0>
		<tr valign="top">
			<td width="175">
				<strong>Swim Pass:</strong>
			</td>
			<td width="150" align="right">
				#request.qSwimPass.swimPass#<cfif request.qSwimPass.swimPass CONTAINS "Student">*</cfif> (#dollarFormat(request.qSwimPass.price)#)
			</td>
			<td width="125">
				&nbsp;
			</td>
		</tr>
	<cfif request.qMember.balance NEQ 0>
		<tr valign="top">
			<td>
				<strong>Swim Balance Adjustment:</strong>
			</td>
			<td align="right">
				#request.qMember.balance# ($#trim(numberFormat(request.qMember.balance * request.pricePerSwim * -1,"999.99"))#)<sup>*</sup>
			</td>
			<td>
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td colspan="3">
				<em><sup>*</sup>This amount reflects practices currently in the system. If you attended recent practices that are not yet entered, you will have a negative balance once they are entered)</em>
			</td>
		</tr>
	</cfif>
		<tr valign="top">
			<td>
				<strong>Valid dates:</strong>
			</td>
			<td align="right">
			<cfif NOT isDate(request.qMember.swimPassExpiration) OR (isDate(request.qMember.swimPassExpiration) AND dateCompare(request.qMember.swimPassExpiration,now()) LT 1)>
				#dateFormat(now(),"m/d/yyyy")# - #dateFormat(dateAdd(request.qSwimPass.expirationUnitAbbreviation,request.qSwimPass.expirationNumber,now()),"m/d/yyyy")#
			<cfelse>
				#dateFormat(dateAdd("d",1,request.qMember.swimPassExpiration),"m/d/yyyy")# - #dateFormat(dateAdd(request.qSwimPass.expirationUnitAbbreviation,request.qSwimPass.expirationNumber,dateAdd("d",1,request.qMember.swimPassExpiration)),"m/d/yyyy")#
			</cfif>
			</td>
			<td>
				&nbsp;
			</td>
		</tr>
<cfelse>
--->
		<tr valign="top">
			<td width="150">
				<strong>Swims Purchasing:</strong>
			</td>
			<td width="25" align="right">
				#attributes.numSwims#
			</td>
			<td width="275">
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td width="150">
				<strong>Free Swims:</strong>
			</td>
			<td width="25" align="right">
				#variables.additionalSwims#
			</td>
			<td width="275">
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td width="150">
				<strong>Total Swims:</strong>
			</td>
			<td width="25" align="right">
				#variables.additionalSwims + attributes.numSwims#
			</td>
			<td width="275">
				&nbsp;
			</td>
		</tr>
<!---
</cfif>
--->
		<tr valign="top">
			<td>
				<strong>Total Cost:</strong>
			</td>
			<td align="right">
				#dollarFormat(variables.swimsCost)#
			</td>
			<td>
				&nbsp;
			</td>
		</tr>
	<cfif request.qSwimPass.swimPass CONTAINS "Student">
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="3">
				* NOTE: By clicking "Confirm Purchase" below, you certify that you are a current full-time student in good standing and that you will
				provide proof of your student status to the SQUID treasurer. You further agree that if you are later found not to have been a
				student, you agree to reimburse the SQUID Swim Team for all practices for which the swim pass was used.
			</td>
		</tr>
	</cfif>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="3" align="center">
				<input type="submit" name="submitBtn" value="Confirm Purchase" tabindex="#variables.tabindex#" class="buttonStyle" />
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

