<!---
<fusedoc
	fuse = "dsp_gallery.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the gallery page list.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="15 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="edit" />
				<string name="delete" />
			</structure>

		</in>
		<out>
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get gallery Page ID --->
	<cfinvoke  
		component="#Request.lookup_cfc#" 
		method="getContent" 
		returnvariable="qryGalleryID"
		dsn=#Request.DSN#
		pageTbl=#Request.pageTbl#
		page="Gallery"
		parent_id=0
	>

	<!--- Get Gallery Pages --->
	<cfinvoke  
		component="#Request.lookup_cfc#" 
		method="getContent" 
		returnvariable="qryPages"
		dsn=#Request.DSN#
		pageTbl=#Request.pageTbl#
		galleryTbl=#Request.galleryTbl#
		page="Gallery"
		parent_id=#qryGalleryID.page_id#
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
				<a href="#Request.self#?fuseaction=#XFA.menu#">Main Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.content_menu#">Content Menu</a>
				> Gallery Pages
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center">
				<a href="#Request.self#?fuseaction=#XFA.edit#">Add Page</a>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="center">
			<cfif qryPages.RecordCount>
				<table width="600" cellspacing="0" cellpadding="3" align="center" class="tableClass">
					<thead>
						<tr class="tableHead">
							<td>
								&nbsp;
							</td>
							<td align="left">
								<strong>Title</strong>
							</td>
							<td align="left">
								<strong>Description</strong>
							</td>
							<td align="center">
								<strong>Number of Files</strong>
							</td>
							<td>
								&nbsp;
							</td>
						</tr>
					</thead>
					<tbody>
					<cfloop query="qryPages">
						<cfscript>
							variables.rowClass = qryPages.currentRow MOD 2;
						</cfscript>
						<tr class="tableRow#variables.rowClass#" valign="top">
							<td>
								<a href="#Request.self#?fuseaction=#XFA.edit#/page_id/#qryPages.page_id#">Edit</a>
							</td>
							<td align="left">
								#qryPages.title#
							</td>
							<td align="left">
								#qryPages.content#
							</td>
							<td align="center">
								#qryPages.numFiles#
							</td>
							<td align="center">
								<a href="#Request.self#?fuseaction=#XFA.delete#&page_id=#qryPages.page_id#" onclick="return confirm('Delete #JsStringFormat(qryPages.title)#?');">Delete</a>
							</td>
						</tr>
					</cfloop>
					</tbody>
				</table>
			<cfelse>
				There are no pages matching your criteria.
			</cfif>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>

