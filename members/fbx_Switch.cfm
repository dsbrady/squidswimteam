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
DASHBOARD
----------------------------------------- --->
	<cfcase value="start,dsp_start,fusebox.defaultfuseaction">
		<!--- This will display the dashboard --->
		<cfscript>
			Request.page_title = "SQUID Member Dashboard";

			XFA.profile = "members.dsp_profile";
			XFA.preferences = "members.dsp_preferences";
			XFA.issues = "members.dsp_issues";
			XFA.officers = "members.dsp_officers";
			XFA.announcements = "members.dsp_announcements";
			XFA.changePassword = "login.dsp_change_password";
			XFA.updateAccounting = "accounting.dsp_start";
			XFA.dsp_members = "members.dsp_members";
			XFA.members_export = "members.dsp_members_export";
			XFA.transactions = "members.dsp_transactions";
			XFA.content = "content.dsp_start";
			XFA.meetAdmin = "meetAdmin.dsp_start";
			XFA.times = "members.dsp_times";
			XFA.announceDetail = "members.dsp_announcement_detail";
			XFA.buySwims = "buySwims.home";
			XFA.dues = "membership.dsp_membershipForm";
			XFA.survey = "survey.dsp_start";
			XFA.pendingAnnouncements = "members.dsp_announcements_pending";
			XFA.trainingResources = "members.dsp_trainingResources";
			XFA.viewTrainingResource = "members.dsp_viewTrainingResource";

			Request.template = "dsp_start.cfm";

			cfcLookup = CreateObject("component",Request.lookup_cfc);
			cfcAnnounce = createObject("component",Request.announce_cfc);

			Request.qMember = cfcLookup.getMembers(Request.dsn,Request.usersTbl,Request.user_statusTbl,Request.practice_transactionTbl,Request.transaction_typeTbl,Request.squid.user_id);
			swimBalance = Request.qMember.balance;
			swimPassExpiration = Request.qMember.swimPassExpiration;
			qAnnouncements = cfcAnnounce.getAnnouncements(0,"Approved",Request.dsn,Request.usersTbl,Request.announcementTbl,Request.announcement_statusTbl,"CASE WHEN a.eventDate IS NOT NULL THEN a.eventDate ELSE a.date_submitted END DESC",5);

			announceCFC = CreateObject("component",Request.announce_cfc);
			qPendingAnnouncements = announceCFC.getAnnouncements(0,"Pending",Request.dsn,Request.usersTbl,Request.announcementTbl,Request.announcement_statusTbl,"",0);

			startDate = CreateDateTime(Year(Now()),Month(Now()),Day(Now()),0,0,0);
			endDate = DateAdd("D",7,startDate);
			endDate = CreateDateTime(Year(endDate),Month(endDate),Day(endDate),23,59,59);

			request.qTrainingResources = request.objTrainingResources.getRecentTrainingResourcesByUserIDAsQuery(request.dsn,request.squid.user_id,5);
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

<!--- ----------------------------------------
MENU
----------------------------------------- --->
	<cfcase value="startOld">
		<!---This will be the value returned if someone types in "circuitname.", omitting the actual fuseaction request--->
		<cfscript>
			XFA.profile = "members.dsp_profile";
			XFA.preferences = "members.dsp_preferences";
			XFA.issues = "members.dsp_issues";
			XFA.officers = "members.dsp_officers";
			XFA.announcements = "members.dsp_announcements";
			XFA.changePassword = "login.dsp_change_password";
			XFA.updateAccounting = "accounting.dsp_start";
			XFA.dsp_members = "members.dsp_members";
			XFA.members_export = "members.dsp_members_export";
			XFA.transactions = "members.dsp_transactions";
			XFA.content = "content.dsp_start";
			XFA.meetAdmin = "meetAdmin.dsp_start";
			XFA.times = "members.dsp_times";

			Request.template = "dsp_menu.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

<!--- ----------------------------------------
TRAINING RESOURCES
----------------------------------------- --->
	<cfcase value="dsp_trainingResources">
	<!--- Displays training resources --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Training Resources";
			Request.template = "dsp_trainingResources.cfm";

			XFA.viewTrainingResource = "members.dsp_viewTrainingResource";
		</cfscript>

		<cfset request.qTrainingResources = request.objTrainingResources.getRecentTrainingResourcesByUserIDAsQuery(request.dsn,request.squid.user_id,0) />

		<cfinclude template="#request.template#" />
	</cfcase>

	<cfcase value="dsp_viewTrainingResource">
	<!--- Displays training resource --->
		<cfparam name="attributes.trainingResourceID" type="numeric" />
		<cfscript>
			Request.page_title = Request.page_title & "<br />Training Resource";
			Request.template = "dsp_viewTrainingResource.cfm";

			XFA.trainingResources = "members.dsp_trainingResources";
		</cfscript>

		<cfset request.qTrainingResource = request.objTrainingResources.getTrainingResourcesByIDAndUserIDAsQuery(request.dsn,attributes.trainingResourceID,request.squid.user_id) />

		<cfinclude template="#Request.template#">
	</cfcase>

