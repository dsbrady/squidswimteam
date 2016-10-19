<!---
<fusedoc
	fuse = "dsp_practices_edit.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the practice update form.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="14 September 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
				<string name="practices" />
			</structure>

			<number name="practice_id" scope="attributes" />
			<number name="coach_id" scope="attributes" />
			<number name="facility_id" scope="attributes" />
			<list name="members" scope="attributes" />
			<list name="guests" scope="attributes" />
			<list name="membersOld" scope="attributes" />
			<list name="guestsOld" scope="attributes" />
			<string name="date_start" scope="attributes" />
			<string name="date_end" scope="attributes" />
			<string name="date_practice" scope="attributes" />
			<string name="notes" scope="attributes" />
			<string name="inactiveVisibility" scope="attributes" />
			<string name="activeVisibility" scope="attributes" />
			<string name="inactiveGuestVisibility" scope="attributes" />
			<string name="activeGuestVisibility" scope="attributes" />

			<boolean name="success" scope="formOrUrl" />
			<string name="reason" scope="formOrUrl" />
		</in>
		<out>
			<number name="practice_id" scope="formOrUrl" />
			<number name="coach_id" scope="formOrUrl" />
			<number name="facility_id" scope="formOrUrl" />
			<list name="members" scope="formOrUrl" />
			<list name="guests" scope="formOrUrl" />
			<list name="membersOld" scope="formOrUrl" />
			<list name="guestsOld" scope="formOrUrl" />
			<string name="date_start" scope="formOrUrl" />
			<string name="date_end" scope="formOrUrl" />
			<string name="date_practice" scope="formOrUrl" />
			<string name="notes" scope="formOrUrl" />
			<string name="inactiveMemberVisibility" scope="formOrUrl" />
			<string name="activeMemberVisibility" scope="formOrUrl" />
			<string name="inactiveGuestVisibility" scope="formOrUrl" />
			<string name="activeGuestVisibility" scope="formOrUrl" />
		</out>
	</io>

