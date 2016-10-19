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
	<cfparam name="attributes.numSwims" default="10" type="numeric" />
	
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<cfset variables.tabindex = 1>

	<!--- Determine final number of swims --->
	<cfif variables.currentBalance GT Request.specialDealMinimumBalance OR DateCompare(Now(),CreateDate(2006,3,1)) LT 0>
		<cfswitch expression="#attributes.numSwims \ 10#">
			<cfcase value="0">
				<cfset freeSwims = 0 />
			</cfcase>
			<cfcase value="1">
				<cfset freeSwims = 1 />
			</cfcase>
			<cfcase value="2">
				<cfset freeSwims = 3 />
			</cfcase>
			<cfcase value="3">
				<cfset freeSwims = 5 />
			</cfcase>
			<cfdefaultcase>
				<cfset freeSwims = 8 />
			</cfdefaultcase>
		</cfswitch>
		<cfif attributes.numSwims GT 40>
			<cfset freeSwims = variables.freeswims + (attributes.numSwims - 40) \ 10 />
		</cfif>
	<cfelse>
		<cfset freeSwims = attributes.numSwims \ 10 />
	</cfif>

	<cfset totalSwims = attributes.numSwims + variables.freeSwims />
	<cfset swimsCost = attributes.numSwims * Request.pricePerSwim />
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
<form name="buySwimsForm" action="#variables.baseHREF##Request.self#/fuseaction/#XFA.next#.cfm" method="post">
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
				<a href="#Request.self#/fuseaction/#XFA.menu#.cfm">Menu</a>
				> <a href="#Request.self#/fuseaction/#XFA.buySwims#.cfm">Buy Swims</a>
				> Confirmation
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="3">
				Please verify the swims you wish to purchase below. After clicking "Confirm Purchase,"
				you will be directed to PayPal's web site to complete your transaction. After completing your
				transaction on PayPal, you should be redirected to SQUID's site.  (If you are on PayPal's site for
				more than 20 minutes, your SQUID session will time out. If that occurs, please 
				<a href="#Request.self#/fuseaction/#XFA.contact#.cfm">contact us</a> to have your
				PayPal transaction confirmed.)
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
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
			<td>
				<strong>Free Swims:</strong>
			</td>
			<td align="right">
				#variables.freeSwims#
			</td>
			<td>
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Total New Swims:</strong>
			</td>
			<td align="right">
				#variables.totalSwims#
			</td>
			<td>
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Total Cost:</strong>
			</td>
			<td align="right">
				$#variables.swimsCost#
			</td>
			<td>
				&nbsp;
			</td>
		</tr>
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

