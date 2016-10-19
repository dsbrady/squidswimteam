<!---
<fusedoc
	fuse = "dsp_content_preview.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the content preview.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="14 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
				<string name="edit" />
			</structure>
			
			<number name="page_id" scope="attributes" />
			<string name="page" scope="attributes" />
			<string name="title" scope="attributes" />
			<string name="content" scope="attributes" />

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
			<number name="page_id" scope="formOrUrl" />
			<string name="title" scope="formOrUrl" />
			<string name="content" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

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
<form name="contentForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post">
	<input type="hidden" name="page_id" value="#Request.squid.content.page_id#" />
	<input type="hidden" name="page" value="#Request.squid.content.page#" />
	<input type="hidden" name="from_preview" value="true" />
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
				<a href="#Request.self#?fuseaction=#XFA.menu#">Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.content_menu#">Content Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.edit#&from_preview=true">Edit</a>
				> Preview #Request.squid.content.page# Page
				<hr />
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center">
				<h2>#Request.squid.content.title#</h2>
			</td>
		</tr>
		<tr valign="top">
			<td>
				#Request.squid.content.content#
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="editBtn" value="Edit" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
				<input type="submit" name="submitBtn" value="Save" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
				<input type="submit" name="cancelBtn" value="Cancel" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

