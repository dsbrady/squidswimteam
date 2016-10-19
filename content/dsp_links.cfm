<!---
<fusedoc
	fuse = "dsp_links.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the links.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="3 November 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="categories" />
				<string name="edit" />
				<string name="delete" />
			</structure>

			<number name="category_id" scope="attributes" />
		</in>
		<out>
			<number name="link_id" scope="formOrUrl" />
			<number name="cateogry_id" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.categoryID" default=0 type="numeric">
	
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get Links --->
	<cfinvoke  
		component="#Request.lookup_cfc#" 
		method="getLinks" 
		returnvariable="qryLinks"
		dsn=#Request.DSN#
		linksTbl=#Request.linksTbl#
		links_categoryTbl=#Request.link_categoryTbl#
		category_id=#attributes.categoryID#
	>

	<!--- Get Categories --->
	<cfinvoke  
		component="#Request.lookup_cfc#" 
		method="getLinkCategories" 
		returnvariable="qryCats"
		dsn=#Request.DSN#
		categoryTbl=#Request.link_categoryTbl#
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
<form name="linkForm" action="#Request.self#?fuseaction=#XFA.next#" method="post" onsubmit="return validateLinks(this);" style="display:inline">
	<input type="hidden" name="links_old" value="#ValueList(qryLinks.link_id)#" />
	<input type="hidden" name="links" value="#ValueList(qryLinks.link_id)#" />
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
				> Links
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center">
				<a href="##" onclick="return addLink();">Add Link</a>
				| <a href="#Request.self#?fuseaction=#XFA.categories#">Update Categories</a>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center">
				Category:
				<select name="categoryID" onchange="return changeCat(this,'#Request.self#?fuseaction=#attributes.fuseaction#&categoryID=' + this[this.selectedIndex].value);">
					<option value="-1" <cfif VAL(attributes.categoryID) EQ -1>selected="selected"</cfif>>(Select a Category)</option>
				<cfloop query="qryCats">
					<option value="#qryCats.category_id#" <cfif VAL(attributes.categoryID) EQ qryCats.category_id>selected="selected"</cfif>>#qryCats.category#</option>
				</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td align="center">
			<cfif VAL(attributes.categoryID) GT 0>
				<table width="600" cellspacing="0" cellpadding="3" align="center" class="tableClass">
					<thead>
						<tr class="tableHead">
							<td>
								&nbsp;
							</td>
							<td align="center">
								<strong>Name</strong>
							</td>
							<td align="center">
								<strong>URL</strong>
							</td>
							<td align="center">
								<strong>Description</strong>
							</td>
							<td>
								&nbsp;
							</td>
						</tr>
					</thead>
					<tbody id="linkTbl">
				<cfif qryLinks.RecordCount EQ 0>
						<tr id="noLinks" class="tableRow1">
							<td colspan="5">
								There are no links in this category.
							</td>
						</tr>
				<cfelse>
					<cfloop query="qryLinks">
						<cfscript>
							variables.rowClass = qryLinks.currentRow MOD 2;
						</cfscript>
						<tr id="link_#qryLinks.link_id#" class="tableRow#variables.rowClass#" valign="top">
							<td>
								<a href="##" onclick="return removeLink(#qryLinks.link_id#);">Remove</a>
							</td>
							<td align="left">
								<input type="text" name="name_#qryLinks.link_id#" size="15" maxlength="50" value="#qryLinks.name#" onchange="madeChanges=true;" />
							</td>
							<td align="left">
								<input type="text" name="url_#qryLinks.link_id#" size="15" maxlength="255" value="#qryLinks.url#" onchange="madeChanges=true;" />
							</td>
							<td align="left">
								<input type="text" name="desc_#qryLinks.link_id#" size="25" maxlength="255" value="#qryLinks.description#" onchange="madeChanges=true;" />
							</td>
							<td align="right">
							<cfif qryLinks.CurrentRow NEQ 1>
								<a href="##" onclick="return moveLink(-1,#qryLinks.link_id#);">U</a>&nbsp;
							</cfif>
								&nbsp;
							<cfif qryLinks.CurrentRow NEQ qryLinks.RecordCount>
								<a href="##" onclick="return moveLink(1,#qryLinks.link_id#);">D</a>
							<cfelse>
								&nbsp;&nbsp;&nbsp;
							</cfif>
							</td>
						</tr>
					</cfloop>
					</tbody>
				</cfif>
				</table>
			<cfelse>
				Please select a category.
			</cfif>
			</td>
		</tr>
		<tr>
			<td>
				&nbsp;
			</td>
		</tr>
		<tr>
			<td align="center">
				<input type="submit" name="submitBtn" value="Save" class="buttonStyle" />
				&nbsp;&nbsp;&nbsp;
				<input type="reset" name="resetBtn" value="Reset Values" class="buttonStyle" />
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>

