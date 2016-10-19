<!--- 
<fusedoc fuse="FBX_Switch.cfm">
	<responsibilities>
		I am the cfswitch statement that handles the fuseaction, delegating work to various fuses.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="15 December 2002" role="Architect">
	</properties>
	<io>
		<in>
			<structure name="fuxebox">
				<string name="fuseaction" />
				<string name="circuit" />
			</structure>
		</in>
	</io>	
</fusedoc>
 --->

<cfswitch expression = "#fusebox.fuseaction#">
<!--- ----------------------------------------
CALENDAR DISPLAY
----------------------------------------- --->
	<cfcase value="start,dsp_start,fusebox.defaultfuseaction">
		<!---This will be the value returned if someone types in "circuitname.", omitting the actual fuseaction request--->
		<cfscript>
			XFA.post = "calendar.dsp_event_details";
			XFA.admin = "calendar.dsp_events";
			XFA.details = "calendar.dsp_event_details";
			Request.js_validate = "calendar/javascript/calendar.js";
		
			Request.template = "dsp_calendar.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

<!--- ----------------------------------------
EVENT DETAILS / EDIT
----------------------------------------- --->
	<cfcase value="dsp_event_details">
	<!--- Displays Event Submission form--->
		<cfparam name="attributes.calendar_id" default="0" type="numeric">
		<cfparam name="attributes.recurring_event_id" default="0" type="numeric">

		<cfscript>
			qEvent = Request.calendar_cfc.getEventInfo(attributes.calendar_id,attributes.recurring_event_id,Request.DSN,Request.calendarTbl,Request.calendar_recurringTbl,Request.event_typeTbl,Request.frequencyTbl);
			
			Request.page_title = Request.page_title & " - Event Details";
			Request.js_validate = "calendar/javascript/post_event.js";
			Request.template = "dsp_post_event.cfm";
			if (Secure("Calendar Admin") OR Request.squid.user_id EQ qEvent.created_user)
			{
				Request.onLoad = Request.onLoad & "document.forms['eventForm'].elements['event'].focus();document.forms['eventForm'].elements['event'].select();";
			}

			XFA.next = "calendar.act_post_event";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>


<!--- ----------------------------------------
SUBMIT EVENT
----------------------------------------- --->
	<cfcase value="dsp_post_event">
	<!--- Displays Event Submission form--->
		<cfparam name="attributes.calendar_id" default="0" type="numeric">
		<cfscript>
			if (VAL(attributes.calendar_id) GT 0)
			{
				Request.page_title = Request.page_title & " - Update Event";
			}
			else
			{
				Request.page_title = Request.page_title & " - Submit Event";
			}
			Request.js_validate = "calendar/javascript/post_event.js";
			Request.template = "dsp_post_event.cfm";
			Request.onLoad = Request.onLoad & "document.forms['eventForm'].elements['frequency_id'].focus();";

			XFA.next = "calendar.act_post_event";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_post_event">
	<cfsilent>
	<!--- Submits info --->
		<cfparam name="attributes.returnFA" default="calendar.start" type="string">
		<cfscript>
			XFA.success = attributes.returnFA;
			XFA.failure = "calendar.dsp_post_event";

			Request.suppressLayout = true;

			Request.validation_template = "val_post_event.cfm";
			Request.template = "../act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>



































<!--- ----------------------------------------
OFFICERS
----------------------------------------- --->
	<cfcase value="dsp_officers">
	<!--- Displays Officers --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Update Officers";
			Request.template = "dsp_officers.cfm";

			XFA.edit = "members.dsp_officers_edit";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_officers_edit">
	<!--- Displays Officers Edit form--->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Update Officers";
			Request.js_validate = "members/javascript/officers_edit.js";
			Request.template = "dsp_officers_edit.cfm";

			XFA.next = "members.act_officers_edit";
			XFA.officers = "members.dsp_officers";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

<!--- ----------------------------------------
MEMBER LIST EXPORT
----------------------------------------- --->
	<cfcase value="dsp_members_export">
	<!--- Displays List of Members --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Export Member List";
			Request.template = "dsp_members_export.cfm";
			Request.js_validate = "members/javascript/members_export.js";

			Request.lookup_cfc = Request.cfcPath & ".lookup_queries";
			XFA.export = "members.act_members_export";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_members_export">
	<cfsilent>
	<!--- Exports data --->
		<cfscript>
			Request.suppressLayout = true;

			Request.template = "act_members_export.cfm";
		</cfscript>

	</cfsilent>
		<cfinclude template="#Request.template#">
	</cfcase>

