<cfcomponent displayname="Calendar Components" hint="CFC for Calendar">
	<cffunction name="getCalendar" access="public" displayname="Get Calendar" hint="Gets Calendar for given date" output="No" returntype="array">
		<cfargument name="theDate" required="Yes" type="date">
		<cfargument name="dsn" required="Yes" type="string">
		<cfargument name="usersTbl" required="Yes" type="string">
		<cfargument name="calendarTbl" required="Yes" type="string">
		<cfargument name="event_typeTbl" required="Yes" type="string">

		<cfscript>
			var aCal = ArrayNew(2);
			var iDate = theDate;
		</cfscript>		
			
		<!--- Get all events for month --->
		<cfinvoke
			method="getMonthEvents"
			returnvariable="qryAllEvents"
			dsn=#dsn#
			theDate=#theDate#
			usersTbl=#usersTbl#
			calendarTbl=#calendarTbl#
			event_typeTbl=#event_typeTbl#
		>
			
		<cfscript>		
			// First, fill up first row
			for (i=1; i LTE 7; i = i + 1)
			{
				aCal[1][i] = StructNew();
				if (i LTE (DayOfWeek(theDate) - 1))
				{
					aCal[1][i].theDay = "";
					aCal[1][i].events = ArrayNew(1);
					aCal[1][i].cellClass = "calendarPlain";
				}
				else
				{
					aCal[1][i].theDay = Day(iDate);
					aCal[1][i].events = getDayEvents(iDate,qryAllEvents);
					if (DateCompare(iDate,CreateDateTime(Year(Now()),Month(Now()),Day(Now()),0,0,0)) EQ 0)
					{
						aCal[1][i].cellClass = "calendarCurrent";
					}
					else
					{
						aCal[1][i].cellClass = "calendarPlain";
					}
					iDate = DateAdd("D",1,iDate);
				}
			}

			// Fill up rows 2-6
			for (i=2; i LTE 6; i = i + 1)
			{
				for (j=1; j LTE 7; j = j + 1)
				{
					aCal[i][j] = StructNew();

					if (Month(iDate) EQ Month(theDate))
					{
						aCal[i][j].theDay = Day(iDate);
						aCal[i][j].events = getDayEvents(iDate,qryAllEvents);
						if (DateCompare(iDate,CreateDateTime(Year(Now()),Month(Now()),Day(Now()),0,0,0)) EQ 0)
						{
							aCal[i][j].cellClass = "calendarCurrent";
						}
						else
						{
							aCal[i][j].cellClass = "calendarPlain";
						}
						iDate = DateAdd("D",1,iDate);
					}
					else
					{
						aCal[i][j].theDay = "";
						aCal[i][j].cellClass = "calendarPlain";
						aCal[i][j].events = ArrayNew(1);
					}
				}
			}			

			// Delete empty rows
			if (LEN(aCal[6][1].theDay) EQ 0)
			{
				ArrayDeleteAt(aCal,6);
			}
			if (LEN(aCal[5][1].theDay) EQ 0)
			{
				ArrayDeleteAt(aCal,5);
			}
		</cfscript>		

		<cfreturn aCal>
	</cffunction>

	<cffunction name="getMonthEvents" access="public" displayname="Get Month Events" hint="Gets all events in a month" output="No" returntype="query">
		<cfargument name="theDate" required="Yes" type="date">
		<cfargument name="dsn" required="Yes" type="string">
		<cfargument name="usersTbl" required="Yes" type="string">
		<cfargument name="calendarTbl" required="Yes" type="string">
		<cfargument name="event_typeTbl" required="Yes" type="string">

		<cfset var endMonth = CreateDateTime(Year(theDate),Month(theDate),DaysInMonth(theDate),23,59,59)>

		<!--- Run query for events in this month --->
		<cfquery name="qryEvents" datasource="#DSN#">
			SELECT
				u.preferred_name + ' ' + u.last_name + '''s Birthday' AS eventString,
				'Birthday' AS event_type,
				'birthday.gif' AS icon,
				0 AS publicView,
				u.birthday AS startDate,
				u.birthday AS endDate,
				Day(u.birthday) AS sortDate,
				0 AS calendar_id,
				0 as recurring_event_id,
				0 AS created_user
			FROM
				#usersTbl# u
			WHERE
				Month(u.birthday) = <cfqueryparam value="#Month(theDate)#" cfsqltype="CF_SQL_INTEGER">
				AND u.active_code = 1
			UNION
			SELECT
				c.event + ' ( ' +
				CASE 
					WHEN DatePart(hh,c.startDate) > 12 THEN CAST((DatePart(hh,c.startDate)-12) AS varchar(2))
				ELSE
					CAST(DatePart(hh,c.startDate) AS varchar(2))
				END
				+ ':' + 
				CASE
					WHEN Datepart(mi,c.startdate) < 10 THEN '0'
				ELSE
					''
				END
				+ CAST(DatePart(mi,c.startDate) AS varchar(2)) + ' ' +
				CASE
					WHEN DatePart(hh,c.startDate) >= 12 THEN 'PM'
				ELSE
					'AM'
				END
				+ ' - ' + 
				CASE 
					WHEN DatePart(hh,c.endDate) > 12 THEN CAST((DatePart(hh,c.endDate)-12) AS varchar(2))
				ELSE
					CAST(DatePart(hh,c.endDate) AS varchar(2))
				END
				+ ':' + 
				CASE
					WHEN Datepart(mi,c.enddate) < 10 THEN '0'
				ELSE
					''
				END
				+ CAST(DatePart(mi,c.endDate) AS varchar(2)) + ' ' +
				CASE
					WHEN DatePart(hh,c.endDate) >= 12 THEN 'PM'
				ELSE
					'AM'
				END
				+ ')'
				AS eventString,
				et.event_type,
				et.icon,
				1 AS publicView,
				c.startDate AS startDate,
				c.endDate AS endDate,
				Day(c.startdate) AS sortDate,
				c.calendar_id,
				c.recurring_event_id,
				c.created_user
			FROM
				#calendarTbl# c,
				#event_typeTbl# et
			WHERE
				c.event_type_id = et.event_type_id
				AND DATEDIFF(day,c.startDate,<cfqueryparam value="#theDate#" cfsqltype="CF_SQL_TIMESTAMP" />) <= 0
				AND DATEDIFF(day,c.startDate,<cfqueryparam value="#endMonth#" cfsqltype="CF_SQL_TIMESTAMP" />) >= 0
				AND c.active_code = 1
			ORDER BY
				sortDate
		</cfquery>

		<cfreturn qryEvents>
	</cffunction>

	<cffunction name="getDayEvents" access="public" displayname="Get Day Events" hint="Gets all events in a day" output="no" returntype="array">
		<cfargument name="theDate" required="Yes" type="date">
		<cfargument name="qryEvents" required="Yes" type="query">

		<cfscript>
			var aEvents = ArrayNew(1);
		</cfscript>

		<!--- Loop along the query and put matches into array --->		
		<cfloop query="qryEvents">
			<cfscript>
				if (CompareNoCase(qryEvents.event_type,'Birthday') EQ 0)
				{
					if (Day(qryEvents.startDate) EQ Day(theDate))
					{
						aEvents[ArrayLen(aEvents) + 1] = StructNew();
						aEvents[ArrayLen(aEvents)].eventString = qryEvents.eventString;
						aEvents[ArrayLen(aEvents)].eventType = qryEvents.event_type;
						aEvents[ArrayLen(aEvents)].icon = qryEvents.icon;
						aEvents[ArrayLen(aEvents)].publicView = qryEvents.publicView;
						aEvents[ArrayLen(aEvents)].calendar_id = qryEvents.calendar_id;
						aEvents[ArrayLen(aEvents)].recurring_event_id = qryEvents.recurring_event_id;
					}
				}
				else
				{
					startDate2 = CreateDateTime(Year(qryEvents.startDate),Month(qryEvents.startDate),Day(qryEvents.startDate),0,0,0);
					endDate2 = CreateDateTime(Year(qryEvents.endDate),Month(qryEvents.endDate),Day(qryEvents.endDate),23,59,59);

					if ((DateCompare(startDate2,theDate) LTE 0) AND (DateCompare(endDate2,theDate) GTE 0))
					{
						aEvents[ArrayLen(aEvents) + 1] = StructNew();
						aEvents[ArrayLen(aEvents)].eventString = qryEvents.eventString;
						aEvents[ArrayLen(aEvents)].eventType = qryEvents.event_type;
						aEvents[ArrayLen(aEvents)].icon = qryEvents.icon;
						aEvents[ArrayLen(aEvents)].publicView = qryEvents.publicView;
						aEvents[ArrayLen(aEvents)].calendar_id = qryEvents.calendar_id;
						aEvents[ArrayLen(aEvents)].recurring_event_id = qryEvents.recurring_event_id;
					}
				}
			</cfscript>
		</cfloop>

		<cfreturn aEvents>
	</cffunction>

	<cffunction name="postEvent" access="public" displayname="Post Event" hint="Posts an Event" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="usersTbl" required="Yes" type="string">
		<cfargument name="user_StatusTbl" required="Yes" type="string">
		<cfargument name="calendarTbl" required="Yes" type="string">
		<cfargument name="calendar_recurringTbl" required="Yes" type="string">
		<cfargument name="event_typeTbl" required="Yes" type="string">
		<cfargument name="frequencyTbl" required="yes" type="string">
		<cfargument name="preferenceTbl" required="yes" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">

		<cfscript>
			var startDate = "";
			var endDate = "";
			var startTime = "";
			var endTime = "";
			var success = StructNew();
			success.success = "Yes";
			success.reason = "";
		</cfscript>		

		<!--- First, validate data --->
		<cfscript>
			if (NOT LEN(trim(formfields.startDate)) OR NOT IsDate(formfields.startDate))
			{
				success.success = "No";
				success.reason = success.reason & "Please enter a valid event date.*";
			}
			if (NOT LEN(trim(formfields.startTime)) OR NOT IsTime(formfields.startTime))
			{
				success.success = "No";
				success.reason = success.reason & "Please enter a valid start time.*";
			}
			if (NOT LEN(trim(formfields.endTime)) OR NOT IsTime(formfields.endTime))
			{
				success.success = "No";
				success.reason = success.reason & "Please enter a valid end time.*";
			}
			if (LEN(trim(formfields.endDate)) AND NOT IsDate(formfields.endDate))
			{
				success.success = "No";
				success.reason = success.reason & "Please enter a valid end date.*";
			}
			if (NOT LEN(trim(formfields.location)))
			{
				success.success = "No";
				success.reason = success.reason & "Please enter the location.*";
			}
			if (NOT LEN(trim(formfields.description)))
			{
				success.success = "No";
				success.reason = success.reason & "Please enter the description.*";
			}
		</cfscript>

		<!--- Set up start date and end date --->
		<cfscript>
			startTime = convertTime24(formfields.startTime);
			endTime = convertTime24(formfields.endTime);
			startDate = ParseDateTime(formfields.startDate);
			startDate = CreateDateTime(Year(startDate),Month(startDate),Day(startDate),ListFirst(startTime,":"),ListLast(startTime,":"),0);
			if (LEN(TRIM(formfields.endDate)))
			{
				endDate = ParseDateTime(formfields.endDate);
				endDate = CreateDateTime(Year(endDate),Month(endDate),Day(endDate),ListFirst(endTime,":"),ListLast(endTime,":"),0);
			}
			else if (VAL(formfields.frequency_id) EQ 0 OR VAL(formfields.calendar_id))
			{
				endDate = startDate;
				endDate = CreateDateTime(Year(endDate),Month(endDate),Day(endDate),ListFirst(endTime,":"),ListLast(endTime,":"),0);
			}
			else
			{
				endDate = "";
			}
		</cfscript>

		<!--- Determine if doing a recurring or one-time event or one instance of a recurring event (calendar_id > 0) --->
		<cfif VAL(formfields.frequency_id) EQ 0 OR (VAL(formfields.calendar_id) AND NOT formfields.updateAll)>
		<!--- One time or single instance (single instance becomes one-time) --->
			<!--- Update --->
			<cfif VAL(formfields.calendar_id)>
				<cfquery name="qUpdate" datasource="#DSN#">
					UPDATE
						#calendarTbl#
					SET
						event_type_id = <cfqueryparam value="#formfields.event_type_id#" cfsqltype="CF_SQL_INTEGER">,
						event = <cfqueryparam value="#formfields.event#" cfsqltype="CF_SQL_VARCHAR">,
						startDate = <cfqueryparam value="#startDate#" cfsqltype="CF_SQL_TIMESTAMP">,
						endDate = <cfqueryparam value="#endDate#" cfsqltype="CF_SQL_TIMESTAMP">,
						location = <cfqueryparam value="#formfields.location#" cfsqltype="CF_SQL_VARCHAR">,
						description = <cfqueryparam value="#formfields.description#" cfsqltype="CF_SQL_VARCHAR">,
						recurring_event_id = 0,
						modified_user = <cfqueryparam value="#updating_user#" cfsqltype="CF_SQL_INTEGER">,
						modified_date = GetDate()
					WHERE
						calendar_id = <cfqueryparam value="#VAL(formfields.calendar_id)#" cfsqltype="CF_SQL_INTEGER">
				</cfquery>
			<!--- Insert --->
			<cfelse>
				<cfquery name="qInsert" datasource="#DSN#">
					INSERT INTO
						#calendarTbl#
					(
						event_type_id,
						event,
						startDate,
						endDate,
						location,
						description,
						created_user,
						modified_user
					)
					VALUES
					(
						<cfqueryparam value="#formfields.event_type_id#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#formfields.event#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#startDate#" cfsqltype="CF_SQL_TIMESTAMP">,
						<cfqueryparam value="#endDate#" cfsqltype="CF_SQL_TIMESTAMP">,
						<cfqueryparam value="#formfields.location#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#formfields.description#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#updating_user#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#updating_user#" cfsqltype="CF_SQL_INTEGER">
					)
				</cfquery>
			</cfif>
		<cfelse>
		<!--- Recurring --->
			<cfif VAL(formfields.recurring_event_id)>
			<!--- Update --->
					<cfquery name="qUpdate" datasource="#DSN#">
						UPDATE
							#calendar_recurringTbl#
						SET
							event_type_id = <cfqueryparam value="#formfields.event_type_id#" cfsqltype="CF_SQL_INTEGER">,
							frequency_id = <cfqueryparam value="#formfields.frequency_id#" cfsqltype="CF_SQL_INTEGER">,
							event = <cfqueryparam value="#formfields.event#" cfsqltype="CF_SQL_VARCHAR">,
							startDate = <cfqueryparam value="#startDate#" cfsqltype="CF_SQL_TIMESTAMP">,
							endDate = <cfqueryparam value="#endDate#" cfsqltype="CF_SQL_TIMESTAMP">,
							startTime = <cfqueryparam value="#startTime#" cfsqltype="CF_SQL_VARCHAR">,
							endTime = <cfqueryparam value="#endTime#" cfsqltype="CF_SQL_VARCHAR">,
							location = <cfqueryparam value="#formfields.location#" cfsqltype="CF_SQL_VARCHAR">,
							description = <cfqueryparam value="#formfields.description#" cfsqltype="CF_SQL_VARCHAR">,
							modified_user = <cfqueryparam value="#updating_user#" cfsqltype="CF_SQL_INTEGER">,
							modified_date = GetDate()
						WHERE
							event_id = <cfqueryparam value="#VAL(formfields.recurring_event_id)#" cfsqltype="CF_SQL_INTEGER">
					</cfquery>
			<!--- Insert --->
			<cfelse>
				<cftransaction isolation="SERIALIZABLE" action="BEGIN">
					<cfquery name="qInsert" datasource="#DSN#">
						INSERT INTO
							#calendar_recurringTbl#
						(
							event_type_id,
							frequency_id,
							event,
							startDate,
							endDate,
							startTime,
							endTime,
							location,
							description,
							created_user,
							modified_user
						)
						VALUES
						(
							<cfqueryparam value="#formfields.event_type_id#" cfsqltype="CF_SQL_INTEGER">,
							<cfqueryparam value="#formfields.frequency_id#" cfsqltype="CF_SQL_INTEGER">,
							<cfqueryparam value="#formfields.event#" cfsqltype="CF_SQL_VARCHAR">,
							<cfqueryparam value="#startDate#" cfsqltype="CF_SQL_TIMESTAMP">,
							<cfqueryparam value="#endDate#" cfsqltype="CF_SQL_TIMESTAMP" null="#IIF(LEN(TRIM(endDate)),DE("No"),DE("Yes"))#">,
							<cfqueryparam value="#startTime#" cfsqltype="CF_SQL_VARCHAR">,
							<cfqueryparam value="#endTime#" cfsqltype="CF_SQL_VARCHAR">,
							<cfqueryparam value="#formfields.location#" cfsqltype="CF_SQL_VARCHAR">,
							<cfqueryparam value="#formfields.description#" cfsqltype="CF_SQL_VARCHAR">,
							<cfqueryparam value="#updating_user#" cfsqltype="CF_SQL_INTEGER">,
							<cfqueryparam value="#updating_user#" cfsqltype="CF_SQL_INTEGER">
						)
					</cfquery>
					
					<!--- Get recurring event id --->
					<cfquery name="qID" datasource="#DSN#">
						SELECT
							MAX(event_id) AS newID
						FROM
							#calendar_recurringTbl#
						WHERE
							created_user = <cfqueryparam value="#updating_user#" cfsqltype="CF_SQL_INTEGER">
					</cfquery>

					<cfset formfields.recurring_event_id = qID.newID />
					<cfset formfields.updateAll = true />

				</cftransaction>
			</cfif>

			<!--- Populate calendar table --->
			<cfset updateRecurringEvent(dsn,calendarTbl,calendar_recurringTbl,frequencyTbl,updating_user,formfields.recurring_event_id) />
		</cfif>

		<!--- Send e-mail to users --->
		<cfif formfields.emailUsers>
			<cfset emailEvent(formfields,dsn,usersTbl,user_StatusTbl,calendarTbl,calendar_recurringTbl,event_typeTbl,frequencyTbl,preferenceTbl) />
		</cfif>

		<cfreturn success>
	</cffunction>

	<cffunction name="updateRecurringEvent" access="private" displayname="updateRecurringEvent" hint="Updates the individual instances of a recurring event" output="No" returntype="void">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="calendarTbl" required="Yes" type="string">
		<cfargument name="calendar_recurringTbl" required="Yes" type="string">
		<cfargument name="frequencyTbl" required="yes" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">
		<cfargument name="event_id" required="yes" type="numeric">

		<cfset var endDateComp = "" />
		<cfset var dateComp = "" />
		<cfset var startDate = "" />
		<cfset var endDate = "" />

		<cftransaction isolation="SERIALIZABLE">
			<!--- Get the recurring event info --->
			<cfquery name="qRecurring" datasource="#DSN#">
				SELECT
					c.event_type_id,
					c.frequency_id,
					f.part,
					c.event,
					c.startDate,
					c.endDate,
					c.startTime,
					c.endTime,
					c.location,
					c.description
				FROM
					#calendar_recurringTbl# c,
					#frequencyTbl# f
				WHERE
					f.frequency_id = c.frequency_id
					AND event_id = <cfqueryparam value="#VAL(event_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
	
			<cfset dateComp = qRecurring.startDate />
			<cfif LEN(TRIM(qRecurring.endDate))>
				<cfset endDateComp = qRecurring.endDate />
			<cfelse>
				<cfset endDateComp = DateAdd("YYYY",1,Now()) />
			</cfif>
	
			<!--- Delete any future occurrences  --->
			<cfquery name="qEventsToDelete" datasource="#DSN#">
				DELETE FROM
					#calendarTbl#
				WHERE
					recurring_event_id = <cfqueryparam value="#VAL(event_id)#" cfsqltype="CF_SQL_INTEGER">
					AND startDate > GetDate()
			</cfquery>
	
			<!--- Now loop --->
			<cfloop condition="DateCompare(dateComp,endDateComp) LTE 0">
				<cfif DateCompare(Now(),dateComp) LTE 0>
					<!--- Set up start date and end date --->
					<cfscript>
						startDate = CreateDateTime(Year(dateComp),Month(dateComp),Day(dateComp),ListFirst(qRecurring.startTime,":"),ListLast(qRecurring.startTime,":"),0);
						endDate = CreateDateTime(Year(dateComp),Month(dateComp),Day(dateComp),ListFirst(qRecurring.endTime,":"),ListLast(qRecurring.endTime,":"),0);
					</cfscript>
	
					<!--- Insert into calendar table --->
					<cfquery name="qInsert" datasource="#DSN#">
						INSERT INTO
							#calendarTbl#
						(
							event_type_id,
							recurring_event_id,
							event,
							startDate,
							endDate,
							location,
							description,
							created_user,
							modified_user
						)
						VALUES
						(
							<cfqueryparam value="#qRecurring.event_type_id#" cfsqltype="CF_SQL_INTEGER">,
							<cfqueryparam value="#VAL(event_id)#" cfsqltype="CF_SQL_INTEGER">,
							<cfqueryparam value="#qRecurring.event#" cfsqltype="CF_SQL_VARCHAR">,
							<cfqueryparam value="#startDate#" cfsqltype="CF_SQL_TIMESTAMP">,
							<cfqueryparam value="#endDate#" cfsqltype="CF_SQL_TIMESTAMP">,
							<cfqueryparam value="#qRecurring.location#" cfsqltype="CF_SQL_VARCHAR">,
							<cfqueryparam value="#qRecurring.description#" cfsqltype="CF_SQL_VARCHAR">,
							<cfqueryparam value="#updating_user#" cfsqltype="CF_SQL_INTEGER">,
							<cfqueryparam value="#updating_user#" cfsqltype="CF_SQL_INTEGER">
						)
					</cfquery>
				</cfif>
				<cfset dateComp = DateAdd(qRecurring.part,1,dateComp) />
			</cfloop>
		</cftransaction>

		<cfreturn />
	</cffunction>

	<cffunction name="isTime" access="public" displayname="Is Time" hint="Determines if the string is in the format h:mm AM/PM" output="No" returntype="boolean">
		<cfargument name="theString" required="Yes" type="string">
		<cfset var success = true>
		
		<cfscript>
		// String must be in the format "h:mm AM" or "h:mm PM". Hours must be from 1-12. Minutes must be from 0-59.

		// First, treat the string as a list with colon delimeters [size must then be 2]
			aTime = ListToArray(theString,":");
		
			if (ArrayLen(aTime) NEQ 2 OR VAL(aTime[1]) LT 1 OR VAL(aTime[1]) GT 12)
			{
				success = false;
			}
			else 
			{
				// Set up other array
				aTime2 = ListToArray(aTime[2]," ");
				if (VAL(aTime2[1]) LT 0 OR VAL(aTime2[1]) GT 59)
				{
					success = false;
				}
				else if (NOT ListFindNoCase("AM,PM",aTime2[2]))
				{
					success = false;
				}
			}
		</cfscript>

		<cfreturn success>
	</cffunction>

	<cffunction name="convertTime24" access="public" displayname="convertTime24" hint="Converts a time from AM/PM to 24 hour time." output="No" returntype="string">
		<cfargument name="theString" required="Yes" type="string">
		<cfset var convertedTime = "">
		
		<cfscript>
		// String must be in the format "h:mm AM" or "h:mm PM". Hours must be from 1-12. Minutes must be from 0-59.

		// If it's a.m., the converted time is just the passed hours and minutes
		if (ListLast(theString," ") EQ "AM" OR VAL(ListFirst(theString,":")) EQ 12)
		{
			convertedTime = ListFirst(theString,":") & ":" & ListFirst(ListLast(theString,":")," ");
		}
		// Otherwise, add 12 to the hours
		else
		{
			convertedTime = (VAL(ListFirst(theString,":")) + 12) & ":" & ListFirst(ListLast(theString,":")," ");
		}
		</cfscript>

		<cfreturn convertedTime>
	</cffunction>

	<cffunction name="getEventInfo" access="public" displayname="getEventInfo" hint="Gets info on an event" output="No" returntype="query">
		<cfargument name="calendar_id" required="Yes" type="numeric" />
		<cfargument name="recurring_event_id" required="Yes" type="numeric" />
		<cfargument name="dsn" required="Yes" type="string" />
		<cfargument name="calendarTbl" required="Yes" type="string" />
		<cfargument name="calendar_recurringTbl" required="Yes" type="string">
		<cfargument name="event_typeTbl" required="Yes" type="string">
		<cfargument name="frequencyTbl" required="Yes" type="string">

		<!--- Run query for event info --->
		<cfquery name="qData" datasource="#DSN#">
			SELECT
				c.calendar_id,
				c.recurring_event_id,
				c.event,
				c.event_type_id,
				et.event_type,
				c.startDate,
				c.endDate,
				c.location,
				c.description,
				c.created_user,
				CASE
					WHEN f.frequency_id IS NULL
				THEN
					0
				ELSE
					f.frequency_id
				END AS frequency_id,
				CASE
					WHEN f.frequency IS NULL
				THEN
					'One Time'
				ELSE
					f.frequency
				END AS frequency,
				CASE
					WHEN c.recurring_event_id = 0
				THEN
					c.endDate
				ELSE
					r.endDate
				END AS recurringEndDate
			FROM
				(
					(
						#calendarTbl# c
						INNER JOIN #event_typeTbl# et
						ON c.event_type_id = et.event_type_id
					)
					LEFT OUTER JOIN #calendar_recurringTbl# r
					ON c.recurring_event_id = r.event_id
				)
				LEFT OUTER JOIN #frequencyTbl# f
				ON r.frequency_id = f.frequency_id
			WHERE
				c.calendar_id = <cfqueryparam value="#calendar_id#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>

		<cfreturn qData>
	</cffunction>

	<cffunction name="emailEvent" access="private" displayname="emailEvent" hint="E-mails event info to users" output="No" returntype="void">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="usersTbl" required="Yes" type="string">
		<cfargument name="user_StatusTbl" required="Yes" type="string">
		<cfargument name="calendarTbl" required="Yes" type="string">
		<cfargument name="calendar_recurringTbl" required="Yes" type="string">
		<cfargument name="event_typeTbl" required="Yes" type="string">
		<cfargument name="frequencyTbl" required="yes" type="string">
		<cfargument name="preferenceTbl" required="yes" type="string">

		<!--- Get users who want e-mails --->
		<cfquery name="qUsers" datasource="#dsn#">
			SELECT
				u.preferred_name,
				u.email
			FROM
				#usersTbl# u,
				#user_statusTbl# us
			WHERE
				u.calendar_preference =
				(
					SELECT
						p.preference_id
					FROM
						#preferenceTbl# p
					WHERE
						p.preference_type = 'Calendar'
						AND p.preference = 'All Events'
				)
				AND u.email IS NOT NULL
				AND u.active_code = 1
				AND u.user_status_id = us.user_status_id
				AND lower(us.status) like '%member%'
		</cfquery>

		<!--- Get calendar info --->
		<cfquery name="qCalInfo" datasource="#DSN#">
			SELECT
				et.event_type,
				c.event,
				c.location,
				c.description,
			<cfif formfields.updateAll AND VAL(formfields.recurring_event_id)>
				c.startTime,
				c.endTime,
				f.frequency,
			<cfelse>
				c.startDate AS startTime,
				c.endDate AS endTime,
				'One Time' AS frequency,
			</cfif>
				c.startDate,
				c.endDate
			FROM
			<cfif formfields.updateAll AND VAL(formfields.recurring_event_id)>
				#frequencyTbl# f,
				#calendar_recurringTbl#
			<cfelse>
				#calendarTbl#
			</cfif> c,
				#event_typeTbl# et
			WHERE
				c.event_type_id = et.event_type_id
			<cfif formfields.updateAll AND VAL(formfields.recurring_event_id)>
				AND f.frequency_id = c.frequency_id
				AND c.event_id = <cfqueryparam value="#VAL(formfields.recurring_event_id)#" cfsqltype="CF_SQL_INTEGER">
			<cfelse>
				AND c.calendar_id = <cfqueryparam value="#VAL(formfields.calendar_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
		</cfquery>

		<!--- Set up content --->
<cfoutput>
		<cfsavecontent variable="plainContent">
{name},

A SQUID event has been updated or posted to the calendar.  The details of that event are:

Event:	#qCalInfo.event#
Type:	#qCalInfo.event_type#
Frequency:	#qCalInfo.frequency#
Start Date:	#DateFormat(qCalInfo.startdate,"m/d/yyyy")#
<cfif formfields.updateAll AND VAL(formfields.recurring_event_id)>End Date:	#DateFormat(qCalInfo.enddate,"m/d/yyyy")#</cfif>
Time:	#TimeFormat(qCalInfo.startTime,"h:mm TT")# - #TimeFormat(qCalInfo.endTime,"h:mm TT")#
Location:	#qCalInfo.location#

Description:
#qCalInfo.description#
		</cfsavecontent>
		<cfsavecontent variable="HTMLContent">
<p>{name},</p>

<p>A SQUID event has been updated or posted to the calendar.  The details of that event are:</p>

<p>
<strong>Event:</strong>	#qCalInfo.event#<br />
<strong>Type:</strong>	#qCalInfo.event_type#<br />
<strong>Frequency:</strong>	#qCalInfo.frequency#<br />
<strong>Start Date:</strong>	#DateFormat(qCalInfo.startdate,"m/d/yyyy")#<br />
<cfif formfields.updateAll AND VAL(formfields.recurring_event_id)><strong>End Date:</strong>	#DateFormat(qCalInfo.enddate,"m/d/yyyy")#<br /></cfif>
<strong>Time:</strong>	#TimeFormat(qCalInfo.startTime,"h:mm TT")# - #TimeFormat(qCalInfo.endTime,"h:mm TT")#<br />
<strong>Location:</strong> #qCalInfo.location#
</p>

<p>
<strong>Description:</strong><br />
#qCalInfo.description#
</p>
		</cfsavecontent>
</cfoutput>

		<cfloop query="qUsers">
			<cfif LEN(trim(qUsers.email))>
<cfmail from="squid@squidswimteam.org" to="#qUsers.email#" subject="<squid-event> #qCalInfo.event#" server="mail.squidswimteam.org">
<cfmailpart type="text/plain" wraptext="50">#ReplaceNoCase(plainContent,"{name}",qUsers.preferred_name,"ALL")#</cfmailpart>
<cfmailpart type="text/HTMl">#ReplaceNoCase(HTMLContent,"{name}",qUsers.preferred_name,"ALL")#</cfmailpart>
</cfmail>
			</cfif>
		</cfloop>

		<cfreturn />
	</cffunction>

	<cffunction name="deleteEvent" access="public" displayname="deleteEvent" hint="Deletes an Event" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="calendarTbl" required="Yes" type="string">
		<cfargument name="calendar_recurringTbl" required="Yes" type="string">

		<cfscript>
			var success = StructNew();
			success.success = "Yes";
			success.reason = "";
		</cfscript>		

		<!--- Determine if doing a recurring or one-time event or one instance of a recurring event (calendar_id > 0) --->
		<cfif (VAL(formfields.calendar_id) AND NOT formfields.updateAll)>
			<cfquery name="qDelete" datasource="#DSN#">
				DELETE FROM
					#calendarTbl#
				WHERE
					calendar_id = <cfqueryparam value="#VAL(formfields.calendar_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
		<cfelse>
			<cfquery name="qDelete" datasource="#DSN#">
				DELETE FROM
					#calendar_recurringTbl#
				WHERE
					event_id = <cfqueryparam value="#VAL(formfields.recurring_event_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>

			<cfquery name="qDeleteOccurrences" datasource="#DSN#">
				DELETE FROM
					#calendarTbl#
				WHERE
					recurring_event_id = <cfqueryparam value="#VAL(formfields.recurring_event_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
		</cfif>

		<cfreturn success>
	</cffunction>

	<cffunction name="getDateRangeEvents" access="public" displayname="getDateRangeEvents" hint="Gets all events in for a certain number of days" output="No" returntype="query">
		<cfargument name="dsn" required="Yes" type="string">
		<cfargument name="usersTbl" required="Yes" type="string">
		<cfargument name="calendarTbl" required="Yes" type="string">
		<cfargument name="event_typeTbl" required="Yes" type="string">
		<cfargument name="startDate" required="Yes" type="date">
		<cfargument name="endDate" required="Yes" type="date">

		<cfset var qData = "" />

		<!--- Run query for events in this month --->
		<cfquery name="qData" datasource="#DSN#">
			SELECT
				u.preferred_name + ' ' + u.last_name + '''s Birthday' AS eventString,
				'Birthday' AS event_type,
				'birthday.gif' AS icon,
				0 AS publicView,
				u.birthday AS startDate,
				u.birthday AS endDate,
				DatePart(dy,u.birthday) AS sortDate,
				0 AS calendar_id,
				0 as recurring_event_id,
				0 AS created_user
			FROM
				#usersTbl# u
			WHERE
				MONTH(u.birthday) >= <cfqueryparam value="#Month(startDate)#" cfsqltype="CF_SQL_INTEGER" /> 
				AND DAY(u.birthday) >= <cfqueryparam value="#Day(startDate)#" cfsqltype="CF_SQL_INTEGER" /> 
				AND MONTH(u.birthday) <= <cfqueryparam value="#Month(endDate)#" cfsqltype="CF_SQL_INTEGER" />
				AND DAY(u.birthday) <= <cfqueryparam value="#Day(endDate)#" cfsqltype="CF_SQL_INTEGER" />
				AND u.active_code = 1
			UNION
			SELECT
				c.event + ' (' +
				CASE 
					WHEN DatePart(hh,c.startDate) > 12 THEN CAST((DatePart(hh,c.startDate)-12) AS varchar(2))
				ELSE
					CAST(DatePart(hh,c.startDate) AS varchar(2))
				END
				+ ':' + 
				CASE
					WHEN Datepart(mi,c.startdate) < 10 THEN '0'
				ELSE
					''
				END
				+ CAST(DatePart(mi,c.startDate) AS varchar(2)) + ' ' +
				CASE
					WHEN DatePart(hh,c.startDate) >= 12 THEN 'PM'
				ELSE
					'AM'
				END
				+ ' - ' + 
				CASE 
					WHEN DatePart(hh,c.endDate) > 12 THEN CAST((DatePart(hh,c.endDate)-12) AS varchar(2))
				ELSE
					CAST(DatePart(hh,c.endDate) AS varchar(2))
				END
				+ ':' + 
				CASE
					WHEN Datepart(mi,c.enddate) < 10 THEN '0'
				ELSE
					''
				END
				+ CAST(DatePart(mi,c.endDate) AS varchar(2)) + ' ' +
				CASE
					WHEN DatePart(hh,c.endDate) >= 12 THEN 'PM'
				ELSE
					'AM'
				END
				+ ')'
				AS eventString,
				et.event_type,
				et.icon,
				1 AS publicView,
				c.startDate AS startDate,
				c.endDate AS endDate,
				DatePart(dy,c.startdate) AS sortDate,
				c.calendar_id,
				c.recurring_event_id,
				c.created_user
			FROM
				#calendarTbl# c,
				#event_typeTbl# et
			WHERE
				c.event_type_id = et.event_type_id
				AND DATEDIFF(day,c.startDate,<cfqueryparam value="#startDate#" cfsqltype="CF_SQL_TIMESTAMP" />) <= 0
				AND DATEDIFF(day,c.startDate,<cfqueryparam value="#endDate#" cfsqltype="CF_SQL_TIMESTAMP" />) >= 0
				AND c.active_code = 1
			ORDER BY
				sortDate
		</cfquery>

		<cfreturn qData />
	</cffunction>

</cfcomponent>