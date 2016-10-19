<!---
<fusedoc
	fuse = "dsp_announcement_detail.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the announcement detail.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="10 August 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="announcements" />
			</structure>
			
			<number name="announcement_id" scope="attributes" />

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
	</io>
</fusedoc>
--->
<cfsilent>
	<!--- Get Announcement --->
	<cfinvoke  
		component="#Request.announce_cfc#" 
		method="getAnnouncements" 
		returnvariable="qryAnnouncements"
		announcement_id=#attributes.announcement_id#
		dsn=#Request.DSN#
		usersTbl=#Request.usersTbl#
		announcementTbl=#Request.announcementTbl#
		statusTbl=#Request.announcement_statusTbl#
	>
</cfsilent>
<cfoutput>
<table width="500" border="0" cellpadding="0" cellspacing="0" align="center">
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
				<a href="#Request.self#/fuseaction/#XFA.menu#.cfm">Menu</a>
				> <a href="#Request.self#/fuseaction/#XFA.announcements#.cfm">Announcements</a>
				> Announcement Detail
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
	<cfif qryAnnouncements.special>
		<tr valign="top">
			<td colspan="2" class="errorText">
				Special Notice
			</td>
		</tr>
	</cfif>
	<cfif qryAnnouncements.isPublic>
		<tr valign="top">
			<td>
				&nbsp;
			</td>
			<td>
				<strong>Public Announcement</strong>
			</td>
		</tr>
	</cfif>
	<cfif IsDate(qryAnnouncements.eventDate)>
		<tr valign="top">
			<td>
				<strong>Event Date:</strong>
			</td>
			<td>
				#DateFormat(qryAnnouncements.eventDate,"m/d/yyyy")#
			</td>
		</tr>
	</cfif>
		<tr valign="top">
			<td width="175">
				<strong>From:</strong>
			</td>
			<td width="325">
				#qryAnnouncements.submittedBy_name#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Subject:</strong>
			</td>
			<td>
				#qryAnnouncements.subject#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Announcement:</strong>
			</td>
			<td>
				#qryAnnouncements.announcement#
			</td>
		</tr>
	<cfif LEN(qryAnnouncements.attachment)>
		<tr valign="top">
			<td>
				<strong>Attachment:</strong>
			</td>
			<td>
				#qryAnnouncements.attachment#
				<br />
				<a href="#Request.announcement_folder#/#qryAnnouncements.attachment#" target="_blank">View attachment in new window</a>
			</td>
		</tr>
	</cfif>
	</tbody>
</table>
</form>
</cfoutput>

