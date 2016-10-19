<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!---
<fusedoc
	fuse = "dsp_file_select.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the file select page.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="13 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			
			<boolean name="imageYN" scope="attributes" />
			<numeric name="category_id" scope="attributes" />
		</in>
		<out>

			<string name="success" scope="formOrUrl" />
			<string name="reason" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.category_id" default=0 type="numeric">
	<cfparam name="attributes.finishFunction" default="" type="string">
	<cfparam name="attributes.imageYN" default="" type="string">

	<!--- Get Files --->
	<cfinvoke  
		component="#Request.lookup_cfc#" 
		method="getFiles" 
		returnvariable="qryFiles"
		dsn=#Request.DSN#
		fileTbl=#Request.fileTbl#
		file_typeTbl=#Request.file_typeTbl#
		file_categoryTbl=#Request.file_categoryTbl#
		category_id=#attributes.category_id#
		imageYN=#attributes.imageYN#
	>

	<!--- Get Categories --->
	<cfinvoke  
		component="#Request.lookup_cfc#" 
		method="getCategories" 
		returnvariable="qryCats"
		dsn=#Request.DSN#
		categoryTbl=#Request.file_categoryTbl#
	>
	
	<cfscript>
		if (attributes.imageYN IS "Yes")
		{
			tblWidth = 450;
		}
		else
		{
			tblWidth = 550;
		}
	</cfscript>
</cfsilent>
<html>
<head>
	<link rel="P3Pv1" href="<cfoutput>#Request.theServer#</cfoutput>/w3c/p3p.xml">
<!--- SES stuff --->
<CFIF IsDefined("variables.baseHref")>
    <cfoutput><base href="#variables.baseHref#"></cfoutput>
</CFIF>
	<title><cfoutput>#Request.page_title#</cfoutput></title>
<cfif Request.js_validate IS NOT "">
	<script src="<cfoutput>#Request.js_validate#</cfoutput>" type="text/javascript"></script>
</cfif>
	<script src="<cfoutput>#Request.js_default#</cfoutput>" type="text/javascript"></script>
	<link media="screen" rel="stylesheet" href="<cfoutput>#Request.ss_main#</cfoutput>">
<cfif Request.ss_template IS NOT "">
	<link media="screen" rel="stylesheet" href="<cfoutput>#Request.ss_template#</cfoutput>">
</cfif>
</head>
<cfoutput><body onload="#Request.onLoad#"></cfoutput>

<cfoutput>
<form id="imageForm" name="imageForm" action="##" method="post">
<table width="#tblWidth#" border="0" cellpadding="0" cellspacing="0" align="center">
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
				Display
				<select name="category_id" onchange="return changeCat(this,'#Request.theServer#/#Request.self#?fuseaction=#attributes.fuseaction#&imageYN=#attributes.imageYN#&category_id=');">
					<option value="0" <cfif VAL(attributes.category_id) EQ 0>selected="selected"</cfif>>(All Categories)</option>
				<cfloop query="qryCats">
					<option value="#qryCats.category_id#" <cfif VAL(attributes.category_id) EQ qryCats.category_id>selected="selected"</cfif>>#qryCats.category#</option>
				</cfloop>
				</select>
				Files
			</td>
		</tr>
		<tr>
			<td>
				&nbsp;
			</td>
		</tr>
		<tr>
			<td align="center">
			<cfif qryFiles.RecordCount>
				<table width="#tblWidth#" cellspacing="0" cellpadding="3" align="center" class="tableClass">
					<thead>
						<tr class="tableHead">
							<td align="center">
								<strong>File</strong>
							</td>
						<cfif attributes.imageYN IS NOT "Yes">
							<td align="center">
								<strong>Type</strong>
							</td>
						</cfif>
							<td align="center">
								<strong>Category</strong>
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
							<td>
								<a href="#Request.content_file_folder#/#qryFiles.filename#" target="fileWin">#qryFiles.filename#</a>
							</td>
						<cfif attributes.imageYN IS NOT "Yes">
							<td align="center">
								#qryFiles.file_type#
							</td>
						</cfif>
							<td align="center">
								#qryFiles.category#
							</td>
							<td align="center">
								<input type="button" id="file_#qryFiles.file_id#" name="file_#qryFiles.file_id#" class="buttonStyle" onclick="return selectFile('#JsStringFormat(Request.content_file_folder & "/" & qryFiles.filename)#','#JSStringFormat(attributes.finishFunction)#',#qryFiles.file_id#);" value="Insert" />
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
		<tr>
			<td align="center">
				<input type="button" name="closeBtn" value="Close Window" class="buttonStyle" onclick="window.close();" />
			</td>
		</tr>
	</tbody>
</table>
</form>

</body>
</cfoutput>
</html>
