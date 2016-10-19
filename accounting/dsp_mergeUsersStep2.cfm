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
<form name="mergeUserForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post" style="display:inline;">
	<input type="hidden" name="primaryUserID" value="#attributes.primaryUserID#" />
	<input type="hidden" name="secondaryUsers" value="#attributes.secondaryUsers#" />
	<input type="hidden" name="last_name" value="#qPrimaryUser.last_name#" />
	<input type="hidden" name="first_name" value="#qPrimaryUser.first_name#" />
	<input type="hidden" name="middle_name" value="#qPrimaryUser.middle_name#" />
	<input type="hidden" name="preferred_name" value="#qPrimaryUser.preferred_name#" />
	<input type="hidden" name="username" value="#qPrimaryUser.username#" />
	<input type="hidden" name="email" value="#qPrimaryUser.email#" />
	<input type="hidden" name="phone_cell" value="#qPrimaryUser.phone_cell#" />
	<input type="hidden" name="phone_day" value="#qPrimaryUser.phone_day#" />
	<input type="hidden" name="phone_night" value="#qPrimaryUser.phone_night#" />
	<input type="hidden" name="fax" value="#qPrimaryUser.fax#" />
	<input type="hidden" name="address1" value="#qPrimaryUser.address1#" />
	<input type="hidden" name="address2" value="#qPrimaryUser.address2#" />
	<input type="hidden" name="city" value="#qPrimaryUser.city#" />
	<input type="hidden" name="state_id" value="#qPrimaryUser.state_id#" />
	<input type="hidden" name="zip" value="#qPrimaryUser.zip#" />
	<input type="hidden" name="country" value="#qPrimaryUser.country#" />
	<input type="hidden" name="status" value="#qPrimaryUser.status#" />
	<input type="hidden" name="date_expiration" value="#dateFormat(qPrimaryUser.date_expiration,"m/d/yyyy")#" />
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
				> Merge User Accounts Step 2
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
				Below are the users you have selected to merge. The primary user is listed first.  If you wish to user the personal information from one of the "secondary" users instead of the primary one, click on the personal information values you want to keep (one per column).
			</td>
		</tr>
		<tr>
			<td>
				<div id="primaryUserDiv">
					<table>
						<thead>
							<tr>
								<th width="75">
									Last Name
								</th>
								<th width="75">
									First Name
								</th>
								<th width="75">
									Middle Name
								</th>
								<th width="75">
									Preferred Name
								</th>
								<th width="75">
									Username
								</th>
								<th width="75">
									E-mail
								</th>
								<th width="75">
									Cell
								</th>
								<th width="75">
									Day
								</th>
								<th width="75">
									Evening
								</th>
								<th width="75">
									Fax
								</th>
								<th width="75">
									Address 1
								</th>
								<th width="75">
									Address 2
								</th>
								<th width="75">
									City
								</th>
								<th width="75">
									State
								</th>
								<th width="75">
									ZIP
								</th>
								<th width="75">
									Country
								</th>
								<th width="75">
									Status
								</th>
								<th width="75">
									Expires
								</th>
							</tr>
						</thead>
						<tbody id="primaryUserList">
						<cfloop query="qPrimaryUser">
							<tr id="primaryUser_#qPrimaryUser.user_id#">
								<td id="lastName_#qPrimaryUser.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['last_name']);" class="selected">
									#qPrimaryUser.last_name#
								</td>
								<td id="firstName_#qPrimaryUser.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['first_name']);" class="selected">
									#qPrimaryUser.first_name#
								</td>
								<td id="middleName_#qPrimaryUser.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['middle_name']);" class="selected">
									#qPrimaryUser.middle_name#
								</td>
								<td id="preferredName_#qPrimaryUser.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['preferred_name']);" class="selected">
									#qPrimaryUser.preferred_name#
								</td>
								<td id="userName_#qPrimaryUser.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['username']);" class="selected">
									#qPrimaryUser.username#
								</td>
								<td id="email_#qPrimaryUser.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['email']);" class="selected">
									#qPrimaryUser.email#
								</td>
								<td id="phoneCell_#qPrimaryUser.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['phone_cell']);" class="selected">
									#qPrimaryUser.phone_cell#
								</td>
								<td id="phoneDay_#qPrimaryUser.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['phone_day']);" class="selected">
									#qPrimaryUser.phone_day#
								</td>
								<td id="phoneNight_#qPrimaryUser.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['phone_night']);" class="selected">
									#qPrimaryUser.phone_night#
								</td>
								<td id="fax_#qPrimaryUser.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['fax']);" class="selected">
									#qPrimaryUser.fax#
								</td>
								<td id="address1_#qPrimaryUser.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['address1']);" class="selected">
									#qPrimaryUser.address1#
								</td>
								<td id="address2_#qPrimaryUser.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['address2']);" class="selected">
									#qPrimaryUser.address2#
								</td>
								<td id="city_#qPrimaryUser.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['city']);" class="selected">
									#qPrimaryUser.city#
								</td>
								<td id="stateID_#qPrimaryUser.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['state_id']);" class="selected">
									#qPrimaryUser.state_id#
								</td>
								<td id="zip_#qPrimaryUser.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['zip']);" class="selected">
									#qPrimaryUser.zip#
								</td>
								<td id="country_#qPrimaryUser.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['country']);" class="selected">
									#qPrimaryUser.country#
								</td>
								<td id="status_#qPrimaryUser.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['status']);" class="selected">
									#qPrimaryUser.status#
								</td>
								<td id="dateExpiration_#qPrimaryUser.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['date_expiration']);" class="selected">
									#dateFormat(qPrimaryUser.date_expiration,"m/d/yyyy")#
								</td>
							</tr>
						</cfloop>
						<cfloop query="qSecondaryUsers">
							<tr id="primaryUser_#qSecondaryUsers.user_id#">
								<td id="lastName_#qSecondaryUsers.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['last_name']);">
									#qSecondaryUsers.last_name#
								</td>
								<td id="firstName_#qSecondaryUsers.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['first_name']);">
									#qSecondaryUsers.first_name#
								</td>
								<td id="middleName_#qSecondaryUsers.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['middle_name']);">
									#qSecondaryUsers.middle_name#
								</td>
								<td id="preferredName_#qSecondaryUsers.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['preferred_name']);">
									#qSecondaryUsers.preferred_name#
								</td>
								<td id="userName_#qSecondaryUsers.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['username']);">
									#qSecondaryUsers.username#
								</td>
								<td id="email_#qSecondaryUsers.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['email']);">
									#qSecondaryUsers.email#
								</td>
								<td id="phoneCell_#qSecondaryUsers.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['phone_cell']);">
									#qSecondaryUsers.phone_cell#
								</td>
								<td id="phoneDay_#qSecondaryUsers.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['phone_day']);">
									#qSecondaryUsers.phone_day#
								</td>
								<td id="phoneNight_#qSecondaryUsers.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['phone_night']);">
									#qSecondaryUsers.phone_night#
								</td>
								<td id="fax_#qSecondaryUsers.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['fax']);">
									#qSecondaryUsers.fax#
								</td>
								<td id="address1_#qSecondaryUsers.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['address1']);">
									#qSecondaryUsers.address1#
								</td>
								<td id="address2_#qSecondaryUsers.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['address2']);">
									#qSecondaryUsers.address2#
								</td>
								<td id="city_#qSecondaryUsers.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['city']);">
									#qSecondaryUsers.city#
								</td>
								<td id="stateID_#qSecondaryUsers.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['state_id']);">
									#qSecondaryUsers.state_id#
								</td>
								<td id="zip_#qSecondaryUsers.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['zip']);">
									#qSecondaryUsers.zip#
								</td>
								<td id="country_#qSecondaryUsers.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['country']);">
									#qSecondaryUsers.country#
								</td>
								<td id="status_#qSecondaryUsers.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['status']);">
									#qSecondaryUsers.status#
								</td>
								<td id="dateExpiration_#qSecondaryUsers.user_id#" onclick="selectValue(document.getElementById('primaryUserList'),this,document.forms['mergeUserForm'].elements['date_expiration']);">
									#dateFormat(qSecondaryUsers.date_expiration,"m/d/yyyy")#
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

