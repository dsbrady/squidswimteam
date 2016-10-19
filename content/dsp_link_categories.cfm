<!---
<fusedoc
	fuse = "dsp_link_categories.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the link categories for updating.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="3 November 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="updateLinks" />
				<string name="next" />
			</structure>

		</in>
		<out>
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

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
<form name="categoryForm" action="#Request.self#?fuseaction=#XFA.next#" method="post" onsubmit="return validateCats(this);" style="display:inline">
	<input type="hidden" name="categories_old" value="#ValueList(qryCats.category_id)#" />
	<input type="hidden" name="categories" value="#ValueList(qryCats.category_id)#" />
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
				> <a href="#Request.self#?fuseaction=#XFA.updateLinks#">Links</a>
				> Categories
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center">
				<a href="##" onclick="return addCat();">Add Category</a>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="center">
				<table width="450" cellspacing="0" cellpadding="3" align="center" class="tableClass">
					<thead>
						<tr class="tableHead">
							<td>
								&nbsp;
							</td>
							<td align="left">
								<strong>Category</strong>
							</td>
							<td>
								&nbsp;
							</td>
						</tr>
					</thead>
					<tbody id="catTbl">
				<cfif qryCats.RecordCount EQ 0>
						<tr id="noCats" class="tableRow1">
							<td colspan="3">
								There are no categories.
							</td>
						</tr>
				<cfelse>
					<cfloop query="qryCats">
						<cfscript>
							variables.rowClass = qryCats.currentRow MOD 2;
						</cfscript>
						<tr id="cat_#qryCats.category_id#" class="tableRow#variables.rowClass#" valign="top">
							<td>
								<a href="##" onclick="return removeCat(#qryCats.category_id#);">Remove</a>
							</td>
							<td align="left">
								<input type="text" name="category_#qryCats.category_id#" size="25" maxlength="50" value="#qryCats.category#" onblur="this.value = this.value.toUpperCase();" />
							</td>
							<td>
							<cfif qryCats.CurrentRow NEQ 1>
								<a href="##" onclick="return moveCat(-1,#qryCats.category_id#);">U</a>
								&nbsp;
							</cfif>
								&nbsp;
							<cfif qryCats.CurrentRow NEQ qryCats.RecordCount>
								<a href="##" onclick="return moveCat(1,#qryCats.category_id#);">D</a>
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
</form>
</cfoutput>

