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
<form name="buySwimsForm" action="#Request.self#?fuseaction=#XFA.next#" method="post">
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
				<a href="#Request.self#?fuseaction=#XFA.menu#">Menu</a>
				> Buy Swims
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				<p>
					To purchase individual swims and pay via PayPal, select the number of of swims you'd like to purchase.
					Each swim is #dollarFormat(request.pricePerSwim)#.  For every 10 swims you purchase, you will receive an additional
					swim at no charge.
					(If you'd like to purchase swims by check, please mail us a check or bring one to practice)
				</p>
<!---
			<cfif request.qMember.balance LT 0>
				<p>
					NOTE: You currently have a negative swim balance of #request.qMember.balance#.
					Your purchase price will be increased at the rate of #dollarFormat(request.pricePerSwim)# per swim.
				</p>
			</cfif>
 --->
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
<!---
			<td width="150">
				<strong>Swim Pass:</strong>
			</td>
			<td width="300">
				<select name="swimPassID" size="1" tabindex="#variables.tabindex#">
					<option value="0" <cfif attributes.swimPassID EQ 0>selected="true"</cfif>>(Select a Pass)</option>
				<cfloop query="request.qSwimPasses">
					<option value="#request.qSwimPasses.swimPassID#" <cfif attributes.swimPassID EQ request.qSwimPasses.swimPassID>selected="true"</cfif>>#request.qSwimPasses.swimPass# (#dollarFormat(request.qSwimPasses.price)#)</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2">OR</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
--->
		<tr valign="top">
			<td width="150">
				<strong>Number of Swims:</strong>
			</td>
			<td width="300">
				<select name="numSwims" size="1" tabindex="#variables.tabindex#">
				<cfloop from="10" to="100" index="i">
					<option value="#i#" <cfif attributes.numSwims EQ i>selected="true"</cfif>>#i#</option>
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

