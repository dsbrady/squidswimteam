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
<form name="mergeUserForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post" style="display:inline;" onsubmit="return validate(this);")>
	<input type="hidden" name="primaryUserID" value="" />
	<input type="hidden" name="secondaryUsers" value="" />
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
				> <a href="#Request.self#?fuseaction=#XFA.acct_menu#">Accounting Menu</a>
				> Merge User Accounts
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
				Select the user you wish to merge the other user(s) <strong>into</strong>.
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
			<td>
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
							<tr id="primaryUser_#qUsers.user_id#" onclick="selectUser(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'],#qUsers.user_id#,document.getElementById('secondaryUser_#qUsers.user_id#'),document.getElementById('secondaryUserList'));">
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
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
				Select the users you wish to merge into the user you selected above.
				<span id="secondaryFilterText">
<!--- TODO:  Get the ajax working
					You can use the	following text box to filter by last name or username.
 --->
				</span>
			</td>
		</tr>
<!--- TODO:  Get the ajax working
		<tr id="secondaryFilterRow">
			<td>
				Filter: <input type="text" name="secondaryUsersFilter" size="25" value="" onkeyup="filterSecondaryUsers(this,document.getElementById('secondaryUserList'),'#Request.filterURL#');" />
			</td>
		</tr>
 --->
		<tr>
			<td>
				<div id="secondaryUserDiv">
					<table>
						<thead>
							<tr>
								<th>
									Last name
								</th>
								<th>
									First name
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
						<tbody id="secondaryUserList">
						<cfloop query="qUsers">
							<tr id="secondaryUser_#qUsers.user_id#" onclick="selectUser(document.getElementById('secondaryUserList'),this,document.forms['mergeUserForm'],#qUsers.user_id#,document.getElementById('primaryUser_#qUsers.user_id#'),document.getElementById('primaryUserList'));">
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
			<td>
				&nbsp;
			</td>
		</tr>
		<tr>
			<td align="center">
				<input type="submit" name="submitBtn" value="Next Step" />
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

