<!---
<fusedoc
	fuse = "dsp_announcements.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the pending announcements.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="10 August 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="edit" />
				<string name="detail" />
				<string name="approve" />
			</structure>
		</in>
		<out>
			<number name="announcement_id" scope="formOrUrl" />
			<number name="approveYN" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.announcement_id" default="0" type="numeric">
	<cfparam name="attributes.orderBy" default="a.date_submitted DESC" type="string">
	
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get Announcements --->
	<cfinvoke  
		component="#Request.announce_cfc#" 
		method="getAnnouncements" 
		returnvariable="qryAnnouncements"
		announcement_id=#attributes.announcement_id#
		status=#attributes.status#
		dsn=#Request.DSN#
		usersTbl=#Request.usersTbl#
		announcementTbl=#Request.announcementTbl#
		statusTbl=#Request.announcement_statusTbl#
		orderBy="a.date_submitted DESC"
		numAnnouncements=0
		user_id=#Request.squid.user_id#
	>
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
<table width="600" border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td align="center">
				<h2>
					#Request.page_title#
				</h2>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr valign="top">
			<td align="center">
				<a href="#Request.self#/fuseaction/#XFA.menu#.cfm">Menu</a>
				> <a href="#Request.self#/fuseaction/#XFA.Announcements#.cfm">Announcements</a>
				> Pending Announcements
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
			<cfif qryAnnouncements.RecordCount>
				<table cellspacing="0" cellpadding="3" align="center" class="tableClass">
					<thead>
						<tr class="tableHead">
							<td>
								&nbsp;
							</td>
							<td>
								&nbsp;
							</td>
							<td align="center">
								##
							</td>
							<td>
								Date
							</td>
							<td>
								Subject
							</td>
							<td>
								Announcement
							</td>
							<td>
								Sent By
							</td>
<!--- 
						<cfif attributes.status IS "Saved for Later">
							<td>
								&nbsp;
							</td>
						</cfif>
 --->
						</tr>
					</thead>
					<tbody>
					<cfloop query="qryAnnouncements">
						<cfscript>
							rowClass = qryAnnouncements.CurrentRow MOD 2;
						</cfscript>
						<tr class="tableRow#rowClass#">
							<td align="center" class="errorText">
							<cfif qryAnnouncements.special>
								!
							<cfelse>
								&nbsp;
							</cfif>
							</td>
							<td>
							<cfif Secure("Approve Messages") OR (qryAnnouncements.sending_user EQ Request.user_id)>
								<a href="#Request.self#/fuseaction/#XFA.edit#/announcement_id/#qryAnnouncements.announcement_id#/success/maybe.cfm">Edit</a>
							<cfelse>
								&nbsp;
							</cfif>
							</td>
							<td align="center">
								#qryAnnouncements.announcement_id#
							</td>
							<td>
								#DateFormat(qryAnnouncements.date_submitted,"M/D/YYYY")#
							</td>
							<td>
								#truncString(qryAnnouncements.subject,35)#
							</td>
							<td>
								#truncString(qryAnnouncements.announcement_plain,35)#
							</td>
							<td>
								#qryAnnouncements.submittedBy_name#
							</td>
<!--- 
						<cfif attributes.status IS "Saved for Later">
							<td>
								<a href="#Request.self#/fuseaction/#XFA.delete#/announcement_id/#VAL(qryAnnouncements.announcement_id)#.cfm" onclick="return confirm('Delete #JsStringFormat(qryAnnouncements.subject)#?');">Delete</a>
							</td>
						</cfif>
--->
						</tr>
					</cfloop>
					</tbody>
				</table>
			<cfelse>
				There are no pending announcements at this time.
			</cfif>
			</td>
		</tr>
		
	</tbody>
</table>
</cfoutput>

