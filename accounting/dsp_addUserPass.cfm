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
<form name="userPassForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post" style="display:inline;" onsubmit="return validate(this);")>
	<input type="hidden" name="selectedUserID" value="" />
<table width="600" border="0" cellpadding="0" cellspacing="0" align="center">
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
				<a href="#Request.self#?fuseaction=#XFA.menu#">Main Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.acct_menu#">Accounting Menu</a>
				> Add User Swim Pass
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2">
				Select the user you wish to apply a swim pass to.
				<span id="primaryFilterText">
<!--- TODO:  Get the ajax working
					You can use the	following text box to filter by last name or username.
 --->
				</span>
			</td>
		</tr>
<!--- TODO:  Get the ajax working
		<tr id="primaryFilterRow">
			<td>
				Filter: <input type="text" name="primaryUsersFilter" size="25" value="" onkeydown="filterPrimaryUsers(this,document.getElementById('primaryUserList'),'#Request.filterURL#');" />
			</td>
		</tr>
 --->
		<tr>
			<td colspan="2">
<!--- TODO:  Get the ajax working
				<div id="primaryUserDivNew"></div>
 --->
				<div id="primaryUserDiv">
					<table>
						<thead>
							<tr>
								<th>
									Last Name
								</th>
								<th>
									First Name
								</th>
								<th>
									Username
								</th>
								<th>
									E-mail
								</th>
								<th>
									Status
								</th>
							</tr>
						</thead>
						<tbody id="primaryUserList">
						<cfloop query="qUsers">
							<tr id="primaryUser_#qUsers.user_id#" onclick="selectUser(document.getElementById('primaryUserList'),this,document.forms['userPassForm'],#qUsers.user_id#);">
								<td>
									#qUsers.last_name#
									&nbsp;
								</td>
								<td>
									#qUsers.preferred_name#
									&nbsp;
								</td>
								<td>
									#qUsers.username#
									&nbsp;
								</td>
								<td>
									#qUsers.email#
									&nbsp;
								</td>
								<td>
									#qUsers.status#
									&nbsp;
								</td>
							</tr>
						</cfloop>
						</tbody>
					</table>
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td width="100">
				<strong>Swim Pass:</strong>
			</td>
			<td width="500">
				<select name="swimPassID">
					<option value="" <cfif val(attributes.swimPassID) EQ 0>selected="true"</cfif>>(Select a swim pass)</option>
				<cfloop query="request.qSwimPasses">
					<option value="#request.qSwimPasses.swimPassID#" <cfif attributes.swimPassID EQ request.qSwimPasses.swimPassID>selected="true"</cfif>>#request.qSwimPasses.swimPass# (#dollarFormat(request.qSwimPasses.price)#)</option>
				</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td>
				<strong>Effective Date:</strong>
			</td>
			<td>
				<input type="text" name="effectiveDate" size="10" maxlength = "10" value="#dateFormat(now(),"mm/dd/yyyy")#" />
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="submitBtn" value="Next Step" />
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

