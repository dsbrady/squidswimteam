<cfcomponent displayname="Announcements Components" hint="CFC for Announcements">
	<cffunction name="getAnnouncements" access="public" displayname="Announcement Info" hint="Gets Announcement Info" output="No" returntype="query">
		<cfargument name="announcement_id" required="no" type="numeric" default="0">
		<cfargument name="status" required="no" type="string" default="Approved">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="usersTbl" required="no" type="string" default="usersTbl">
		<cfargument name="announcementTbl" required="no" type="string" default="announcementTbl">
		<cfargument name="statusTbl" required="no" type="string" default="announcement_statusTbl">
		<cfargument name="orderBy" required="no" type="string" default="a.date_submitted DESC">
		<cfargument name="numAnnouncements" required="no" type="numeric" default="0" />
		<cfargument name="startDate" required="No" type="date" />
		<cfargument name="endDate" required="No" type="date" />
		<cfargument name="user_id" required="No" type="numeric" default="0" />

		<!--- Run query --->
		<cfquery name="qryAnnouncements" datasource="#arguments.dsn#">
			SELECT
			<cfif VAL(numAnnouncements)>
				TOP #VAL(numAnnouncements)#
			</cfif>
				a.announcement_id,
				a.sending_user,
				a.approved_by,
				a.status_id,
				a.date_submitted,
				a.eventDate,
				CASE WHEN
					a.eventDate IS NOT NULL
				THEN
					a.eventDate
				ELSE
					a.date_submitted
				END AS announcementDate,
				a.date_approved,
				a.date_expires,
				a.isPublic,
				sb.preferred_name + ' ' + sb.last_name AS submittedBy_name,
				sb.email AS submittedBy_email,
				ab.preferred_name + ' ' + ab.last_name AS approvedBy_name,
				a.subject,
				s.status,
				a.special,
				a.attachment,
				a.announcement,
				a.announcement_plain
			FROM

				(
					(
						#arguments.announcementTbl# a
						LEFT JOIN #arguments.usersTbl# ab
						ON a.approved_by = ab.user_id
					)
					INNER JOIN
					#arguments.statusTbl# s
					ON a.status_id = s.status_id
				)
				INNER JOIN
					#arguments.usersTbl# sb
					ON a.sending_user = sb.user_id
			WHERE
				a.active_code = 1
			<cfif VAL(arguments.announcement_id) GT 0>
				AND a.announcement_id = <cfqueryparam value="#VAL(arguments.announcement_id)#" cfsqltype="CF_SQL_INTEGER">
			<cfelse>
				AND upper(s.status) = <cfqueryparam value="#UCASE(arguments.status)#" cfsqltype="CF_SQL_VARCHAR">
			</cfif>
			<cfif StructKeyExists(arguments,"startDate")>
				AND
					(
						(
							a.eventDate IS NULL
							AND a.date_submitted >= <cfqueryparam value="#arguments.startDate#" cfsqltype="CF_SQL_DATE" />
						)
						OR a.eventDate >= <cfqueryparam value="#arguments.startDate#" cfsqltype="CF_SQL_DATE" />
					)
			</cfif>
			<cfif StructKeyExists(arguments,"endDate")>
				AND
					(
						(
							a.eventDate IS NULL
							AND a.date_submitted <= <cfqueryparam value="#arguments.endDate#" cfsqltype="CF_SQL_DATE" />
						)
						OR a.eventDate <= <cfqueryparam value="#arguments.endDate#" cfsqltype="CF_SQL_DATE" />
					)
			</cfif>
			<cfif arguments.status IS "Saved for Later">
				AND a.sending_user = <cfqueryparam value="#VAL(arguments.user_id)#" cfsqltype="CF_SQL_INTEGER" />
			</cfif>
	<cfif LEN(TRIM(arguments.orderBy))>
		ORDER BY
			#arguments.orderBy#
	</cfif>
		</cfquery>

		<cfreturn qryAnnouncements>
	</cffunction>

	<cffunction name="validateAnnouncement" access="public" displayname="Validates Announcement" hint="Validates Announcement" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="announcementTbl" required="no" type="string" default="announcementTbl">
		<cfargument name="attachmentPath" required="yes" type="string">

		<cfset var success = StructNew() />

		<cfparam name="formfields.from_preview" default="false" type="boolean">
		<cfparam name="formfields.uploaded_src" default="" type="string">
		<cfparam name="formfields.src" default="" type="string">

		<cfscript>
			success.success = "Yes";
			success.reason = "";
			success.content = StructNew();
			success.content.plain = "";
			success.content.html = "";
			success.attachment = "";
		</cfscript>

		<!--- Validate data --->
		<cfscript>
			if (LEN(trim(arguments.formfields.eventDate)) AND NOT isDate(arguments.formfields.eventDate))
			{
				success.success = "No";
				success.reason = success.reason & "Please enter a valid event date.*";
			}
			if (NOT LEN(trim(arguments.formfields.subject)))
			{
				success.success = "No";
				success.reason = success.reason & "Please enter the subject.*";
			}
			if (NOT LEN(trim(arguments.formfields.announcement)))
			{
				success.success = "No";
				success.reason = success.reason & "Please enter the announcement text.*";
			}
		</cfscript>

		<cfif NOT success.success>
			<cfreturn success>
		</cfif>

		<!--- Set HTML and plain text versions --->
		<cfinvoke
			component="#this#"
			method="contentFormat"
			returnvariable="success.content"
			content=#arguments.formfields.announcement#
		>

		<!--- If there's a file, upload it --->
		<cfif (NOT LEN(TRIM(arguments.formfields.uploaded_src))) AND LEN(TRIM(arguments.formfields.src))>
			<cftry>
				<cffile
					accept="image/gif,image/jpeg,image/pjpeg,application/msword,application/mspowerpoint,application/vnd.ms-excel,application/pdf"
					action="UPLOAD"
					filefield="src"
					destination="#arguments.attachmentPath#"
					nameConflict="MAKEUNIQUE"
				>

				<cfset success.attachment = CFFILE.serverfile>

				<cfcatch type="Any">
					<cfset success.success = "No">
					<cfset success.reason = "There was a problem uploading the file.  It may not be in the proper format.">
				</cfcatch>
			</cftry>
		<!--- Otherwise,  make sure you're not coming from preview --->
		<cfelseif NOT LEN(TRIM(arguments.formfields.uploaded_src))>
			<cfset success.attachment = "">
		<cfelse>
			<cfset success.attachment = arguments.formfields.uploaded_src>
		</cfif>

		<cfset success.subject = arguments.formfields.subject>
		<cfset success.status_id = arguments.formfields.status_id>
		<cfset success.sending_user = arguments.formfields.sending_user>
		<cfset success.submittedBy_name = arguments.formfields.submittedBy_name>
		<cfset success.special = arguments.formfields.special>
		<cfset success.isPublic = arguments.formfields.isPublic>
		<cfset success.eventDate = arguments.formfields.eventDate>

		<cfreturn success>
	</cffunction>

	<cffunction name="contentFormat" access="public" displayname="Format Content" hint="Generates HTML and plain text versions" output="No" returntype="struct">
		<cfargument name="content" required="Yes" type="string">

		<cfset var.plain = ReplaceNoCase(arguments.content,"<p>","#chr(10)##chr(13)##chr(10)##chr(13)#","ALL")>
		<cfset var.genContent = StructNew()>
		<cfset var.genContent.html = arguments.content>
		<cfset var.genContent.plain = REReplaceNoCase(var.plain,"<[^>]*>","","All")>
		<cfset var.genContent.plain = ReplaceNoCase(var.genContent.plain,"&nbsp;"," ","All")>

		<cfreturn var.genContent>
	</cffunction>

	<cffunction name="updateAnnouncement" access="public" displayname="Update Announcement" hint="Updates Announcement" output="No">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="announcementTbl" required="no" type="string" default="announcementTbl">
		<cfargument name="preferenceTbl" required="no" type="string" default="preferenceTbl">
		<cfargument name="usersTbl" required="no" type="string" default="usersTbl">
		<cfargument name="announcement_statusTbl" required="no" type="string" default="announcement_statusTbl">
		<cfargument name="updating_user" required="yes" type="numeric">
		<cfargument name="approval_url" required="yes" type="string">
		<cfargument name="unsubscribeURL" required="true" type="string" />
		<cfargument name="encryptionKey" required="true" type="string" />
		<cfargument name="encryptionAlgorithm" required="true" type="string" />
		<cfargument name="encryptionEncoding" required="true" type="string" />

		<cfscript>
			var announcement_id = 0;
			var success = StructNew();
			success.success = "Yes";
			success.reason = "";
		</cfscript>

		<!--- Update database --->
		<cfif VAL(arguments.formfields.announcement_id) GT 0>
			<cfquery name="qryUpdate" datasource="#arguments.dsn#">
				UPDATE
					#arguments.announcementTbl#
				SET
					status_id = <cfqueryparam value="#VAL(arguments.formfields.status_id)#" cfsqltype="CF_SQL_INTEGER">,
					special = <cfqueryparam value="#arguments.formfields.special#" cfsqltype="CF_SQL_BIT">,
				<cfif VAL(arguments.formfields.status_id) EQ 2>
					approved_by = <cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
					date_approved = GetDate(),
				</cfif>
					isPublic = <cfqueryparam value="#arguments.formfields.isPublic#" cfsqltype="CF_SQL_BIT" />,
					eventDate = <cfqueryparam value="#arguments.formfields.eventDate#" cfsqltype="CF_SQL_DATE" null="#IIF(LEN(TRIM(arguments.formfields.eventDate)),DE("NO"),DE("Yes"))#" />,
					subject = <cfqueryparam value="#arguments.formfields.subject#" cfsqltype="CF_SQL_VARCHAR">,
					announcement = <cfqueryparam value="#arguments.formfields.announcement#" cfsqltype="CF_SQL_LONGVARCHAR">,
					announcement_plain = <cfqueryparam value="#arguments.formfields.announcement_plain#" cfsqltype="CF_SQL_LONGVARCHAR">,
					attachment = <cfqueryparam value="#arguments.formfields.src#" cfsqltype="CF_SQL_VARCHAR">
				WHERE
					announcement_id = <cfqueryparam value="#VAL(arguments.formfields.announcement_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>

			<cfset announcement_id = VAL(arguments.formfields.announcement_id)>
		<cfelse>
			<cftransaction action="BEGIN" isolation="SERIALIZABLE">
				<cfquery name="qryInsert" datasource="#arguments.dsn#">
					SET NOCOUNT ON;
					INSERT INTO
						#arguments.announcementTbl#
					(
						sending_user,
						status_id,
						date_submitted,
						subject,
						special,
						isPublic,
						eventDate,
						announcement,
						announcement_plain,
						attachment
					)
					VALUES
					(
						<cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#VAL(arguments.formfields.status_id)#" cfsqltype="CF_SQL_INTEGER">,
						GetDate(),
						<cfqueryparam value="#arguments.formfields.subject#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#arguments.formfields.special#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#arguments.formfields.isPublic#" cfsqltype="CF_SQL_BIT" />,
						<cfqueryparam value="#arguments.formfields.eventDate#" cfsqltype="CF_SQL_DATE" null="#IIF(LEN(TRIM(arguments.formfields.eventDate)),DE("NO"),DE("Yes"))#" />,
						<cfqueryparam value="#arguments.formfields.announcement#" cfsqltype="CF_SQL_LONGVARCHAR">,
						<cfqueryparam value="#arguments.formfields.announcement_plain#" cfsqltype="CF_SQL_LONGVARCHAR">,
						<cfqueryparam value="#arguments.formfields.src#" cfsqltype="CF_SQL_VARCHAR">
					);
					SET NOCOUNT ON;
					SELECT
						scope_identity() AS newID
				</cfquery>

				<cfset announcement_id = qryInsert.newID>
			</cftransaction>
		</cfif>

		<!--- If new and pending, send e-mail to admin --->
		<cfif arguments.formfields.status_id EQ 1 AND arguments.formfields.announcement_id EQ 0>
			<cfmail from="squid@squidswimteam.org" to="moderator@squidswimteam.org" subject="New Squid Announcement Posted - #arguments.formfields.subject#" server="mail.squidswimteam.org">