<!--- ----------------------------------------
PROFILE/MEMBERS
----------------------------------------- --->
	<cfcase value="dsp_members">
	<!--- Displays List of Members --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Add / Update Members";
			Request.template = "dsp_members.cfm";

			Request.lookup_cfc = Request.cfcPath & ".lookup_queries";
			XFA.edit = "members.dsp_profile";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_profile">
	<!--- Displays Profile --->
		<cfparam name="attributes.user_id" default="#Request.squid.user_id#" type="numeric">
		<cfscript>
			if (attributes.user_id EQ Request.squid.user_id)
			{
				Request.page_title = Request.page_title & "<br />Your Profile";
			}
			else if (VAL(attributes.user_id) GT 0)
			{
				Request.page_title = Request.page_title & "<br />Member Profile";
			}
			else
			{
				Request.page_title = Request.page_title & "<br />Add Member";
			}
			Request.js_validate = "members/javascript/profile.js";
			Request.template = "dsp_profile.cfm";

			Request.user_cfc = Request.cfcPath & ".login";
			Request.lookup_cfc = Request.cfcPath & ".lookup_queries";
			XFA.next = "members.act_profile";
			XFA.delete_picture = "members.act_profile_delete_picture";

			if (attributes.user_id EQ Request.squid.user_id OR Secure("Update Members"))
			{
				Request.onLoad = Request.onLoad & "document.profileForm[5].focus();";
			}
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_profile">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "members.dsp_profile";
			XFA.failure = "members.dsp_profile";

			Request.suppressLayout = true;

			Request.profile_cfc = Request.cfcPath & ".profile";
			Request.image_cfc = Request.cfcPath & ".image";
			Request.login_cfc = Request.cfcPath & ".login";
			Request.validation_template = "val_profile.cfm";
			Request.template = "act_profile.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="act_profile_delete_picture">
	<cfsilent>
	<!--- Deletes provile picture --->
		<cfscript>
			XFA.success = "members.dsp_profile";
			XFA.failure = "members.dsp_profile";

			Request.suppressLayout = true;

			Request.profile_cfc = Request.cfcPath & ".profile";
			Request.image_cfc = Request.cfcPath & ".image";
			Request.login_cfc = Request.cfcPath & ".login";
			Request.validation_template = "val_profile_delete_picture.cfm";
			Request.template = "act_profile.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

<!--- ----------------------------------------
PREFS
----------------------------------------- --->
	<cfcase value="dsp_preferences">
	<!--- Displays Preferences Screen --->
		<cfscript>
			attributes.user_id = Request.squid.user_id;
			Request.page_title = Request.page_title & "<br />Your Preferenes";
			Request.template = "dsp_preferences.cfm";

			Request.lookup_cfc = Request.cfcPath & ".lookup_queries";
			XFA.next = "members.act_preferences";

			Request.onLoad = Request.onLoad & "document.preferencesForm[1].focus();";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_preferences">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "members.dsp_preferences";
			XFA.failure = "members.dsp_preferences";

			Request.suppressLayout = true;

			Request.profile_cfc = Request.cfcPath & ".profile";
			Request.login_cfc = Request.cfcPath & ".login";
			Request.validation_template = "val_preferences.cfm";
			Request.template = "act_preferences.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

