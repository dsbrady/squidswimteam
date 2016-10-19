<!---
<fusedoc
	fuse = "dsp_gallery_files.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the gallery files page.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="16 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
				<string name="gallery" />
				<string name="page" />
				<string name="file_select" />
			</structure>
			
			<number name="page_id" scope="attributes" />

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
			<number name="page_id" scope="formOrUrl" />
			<string name="files_old" scope="formOrUrl" />
			<string name="files" scope="formOrUrl" />

			<string name="success" scope="formOrUrl" />
			<string name="reason" scope="formOrUrl" />
		</out>
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

	<!--- Get page info --->
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
	
	<cfset variables.tabindex = 1>
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
<form name="pageForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post">
	<input type="hidden" name="page_id" value="#VAL(attributes.page_id)#" />
	<input type="hidden" name="files_old" value="#ValueList(qryFiles.file_id)#" />
	<input type="hidden" name="files" value="#ValueList(qryFiles.file_id)#" />
	<input type="hidden" name="links_old" value="#ValueList(qryFiles.link_id)#" />
	<input type="hidden" name="links" value="#ValueList(qryFiles.link_id)#" />

	<input type="hidden" name="linkURL" value="#Request.self#?fuseaction=#XFA.file_select#" />
	<input type="hidden" name="linkFA" value="#XFA.act_add_link_file#" />
<table width="550" border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td align="center" colspan="2">
				<h2>
					#Request.page_title#
				</h2>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr valign="top">
			<td align="center" colspan="2">
				<a href="#Request.self#?fuseaction=#XFA.menu#">Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.content_menu#">Content Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.contentGallery#">Gallery</a>
				> <a href="#Request.self#?fuseaction=#XFA.page#">Page Update</a>
				> Add/Remove Files
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td width="100">
				<strong>Title:</strong>
			</td>
			<td width="450">
				#qryPage.title#
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2" align="center">
				<a href="#Request.self#?fuseaction=#XFA.file_select#" onclick="return openFileWin('#Request.self#?fuseaction=#XFA.file_select#&finishFunction=opener.addFile(file_id,\'#XFA.act_add_file#\',#attributes.page_id#);opener.window.focus();');">Insert File</a>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
	<!--- Display files --->
		<tr>
			<td colspan="2" align="center">
				<table width="450" cellspacing="0" cellpadding="3" align="center" class="tableClass">
					<thead>
						<tr class="tableHead">
							<td>
								&nbsp;
							</td>
							<td align="center">
								<strong>File (Thumbnail)</strong>
							</td>
							<td align="center">
								<strong>Type</strong>
							</td>
							<td align="center">
								<strong>Links To</strong>
							</td>
							<td>
								&nbsp;
							</td>
						</tr>
					</thead>
					<tbody id="fileTbl">
				<cfif qryFiles.RecordCount EQ 0>
						<tr id="noFiles" class="tableRow1">
							<td colspan="5">
								There are no files on this page.
							</td>
						</tr>
				<cfelse>
					<cfloop query="qryFiles">
						<cfscript>
							variables.rowClass = qryFiles.currentRow MOD 2;
						</cfscript>
						<tr id="file_#qryFiles.file_id#" class="tableRow#variables.rowClass#" valign="top">
							<td>
								<a href="##" onclick="return removeFile(#qryFiles.file_id#);">Remove</a>
							</td>
							<td align="left">
								#qryFiles.filename#
							</td>
							<td align="left">
								#qryFiles.file_type#
							</td>
							<td align="left">
							<cfif LEN(TRIM(qryFiles.link_file)) GT 0>
								#qryFiles.link_file#
							<cfelse>
								(<a href="##" onclick="return openFileWin('#Request.self#?fuseaction=#XFA.file_select#&finishFunction=opener.addLinkFile(#qryFiles.file_id#,file_id);this.window.focus();');this.window.focus();">Add Link</a>)
							</cfif>
							</td>
							<td>
							<cfif qryFiles.CurrentRow NEQ 1>
								<a href="##" onclick="return moveFile(-1,#qryFiles.file_id#);">U</a>
								&nbsp;
							</cfif>
								&nbsp;
							<cfif qryFiles.CurrentRow NEQ qryFiles.RecordCount>
								<a href="##" onclick="return moveFile(1,#qryFiles.file_id#);">D</a>
							</cfif>
							</td>
						</tr>
					</cfloop>
				</cfif>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				&nbsp;
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="submitBtn" value="Save" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	</tbody>
</table>
</form>
<iframe id="PageProcessing" style="display:none"></iframe>
</cfoutput>

