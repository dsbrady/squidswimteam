<!--- I display the buy swims content --->
<cfparam name="attributes.numSwims" default="0" type="numeric" />
<cfparam name="attributes.displayZeroSwims" default="false" type="boolean" />
<cfoutput>
<p>
	To purchase individual swims and pay via PayPal, select the number of of swims you'd like to purchase.
	Each swim is #dollarFormat(request.pricePerSwimMembers)#.  For every 10 swims you purchase, you will receive an additional
	swim at no charge.
	(If you'd like to purchase swims by check, please mail us a check or bring one to practice)
</p>
<div id="numberOfSwimsLabelContainer">
	<label for="numSwims">
		<strong>Number of Swims:</strong>
	</label>
</div>
<div id="numberOfSwimsSelectContainer">
	<select name="numSwims" size="1" id="numSwims">
	<cfif attributes.displayZeroSwims>
		<option value="0" <cfif attributes.numSwims EQ 0>selected="true"</cfif>>0</option>
	</cfif>
	<cfloop from="10" to="100" index="i">
		<option value="#i#" <cfif attributes.numSwims EQ i>selected="true"</cfif>>#i#</option>
	</cfloop>
	</select>
</div>
</cfoutput>
