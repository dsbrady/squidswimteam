<!---
<fusedoc
	fuse = "dsp_files_upload.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the file upload.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="9 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
				<string name="files" />
			</structure>
			
			<number name="categoryID" scope="attributes" />
			<number name="fileTypeID" scope="attributes" />
			<number name="category_id" scope="attributes" />
			<number name="file_type_id" scope="attributes" />
			<string name="new_category" scope="attributes" />
			<string name="description" scope="attributes" />
		</in>
		<out>
			<number name="categoryID" scope="formOrUrl" />
			<number name="fileTypeID" scope="formOrUrl" />
			<number name="category_id" scope="formOrUrl" />
			<number name="file_type_id" scope="formOrUrl" />
			<string name="new_category" scope="formOrUrl" />
			<string name="filename" scope="formOrUrl" />
			<string name="description" scope="formOrUrl" />
		</out>
	</io>

</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.fileTypeID" default=0 type="numeric">
	<cfparam name="attributes.categoryID" default=0 type="numeric">
	<cfparam name="attributes.category_id" default=#attributes.categoryID# type="numeric">
	<cfparam name="attributes.new_category" default="" type="string">
	<cfparam name="attributes.file_type_id" default=#attributes.fileTypeID# type="numeric">
	<cfparam name="attributes.description" default="" type="string">
	
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get all categories --->
	<cfinvoke  
		component="#Request.lookup_cfc#" 
		method="getCategories" 
		returnvariable="qryCats"
		dsn=#Request.DSN#
		categoryTbl=#Request.file_categoryTbl#
	>

	<!--- Get File Types --->
	<cfinvoke  
		component="#Request.lookup_cfc#" 
		method="getFileTypes" 
		returnvariable="qryFileTypes"
		dsn=#Request.DSN#
		file_typeTbl=#Request.file_typeTbl#
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
</cfif>

<cfoutput>
<form name="fileForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post" onsubmit="return validate(this);" enctype="multipart/form-data">
<table width="500" border="0" cellpadding="0" cellspacing="0" align="center">
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
			<td colspan="2" align="center">
				<a href="#Request.self#?fuseaction=#XFA.menu#">Main Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.content_menu#">Content Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.files#&fileTypeID=#attributes.fileTypeID#&categoryID=#attributes.categoryID#">Files</a>
				> Upload File
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Category:</strong>
			</td>
			<td>
				<select name="category_id" size="1" tabindex="#variables.tabindex#" onchange="return changeCat(this,this.form.elements.new_category);" />
					<option value="0" <cfif attributes.category_id EQ 0>selected="selected"</cfif>>(Select a category)</option>
				<cfloop query="qryCats">
					<option value="#qryCats.category_id#" <cfif attributes.category_id EQ qryCats.category_id>selected="selected"</cfif>>#qryCats.category#</option>
				</cfloop>
					<option value="-1" <cfif attributes.category_id EQ -1>selected="selected"</cfif>>(Add Category)</option>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
				<br />
				<input type="text" id="newCat" name="new_category" size="25" maxlength="50" value="#attributes.new_category#" style="visibility:<cfif attributes.category_id EQ -1>visible<cfelse>hidden</cfif>;" tabindex="#variables.tabindex#" />
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>File Type:</strong>
			</td>
			<td>
				<select name="file_type_id" size="1" tabindex="#variables.tabindex#" />
					<option value="0" <cfif attributes.file_type_id EQ 0>selected="selected"</cfif>>(Select a file type)</option>
				<cfloop query="qryFileTypes">
					<option value="#qryFileTypes.file_type_id#" <cfif attributes.file_type_id EQ qryFileTypes.file_type_id>selected="selected"</cfif>>#qryFileTypes.file_type#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>File:</strong>
			</td>
			<td>
				<input type="file" name="filename" size="25" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Description:</strong>
			</td>
			<td>
				<input type="text" name="description" size="25" maxlength="255" tabindex="#variables.tabindex#" value="#attributes.description#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2" align="center">
				<input type="submit" name="submitBtn" value="Upload File" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

