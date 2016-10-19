<!---
<fusedoc
	fuse = "dsp_buySwims.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the Buy Swims screen.
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
				> Buy Swims
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				To purchase swims and pay via PayPal, select the number of of swims you'd like to purchase.
				You will receive additional swims for based on the number of swims you purchase, as shown in the table below, at no additional charge.
				Each swim is #dollarFormat(request.pricePerSwim)#.
				(If you'd like to purchase swims by check, please mail us a check or bring one to practice)
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<table border="1" cellpadding="2" cellspacing="0">
					<thead>
						<tr>
							<th>Purchased</th>
							<th>Free Swims</th>
						</tr>
					</thead>
					<tbody>
					<cfif variables.currentBalance GT Request.specialDealMinimumBalance OR DateCompare(Now(),CreateDate(2006,3,1)) LT 0>
						<tr align="center">
							<td>10 - 19</td>
							<td>1</td>
						</tr>
						<tr align="center">
							<td>20 - 29</td>
							<td>3</td>
						</tr>
						<tr align="center">
							<td>30 - 39</td>
							<td>5</td>
						</tr>
						<tr align="center">
							<td>40+</td>
							<td>8 + 1 for every 10 above 40</td>
						</tr>
					<cfelse>
						<tr align="center">
							<td>10+</td>
							<td>1 for every 10 purchased</td>
						</tr>
					</cfif>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td width="150">
				<strong>Number of Swims:</strong>
			</td>
			<td width="300">
				<select name="numSwims" size="1" tabindex="#variables.tabindex#">
				<cfloop from="10" to="100" index="i">
					<option value="#i#" <cfif attributes.numSwims EQ i>selected="selected"</cfif>>#i#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2" align="center">
				<input type="submit" name="submitBtn" value="Next Step" tabindex="#variables.tabindex#" class="buttonStyle" />
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

