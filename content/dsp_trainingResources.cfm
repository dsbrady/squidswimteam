<!---
<fusedoc
	fuse = "dsp_links.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the links.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="3 November 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="categories" />
				<string name="edit" />
				<string name="delete" />
			</structure>

			<number name="category_id" scope="attributes" />
		</in>
		<out>
			<number name="link_id" scope="formOrUrl" />
			<number name="cateogry_id" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.categoryID" default=0 type="numeric">

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
		category_id=#attributes.categoryID#
	>

	<!--- Get Categories --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getLinkCategories"
		returnvariable="qryCats"
		dsn=#Request.DSN#
		categoryTbl=#Request.link_categoryTbl#
	>
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
				<a href="#Request.self#/fuseaction/#XFA.menu#.cfm">Main Menu</a>
				> <a href="#Request.self#/fuseaction/#XFA.content_menu#.cfm">Content Menu</a>
				> Training Resources
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center">
				<a href="#Request.self#/fuseaction/#XFA.edit#.cfm">Add Resource</a>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
			<cfif request.qTrainingResources.recordCount GT 0>
				<table cellspacing="0" cellpadding="3" align="center" class="tableClass" width="80%">
					<thead>
						<tr class="tableHead">
							<td>
								&nbsp;
							</td>
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
							<td>
								&nbsp;
							</td>
						</tr>
					</thead>
					<tbody>
					<cfloop query="request.qTrainingResources">
						<tr class="tableRow#request.qTrainingResources.currentRow MOD 2#" valign="top">
							<td>
								<a href="#request.self#?fuseaction=#XFA.edit#&trainingResourceID=#request.qTrainingResources.trainingResourceID#">Edit</a>
							</td>
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
							<td>
								<a href="#request.self#?fuseaction=#XFA.delete#&trainingResourceID=#request.qTrainingResources.trainingResourceID#" onclick="return confirm('Are sure you wish to delete #jsStringFormat(request.qTrainingResources.trainingResource)#?');">Delete</a>
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