</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.date_start" default="#Month(Now())#-1-#Year(Now())#" type="string">
	<cfparam name="attributes.date_end" default="#DateFormat(Now(),"M-D-YYYY")#" type="string">
	<cfparam name="attributes.coach_id" default=0 type="numeric">
	<cfparam name="attributes.facility_id" default=0 type="numeric">
	<cfparam name="attributes.members" default="" type="string">
	<cfparam name="attributes.guests" default="" type="string">
	<cfparam name="attributes.membersOld" default="" type="string">
	<cfparam name="attributes.guestsOld" default="" type="string">
	<cfparam name="attributes.date_practice" default="#DateFormat(Now(),"M-D-YYYY")#" type="string">
	<cfparam name="attributes.notes" default="" type="string">
	<cfparam name="attributes.activeMemberVisibility" default="inline" type="string">
	<cfparam name="attributes.inactiveMemberVisibility" default="none" type="string">
	<cfparam name="attributes.activeGuestVisibility" default="" type="string">
	<cfparam name="attributes.inactiveGuestVisibility" default="none" type="string">

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<cfscript>
		attributes.date_start = Replace(attributes.date_start,"-","/","ALL");
		attributes.date_end = Replace(attributes.date_end,"-","/","ALL");
		attributes.date_practice = Replace(attributes.date_practice,"-","/","ALL");
	</cfscript>

	<!--- Get Facilities --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getFacilities"
		returnvariable="qryFacilities"
		dsn=#Request.DSN#
		facilityTbl=#Request.facilityTbl#
		defaultsTbl=#Request.practice_defaultTbl#
	>

	<!--- Get Coaches --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getCoaches"
		returnvariable="qryCoaches"
		dsn=#Request.DSN#
		usersTbl=#Request.usersTbl#
		officerTbl=#Request.officerTbl#
		officer_typeTbl=#Request.officer_typeTbl#
		defaultsTbl=#Request.practice_defaultTbl#
	>

	<!--- Get all members --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getMembers"
		returnvariable="qryMembers"
		dsn=#Request.DSN#
		usersTbl=#Request.usersTbl#
		user_statusTbl=#Request.user_statusTbl#
		transactionTbl=#Request.practice_transactionTbl#
		transaction_typeTbl=#Request.transaction_typeTbl#
		activityDays=#Request.activityDays#
	>

	<!--- Get active members --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getMembersActivity"
		returnvariable="qryActiveMembers"
		qrySource=#qryMembers#
		activityLevel="active"
		statusType="Member"
	>

	<!--- Get inactive members --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getMembersActivity"
		returnvariable="qryInactiveMembers"
		qrySource=#qryMembers#
		activityLevel="inactive"
		statusType="Member"
	>

	<!--- Get active guests --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getMembersActivity"
		returnvariable="qryActiveGuests"
		qrySource=#qryMembers#
		activityLevel="active"
		statusType="Guest"
	>

	<!--- Get inactive guests --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getMembersActivity"
		returnvariable="qryInactiveGuests"
		qrySource=#qryMembers#
		activityLevel="inactive"
		statusType="Guest"
	>

	<cfif (NOT (LEN(TRIM(attributes.activeGuestVisibility)))) AND qryActiveGuests.RecordCount>
		<cfset attributes.activeGuestVisibility = "inline">
	<cfelseif (NOT (LEN(TRIM(attributes.activeGuestVisibility))))>
		<cfset attributes.activeGuestVisibility = "none">
	</cfif>
	<cfif (attributes.success IS NOT "No") AND VAL(attributes.practice_id) GT 0>
		<!--- Get practice info --->
		<cfinvoke
			component="#Request.lookup_cfc#"
			method="getPractices"
			returnvariable="qryPractices"
			dsn=#Request.DSN#
			practicesTbl=#Request.practicesTbl#
			usersTbl=#Request.usersTbl#
			facilityTbl=#Request.facilityTbl#
			practice_id=#VAL(attributes.practice_id)#
		>

		<cfinvoke
			component="#Request.lookup_cfc#"
			method="getTransactions"
			returnvariable="qryAttendeeMembers"
			dsn=#Request.DSN#
			transactionTbl=#Request.practice_transactionTbl#
			practiceTbl=#Request.practicesTbl#
			transaction_typeTbl=#Request.transaction_typeTbl#
			usersTbl=#Request.usersTbl#
			user_statusTbl=#Request.user_statusTbl#
			facilityTbl=#Request.facilityTbl#
			practice_id=#VAL(attributes.practice_id)#
			memberType="Member"
		>

		<cfinvoke
			component="#Request.lookup_cfc#"
			method="getTransactions"
			returnvariable="qryAttendeeGuests"
			dsn=#Request.DSN#
			transactionTbl=#Request.practice_transactionTbl#
			practiceTbl=#Request.practicesTbl#
			transaction_typeTbl=#Request.transaction_typeTbl#
			usersTbl=#Request.usersTbl#
			user_statusTbl=#Request.user_statusTbl#
			facilityTbl=#Request.facilityTbl#
			practice_id=#VAL(attributes.practice_id)#
			memberType="Guest"
		>

		<cfscript>
			attributes.coach_id = qryPractices.coach_id;
			attributes.facility_id = qryPractices.facility_id;
			attributes.notes = qryPractices.notes;
			attributes.date_practice = DateFormat(qryPractices.date_practice,"M/D/YYYY");
			attributes.members = ValueList(qryAttendeeMembers.member_id);
			attributes.membersOld = ValueList(qryAttendeeMembers.member_id);
			attributes.guests = ValueList(qryAttendeeGuests.member_id);
			attributes.guestsOld = ValueList(qryAttendeeGuests.member_id);
		</cfscript>

	<cfelseif (attributes.success IS NOT "No")>
		<!--- Get Defaults --->
		<cfinvoke
			component="#Request.accounting_cfc#"
			method="getDefaults"
			returnvariable="qryDefaults"
			dsn=#Request.DSN#
			defaultsTbl=#Request.practice_defaultTbl#
		>

		<cfscript>
			attributes.coach_id = qryDefaults.coach_id;
			attributes.facility_id = qryDefaults.facility_id;
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
</cfif>

