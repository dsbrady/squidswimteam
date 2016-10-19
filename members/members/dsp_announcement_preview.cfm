<!---
<fusedoc
	fuse = "dsp_announcement_preview.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the announcement preview.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="6 July 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
				<string name="announcements" />
			</structure>
			
			<number name="announcement_id" scope="attributes" />
			<string name="subject" scope="attributes" />
			<string name="announcement" scope="attributes" />

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
			<number name="announcement_id" scope="formOrUrl" />
			<string name="subject" scope="formOrUrl" />
			<string name="announcement" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<cfset variables.tabindex = 1>
</cfsilent>

<cfif attributes.success IS "no">
	<h2>There were problems with your submission:</h2>
	<ul class="errorText">
		<cfloop list="#attributes.reason#" index="variables.theItem" delimiters="*">
			<li><cfoutput>#variables.theItem#</cfoutput></li>
		</cfloop>
	</ul>
	<p>Please make corrections below and re-submit the information.</p>
</cfif>

<cfoutput>
<form name="announcementForm" action="#variables.baseHREF##Request.self#/fuseaction/#XFA.next#.cfm" method="post">
	<input type="hidden" name="announcement_id" value="#Request.squid.announcement.announcement_id#" />
	<input type="hidden" name="from_preview" value="true" />
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
				> <a href="#Request.self#/fuseaction/#XFA.edit#.cfm">Edit</a>
				> Preview Announcement
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td width="200">
				<strong>Submitted By:</strong>
			</td>
			<td width="300">
				#Request.squid.announcement.submittedBy_name#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Special Announcement?</strong>
			</td>
			<td>
				#YesNoFormat(Request.squid.announcement.special)#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Public Announcement?</strong>
			</td>
			<td>
				#YesNoFormat(Request.squid.announcement.isPublic)#
			</td>
		</tr>
	<cfif LEN(TRIM(Request.squid.announcement.eventDate))>
		<tr valign="top">
			<td>
				<strong>Event Date</strong>
			</td>
			<td>
				#Request.squid.announcement.eventDate#
			</td>
		</tr>
	</cfif>
		<tr valign="top">
			<td>
				<strong>Status:</strong>
			</td>
			<td>
				#qStatuses.status#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Subject:</strong>
			</td>
			<td>
				#Request.squid.announcement.subject#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Announcement:</strong>
			</td>
			<td>
				#Request.squid.announcement.content.html#
			</td>
		</tr>
	<cfif LEN(Request.squid.announcement.attachment)>
		<tr valign="top">
			<td>
				<strong>Attachment:</strong>
			</td>
			<td>
				#Request.squid.announcement.attachment#
				<br />
				<a href="#Request.announcement_folder#/#Request.squid.announcement.attachment#" target="_blank">View attachment in new window</a>
			</td>
		</tr>
	</cfif>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="editBtn" value="Edit" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
				<input type="submit" name="submitBtn" value="Save" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
				<input type="submit" name="cancelBtn" value="Cancel" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

