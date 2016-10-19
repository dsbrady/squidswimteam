<!--- 
<fusedoc fuse="dsp_content.cfm" language="ColdFusion" specification="3.0">
	<responsibilities>
		I display content page.
	</responsibilities>	
	<properties>
		<history author="Scott Brady" date="14 October 2003" type="Create" role="Architect">
	</properties>
	<io>
		<in>
			<structure name="XFA">
				
			</structure>
		</in>
	</io>
</fusedoc>
--->
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
			<td>
				#qryContent.content#
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>
