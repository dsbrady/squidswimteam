<!---
<fusedoc
	fuse = "dsp_announcements.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the announcements.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="6 July 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="post" />
				<string name="pending" />
				<string name="detail" />
			</structure>
		</in>
		<out>
			<number name="announcement_id" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.announcement_id" default="0" type="numeric">
	<cfparam name="attributes.orderBy" default="a.date_submitted DESC" type="string">
	
	<cfparam name="attributes.date_from" default="#Month(DateAdd("m",-1,Now()))#-1-#Year(DateAdd("m",-1,Now()))#" type="string">
	<cfparam name="attributes.date_to" default="#DateFormat(Request.end_of_time,"M-D-YYYY")#" type="string">

	<cfset attributes.date_from = Replace(attributes.date_from,"-","/","ALL")>	
	<cfset attributes.date_to = Replace(attributes.date_to,"-","/","ALL")>	

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get maximum news date if end date is end of time --->
	<cfif attributes.date_to IS DateFormat(Request.end_of_time,"M/D/YYYY")>
		<cfinvoke  
			component="#Request.lookup_cfc#" 
			method="getMinMaxValue" 
			returnvariable="qSubmitMax"
			dsn=#Request.DSN#
			tblName=#Request.announcementTbl#
			field="date_submitted"
			activeField="active_code"
		>

		<cfinvoke  
			component="#Request.lookup_cfc#" 
			method="getMinMaxValue" 
			returnvariable="qEventMax"
			dsn=#Request.DSN#
			tblName=#Request.announcementTbl#
			field="eventDate"
			activeField="active_code"
		>

		<!--- Determine which date to use --->
		<cfif IsDate(qSubmitMax.maxVal) AND NOT IsDate(qEventMax.maxVal)>
			<cfset maxDate = qSubmitMax.maxVal />
		<cfelseif NOT IsDate(qSubmitMax.maxVal) AND IsDate(qEventMax.maxVal)>
			<cfset maxDate = qEventMax.maxVal />
		<cfelseif NOT IsDate(qSubmitMax.maxVal) AND NOT IsDate(qEventMax.maxVal)>
			<cfset maxDate = Now() />
		<cfelseif DateCompare(qSubmitMax.maxVal,qEventMax.maxVal) LT 0>
			<cfset maxDate = qEventMax.maxVal />
		<cfelse>
			<cfset maxDate = qSubmitMax.maxVal />
		</cfif>

		<!--- If the to date is before today, get the end of the current month, otherwise keep it --->
		<cfif DateCompare(Now(),variables.maxDate) LT 0>
			<cfset attributes.date_to = DateFormat(variables.maxDate,"M/D/YYYY") />
		<cfelse>
			<cfset attributes.date_to = DateFormat(CreateDate(Year(Now()),Month(Now()),DaysInMonth(Now())),"M/D/YYYY") />
		</cfif>
	</cfif>

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
		orderBy="CASE WHEN a.eventDate IS NOT NULL THEN a.eventDate ELSE a.date_submitted END DESC"
		startDate=#attributes.date_from#
		endDate=#attributes.date_to#
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
				<a href="#Request.self#?fuseaction=#XFA.menu#">Menu</a>
				> Announcements
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center">
			<form name="searchForm" action="#Request.self#?fuseaction=#attributes.fuseaction#" method="post">
				Display Announcements from
				<input type="text" name="date_from" size="10" maxlength="10" value="#attributes.date_from#" />
				to
				<input type="text" name="date_to" size="10" maxlength="10" value="#attributes.date_to#" />
				<input type="submit" name="submitBtn" value="Search" />
			</form>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center">
				<a href="#Request.self#?fuseaction=#XFA.edit#">Post Announcement</a>
				| <a href="#Request.self#?fuseaction=#XFA.pending#&status=Saved%20for%20Later">Your Saved Announcements</a>
			<cfif Secure("Approve Messages")>
				<br />
				| <a href="#Request.self#?fuseaction=#XFA.pending#&status=pending">Approve Pending Announcements</a>
				<strong>(#VAL(qPendingAnnouncements.RecordCount)#)</strong>
			</cfif>
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
								<strong>Date</strong>
							</td>
							<td>
								<strong>From</strong>
							</td>
							<td>
								<strong>Subject</strong>
							</td>
							<td>
								<strong>Announcement</strong>
							</td>
						</tr>
					</thead>
					<tbody>
					<cfloop query="qryAnnouncements">
						<cfscript>
							variables.rowClass = qryAnnouncements.currentRow MOD 2;
						</cfscript>
						<tr class="tableRow#variables.rowClass#">
							<td align="center" class="errorText">
							<cfif qryAnnouncements.special>
								!
							<cfelse>
								&nbsp;
							</cfif>
							</td>
							<td>
								#DateFormat(qryAnnouncements.announcementDate,"M/D/YYYY")#
							</td>
							<td>
								#qryAnnouncements.submittedBy_name#
							</td>
							<td>
								<a href="#Request.self#?fuseaction=#XFA.detail#&announcement_id=#qryAnnouncements.announcement_id#">#truncString(qryAnnouncements.subject,35)#</a>
							</td>
							<td>
								<a href="#Request.self#?fuseaction=#XFA.detail#&announcement_id=#qryAnnouncements.announcement_id#">#truncString(qryAnnouncements.announcement_plain,35)#</a>
							</td>
						</tr>
					</cfloop>
					</tbody>
				</table>
			<cfelse>
				There are no announcements matching your criteria.
			</cfif>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>