<!--- ----------------------------------------
MEETING MINUTES
----------------------------------------- --->
	<cfcase value="dsp_minutes">
	<!--- Displays Meeting minutes --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Meeting Minutes";
			Request.template = "dsp_minutes.cfm";

			qMinutes = Request.lookupCFC.getMinutes(Request.dsn);
		</cfscript>

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

		<cfinclude template="#Request.template#">
	</cfcase>

<!--- ----------------------------------------
EVENTS/TIMES
----------------------------------------- --->
	<cfcase value="dsp_times">
	<!--- Displays Events/Times --->
		<cfparam name="attributes.distanceID" default="0" type="numeric" />
		<cfparam name="attributes.strokeID" default="0" type="numeric" />
		<cfparam name="attributes.distanceTypeID" default="0" type="numeric" />
		<cfparam name="attributes.unitID" default="0" type="numeric" />
		<cfparam name="attributes.startDate" default="#dateFormat(createDate(year(now()),1,1),"m/d/yyyy")#" type="string" />
		<cfparam name="attributes.endDate" default="#dateFormat(now(),"m/d/yyyy")#" type="date" />

		<cfscript>
			Request.page_title = Request.page_title & "<br />Event Times";
			Request.template = "dsp_times.cfm";

			memberCFC = CreateObject("component",Request.members_cfc);
			lookupCFC = CreateObject("component",Request.lookup_cfc);
			qStrokes = lookupCFC.getStrokes(Request.dsn,Request.strokeTbl);
			qDistances = lookupCFC.getDistances(Request.dsn,Request.distanceTbl);
			qDistanceTypes = lookupCFC.getDistanceTypes(Request.dsn,Request.distanceTypeTbl);
			qUnits = lookupCFC.getDistanceUnits(Request.dsn,Request.distanceUnitTbl);
			qEvents = lookupCFC.getUserEvents(Request.dsn,Request.usersTbl,Request.userEventTbl,Request.distanceTbl,request.distanceTypeTbl,request.distanceUnitTbl,Request.strokeTbl,Request.squid.user_id,0,attributes.distanceID,attributes.strokeID,attributes.distanceTypeID,attributes.unitID,attributes.startDate,attributes.endDate);

			XFA.edit = "members.dsp_event_edit";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_event_edit">
	<!--- Displays Event Edit form --->
		<cfparam name="attributes.eventID" default="0" type="numeric" />
		<cfscript>
			if (VAL(attributes.eventID))
			{
				Request.page_title = Request.page_title & "<br />Edit Event";
			}
			else
			{
				Request.page_title = Request.page_title & "<br />Add Event";
			}

			Request.template = "dsp_event_edit.cfm";
			Request.js_validate = "members/javascript/event_edit.js";
			Request.onLoad = Request.onLoad & "document.forms['inputForm'].elements['distanceID'].focus();";
			XFA.next = "members.act_event_edit";
			XFA.times = "members.dsp_times";

			memberCFC = CreateObject("component",Request.members_cfc);
			lookupCFC = CreateObject("component",Request.lookup_cfc);
			qEvent = lookupCFC.getUserEvents(Request.dsn,Request.usersTbl,Request.userEventTbl,Request.distanceTbl,request.distanceTypeTbl,request.distanceUnitTbl,Request.strokeTbl,Request.squid.user_id,VAL(attributes.eventID),0,0,0,0,0,0);
			qStrokes = lookupCFC.getStrokes(Request.dsn,Request.strokeTbl);
			qDistances = lookupCFC.getDistances(Request.dsn,Request.distanceTbl);
			qDistanceTypes = lookupCFC.getDistanceTypes(Request.dsn,Request.distanceTypeTbl);
			qUnits = lookupCFC.getDistanceUnits(Request.dsn,Request.distanceUnitTbl);
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_event_edit">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "members.dsp_times";
			XFA.failure = "members.dsp_event_edit";

			Request.suppressLayout = true;

			memberCFC = CreateObject("component",Request.members_cfc);
			Request.validation_template = "val_event_edit.cfm";
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

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

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

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_officers_edit">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "members.dsp_officers";
			XFA.failure = "members.dsp_officers_edit";

			Request.suppressLayout = true;

			Request.validation_template = "val_officers_edit.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