<cfoutput>
<form name="practiceForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post" onsubmit="return validate(this);">
	<input type="hidden" name="practice_id" value="#VAL(attributes.practice_id)#" />
	<input type="hidden" name="membersOld" value="#attributes.membersOld#" />
	<input type="hidden" name="guestsOld" value="#attributes.guestsOld#" />
	<input type="hidden" name="date_start" value="#attributes.date_start#" />
	<input type="hidden" name="date_end" value="#attributes.date_end#" />
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
			<td colspan="2" align="center">
				<a href="#Request.self#?fuseaction=#XFA.menu#">Main Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.acct_menu#">Accounting Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.practices#&date_start=#attributes.date_start#&date_end=#attributes.date_end#">Practices</a>
				> <cfif VAL(attributes.practice_id)>Update<cfelse>Add</cfif> Practice
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Date:</strong>
			</td>
			<td>
				<input type="text" name="date_practice" size="10" maxlength="10" tabindex="#variables.tabindex#" value="#attributes.date_practice#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Coach:</strong>
			</td>
			<td>
			<cfscript>
				if (qryCoaches.RecordCount LT 15)
				{
					variables.selSize = qryCoaches.RecordCount;
				}
				else
				{
					variables.selSize = 15;
				}
			</cfscript>
				<select name="coach_id" size="#variables.selSize#" tabindex="#variables.tabindex#" />
					<option value="0" <cfif attributes.coach_id EQ 0>selected="selected"</cfif>>(No Coach)</option>
				<cfloop query="qryCoaches">
					<option value="#qryCoaches.user_id#" <cfif attributes.coach_id EQ qryCoaches.user_id>selected="selected"</cfif>>#qryCoaches.preferred_name# #qryCoaches.last_name#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Facility:</strong>
			</td>
			<td>
			<cfscript>
				if (qryFacilities.RecordCount LT 4)
				{
					variables.selSize = qryFacilities.RecordCount;
				}
				else
				{
					variables.selSize = 5;
				}
			</cfscript>
				<select name="facility_id" size="#variables.selSize#" tabindex="#variables.tabindex#" />
					<option value="0" <cfif attributes.facility_id EQ 0>selected="selected"</cfif>>(No Facility)</option>
				<cfloop query="qryFacilities">
					<option value="#qryFacilities.facility_id#" <cfif attributes.facility_id EQ qryFacilities.facility_id>selected="selected"</cfif>>#qryFacilities.facility#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Notes:</strong>
			</td>
			<td>
				<input type="text" name="notes" size="25" maxlength="255" tabindex="#variables.tabindex#" value="#attributes.notes#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Members:</strong>
			</td>
			<td>
				<input type="text" name="membersTot" size="2" maxlength="2" tabindex="-1" value="#ListLen(attributes.members)#" onfocus="this.blur();" />
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Guests:</strong>
			</td>
			<td>
				<input type="text" name="guestsTot" size="2" maxlength="2" tabindex="-1" value="#ListLen(attributes.guests)#" onfocus="this.blur();" />
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Total:</strong>
			</td>
			<td>
				<input type="text" name="attendanceTot" size="2" maxlength="2" tabindex="-1" value="#ListLen(attributes.guests) + ListLen(attributes.members)#" onfocus="this.blur();" />
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				<strong>Members:</strong>
			</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				<table width="100%">
					<tbody id="activeMemberShow">
						<tr>
							<td colspan="4">
								<a href="#Request.self#?fuseaction=#attributes.fuseaction#&practice_id=#attributes.practice_id#&date_practice=#attributes.date_practice#&facility_id=#attributes.facility_id#&coach_id=#attributes.coach_id#&members=#attributes.members#&guests=#attributes.guests#&notes=#attributes.notes#&date_start=#attributes.date_start#&date_end=#attributes.date_end#&activeMemberVisibility=<cfif attributes.activeMemberVisibility IS "inline">none<cfelse>inline</cfif>&inactiveMemberVisibility=#attributes.inactiveMemberVisibility#&activeGuestVisibility=#attributes.activeGuestVisibility#&inactiveGuestVisibility=#attributes.inactiveGuestVisibility#" onclick="return showMembers('active','Member');"><span id="activeMemberTxt"><cfif attributes.activeMemberVisibility IS "inline">Hide<cfelse>Show</cfif></span> Active Members</a>
							</td>
						</tr>
					</tbody>
					<tbody id="activeMember" style="display:#attributes.activeMemberVisibility#;">
						<tr valign="top">
							<td>
								&nbsp;
							</td>
							<td colspan="3">
								<a href="" onclick="return addRow(document.getElementById('activeMember'),document.forms['practiceForm'],'member');">Add New Member</a>
							</td>
						</tr>
					<cfif qryActiveMembers.RecordCount>
						<cfset variables.halfway = CEILING(qryActiveMembers.RecordCount / 2)>
						<cfset variables.tabindex2 = 0>
						<cfloop from="1" to="#variables.halfway#" index="i">
						<tr valign="top">
							<td>
								<input type="checkbox" name="members" value="#qryActiveMembers.user_id[i]#" tabindex="#variables.tabindex#" <cfif ListFind(attributes.members,qryActiveMembers.user_id[i])>checked="checked"</cfif> onclick="return calculate(this,this.form);" />
							</td>
							<td>
								#qryActiveMembers.preferred_name[i]# #qryActiveMembers.last_name[i]#
							</td>
							<cfif (i LT variables.halfway) OR ((i EQ variables.halfway) AND qryActiveMembers.RecordCount EQ (i + variables.halfway))>
								<td>
									<cfset variables.tabindex2 = variables.tabindex + variables.halfway>
									<input type="checkbox" name="members" value="#qryActiveMembers.user_id[i + variables.halfway]#" tabindex="#variables.tabindex2#" <cfif ListFind(attributes.members,qryActiveMembers.user_id[i + variables.halfway])>checked="checked"</cfif> onclick="return calculate(this,this.form);" />
								</td>
								<td>
									#qryActiveMembers.preferred_name[i + variables.halfway]# #qryActiveMembers.last_name[i + variables.halfway]#
								</td>
							<cfelse>
								<td colspan="2">
									&nbsp;
								</td>
							</cfif>
						</tr>
							<cfset variables.tabindex = variables.tabindex + 1>
						</cfloop>
						<cfset variables.tabindex = variables.tabindex2 + 1>
					<cfelse>
						<tr valign="top">
							<td colspan="4">
								No Active Members
							</td>
						</tr>
					</cfif>
					</tbody>
					<tbody id="inactiveMemberShow">
						<tr>
							<td colspan="4">
								<a href="#Request.self#?fuseaction=#attributes.fuseaction#&practice_id=#attributes.practice_id#&date_practice=#attributes.date_practice#&facility_id=#attributes.facility_id#&coach_id=#attributes.coach_id#&members=#attributes.members#&guests=#attributes.guests#&notes=#attributes.notes#&date_start=#attributes.date_start#&date_end=#attributes.date_end#&inactiveMemberVisibility=<cfif attributes.inactiveMemberVisibility IS "inline">none<cfelse>inline</cfif>&activeMemberVisibility=#attributes.activeMemberVisibility#&activeGuestVisibility=#attributes.activeGuestVisibility#&inactiveGuestVisibility=#attributes.inactiveGuestVisibility#" onclick="return showMembers('inactive','Member');"><span id="inactiveMemberTxt"><cfif attributes.inactiveMemberVisibility IS "inline">Hide<cfelse>Show</cfif></span> Inactive Members</a>
							</td>
						</tr>
					</tbody>
					<tbody id="inactiveMember" style="display:#attributes.inactiveMemberVisibility#;">
					<cfif qryInactiveMembers.RecordCount>
						<cfset variables.halfway = CEILING(qryInactiveMembers.RecordCount / 2)>
						<cfset variables.tabindex2 = 0>
						<cfloop from="1" to="#variables.halfway#" index="i">
						<tr valign="top">
							<td>
								<input type="checkbox" name="members" value="#qryInactiveMembers.user_id[i]#" tabindex="#variables.tabindex#" <cfif ListFind(attributes.members,qryInactiveMembers.user_id[i])>checked="checked"</cfif> onclick="return calculate(this,this.form);" />
							</td>
							<td>
								#qryInactiveMembers.preferred_name[i]# #qryInactiveMembers.last_name[i]#
							</td>
							<cfif (i LT variables.halfway) OR ((i EQ variables.halfway) AND qryInactiveMembers.RecordCount EQ (i + variables.halfway))>
								<td>
									<cfset variables.tabindex2 = variables.tabindex + variables.halfway>
									<input type="checkbox" name="members" value="#qryInactiveMembers.user_id[i + variables.halfway]#" tabindex="#variables.tabindex2#" <cfif ListFind(attributes.members,qryInactiveMembers.user_id[i + variables.halfway])>checked="checked"</cfif> onclick="return calculate(this,this.form);" />
								</td>
								<td>
									#qryInactiveMembers.preferred_name[i + variables.halfway]# #qryInactiveMembers.last_name[i + variables.halfway]#
								</td>
							<cfelse>
								<td colspan="2">
									&nbsp;
								</td>
							</cfif>
						</tr>
							<cfset variables.tabindex = variables.tabindex + 1>
						</cfloop>
						<cfset variables.tabindex = variables.tabindex2 + 1>
					<cfelse>
						<tr valign="top">
							<td colspan="4">
								No Inactive Members
							</td>
						</tr>
					</cfif>
					</tbody>
					<tbody id="guests">
					<tr valign="top">
						<td colspan="4">
							&nbsp;
						</td>
					</tr>
					<tr valign="top">
						<td colspan="4">
							<strong>Guests:</strong>
						</td>
					</tr>
					</tbody>
					<tbody id="activeGuestShow">
						<tr>
							<td colspan="4">
								<a href="#Request.self#?fuseaction=#attributes.fuseaction#&practice_id=#attributes.practice_id#&date_practice=#attributes.date_practice#&facility_id=#attributes.facility_id#&coach_id=#attributes.coach_id#&members=#attributes.members#&guests=#attributes.guests#&notes=#attributes.notes#&date_start=#attributes.date_start#&date_end=#attributes.date_end#&activeMemberVisibility=#attributes.activeMemberVisibility#&inactiveMemberVisibility=#attributes.inactiveMemberVisibility#&activeGuestVisibility=<cfif attributes.activeGuestVisibility IS "inline">none<cfelse>inline</cfif>&inactiveGuestVisibility=#attributes.inactiveGuestVisibility#" onclick="return showMembers('active','Guest');"><span id="activeGuestTxt"><cfif attributes.activeGuestVisibility IS "inline">Hide<cfelse>Show</cfif></span> Active Guests</a>
							</td>
						</tr>
					</tbody>
					<tbody id="activeGuest" style="display:#attributes.activeGuestVisibility#;">
						<tr valign="top">
							<td>
								&nbsp;
							</td>
							<td colspan="3">
								<a href="" onclick="return addRow(document.getElementById('activeGuest'),document.forms['practiceForm'],'guest');">Add New Guest</a>
							</td>
						</tr>
					<cfif qryActiveGuests.RecordCount>
						<cfset variables.halfway = CEILING(qryActiveGuests.RecordCount / 2)>
						<cfset variables.tabindex2 = 0>
						<cfloop from="1" to="#variables.halfway#" index="i">
						<tr valign="top">
							<td>
								<input type="checkbox" name="guests" value="#qryActiveGuests.user_id[i]#" tabindex="#variables.tabindex#" <cfif ListFind(attributes.guests,qryActiveGuests.user_id[i])>checked="checked"</cfif> onclick="return calculate(this,this.form);" />
							</td>
							<td>
								#qryActiveGuests.preferred_name[i]# #qryActiveGuests.last_name[i]#
							</td>
							<cfif (i LT variables.halfway) OR ((i EQ variables.halfway) AND qryActiveGuests.RecordCount EQ (i + variables.halfway))>
								<td>
									<cfset variables.tabindex2 = variables.tabindex + variables.halfway>
									<input type="checkbox" name="guests" value="#qryActiveGuests.user_id[i + variables.halfway]#" tabindex="#variables.tabindex2#" <cfif ListFind(attributes.guests,qryActiveGuests.user_id[i + variables.halfway])>checked="checked"</cfif> onclick="return calculate(this,this.form);" />
								</td>
								<td>
									#qryActiveGuests.preferred_name[i + variables.halfway]# #qryActiveGuests.last_name[i + variables.halfway]#
								</td>
							<cfelse>
								<td colspan="2">
									&nbsp;
								</td>
							</cfif>
						</tr>
							<cfset variables.tabindex = variables.tabindex + 1>
						</cfloop>
						<cfset variables.tabindex = variables.tabindex2 + 1>
					<cfelse>
						<tr valign="top">
							<td colspan="4">
								No Active Guests
							</td>
						</tr>
					</cfif>
					</tbody>
					<tbody id="inactiveGuestShow">
						<tr>
							<td colspan="4">
								<a href="#Request.self#?fuseaction=#attributes.fuseaction#&practice_id=#attributes.practice_id#&date_practice=#attributes.date_practice#&facility_id=#attributes.facility_id#&coach_id=#attributes.coach_id#&members=#attributes.members#&guests=#attributes.guests#&notes=#attributes.notes#&date_start=#attributes.date_start#&date_end=#attributes.date_end#&activeMemberVisibility=#attributes.activeMemberVisibility#&inactiveMemberVisibility=#attributes.inactiveMemberVisibility#&inactiveGuestVisibility=<cfif attributes.inactiveGuestVisibility IS "inline">none<cfelse>inline</cfif>&activeGuestVisibility=#attributes.activeGuestVisibility#" onclick="return showMembers('inactive','Guest');"><span id="inactiveGuestTxt"><cfif attributes.inactiveGuestVisibility IS "inline">Hide<cfelse>Show</cfif></span> Inactive Guests</a>
							</td>
						</tr>
					</tbody>
					<tbody id="inactiveGuest" style="display:#attributes.inactiveGuestVisibility#;">
					<cfif qryInactiveGuests.RecordCount>
						<cfset variables.halfway = CEILING(qryInactiveGuests.RecordCount / 2)>
						<cfset variables.tabindex2 = 0>
						<cfloop from="1" to="#variables.halfway#" index="i">
						<tr valign="top">
							<td>
								<input type="checkbox" name="guests" value="#qryInactiveGuests.user_id[i]#" tabindex="#variables.tabindex#" <cfif ListFind(attributes.guests,qryInactiveGuests.user_id[i])>checked="checked"</cfif> onclick="return calculate(this,this.form);" />
							</td>
							<td>
								#qryInactiveGuests.preferred_name[i]# #qryInactiveGuests.last_name[i]#
							</td>
							<cfif (i LT variables.halfway) OR ((i EQ variables.halfway) AND qryInactiveGuests.RecordCount EQ (i + variables.halfway))>
								<td>
									<cfset variables.tabindex2 = variables.tabindex + variables.halfway>
									<input type="checkbox" name="guests" value="#qryInactiveGuests.user_id[i + variables.halfway]#" tabindex="#variables.tabindex2#" <cfif ListFind(attributes.guests,qryInactiveGuests.user_id[i + variables.halfway])>checked="checked"</cfif> onclick="return calculate(this,this.form);" />
								</td>
								<td>
									#qryInactiveGuests.preferred_name[i + variables.halfway]# #qryInactiveGuests.last_name[i + variables.halfway]#
								</td>
							<cfelse>
								<td colspan="2">
									&nbsp;
								</td>
							</cfif>
						</tr>
							<cfset variables.tabindex = variables.tabindex + 1>
						</cfloop>
						<cfset variables.tabindex = variables.tabindex2 + 1>
					<cfelse>
						<tr valign="top">
							<td colspan="4">
								No Inactive Guests
							</td>
						</tr>
					</cfif>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2" align="center">
				<input type="submit" name="submitBtn" value="Save Practice" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
				<input type="reset" name="resetBtn" value="Reset Form" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