#arguments.formfields.submittedBy_name# has posted an announcement to the
SQUID web site.

To approve or reject it, go to #arguments.approval_url#

Subject: #arguments.formfields.subject#
Announcement:
#arguments.formfields.announcement_plain#
			</cfmail>
		<!--- Else if approved, e-mail to everyone --->
		<cfelseif arguments.formfields.status_id EQ 2>
			<cfinvoke
				component="#this#"
				method="emailAnnouncement"
				dsn=#arguments.DSN#
				returnvariable="success"
				announcement_id=#announcement_id#
				announcementTbl=#arguments.announcementTbl#
				preferenceTbl=#arguments.preferenceTbl#
				usersTbl=#arguments.usersTbl#
				statusTbl=#arguments.announcement_statusTbl#
				unsubscribeURL=#arguments.unsubscribeURL#
				encryptionKey=#arguments.encryptionKey#
				encryptionAlgorithm=#arguments.encryptionAlgorithm#
				encryptionEncoding=#arguments.encryptionEncoding#
			>
		</cfif>

		<cfreturn>
	</cffunction>

	<cffunction name="emailAnnouncement" access="public" displayname="E-mail Announcement" hint="E-mails Announcement" output="No">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="announcement_id" required="no" type="numeric" default="0">
		<cfargument name="announcementTbl" required="no" type="string" default="announcementTbl">
		<cfargument name="preferenceTbl" required="no" type="string" default="preferenceTbl">
		<cfargument name="usersTbl" required="no" type="string" default="usersTbl">
		<cfargument name="statusTbl" required="no" type="string" default="announcement_statusTbl">
		<cfargument name="unsubscribeURL" required="true" type="string" />
		<cfargument name="encryptionKey" required="true" type="string" />
		<cfargument name="encryptionAlgorithm" required="true" type="string" />
		<cfargument name="encryptionEncoding" required="true" type="string" />

		<!--- Get announcement information --->
		<cfinvoke
			component="#this#"
			method="getAnnouncements"
			returnvariable="qryAnnouncements"
			announcement_id=#arguments.announcement_id#
			dsn=#arguments.DSN#
			usersTbl=#arguments.usersTbl#
			announcementTbl=#arguments.announcementTbl#
			statusTbl=#arguments.statusTbl#
		>

		<!--- Get users for e-mailing --->
		<cfquery name="qryUsers" datasource="#arguments.dsn#">
			SELECT
				u.user_id,
				u.email,
				u.email_preference,
				ep.preference AS emailPref,
				u.posting_preference,
				pp.preference AS postPref
			FROM
				#arguments.usersTbl# u,
				#arguments.preferenceTbl# ep,
				#arguments.preferenceTbl# pp
			WHERE
				u.email_preference = ep.preference_id
				AND u.posting_preference = pp.preference_id
				AND u.active_code = 1
			<cfif qryAnnouncements.special>
				AND upper(pp.preference) <> 'WILL READ ON WEBSITE'
			<cfelse>
				AND upper(pp.preference) = 'ALL MESSAGES'
			</cfif>
				AND NOT EXISTS
				(
					SELECT
						us.userID
					FROM
						unsubscribes us
					WHERE
						(
							u.user_id = us.userID
							OR u.email = us.email
						)
						AND us.resubscribeDate IS NULL
				)
				ORDER BY
				u.email_preference,
				u.posting_preference,
				u.last_name,
				u.first_name
		</cfquery>

		<!--- Send e-mail --->
		<cfset membersCFC = createObject("component","cfc.members") />
		<cfloop query="qryUsers">
			<!--- Get unsubscribe content --->
			<cfset unsubscribeContent = membersCFC.getUnsubscribeContent(arguments.dsn,qryUsers.user_id,arguments.unsubscribeURL,arguments.encryptionKey,arguments.encryptionAlgorithm,arguments.encryptionEncoding) />

			<cfif isValid("email",qryUsers.email)>
				<!--- Plain text --->
				<cfif LEN(trim(qryUsers.email)) AND CompareNoCase(qryUsers.emailPref,"Plain Text") EQ 0>
					<cfmail from="squid@squidswimteam.org" to="#qryUsers.email#" subject="<squid-announce> - #qryAnnouncements.subject#" server="mail.squidswimteam.org" username="#Request.admin_email#" password="#Request.adminEmailPassword#">
						<cfmailparam name = "Reply-To" value = "#qryAnnouncements.submittedBy_name# <#qryAnnouncements.submittedBy_email#>">
