<!---
<fusedoc
	fuse = "dsp_update_content.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the content edit form.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="10 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
			</structure>
			
			<string name="page" scope="attributes" />
			<string name="content" scope="attributes" />

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
			<string name="content" scope="formOrUrl" />
			<number name="page_id" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="Request.squid.content.title" default="" type="string">
	<cfparam name="Request.squid.content.content" default="" type="string">
	<cfparam name="Request.squid.content.page_id" default=0 type="numeric">
	<cfparam name="attributes.from_preview" default="false" type="boolean">
	
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get current info --->
	<cfinvoke  
		component="#Request.lookup_cfc#" 
		method="getContent" 
		returnvariable="qryContent"
		dsn=#Request.DSN#
		pageTbl=#Request.pageTbl#
		page=#attributes.page#
	>

	<cfscript>
		if ((attributes.success IS NOT "No") AND (NOT attributes.from_preview))
		{
			Session.squid.content = StructNew();
			Session.squid.content.content = qryContent.content;
			Session.squid.content.title = qryContent.title;
			Session.squid.content.page_id = VAL(qryContent.page_id);
			
			Request.squid = StructCopy(Session.squid);
		}
	</cfscript>

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
<script type="text/javascript" src="#Request.contentHtmlEditPath#/browserdetect.js"></script>
<script type="text/javascript" src="#Request.contentHtmlEditPath#/richtext.js"></script>
<form id="contentForm" name="contentForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post" onsubmit="return validate(this);">
	<input type="hidden" name="page_id" value="#Request.squid.content.page_id#" />
	<input type="hidden" name="page" value="#attributes.page#" />
<table width="750" border="0" cellpadding="0" cellspacing="0" align="center">
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
				> Update #attributes.page# Page
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
				<input type="text" name="title" size="35" maxlength="255" value="#Request.squid.content.title#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Content:</strong>
			</td>
			<td>
				<textarea name="content">#request.squid.content.content#</textarea>
<!--- 12/17/2012 - no longer needed with ckeditor
				<script type="text/javascript">
				Start('#JSStringFormat(Request.contentHtmlEditPath)#','#JSStringFormat(Request.squid.content.content)#','#JsStringFormat(Request.theServer)#','#JSStringFormat(XFA.file_select)#');
				</script>
				<iframe id="testFrame" style="position: absolute; visibility: hidden; width: 0px; height: 0px;"></iframe>
				<cfset variables.tabindex = variables.tabindex + 1>
				<input type="hidden" name="content" value="" />
--->
				</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="previewBtn" value="Preview" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
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

