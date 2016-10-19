<!---
<fusedoc
	fuse = "dsp_calendar.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the calendar.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="30 December 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="post" />
			</structure>
		</in>
	</io>

</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.theMonth" default="#Month(Now())#" type="string">
	<cfparam name="attributes.theYear" default="#Year(Now())#" type="string">

	<!--- Validate --->
	<cfif NOT isNumeric(attributes.theMonth) OR attributes.theMonth LT 1 OR attributes.theMonth GT 12>
		<cfset attributes.theMonth = Month(Now())>
	<cfelse>
		<cfset attributes.theMonth = VAL(attributes.theMonth)>
	</cfif>

	<cfif NOT isNumeric(attributes.theYear)>
		<cfset attributes.theYear = Year(Now())>
	<cfelse>
		<cfset attributes.theYear = VAL(attributes.theYear)>
	</cfif>

	<!--- Set current and navigation variables --->
	<cfset theDate = ParseDateTime(attributes.theMonth & "-1-" & attributes.theYear)>
	<cfset lastYear = DateAdd("YYYY",-1,theDate)>
	<cfset lastMonth = DateAdd("M",-1,theDate)>
	<cfset nextMonth = DateAdd("M",1,theDate)>
	<cfset nextYear = DateAdd("YYYY",1,theDate)>

</cfsilent>
	<!--- Get calendar array --->
	<cfset aCal = Request.calendar_cfc.getCalendar(variables.theDate,Request.DSN,Request.usersTbl,Request.calendarTbl,Request.event_typeTbl)>
<table width="600" border="0" cellpadding="2" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td align="center">
				<h2>
				<cfoutput>
					#Request.page_title#<br />
					#DateFormat(theDate,"MMMM YYYY")#
				</cfoutput>
				</h2>
			</td>
		</tr>
		<tr>
			<td align="center">
		<cfoutput>
				<a href="#Request.self#/fuseaction/#XFA.post#/theMonth/#attributes.theMonth#/theYear/#attributes.theYear#.cfm">Submit Event</a>
		</cfoutput>
			</td>
		</tr>
		<tr>
			<td align="center">
				&nbsp;
			</td>
		</tr>
	</thead>
	<tbody>
		<!--- Display navigation form --->
		<tr>
			<td>
		<cfoutput>
			<form name="navForm" action="#Request.self#/fuseaction/#attributes.fuseaction#.cfm" method="post" onsubmit="return validate(this);" style="display:inline;">
		</cfoutput>
				<table width="600" border="0" cellpadding="0" cellspacing="0" align="center">
					<tbody>
					<cfoutput>
						<tr>
							<td width="40">
								<a href="#Request.self#/fuseaction/#attributes.fuseaction#/theMonth/#Month(lastYear)#/theYear/#Year(lastYear)#">&lt;&lt;</a>
							</td>
							<td width="30">
								<a href="#Request.self#/fuseaction/#attributes.fuseaction#/theMonth/#Month(lastMonth)#/theYear/#Year(lastMonth)#">&lt;</a>
							</td>
							<td width="460" align="center">
								<select name="theMonth" size="1" tabindex="1">
								<cfloop from="1" to="12" index="i">
									<option value="#i#" <cfif i EQ attributes.theMonth>selected="selected"</cfif>>#DateFormat(CreateDate(2003,i,1),"MMMM")#</option>
								</cfloop>
								</select>
								<input type="text" name="theYear" size="4" maxlength="4" value="#attributes.theYear#" tabindex="2" />
								<input type="submit" name="submitBtn" value="Go" class="buttonStyle" tabindex="3" />
							</td>
							<td width="30">
								<a href="#Request.self#/fuseaction/#attributes.fuseaction#/theMonth/#Month(nextMonth)#/theYear/#Year(nextMonth)#">&gt;</a>
							</td>
							<td width="40">
								<a href="#Request.self#/fuseaction/#attributes.fuseaction#/theMonth/#Month(nextYear)#/theYear/#Year(nextYear)#">&gt;&gt;</a>
							</td>
						</tr>
					</cfoutput>
					</tbody>
				</table>
			</form>
			</td>
		</tr>
		<!--- Build calendar --->
		<tr>
			<td>
				<table width="600" border="1" cellpadding="0" cellspacing="0" align="center" class="calendarTable">
					<thead>
						<tr align="center">
							<td width="85" height="35" class="calendarHead">
								S
							</td>
							<td width="85" class="calendarHead">
								M
							</td>
							<td width="85" class="calendarHead">
								T
							</td>
							<td width="85" class="calendarHead">
								W
							</td>
							<td width="85" class="calendarHead">
								T
							</td>
							<td width="85" class="calendarHead">
								F
							</td>
							<td width="85" class="calendarHead">
								S
							</td>
						</tr>
					</thead>
					<tbody>
				<cfoutput>
					<cfloop from="1" to="#ArrayLen(aCal)#" index="i">
						<tr>
						<cfloop from="1" to="#ArrayLen(aCal[i])#" index="j">
							<td class="#aCal[i][j].cellClass#">
								<strong>#aCal[i][j].theDay#</strong>&nbsp;
							<cfif ArrayLen(aCal[i][j].events)>
								<br /><br />
								<cfloop from="1" to="#ArrayLen(aCal[i][j].events)#" index="k">
									<cfif (VAL(Request.squid.user_id) GT 0) OR (aCal[i][j].events[k].publicView)>
										<span onmouseover="return showDetails('#JsStringFormat(aCal[i][j].events[k].eventString)#',document.getElementById('eventDetails'),'visible',this);" onmouseout="return showDetails('',document.getElementById('eventDetails'),'hidden',this);" title="#HTMLEditFormat(aCal[i][j].events[k].eventString)#"><cfif VAL(aCal[i][j].events[k].calendar_id)><a href="#Request.self#/fuseaction/#XFA.details#/calendar_id/#VAL(aCal[i][j].events[k].calendar_id)#/recurring_event_id/#VAL(aCal[i][j].events[k].recurring_event_id)#/returnMonth/#attributes.theMonth#/returnYear/#attributes.theYear#.cfm"></cfif><img src="images/calendar/#aCal[i][j].events[k].icon#" height="40" width="40" alt="" /><cfif VAL(aCal[i][j].events[k].calendar_id)></a></cfif></span>
									</cfif>
								</cfloop>
							</cfif>
							</td>
						</cfloop>
						</tr>
					</cfloop>
				</cfoutput>
					</tbody>
				</table>
				Click on an event to view the event details<cfif Secure("Calendar Admin")> or to edit the event</cfif>.
			</td>
		</tr>
	</tbody>
</table>

<div id="eventDetails" class="calendarDetails" style="position:absolute;left:0px;top:0px;cursor:hand;"></div>
