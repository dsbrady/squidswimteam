<!---
<fusedoc
	fuse = "dsp_files.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the files.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="6 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="upload" />
				<string name="edit" />
				<string name="delete" />
			</structure>

			<number name="file_type_id" scope="attributes" />
		</in>
		<out>
			<number name="file_type_id" scope="formOrUrl" />
			<number name="file_id" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.fileTypeID" default=0 type="numeric">
	<cfparam name="attributes.categoryID" default=0 type="numeric">
	
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get Files --->
	<cfinvoke  
		component="#Request.lookup_cfc#" 
		method="getFiles" 
		returnvariable="qryFiles"
		dsn=#Request.DSN#
		fileTbl=#Request.fileTbl#
		file_typeTbl=#Request.file_typeTbl#
		file_categoryTbl=#Request.file_categoryTbl#
		file_type_id=#attributes.fileTypeID#
		category_id=#attributes.categoryID#
	>

	<!--- Get File Types --->
	<cfinvoke  
		component="#Request.lookup_cfc#" 
		method="getFileTypes" 
		returnvariable="qryFileTypes"
		dsn=#Request.DSN#
		file_typeTbl=#Request.file_typeTbl#
	>

	<!--- Get Categories --->
	<cfinvoke  
		component="#Request.lookup_cfc#" 
		method="getCategories" 
		returnvariable="qryCats"
		dsn=#Request.DSN#
		categoryTbl=#Request.file_categoryTbl#
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
				> Files
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center">
				<a href="#Request.self#?fuseaction=#XFA.upload#&fileTypeID=#attributes.fileTypeID#&categoryID=#attributes.categoryID#">Upload File</a>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center">
			<form name="fileTypeForm" action="#Request.self#?fuseaction=#attributes.fuseaction#" method="post">
				Display
				<select name="categoryID">
					<option value="0" <cfif VAL(attributes.categoryID) EQ 0>selected="selected"</cfif>>(All Categories)</option>
				<cfloop query="qryCats">
					<option value="#qryCats.category_id#" <cfif VAL(attributes.categoryID) EQ qryCats.category_id>selected="selected"</cfif>>#qryCats.category#</option>
				</cfloop>
				</select>
				<select name="fileTypeID">
					<option value="0" <cfif VAL(attributes.fileTypeID) EQ 0>selected="selected"</cfif>>(All File Types)</option>
				<cfloop query="qryFileTypes">
					<option value="#qryFileTypes.file_type_id#" <cfif VAL(attributes.fileTypeID) EQ qryFileTypes.file_type_id>selected="selected"</cfif>>#qryFileTypes.file_type#</option>
				</cfloop>
				</select>
				Files
				<br />
				<input type="submit" name="submitBtn" value="Find Files" />
			</form>
			</td>
		</tr>
		<tr>
			<td align="center">
			<cfif qryFiles.RecordCount>
				<table width="600" cellspacing="0" cellpadding="3" align="center" class="tableClass">
					<thead>
						<tr class="tableHead">
							<td align="center">
								<strong>File</strong>
							</td>
							<td align="center">
								<strong>Type</strong>
							</td>
							<td align="center">
								<strong>Category</strong>
							</td>
							<td align="center">
								<strong>Description</strong>
							</td>
							<td>
								&nbsp;
							</td>
						</tr>
					</thead>
					<tbody>
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
								#qryFiles.category#
							</td>
							<td align="left">
								#qryFiles.description#
							</td>
							<td align="center">
								<a href="#Request.self#?fuseaction=#XFA.delete#&fileTypeID=#attributes.fileTypeiD#&categoryID=#attributes.categoryID#&file_id=#qryFiles.file_id#7filename=#URLEncodedFormat(qryFiles.filename)#" onclick="return confirm('Delete \'#qryFiles.filename#\'?');">Delete</a>
							</td>
						</tr>
					</cfloop>
					</tbody>
				</table>
			<cfelse>
				There are no files matching your criteria.
			</cfif>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>

