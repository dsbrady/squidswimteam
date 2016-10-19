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
		<cfoutput>#attributes.reason#</cfoutput>
	</p>
</cfif>
<cfoutput>
<table width="600" border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td align="center">
				<h2>
					#Request.page_title#
				</h2>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr valign="top">
			<td align="center">
				<a href="#Request.self#?fuseaction=#XFA.menu#">Main Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.acct_menu#">Accounting Menu</a>
				> User Swim Passes
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center">
				<form name="dateForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post" style="display:inline;" onsubmit="return validate(this);")>
				<table width="400">
					<tbody>
						<tr valign="top">
							<td align="center">
								<input type="text" name="startDate" size="10" maxlength="10" tabindex="1" value="#attributes.startDate#" />
							</td>
							<td>
								to
							</td>
							<td>
								<input type="text" name="endDate" size="10" maxlength="10" tabindex="2" value="#attributes.endDate#" />
							</td>
							<td>
								<input type="submit" name="submitBtn" tabindex="3" value="Filter Swim Passes" />
							</td>
						</tr>
					</tbody>
				</table>
				</form>
			</td>
		</tr>
		<tr>
			<td align="center">
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td>
				<h3>Swim Pass Purchases</h3>
			</td>
		</tr>
		<tr>
			<td align="center">
			<cfif request.qPurchases.recordCount GT 0>
				<table width="700" cellspacing="0" cellpadding="3" align="center" class="tableClass">
					<thead>
						<tr class="tableHead">
							<td>
								<strong>Purchased</strong>
							</td>
							<td>
								<strong>Effective</strong>
							</td>
							<td>
								<strong>Name</strong>
							</td>
							<td>
								<strong>Type</strong>
							</td>
							<td>
								<strong>Price</strong>
							</td>
							<td>
								<strong>Notes</strong>
							</td>
						</tr>
					</thead>
					<tbody>
					<cfloop query="request.qPurchases">
						<cfset variables.rowClass = request.qPurchases.currentRow MOD 2 />
						<tr class="tableRow#variables.rowClass#" valign="top">
							<td>
								#dateFormat(request.qPurchases.date_transaction,"m/d/yyyy")#
							</td>
							<td>
								#dateFormat(request.qPurchases.activeDate,"m/d/yyyy")#
								-
								#dateFormat(request.qPurchases.expirationDate,"m/d/yyyy")#
							</td>
							<td nowrap="true">
								#request.qPurchases.first_name# #request.qPurchases.last_name#
							</td>
							<td>
								#request.qPurchases.swimPass#
							</td>
							<td>
								#dollarFormat(request.qPurchases.price)#
							</td>
							<td>
								#request.qPurchases.notes#
							</td>
						</tr>
					</cfloop>
					</tbody>
				</table>				
			<cfelse>
				<strong>No swim passes purchased in this date range.</strong>
			</cfif>
			</td>
		</tr>
		<tr>
			<td align="center">
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td>
				<h3>Effective Swim Passes</h3>
			</td>
		</tr>
		<tr>
			<td>
			<cfif request.qEffective.recordCount GT 0>
				<table width="600" cellspacing="0" cellpadding="3" class="tableClass">
					<thead>
						<tr class="tableHead">
							<td>
								<strong>Effective</strong>
							</td>
							<td>
								<strong>Name</strong>
							</td>
							<td>
								<strong>Type</strong>
							</td>
						</tr>
					</thead>
					<tbody>
					<cfloop query="request.qEffective">
						<cfset variables.rowClass = request.qEffective.currentRow MOD 2 />
						<tr class="tableRow#variables.rowClass#" valign="top">
							<td>
								#dateFormat(request.qEffective.activeDate,"m/d/yyyy")#
								-
								#dateFormat(request.qEffective.expirationDate,"m/d/yyyy")#
							</td>
							<td nowrap="true">
								#request.qEffective.first_name# #request.qEffective.last_name#
							</td>
							<td>
								#request.qEffective.swimPass#
							</td>
						</tr>
					</cfloop>
					</tbody>
				</table>				
			<cfelse>
				<p align="center">
					<strong>No swim passes effective in this date range.</strong>
				</p>
			</cfif>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>