<!---
<fusedoc
	fuse = "dsp_links.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the links.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="4 November 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
		</in>
		<out>
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get Links --->
	<cfinvoke  
		component="#Request.lookup_cfc#" 
		method="getLinks" 
		returnvariable="qryLinks"
		dsn=#Request.DSN#
		linksTbl=#Request.linksTbl#
		links_categoryTbl=#Request.link_categoryTbl#
	>
</cfsilent>

<table width="600" border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td align="center">
				<h2>
					<cfoutput>#Request.page_title#</cfoutput>
				</h2>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td align="center">
			<cfif qryLinks.RecordCount>
				<table width="500">
					<tbody>
				<cfoutput query="qryLinks" group="category_id">
						<tr>
							<td align="left">
								<h4>#qryLinks.category#</h4>
							</td>
						</tr>
						<tr>
							<td align="left">
							<cfoutput>
								<p>
									<a href="#qryLinks.url#" target="_blank">#qryLinks.name#</a><cfif LEN(TRIM(qryLinks.description))> - #qryLinks.description#</cfif>
								</p>
							</cfoutput>
							</td>
						</tr>
						<tr>
							<td>
								&nbsp;
							</td>
						</tr>
				</cfoutput>
					</tbody>
				</table>
			<cfelse>
				Currently, there are no links.
			</cfif>
			</td>
		</tr>
	</tbody>
</table>

