<!---
<fusedoc
	fuse = "dsp_gallery_update.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the gallery page edit form.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="15 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
				<string name="gallery" />
				<string name="files" />
			</structure>
			
			<number name="page_id" scope="attributes" />
			<string name="title" scope="attributes" />
			<string name="content" scope="attributes" />

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
			<number name="page_id" scope="formOrUrl" />
			<string name="title" scope="formOrUrl" />
			<string name="content" scope="formOrUrl" />
			<string name="title_old" scope="formOrUrl" />
			<string name="content_old" scope="formOrUrl" />

			<string name="success" scope="formOrUrl" />
			<string name="reason" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.page_id" default=0 type="numeric">
	<cfparam name="attributes.title" default="" type="string">
	<cfparam name="attributes.content" default="" type="string">
	<cfparam name="attributes.title_old" default="" type="string">
	<cfparam name="attributes.content_old" default="" type="string">

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<cfif attributes.page_id GT 0 AND attributes.success IS NOT "No">
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
	
		<cfscript>
			if (attributes.success IS NOT "No")
			{
				attributes.title = qryPage.title;
				attributes.content = qryPage.content;
			}
			attributes.title_old = qryPage.title;
			attributes.content_old = qryPage.content;
		</cfscript>
	</cfif>

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
<form name="pageForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post" onsubmit="return validate(this);">
	<input type="hidden" name="page_id" value="#VAL(attributes.page_id)#" />
	<input type="hidden" name="title_old" value="#attributes.title_old#" />
	<input type="hidden" name="content_old" value="#attributes.content_old#" />
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
				> <cfif VAL(attributes.page_id)>Update<cfelse>Add</cfif> Gallery Page
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Title:</strong>
			</td>
			<td>
				<input type="text" name="title" size="45" maxlength="255" value="#attributes.title#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Description:</strong>
			</td>
			<td>
				<input type="text" name="content" size="45" maxlength="255" value="#attributes.content#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2" align="center">
			<cfif VAL(attributes.page_id) EQ 0>
				(You must save this page before you can add files.)
			<cfelse>
				<a href="#Request.self#?fuseaction=#XFA.files#&page_id=#attributes.page_id#">Add/Remove Files</a>
				<br />
				(Please save any changes before updating files.)
			</cfif>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
	<cfif VAL(attributes.page_id) GT 0>
		<!--- Display files --->
		<tr>
			<td colspan="2" align="center">
				<table width="450" cellspacing="0" cellpadding="3" align="center" class="tableClass">
					<thead>
						<tr class="tableHead">
							<td align="left" width="300">
								<strong>File</strong>
							</td>
							<td align="left" width="150">
								<strong>Type</strong>
							</td>
							<td align="left" width="150">
								<strong>Links To</strong>
							</td>
						</tr>
					</thead>
					<tbody>
				<cfif qryFiles.RecordCount EQ 0>
						<tr class="tableRow1">
							<td colspan="3">
								There are currently no files on this page.
							</td>
						</tr>
				<cfelse>
					<cfloop query="qryFiles">
						<cfscript>
							variables.rowClass = qryFiles.currentRow MOD 2;
						</cfscript>
						<tr class="tableRow#variables.rowClass#" valign="top">
							<td align="left">
								<a href="#Request.content_file_folder#/#qryFiles.filename#" target="fileWin">#qryFiles.filename#</a>
							</td>
							<td align="left">
								#qryFiles.file_type#
							</td>
							<td align="left">
							<cfif VAL(qryFiles.link_id) GT 0>
								<a href="#Request.content_file_folder#/#qryFiles.link_file#" target="fileWin">#qryFiles.link_file#</a>
							<cfelse>
								&nbsp;
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
			<td colspan="2">&nbsp;</td>
		</tr>
	</cfif>
		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="submitBtn" value="Save" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
				<input type="reset" name="resetBtn" value="Reset Values" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