<!--- ----------------------------------------
SWIMS/TRANSACTIONS
----------------------------------------- --->
	<cfcase value="dsp_transactions">
		<cfparam name="attributes.member_id" default="#Request.squid.user_id#" type="numeric">
		<cfparam name="attributes.transactionCategory" default="debit" type="string" />
	<!--- Displays Transactions --->
		<cfscript>
			if (NOT (Secure("Update Financials") OR Secure("Update Practices")))
			{
				attributes.member_id = Request.squid.user_id;
			}
			if (attributes.member_id EQ Request.squid.user_id)
			{
				Request.page_title = Request.page_title & "<br />Your Transactions";
			}
			else
			{
				Request.page_title = Request.page_title & "<br />Member Transactions";
			}

			Request.template = "../accounting/dsp_transactions.cfm";
			Request.js_validate = "accounting/javascript/transactions.js";

			XFA.export = "members.act_transactions_export";
			XFA.buySwims = "buySwims.home";
		</cfscript>

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_transactions_export">
	<cfsilent>
		<cfparam name="attributes.member_id" default="#Request.squid.user_id#" type="numeric">
	<!--- Exports data --->
		<cfscript>
			if (NOT (Secure("Update Financials") OR Secure("Update Practices")))
			{
				attributes.member_id = Request.squid.user_id;
			}

			Request.suppressLayout = true;

			Request.template = "act_transactions_export.cfm";
		</cfscript>

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

	</cfsilent>
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

			XFA.export = "members.act_members_export";
		</cfscript>

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_members_export">
	<cfsilent>
	<!--- Exports data --->
		<cfscript>
			Request.suppressLayout = true;

			Request.template = "act_members_export.cfm";
		</cfscript>

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

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

			lookupCFC = CreateObject("component",Request.lookup_cfc);

			XFA.edit = "members.dsp_profile";
		</cfscript>

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_profile">
	<!--- Displays Profile --->
		<cfparam name="attributes.user_id" default="#Request.squid.user_id#" type="numeric">
		<cfparam name="attributes.actionType" default="view" type="string">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
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
			XFA.next = "members.act_profile";
			XFA.delete_picture = "members.act_profile_delete_picture";
			XFA.buySwims = "buySwims.home";
			XFA.dues = "membership.dsp_membershipForm";

 			if ((CompareNoCase(attributes.actionType,"view") NEQ 0) AND (attributes.user_id EQ Request.squid.user_id OR Secure("Update Members")))
			{
				Request.onLoad = Request.onLoad & "document.profileForm[5].focus();";
			}
		</cfscript>

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

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
			Request.validation_template = "val_profile.cfm";
			Request.template = "act_profile.cfm";
		</cfscript>

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

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
			Request.validation_template = "val_profile_delete_picture.cfm";
			Request.template = "act_profile.cfm";
		</cfscript>

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

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

			XFA.add = "members.dsp_announcement_add";
			XFA.detail = "members.dsp_announcement_detail";
			XFA.edit = "members.dsp_announcement_edit";
			XFA.pending = "members.dsp_announcements_pending";

			announceCFC = CreateObject("component",Request.announce_cfc);
			qPendingAnnouncements = announceCFC.getAnnouncements(0,"Pending",Request.dsn,Request.usersTbl,Request.announcementTbl,Request.announcement_statusTbl,"",0);
		</cfscript>

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

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
			XFA.delete = "members.act_announcement_delete";
		</cfscript>

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_announcement_add,dsp_announcement_edit">
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
			arrayAppend(request.jsOther,request.htmlEditor);
			Request.onLoad = Request.onLoad & "CKEDITOR.replace('announcement',{customConfig:'#request.htmlEditorConfig#'});";

			Request.announce_cfc = Request.cfcPath & ".announcements";
			XFA.next = "members.act_announcement_edit";
			XFA.announcements = "members.dsp_announcements";
			XFA.preview = "members.dsp_announcement_preview";
			XFA.delete_attachment = "members.act_announcement_delete_attachment";

			Request.onLoad = Request.onLoad & "document.announcementForm.isPublic.focus();";
		</cfscript>

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

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
			XFA.unsubscribe = "home.act_unsubscribe";

			Request.suppressLayout = true;

			Request.announce_cfc = Request.cfcPath & ".announcements";
			Request.validation_template = "val_announcement_edit.cfm";
			Request.template = "act_announcement_edit.cfm";
		</cfscript>

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

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

			qStatuses = Request.lookupCFC.getStatus(Request.dsn,Request.announcement_statusTbl,VAL(Request.squid.announcement.status_id),"lower(s.status)");
		</cfscript>

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

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

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

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

			Request.issues_cfc = Request.cfcPath & ".issues";
			XFA.edit = "members.dsp_issues_edit";
			XFA.detail = "members.dsp_issues_detail";

			Request.onLoad = Request.onLoad & "document.issuesForm.status_id.focus();";
		</cfscript>

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

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

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_issues_edit">
	<!--- Displays Issues Edit form--->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Update Issues/Bugs";
			Request.js_validate = "members/javascript/issues_edit.js";
			Request.template = "dsp_issues_edit.cfm";

			Request.issues_cfc = Request.cfcPath & ".issues";
			XFA.next = "members.act_issues_edit";
			XFA.issues = "members.dsp_issues";

			Request.onLoad = Request.onLoad & "document.issuesForm.status_id.focus();";
		</cfscript>

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

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

		<cfif Request.squid.user_id EQ 469>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.noaccess#">
		</cfif>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>



	<cfdefaultcase>
		<!---This will just display an error message and is useful in catching typos of fuseaction names while developing--->
		<cfoutput><p>This is the cfdefaultcase tag. I received a fuseaction called <strong>"#attributes.fuseaction#"</strong> and I don't know what to do with it.</p></cfoutput>
	</cfdefaultcase>

</cfswitch>
