<!---
<fusedoc
	fuse = "val_announcement_edit.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="6 July 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
				<string name="preview" />
			</structure>

			<number name="announcement_id" scope="attributes" />
			<number name="status_id" scope="attributes" />
			<string name="src" scope="attributes" />
			<string name="subject" scope="attributes" />
			<number name="sending_user" scope="attributes" />
			<string name="announcement" scope="attributes" />
			<string name="previewBtn" scope="attributes" />
			<string name="submitBtn" scope="attributes" />
		</in>
		<out>
			<number name="announcement_id" scope="formOrUrl" />
			<number name="status_id" scope="formOrUrl" />
			<string name="src" scope="formOrUrl" />
			<string name="subject" scope="formOrUrl" />
			<number name="sending_user" scope="formOrUrl" />
			<string name="announcement" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.announcement_id" default="0" type="numeric">
<cfparam name="attributes.status_id" default="1" type="numeric">
<cfparam name="attributes.sending_user" default="#Request.squid.user_id#" type="numeric">
<cfparam name="attributes.from_preview" default="false" type="boolean">
<cfparam name="attributes.subject" default="" type="string">
<cfparam name="attributes.announcement" default="" type="string">
<cfparam name="attributes.announcement_plain" default="" type="string">
<cfparam name="attributes.previewBtn" default="" type="string">
<cfparam name="attributes.submitBtn" default="" type="string">
<cfparam name="attributes.editBtn" default="" type="string">
<cfparam name="attributes.cancelBtn" default="" type="string">
<cfparam name="attributes.special" default="false" type="boolean">
<cfparam name="attributes.isPublic" default="false" type="boolean" />
<cfparam name="attributes.eventDate" default="" type="string" />

<cfparam name="strSuccess" default="#StructNew()#" type="struct">
<cfparam name="strSuccess.success" default="yes" type="boolean">
<cfparam name="strSuccess.reason" default="" type="string">

<!--- If previewing, set new XFA --->
<cfif LEN(attributes.previewBtn) GT 0>
	<cfset XFA.success = XFA.preview>
<cfelseif LEN(attributes.editBtn) GT 0>
	<cfset XFA.success = XFA.failure>
	<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.success#&announcement_id=#attributes.announcement_id#">
</cfif>

<!--- If coming from preview, set form values equal to session values --->
<!--- Else Validate data and upload file (if necessary) --->
<cfif (attributes.from_preview) AND LEN(attributes.cancelBtn) EQ 0>
	<cfscript>
		attributes.announcement_id = Request.squid.announcement.announcement_id;
		attributes.status_id = Request.squid.announcement.status_id;
		attributes.sending_user = Request.squid.announcement.sending_user;
		attributes.submittedBy_name = Request.squid.announcement.submittedBy_name;
		attributes.subject = Request.squid.announcement.subject;
		attributes.src = Request.squid.announcement.attachment;
		attributes.announcement = Request.squid.announcement.content.html;
		attributes.announcement_plain = Request.squid.announcement.content.plain;
		attributes.special = Request.squid.announcement.special;
		attributes.isPublic = Request.squid.announcement.isPublic;
		attributes.eventDate = Request.squid.announcement.eventDate;
	</cfscript>
<cfelseif LEN(attributes.cancelBtn) EQ 0>
	<cfinvoke
		component="#Request.announce_cfc#"
		method="validateAnnouncement"
		returnvariable="strSuccess"
		formfields=#attributes#
		dsn=#Request.DSN#
		announcementTbl=#Request.announcementTbl#
		attachmentPath = #Request.announcement_path#
	>

	<cfscript>
		attributes.announcement_plain = strSuccess.content.plain;
		attributes.src = strSuccess.attachment;
	</cfscript>
</cfif>

<cfif NOT strSuccess.success>
	<cfscript>
		variables.theURL = Request.self & "?fuseaction=" & XFA.failure;
		variables.theURL = variables.theURL & "&success=" & strSuccess.success & "&reason=" & strSuccess.reason;
	</cfscript>

	<cfloop collection="#attributes#" item="variables.theItem">
		<cfscript>
			if ((variables.theItem IS NOT "SubmitBtn") AND (variables.theItem IS NOT "fieldnames") AND (variables.theItem IS NOT "fuseaction") AND (LEN(attributes[variables.theItem])))
			{
				variables.theURL = variables.theURL & "&" & variables.theItem & "=" & attributes[variables.theItem];
			}
		</cfscript>
	</cfloop>

	<cflocation addtoken="no" url="#variables.theURL#">
</cfif>

<!--- If final submission, update database and send e-mail if not approving --->
<cfif LEN(attributes.submitBtn) GT 0>

	<cfinvoke
		component="#Request.announce_cfc#"
		method="updateAnnouncement"
		formfields=#attributes#
		dsn=#Request.DSN#
		announcementTbl=#Request.announcementTbl#
		usersTbl=#Request.usersTbl#
		preferenceTbl=#Request.preferenceTbl#
		announcement_statusTbl=#Request.announcement_statusTbl#
		updating_user=#Request.squid.user_id#
		approval_url="#Request.theServer#/#Request.self#?fuseaction=#XFA.announcements#"
		unsubscribeURL="#Request.unsubscribeURL#"
		encryptionKey=#request.encryptionKey#
		encryptionAlgorithm=#request.encryptionAlgorithm#
		encryptionEncoding=#request.encryptionEncoding#
	>

	<!--- Kill session variables for announcement --->
	<cfscript>
		StructDelete(Session.squid,"announcement",true);
	</cfscript>
<cfelseif LEN(attributes.cancelBtn) GT 0>
	<!--- Kill session variables for announcement --->
	<cfscript>
		StructDelete(Session.squid,"announcement",true);
	</cfscript>
<cfelse>
	<cfset Session.squid.announcement = StructNew()>
	<cfset Session.squid.announcement.content = StructNew()>
	<cfset Session.squid.announcement.content.html = strSuccess.content.html>
	<cfset Session.squid.announcement.content.plain = strSuccess.content.plain>
	<cfset Session.squid.announcement.attachment = strSuccess.attachment>
	<cfset Session.squid.announcement.subject = strSuccess.subject>
	<cfset Session.squid.announcement.special = strSuccess.special>
	<cfset Session.squid.announcement.status_id = strSuccess.status_id>
	<cfset Session.squid.announcement.sending_user = strSuccess.sending_user>
	<cfset Session.squid.announcement.submittedBy_name = strSuccess.submittedBy_name>
	<cfset Session.squid.announcement.announcement_id = attributes.announcement_id>
	<cfset Session.squid.announcement.isPublic = strSuccess.isPublic>
	<cfset Session.squid.announcement.eventDate = strSuccess.eventDate>
</cfif>