<cfif LEN(TRIM(qryAnnouncements.attachment))><cfmailparam file="#Request.announcement_path#\#qryAnnouncements.attachment#"></cfif>
From:	#qryAnnouncements.submittedBy_name# (#qryAnnouncements.submittedBy_email#)
<cfif IsDate(qryAnnouncements.eventDate)>Event Date: #Dateformat(qryAnnouncements.eventDate,"m/d/yyyy")#</cfif>

#qryAnnouncements.announcement_plain#
<cfif LEN(TRIM(qryAnnouncements.attachment))>
(See Attached File)
</cfif>

-----------------------------------
Squid Swim Team
#Request.theServer#

#unsubscribeContent.text#
					</cfmail>
				<!--- HTML --->
				<cfelseif LEN(trim(qryUsers.email))>

					<cfmail from="squid@squidswimteam.org" to="#qryUsers.email#" subject="<squid-announce> - #qryAnnouncements.subject#" type="HTML" server="mail.squidswimteam.org" username="#Request.admin_email#" password="#Request.adminEmailPassword#">
						<cfmailparam name = "Reply-To" value = "#qryAnnouncements.submittedBy_name# <#qryAnnouncements.submittedBy_email#>">
						<cfif LEN(TRIM(qryAnnouncements.attachment))>
							<cfmailparam file="#Request.announcement_path#\#qryAnnouncements.attachment#">
						</cfif>
	<p>
	From: #qryAnnouncements.submittedBy_name# (<a href="mailto:#qryAnnouncements.submittedBy_email#">#qryAnnouncements.submittedBy_email#</a>)
	<cfif IsDate(qryAnnouncements.eventDate)>
		<br />Event Date: #Dateformat(qryAnnouncements.eventDate,"m/d/yyyy")#
	</cfif>
	</p>

	#qryAnnouncements.announcement#

	<cfif LEN(TRIM(qryAnnouncements.attachment))>
	<p>
	(See Attached File)
	</p>
	</cfif>
	<p>
	-----------------------------------<br />
	Squid Swim Team<br />
	<a href="#Request.theServer#">#Request.theServer#</a>
	</p>
	#unsubscribecontent.html#
					</cfmail>

				</cfif>
			</cfif>
		</cfloop>
	</cffunction>
</cfcomponent>