<!--- ----------------------------------------
ANNOUNCEMENTS
----------------------------------------- --->
	<cfcase value="dsp_announcements">
	<!--- Displays Annoucements --->
		<cfparam name="attributes.status" default="Approved" type="string">
		<cfscript>
			Request.page_title = Request.page_title & "<br />Announcements";
			Request.template = "dsp_announcements.cfm";

			Request.announce_cfc = Request.cfcPath & ".announcements";
			XFA.detail = "members.dsp_announcement_detail";
			XFA.pending = "members.dsp_announcements_pending";
			XFA.edit = "members.dsp_announcement_edit";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_announcements_pending">
	<!--- Displays Pending Annoucements --->
		<cfparam name="attributes.status" default="Pending" type="string">
		<cfscript>
			Request.page_title = Request.page_title & "<br />Pending Announcements";
			Request.template = "dsp_announcements_pending.cfm";

			Request.announce_cfc = Request.cfcPath & ".announcements";
			XFA.announcements = "members.dsp_announcements";
			XFA.detail = "members.dsp_announcement_detail";
			XFA.edit = "members.dsp_announcement_edit";
			XFA.approve = "members.act_announcement_approve";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_announcement_edit">
		<cfparam name="attributes.announcement_id" default="0" type="numeric">
	<!--- Displays Announcement Edit form--->
		<cfscript>
			if (VAL(attributes.announcement_id))
			{
				Request.page_title = Request.page_title & "<br />Update Announcement";
			}
			else
			{
				Request.page_title = Request.page_title & "<br />Post Announcement";
			}
			Request.js_validate = "members/javascript/announcement_edit.js";
			Request.template = "dsp_announcement_edit.cfm";

			Request.announce_cfc = Request.cfcPath & ".announcements";
			XFA.next = "members.act_announcement_edit";
			XFA.announcements = "members.dsp_announcements";
			XFA.preview = "members.dsp_announcement_preview";
			XFA.delete_attachment = "members.act_announcement_delete_attachment";

			Request.onLoad = Request.onLoad & "document.announcementForm.subject.focus();document.announcementForm.subject.select();";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_announcement_edit">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "members.dsp_announcements";
			XFA.failure = "members.dsp_announcement_edit";
			XFA.preview = "members.dsp_announcement_preview";
			XFA.announcements = "members.dsp_announcements_pending";
			XFA.attachment_delete = "members.act_announcement_attachment_delete";

			Request.suppressLayout = true;

			Request.announce_cfc = Request.cfcPath & ".announcements";
			Request.validation_template = "val_announcement_edit.cfm";
			Request.template = "act_announcement_edit.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="dsp_announcement_preview">
	<!--- Displays Announcement Preview --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Preview Announcement";
			Request.template = "dsp_announcement_preview.cfm";
			Request.message_template = "dsp_announcement_content.cfm";

			Request.announce_cfc = Request.cfcPath & ".announcements";
			XFA.next = "members.act_announcement_edit";
			XFA.announcements = "members.dsp_announcements";
			XFA.edit = "members.dsp_announcement_edit";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_announcement_detail">
	<!--- Displays Announcement Detail --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Announcement Detail";
			Request.template = "dsp_announcement_detail.cfm";
			Request.message_template = "dsp_announcement_content.cfm";

			Request.announce_cfc = Request.cfcPath & ".announcements";
			XFA.announcements = "members.dsp_announcements";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

<!--- ----------------------------------------
ISSUES
----------------------------------------- --->
	<cfcase value="dsp_issues">
	<!--- Displays Issues --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Issues/Bugs";
			Request.template = "dsp_issues.cfm";

			Request.lookup_cfc = Request.cfcPath & ".lookup_queries";
			Request.issues_cfc = Request.cfcPath & ".issues";
			XFA.edit = "members.dsp_issues_edit";
			XFA.detail = "members.dsp_issues_detail";

			Request.onLoad = Request.onLoad & "document.issuesForm.status_id.focus();";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_issues_detail">
	<!--- Displays Issues Detail--->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Issues Detail";
			Request.template = "dsp_issues_detail.cfm";

			Request.issues_cfc = Request.cfcPath & ".issues";
			XFA.issues = "members.dsp_issues";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_issues_edit">
	<!--- Displays Issues Edit form--->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Update Issues/Bugs";
			Request.js_validate = "members/javascript/issues_edit.js";
			Request.template = "dsp_issues_edit.cfm";

			Request.lookup_cfc = Request.cfcPath & ".lookup_queries";
			Request.issues_cfc = Request.cfcPath & ".issues";
			XFA.next = "members.act_issues_edit";
			XFA.issues = "members.dsp_issues";

			Request.onLoad = Request.onLoad & "document.issuesForm.status_id.focus();";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_issues_edit">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "members.dsp_issues";
			XFA.failure = "members.dsp_issues_edit";
			XFA.detail = "members.dsp_issues_detail";

			Request.suppressLayout = true;

			Request.issues_cfc = Request.cfcPath & ".issues";
			Request.validation_template = "val_issues_edit.cfm";
			Request.template = "act_issues_edit.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>



	<cfdefaultcase>
		<!---This will just display an error message and is useful in catching typos of fuseaction names while developing--->
		<cfoutput><p>This is the cfdefaultcase tag. I received a fuseaction called <strong>"#attributes.fuseaction#"</strong> and I don't know what to do with it.</p></cfoutput>
	</cfdefaultcase>

</cfswitch>
