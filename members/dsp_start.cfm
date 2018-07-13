<!---
<fusedoc
	fuse = "dsp_start"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the home page.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="4 June 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
			</structure>
		</in>
	</io>

</fusedoc>
--->
<table width="575" border="0" cellpadding="2" cellspacing="0" align="center">
<cfoutput>
 	<thead>
		<tr>
			<td align="center" colspan="3">
				<h2>
					#Request.page_title#
				</h2>
			</td>
		</tr>
 	</thead>
	<tbody>
		<tr valign="top">
		<!--- Profile --->
			<td width="285" align="center">
				<table width="285" cellpadding="0" cellspacing="0" border="0" bgcolor="##E1ECEE">
					<tr>
						<td colspan="3" width="285" height="36"><img src="images/dashboardTableProfile.gif" width="285" height="36" alt="Your Profile" hspace="0" vspace="0" /></td>
					</tr>
					<tr>
						<td width="13" background="images/dashboardTableLeftBorder.gif"><img src="images/spacer.gif" width="13" height="12" alt="" /></td>
						<td width="260">
							(<a href="#Request.self#?fuseaction=#XFA.profile#&user_id=#Request.squid.user_id#&actionType=edit">Edit Profile</a>)
							<table>
								<tr align="left" valign="top">
									<td colspan="2">
										<strong>Name</strong>:
									</td>
									<td>
										#Request.squid.preferred_name#
										#Request.squid.last_name#
									</td>
								</tr>
								<tr align="left" valign="top">
									<td colspan="2">
										<strong>Member Through</strong>:
									</td>
									<td>
										#DateFormat(Request.squid.date_expiration,"m/d/yyyy")#
									<cfif DateDiff("D",Now(),Request.squid.date_expiration) LTE Request.renewalDays>
										<br /><a href="#Request.self#?fuseaction=#XFA.dues#">Pay Dues</a>
									</cfif>
									</td>
								</tr>
							<cfif LEN(Request.squid.usms_number)>
								<tr align="left" valign="top">
									<td colspan="2">
										<strong>USMS</strong>:
									</td>
									<td>
										#Request.squid.usms_number#
									<cfif LEN(Request.squid.usms_year)>
										(#Request.squid.usms_year#)
									</cfif>
									</td>
								</tr>
							</cfif>
							<cfif isDate(variables.swimPassExpiration)>
								<tr align="left" valign="top">
									<td colspan="2">
										<strong>Swim Pass Expires</strong>:
									</td>
									<td>
										#dateFormat(variables.swimPassExpiration,"m/d/yyyy")#
										<br />
										(<a href="#Request.self#?fuseaction=#XFA.buySwims#">Buy Swims</a>)
									</td>
								</tr>
							<cfelse>
								<tr align="left" valign="top">
									<td colspan="2">
										<strong><a href="#Request.self#?fuseaction=#XFA.transactions#">Swim Balance</a></strong>:
									</td>
									<td>
										#variables.swimBalance#
										<br />
										(<a href="#Request.self#?fuseaction=#XFA.buySwims#">Buy Swims</a>)
									</td>
								</tr>
							</cfif>
								<tr align="left" valign="top">
									<td colspan="3">
										<strong>Preferences</strong>:
									</td>
								</tr>
								<tr align="left" valign="top">
									<td width="15">&nbsp;</td>
									<td>
										<strong>E-mail Type</strong>:
									</td>
									<td>
										#Request.squid.emailPref#
									</td>
								</tr>
								<tr align="left" valign="top">
									<td>&nbsp;</td>
									<td>
										<strong>Announcements</strong>:
									</td>
									<td>
										#Request.squid.postingPref#
									</td>
								</tr>
<!---
								<tr align="left" valign="top">
									<td>&nbsp;</td>
									<td>
										<strong>Calendar</strong>:
									</td>
									<td>
										#Request.squid.calendarPref#
									</td>
								</tr>
--->
								<tr align="left" valign="top">
									<td>&nbsp;</td>
									<td>
										<strong>Postal Mail</strong>:
									</td>
									<td>
										#YesNoFormat(Request.squid.mailingListYN)#
									</td>
								</tr>
							</table>
						</td>
						<td width="12" background="images/dashboardTableRightBorder.gif"><img src="images/spacer.gif" width="12" height="12" alt="" /></td>
					</tr>
					<tr>
						<td colspan="3"height="12"><img src="images/dashboardTableFooter.gif" width="285" height="12" alt="" hspace="0" vspace="0" /></td>
					</tr>
				</table>
			</td>
			<td width="5">
				&nbsp;
			</td>
		<!--- Menu --->
			<td width="285" align="center">
				<table width="285" cellpadding="0" cellspacing="0" border="0" bgcolor="##E1ECEE">
					<tr>
						<td colspan="3" width="285" height="36"><img src="images/dashboardTableCanDo.gif" width="285" height="36" alt="What You Can Do" hspace="0" vspace="0" /></td>
					</tr>
					<tr>
						<td width="13" background="images/dashboardTableLeftBorder.gif"><img src="images/spacer.gif" width="13" height="12" alt="" /></td>
						<td width="260">
							<table>
								<tr align="left">
									<td>
										<a href="#Request.self#?fuseaction=#XFA.times#">View/Edit Your Event Times</a>
									</td>
								</tr>
								<tr align="left">
									<td>
										<a href="#Request.self#?fuseaction=#XFA.dsp_members#">
										<cfif Secure("Update Members")>
											View/Update
										<cfelse>
											View
										</cfif>
											Members
										</a>
									</td>
								</tr>
							<cfif Secure("Update Financials") OR Secure("Update Practices")>
								<tr align="left">
									<td>
										<a href="#Request.self#?fuseaction=#XFA.transactions#">View Swims/Transactions</a>
									</td>
								</tr>
							</cfif>
								<tr align="left">
									<td>
										<a href="#Request.self#?fuseaction=#XFA.members_export#">Export Member List</a>
									</td>
								</tr>
							<cfif Secure("Update Officers")>
								<tr align="left">
									<td>
										<a href="#Request.self#?fuseaction=#XFA.officers#">Update Officers</a>
									</td>
								</tr>
							</cfif>
							<cfif Secure("Update Financials") OR Secure("Update Practices")>
								<tr align="left">
									<td>
										<a href="#Request.self#?fuseaction=#XFA.updateAccounting#">Update Accounting/Attendance</a>
									</td>
								</tr>
							</cfif>
							<cfif Secure("Update Content")>
								<tr align="left">
									<td>
										<a href="#Request.self#?fuseaction=#XFA.content#">Update Web Site Content</a>
									</td>
								</tr>
							</cfif>
							<cfif Secure("Update Swim Meet")>
								<tr align="left">
									<td>
										<a href="#Request.self#?fuseaction=#XFA.meetAdmin#">Swim Meet Administrator</a>
									</td>
								</tr>
							</cfif>
								<tr align="left">
									<td>
										&nbsp;
									</td>
								</tr>
								<tr align="left">
									<td>
										<a href="#Request.self#?fuseaction=#XFA.changePassword#&returnFA=#attributes.fuseaction#">Change Password</a>
									</td>
								</tr>
							</table>
						</td>
						<td width="12" background="images/dashboardTableRightBorder.gif"><img src="images/spacer.gif" width="12" height="12" alt="" /></td>
					</tr>
					<tr>
						<td colspan="3"height="12"><img src="images/dashboardTableFooter.gif" width="285" height="12" alt="" hspace="0" vspace="0" /></td>
					</tr>
				</table>
			</td>
		</tr>
	<CFIF request.squid.user_id NEQ 469>
		<tr>
			<td colspan="3">
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td align="center">
		<!--- Announcements --->
				<table width="285" cellpadding="0" cellspacing="0" border="0" bgcolor="##E1ECEE">
					<tr>
						<td colspan="3" width="285" height="36"><img src="images/dashboardTableAnnouncements.gif" width="285" height="36" alt="Recent Announcements" hspace="0" vspace="0" /></td>
					</tr>
					<tr>
						<td width="13" background="images/dashboardTableLeftBorder.gif"><img src="images/spacer.gif" width="13" height="12" alt="" /></td>
						<td width="260">
							<a href="#Request.self#?fuseaction=#XFA.announcements#">View All</a>
						<cfif Secure("Approve Messages") AND VAL(qPendingAnnouncements.RecordCount)>
							<a href="#Request.self#?fuseaction=#XFA.pendingAnnouncements#"><strong>(#VAL(qPendingAnnouncements.RecordCount)# Pending)</strong></a>
						</cfif>
							<table>
							<cfloop query="qAnnouncements">
								<tr valign="top">
									<td align="left">
										#DateFormat(qAnnouncements.announcementDate,"M/D/YYYY")#
									</td>
									<td align="left">
										<a href="#Request.self#?fuseaction=#XFA.announceDetail#&announcement_id=#qAnnouncements.announcement_id#">#truncString(qAnnouncements.subject,35)#</a>
									</td>
								</tr>
							</cfloop>
							</table>
						</td>
						<td width="12" background="images/dashboardTableRightBorder.gif"><img src="images/spacer.gif" width="12" height="12" alt="" /></td>
					</tr>
					<tr>
						<td colspan="3"height="12"><img src="images/dashboardTableFooter.gif" width="285" height="12" alt="" hspace="0" vspace="0" /></td>
					</tr>
				</table>
				<br />
			</td>
			<td>
				&nbsp;
			</td>
			<td align="center">
				<!--- Training Resources --->
				<table width="285" cellpadding="0" cellspacing="0" border="0" bgcolor="##E1ECEE">
					<tr>
						<td colspan="3" width="285" height="36"><img src="images/dashboardTableTraining.gif" width="285" height="36" alt="Training Resources" hspace="0" vspace="0" /></td>
					</tr>
					<tr>
						<td width="13" background="images/dashboardTableLeftBorder.gif"><img src="images/spacer.gif" width="13" height="12" alt="" /></td>
						<td width="260">
						<cfif request.qTrainingResources.recordCount GT 0>
							<a href="#Request.self#?fuseaction=#XFA.trainingResources#">View All</a>
							<table>
							<cfloop query="request.qTrainingResources">
								<tr valign="top">
									<td align="left">
										#request.qTrainingResources.trainingResourceType#
									</td>
									<td align="left">
										<a href="#Request.self#?fuseaction=#XFA.viewTrainingResource#&trainingResourceID=#request.qTrainingResources.trainingResourceID#">#truncString(request.qTrainingResources.trainingResource,35)#</a>
									</td>
								</tr>
							</cfloop>
							</table>
						<cfelse>
							There are no training resources at this time.
						</cfif>
						</td>
						<td width="12" background="images/dashboardTableRightBorder.gif"><img src="images/spacer.gif" width="12" height="12" alt="" /></td>
					</tr>
					<tr>
						<td colspan="3"height="12"><img src="images/dashboardTableFooter.gif" width="285" height="12" alt="" hspace="0" vspace="0" /></td>
					</tr>
				</table>
			</td>
		</tr>
	</CFIF>
	</tbody>
</cfoutput>
</table>
