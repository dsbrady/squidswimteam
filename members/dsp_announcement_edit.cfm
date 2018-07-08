<!---
<fusedoc
	fuse = "dsp_announcement_edit.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the announcement edit form.
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
	<cfparam name="Request.squid.announcement.announcement_id" default="0" type="numeric">
	<cfparam name="Request.squid.announcement.status_id" default="1" type="numeric">
	<cfparam name="Request.squid.announcement.sending_user" default="#Request.squid.user_id#" type="numeric">
	<cfparam name="Request.squid.announcement.submittedBy_name" default="#Request.squid.preferred_name# #Request.squid.last_name#" type="string">
	<cfparam name="Request.squid.announcement.subject" default="" type="string">
	<cfparam name="Request.squid.announcement.attachment" default="" type="string">
	<cfparam name="Request.squid.announcement.content.html" default="" type="string">
	<cfparam name="Request.squid.announcement.content.plain" default="" type="string">
	<cfparam name="Request.squid.announcement.special" default="false" type="boolean">
	<cfparam name="Request.squid.announcement.eventDate" default="" type="string" />
	<cfparam name="Request.squid.announcement.isPublic" default="false" type="boolean" />

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<cfif attributes.announcement_id GT 0 AND attributes.success IS NOT "">
		<!--- Get announcement information --->
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

		<cfscript>
			if (attributes.success IS NOT "No")
			{
				Session.squid.announcement = StructNew();
				Session.squid.announcement.content = StructNew();
				Session.squid.announcement.content.html = qryAnnouncements.announcement;
				Session.squid.announcement.content.plain = qryAnnouncements.announcement_plain;
				Session.squid.announcement.attachment = qryAnnouncements.attachment;
				Session.squid.announcement.subject = qryAnnouncements.subject;
				Session.squid.announcement.status_id = qryAnnouncements.status_id;
				Session.squid.announcement.sending_user = qryAnnouncements.sending_user;
				Session.squid.announcement.submittedBy_name = qryAnnouncements.submittedBy_name;
				Session.squid.announcement.announcement_id = qryAnnouncements.announcement_id;
				Session.squid.announcement.special = qryAnnouncements.special;
				Session.squid.announcement.eventDate = DateFormat(qryAnnouncements.eventDate,"m/d/yyyy");
				Session.squid.announcement.isPublic = YesNoFormat(qryAnnouncements.isPublic);

				Request.squid = StructCopy(Session.squid);
			}
		</cfscript>
	</cfif>

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
<cfelseif attributes.success IS "yes">
	<p class="errorText">
		<cfoutput>#attributes.reason#</cfoutput>
	</p>
</cfif>

<cfoutput>
<form id="announcementForm" name="announcementForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post" onsubmit="return validate(this);" enctype="multipart/form-data">
	<input type="hidden" name="announcement_id" value="#attributes.announcement_id#" />
	<input type="hidden" name="original_announcement_id" value="#attributes.announcement_id#" />
<table width="750" border="0" cellpadding="0" cellspacing="0" align="center">
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
				> <a href="#Request.self#?fuseaction=#XFA.announcements#">Announcements</a>
				> <cfif VAL(Request.squid.announcement.announcement_id)>Update<cfelse>Post</cfif> Announcement
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
	<cfif Secure("Approve Messages") AND Request.squid.announcement.sending_user EQ Request.squid.user_id AND NOT Secure("Self-Approve Messages")>
		<tr>
			<td colspan="2" class="errorText">
				Because you are the author of this post, another officer must approve this post.
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
	</cfif>
		<tr valign="top">
			<td>
				<strong>Submitted By:</strong>
			</td>
			<td>
				<input type="hidden" name="sending_user" value="#Request.squid.announcement.sending_user#" />
				<input type="hidden" name="submittedBy_name" value="#Request.squid.announcement.submittedBy_name#" />
				#Request.squid.announcement.submittedBy_name#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Status:</strong>
			</td>
			<td>
		<cfif Secure("Approve Messages")>
			<cfset qStatuses = Request.lookupCFC.getStatus(Request.dsn,Request.announcement_statusTbl,0,"lower(s.status)") />
				<select name="status_id" tabindex="#variables.tabindex#">
			<cfloop query="qStatuses">
				<!--- The authr of a post can no longer approve them, unless they have permission --->
				<cfif (qStatuses.status IS "Approved" AND (Request.squid.announcement.sending_user NEQ Request.squid.user_id OR Secure("Self-Approve Messages"))) OR qStatuses.status IS NOT "Approved">
					<option value="#VAL(qStatuses.status_id)#" <cfif Request.squid.announcement.status_id EQ VAL(qStatuses.status_id)>selected="selected"</cfif>>#qStatuses.status#</option>
				</cfif>
			</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
		<cfelse>
			<cfset qStatuses = Request.lookupCFC.getStatus(Request.dsn,Request.announcement_statusTbl,VAL(Request.squid.announcement.status_id),"lower(s.status)") />
				<input type="hidden" name="status_id" value="#Request.squid.announcement.status_id#" />
				#qStatuses.status#
		</cfif>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Make Public?</strong>
			</td>
			<td>
				<input type="checkbox" name="isPublic" value="true" tabindex="#variables.tabindex#" <cfif Request.squid.announcement.isPublic>checked="checked"</cfif> />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Event Date:</strong>
				(optional)
			</td>
			<td>
				<input type="text" name="eventDate" size="10" maxlength="10" value="#Request.squid.announcement.eventDate#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Subject:</strong>
			</td>
			<td>
				<input type="text" name="subject" size="35" maxlength="255" value="#Request.squid.announcement.subject#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Announcement:</strong>
			</td>
			<td>
				<textarea name="announcement">#request.squid.announcement.content.html#</textarea>
<!--- 12/17/2012 - no longer needed with ckeditor
				<script type="text/javascript">
					Start('#JSStringFormat(Request.announceHtmlEditPath)#','#JSStringFormat(Request.squid.announcement.content.html)#');
				</script>
				<iframe id="testFrame" style="position: absolute; visibility: hidden; width: 0px; height: 0px;"></iframe>
				<cfset variables.tabindex = variables.tabindex + 1>
				<input type="hidden" name="announcement" value="" />
--->
				<input type="hidden" name="announcement_plain" value="#Request.squid.announcement.content.plain#" />
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Attachment:</strong>
			</td>
			<td>
			<cfif LEN(TRIM(Request.squid.announcement.attachment))>
				<input type="hidden" name="uploaded_src" value="#Request.squid.announcement.attachment#" />
				<input type="hidden" name="src" value="#Request.squid.announcement.attachment#" />
				#Request.squid.announcement.attachment#
				<br />
				<a href="#Request.announcement_folder#/#Request.squid.announcement.attachment#" target="_blank">View attachment in new window</a> | <a href="#Request.self#?fuseaction=#XFA.delete_attachment#">Delete attachment</a>
			<cfelse>
				<input type="hidden" name="uploaded_src" value="" />
				<input type="file" name="src" size="35" maxlength="255" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</cfif>
			</td>
		</tr>
		<tr>
			<td colspan="2"><em>(Allowed files:  Word, Excel, Powerpoint, GIF, JPEG)</em></td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				<input type="checkbox" name="special" value="true" <cfif Request.squid.announcement.special>checked="checked"</cfif> />
				This announcement is a <strong>Special Announcement</strong>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="previewBtn" value="Preview" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
				<input type="submit" name="submitBtn" value="Save" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
				<input type="reset" name="resetBtn" value="Reset Values" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

