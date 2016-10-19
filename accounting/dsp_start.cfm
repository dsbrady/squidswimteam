<!---
<fusedoc
	fuse = "dsp_start.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the home page.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="9 September 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="facilities" />
				<string name="coaches" />
				<string name="defaults" />
				<string name="attendance" />
			</structure>
		</in>
	</io>

</fusedoc>
--->
<table width="500" border="0" cellpadding="2" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td align="center">
				<h2>
					<cfoutput>#Request.page_title#</cfoutput>
				</h2>
			</td>
		</tr>
	<cfoutput>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.facilities#">Update Facilities</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.coaches#">Update Coaches</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.defaults#">Update Practice Defaults</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.practices#">Update Practices</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.transactions#">View/Update Transactions</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.membershipTransactions#">Update Membership Transactions</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.userSwimPasses#">View User Swim Passes</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.addUserPass#">Add User Swim Pass</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.transactionsUnconfirmed#">Confirm PayPal Transactions</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.mergeUsers#">Merge User Accounts</a>
			</td>
		</tr>
		<tr>
			<td>
				&nbsp;
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.attendance_sheet#">Print Attendance Sheets</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.balances#">View/Print Swim Balances</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.attendance_graph#">View Attendance Graphs</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.attendanceSummary#">View Attendance Summary</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.coachingSummary#">View Coaching Summary</a>
			</td>
		</tr>
		<tr>
			<td>
				&nbsp;
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.menu#">Return to Main Menu</a>
			</td>
		</tr>
		<tr>
			<td>
				&nbsp;
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.logout#&returnFA=#XFA.home#">Logout</a>
			</td>
		</tr>
	</cfoutput>
	</tbody>
</table>
