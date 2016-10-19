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
				<a href="#Request.self#?fuseaction=#XFA.menu#">Menu</a>
				> Training Resources
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
			<cfif request.qTrainingResources.recordCount GT 0>
				<table cellspacing="0" cellpadding="3" align="center" class="tableClass" width="100%">
					<thead>
						<tr class="tableHead">
							<td>
								<strong>Date</strong>
							</td>
							<td>
								<strong>Type</strong>
							</td>
							<td>
								<strong>Resource</strong>
							</td>
							<td>
								<strong>Description</strong>
							</td>
						</tr>
					</thead>
					<tbody>
					<cfloop query="request.qTrainingResources">
						<tr class="tableRow#request.qTrainingResources.currentRow MOD 2#" valign="top">
							<td>
								#dateFormat(request.qTrainingResources.created,"m/d/yyyy")#
							</td>
							<td>
								#request.qTrainingResources.trainingResourceType#
							</td>
							<td>
								<a href="#request.self#?fuseaction=#XFA.viewTrainingResource#&trainingResourceID=#request.qTrainingResources.trainingResourceID#">#request.qTrainingResources.trainingResource#</a>
							</td>
							<td>
								#request.qTrainingResources.description#
							</td>
						</tr>
					</cfloop>
					</tbody>
				</table>
			<cfelse>
				There are no training resources at this time.
			</cfif>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>

