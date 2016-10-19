<!---
<fusedoc
	fuse = "dsp_start.cfm"
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
				<string name="issues" />
				<string name="profile" />
			</structure>
		</in>
	</io>

</fusedoc>
--->
<table width="500" border="0" cellpadding="2" cellspacing="0" align="center">
 	<thead>
	<cfoutput>
		<tr>
			<td align="center">
				<h2>
					#Request.page_title#
				</h2>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#/fuseaction/#XFA.profile#/user_id/#Request.squid.user_id#/actionType/edit.cfm">Your Profile</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#/fuseaction/#XFA.announcements#.cfm">Announcements</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#/fuseaction/#XFA.times#.cfm">Your Event Times</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#/fuseaction/#XFA.preferences#.cfm">Your Preferences</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#/fuseaction/#XFA.dsp_members#.cfm">
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
		<tr>
			<td>
				<a href="#Request.self#/fuseaction/#XFA.transactions#.cfm">View Swims/Transactions</a>
			</td>
		</tr>
	<cfelse>
		<tr>
			<td>
				<a href="#Request.self#/fuseaction/#XFA.transactions#.cfm">View My Swims/Transactions</a>
			</td>
		</tr>
	</cfif>
		<tr>
			<td>
				<a href="#Request.self#/fuseaction/#XFA.members_export#.cfm">Export Member List</a>
			</td>
		</tr>
	<cfif Secure("Update Officers")>
		<tr>
			<td>
				<a href="#Request.self#/fuseaction/#XFA.officers#.cfm">Update Officers</a>
			</td>
		</tr>
	</cfif>
	<cfif VAL(Request.squid.tester_id) OR VAL(Request.squid.developer_id)>
		<tr>
			<td>
				<a href="#Request.self#/fuseaction/#XFA.issues#.cfm">Issues/Bugs</a>
			</td>
		</tr>
	</cfif>
	<cfif Secure("Update Financials") OR Secure("Update Practices")>
		<tr>
			<td>
				<a href="#Request.self#/fuseaction/#XFA.updateAccounting#.cfm">Update Accounting/Attendance</a>
			</td>
		</tr>
	</cfif>
	<cfif Secure("Update Content")>
		<tr>
			<td>
				<a href="#Request.self#/fuseaction/#XFA.content#.cfm">Update Web Site Content</a>
			</td>
		</tr>
	</cfif>
	<cfif Secure("Update Swim Meet")>
		<tr>
			<td>
				<a href="#Request.self#/fuseaction/#XFA.meetAdmin#.cfm">Swim Meet Administrator</a>
			</td>
		</tr>
	</cfif>
		<tr>
			<td>
				&nbsp;
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#/fuseaction/#XFA.changePassword#/returnFA/#attributes.fuseaction#.cfm">Change Password</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#/fuseaction/#XFA.logout#/returnFA/#XFA.home#.cfm">Logout</a>
			</td>
		</tr>
	</cfoutput>
	</tbody>
</table>
