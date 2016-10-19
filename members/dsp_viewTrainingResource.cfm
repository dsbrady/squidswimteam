<cfoutput>
<table width="500" border="0" cellpadding="0" cellspacing="0" align="center">
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
				<a href="#Request.self#/fuseaction/#XFA.menu#.cfm">Dashboard</a>
				> <a href="#Request.self#/fuseaction/#XFA.trainingResources#.cfm">Training Resources</a>
				> View Training Resource
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	<cfif request.qTrainingResource.recordCount GT 0>
		<tr>
			<td align="center">
				<h2>#request.qTrainingResource.trainingResource#</h2>
			</td>
		</tr>
		<tr>
			<td>
				#request.qTrainingResource.description#
			</td>
		</tr>
		<tr>
			<td>
				&nbsp;
			</td>
		</tr>
		<tr>
			<td>
			<cfif request.qTrainingResource.trainingResourceType IS "Training Video">
				#request.qTrainingResource.resourceContent#
			</cfif>
			</td>
		</tr>
	<cfelse>
		<tr>
			<td align="center">
				<h2>Resource Not Found!</h2>
			</td>
		</tr>
		<tr>
			<td>
				The training resource you requested was not found.  It may no longer exist or you may not have
				access to view it at this time.
			</td>
		</tr>
	</cfif>
	</tbody>
</table>
</cfoutput>

