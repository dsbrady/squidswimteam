<!---
<fusedoc
	fuse = "dsp_gallery.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the gallery page list.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="19 October 2003" type="Create">
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
	<!--- Get Gallery Page ID --->
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
	<cfif qryPages.RecordCount>
		<tr>
			<td>
				Select a page to view:
				<ul>
				<cfloop query="qryPages">
					<li>
						<a href="#Request.self#?fuseaction=#XFA.details#&page_id=#qryPages.page_id#">#qryPages.title#</a><cfif LEN(TRIM(qryPages.content))> - #qryPages.content#</cfif>
					</li>
				</cfloop>
				</ul>
			</td>
		</tr>
	<cfelse>
		<tr>
			<td>
				Currently, there are no gallery pages.
			</td>
		</tr>
	</cfif>
	</tbody>
</table>
</cfoutput>

