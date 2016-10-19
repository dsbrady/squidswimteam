<cfsetting enablecfoutputonly="Yes">
<cfsilent>
<!---
<fusedoc
	fuse = "act_members_export.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I perform the export.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="10 November 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
		</in>
	</io>
</fusedoc>
--->
<cfparam name="attributes.exportMember" default="" type="string">
<cfparam name="attributes.getVisibleOnly" default=true type="boolean">
<cfif Secure("Update Members")>
	<cfset attributes.getVisibleOnly = false>
</cfif>

<!--- Get member info --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getMembers"
		returnvariable="qryMembers"
		dsn=#Request.DSN#
		usersTbl=#Request.usersTbl#
		user_statusTbl=#Request.user_statusTbl#
		transaction_typeTbl=#Request.transaction_typeTbl#
		transactionTbl=#Request.practice_transactionTbl#
		activityDays=#Request.activityDays#
		userList=#attributes.exportMember#
		getContactInfo=true
		getVisibleOnly=#attributes.getVisibleOnly#
	>


<cfif ReFind("MSIE",cgi.HTTP_USER_AGENT)>
	<cfheader name="Content-type" value="unknown">
<cfelse>
	<cfheader name="Content-type" value="application/msexcel">
</cfif>
	<!--- Suggest default filename for spreadsheet and download --->
	<cfheader name="content-disposition" value="attachment; filename=memberList.xls">

	<!--- Set the content-type so Excel is invoked --->
	<CFCONTENT TYPE="application/msexcel" reset="yes">

</cfsilent>
<CFOUTPUT>
<table border="1">
	<thead>
		<tr>
			<td>
				<strong>##</strong>
			</td>
			<td>
				<strong>First Name</strong>
			</td>
			<td>
				<strong>Last Name</strong>
			</td>
			<td>
				<strong>Address</strong>
			</td>
			<td>
				<strong>Address 2</strong>
			</td>
			<td>
				<strong>City</strong>
			</td>
			<td>
				<strong>State</strong>
			</td>
			<td>
				<strong>ZIP</strong>
			</td>
			<td>
				<strong>Phone (Cell)</strong>
			</td>
			<td>
				<strong>Phone (Day)</strong>
			</td>
			<td>
				<strong>Phone (Night)</strong>
			</td>
			<td>
				<strong>Fax</strong>
			</td>
			<td>
				<strong>E-Mail</strong>
			</td>
		</tr>
	</thead>
	<tbody>
	<cfloop query="qryMembers">
		<tr>
			<td>
				#qryMembers.CurrentRow#
			</td>
			<td>
				#qryMembers.preferred_name#
			</td>
			<td>
				#qryMembers.last_name#
			</td>
			<td>
				#qryMembers.address1#
			</td>
			<td>
				#qryMembers.address2#
			</td>
			<td>
				#qryMembers.city#
			</td>
			<td>
				#qryMembers.state_id#
			</td>
			<td>
				#qryMembers.zip#
			</td>
			<td>
				#qryMembers.phone_cell#
			</td>
			<td>
				#qryMembers.phone_day#
			</td>
			<td>
				#qryMembers.phone_night#
			</td>
			<td>
				#qryMembers.fax#
			</td>
			<td>
				#qryMembers.email#
			</td>
		</tr>
	</cfloop>
	</tbody>
</table>
</CFOUTPUT>
