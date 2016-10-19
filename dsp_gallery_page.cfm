<!---
<fusedoc
	fuse = "dsp_gallery_page.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the gallery page.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="19 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			
			<number name="page_id" scope="attributes" />

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.page_id" default=0 type="numeric">

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

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

	<!--- Get current item --->
	<cfinvoke  
		component="#Request.lookup_cfc#" 
		method="getContent" 
		returnvariable="qryPage"
		dsn=#Request.DSN#
		pageTbl=#Request.pageTbl#
		galleryTbl=#Request.galleryTbl#
		page_id=#VAL(attributes.page_id)#
		page="Gallery"
		parent_id=#qryGalleryID.page_id#
	>

	<!--- Get files --->
	<cfinvoke  
		component="#Request.lookup_cfc#" 
		method="getGalleryFiles" 
		returnvariable="qryFiles"
		dsn=#Request.DSN#
		galleryTbl=#Request.galleryTbl#
		fileTbl=#Request.fileTbl#
		file_typeTbl=#Request.file_typeTbl#
		categoryTbl=#Request.file_categoryTbl#
		page_id=#VAL(attributes.page_id)#
	>
</cfsilent>

<cfoutput>
<table width="550" border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td align="center">
				<h2>
					#Request.page_title#
					<br />#qryPage.title#
				</h2>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr valign="top">
			<td align="center">
				#qryPage.content#
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<!--- Display files --->
<cfif qryFiles.RecordCount EQ 0>
		<tr>
			<td align="center">
				There are currently no files on this page.
			</td>
		</tr>
<cfelse>
		<tr>
			<td align="center">
				<table width="500" cellspacing="0" cellpadding="3" align="center" class="tableClass">
					<tbody>
					<cfloop query="qryFiles">
						<tr class="tableRow1">
							<td align="center">
							<cfif CompareNoCase(qryFiles.file_type,"Image") EQ 0>
								<cftry>
									<!--- Get image info --->
									<cfinvoke  
										component="#Request.image_cfc#" 
										method="getImageInfo" 
										returnvariable="imageinfo"
										file="#Request.content_file_path#\#qryFiles.filename#"
									>
									<cfcatch type="Any">
										<cfset imageinfo.height = "">
										<cfset imageinfo.width = "">
									</cfcatch>
								</cftry>
								<cfif VAL(qryFiles.link_id) GT 0>
									<a href="#Request.content_file_folder#/#qryFiles.link_file#" target="fileWin">
								</cfif>
								<img src="#Request.content_file_folder#/#qryFiles.filename#" alt="#qryFiles.description#" height="#imageinfo.height#" width="#imageinfo.width#" />
								<cfif VAL(qryFiles.link_id) GT 0>
									</a>
								</cfif>
							<cfelse>
								<a href="#Request.content_file_folder#/#qryFiles.filename#" target="fileWin">#qryFiles.filename#</a>
								<cfif LEN(TRIM(qryFiles.description))>- #qryFiles.description#</cfif>
							</cfif>
							</td>
						</tr>
						<tr class="tableRow1">
							<td>&nbsp;</td>
						</tr>
					</cfloop>
					</tbody>
				</table>
			</td>
		</tr>
</cfif>
	</tbody>
</table>
</cfoutput>

