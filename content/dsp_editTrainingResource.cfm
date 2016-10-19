<cfsilent>
	<cfif attributes.trainingResourceID GT 0 AND attributes.success>
		<cfset attributes.trainingResourceTypeID = request.qTrainingResource.trainingResourceTypeID />
		<cfset attributes.trainingResource = request.qTrainingResource.trainingResource />
		<cfset attributes.description = request.qTrainingResource.description />
		<cfset attributes.resourceContent = request.qTrainingResource.resourceContent />
	</cfif>

	<!--- Hard-coding this since all we're supporting are videos for now --->
	<cfset attributes.traningResourceTypeID = 1 />

	<cfset variables.tabindex = 1 />
</cfsilent>

<cfif NOT attributes.success>
	<h2>There were problems with your submission:</h2>
	<ul class="errorText">
		<cfloop list="#attributes.reason#" index="variables.theItem" delimiters="*">
			<li><cfoutput>#variables.theItem#</cfoutput></li>
		</cfloop>
	</ul>
	<p>Please make corrections below and re-submit the information.</p>
</cfif>

<cfoutput>
<form id="editForm" name="editForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post">
	<input type="hidden" name="trainingResourceID" value="#VAL(attributes.trainingResourceID)#" />
	<input type="hidden" name="trainingResourceTypeID" value="#VAL(attributes.trainingResourceTypeID)#" />
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
				> <a href="#Request.self#?fuseaction=#XFA.trainingResources#">Training Resources</a>
				> #request.pageSubTitle#
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Name:</strong>
			</td>
			<td>
				<input type="text" id="trainingResource" name="trainingResource" size="25" maxlength="50" value="#attributes.trainingResource#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1 />
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Description:</strong>
			</td>
			<td>
				<textarea name="description" cols="50" rows="5" tabindex="#variables.tabindex#">#attributes.description#</textarea>
				<cfset variables.tabindex = variables.tabindex + 1 />
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Resource Content:</strong>
			</td>
			<td>
				<textarea name="resourceContent" cols="50" rows="10	" tabindex="#variables.tabindex#">#attributes.resourceContent#</textarea>
				<cfset variables.tabindex = variables.tabindex + 1 />
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="submitBtn" value="Save" class="buttonStyle" tabindex="#variables.tabindex#" />
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

