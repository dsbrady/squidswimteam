<!---
<fusedoc
	fuse = "dsp_post_event.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the event submission form.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="2 January 2004" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
			</structure>
			
			<number name="officer_type_id" scope="attributes" />
			<string name="user_id" scope="attributes" />

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
			<number name="officer_type_id" scope="formOrUrl" />
			<string name="user_id" scope="formOrUrl" />
		</out>
	</io>

</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.calendar_id" default="0" type="numeric">
	<cfparam name="attributes.recurring_event_id" default="0" type="numeric">
	<cfparam name="attributes.event_type_id" default="1" type="numeric">
	<cfparam name="attributes.theMonth" default="#Month(Now())#" type="string">
	<cfparam name="attributes.theYear" default="#Year(Now())#" type="string">
	<cfparam name="attributes.frequency_id" default="0" type="numeric">
	<cfparam name="attributes.startDate" default="#DateFormat(Now(),"m/d/yyyy")#" type="string">
	<cfparam name="attributes.startTime" default="#TimeFormat(Now(),"h:mm TT")#" type="string">
	<cfparam name="attributes.endTime" default="" type="string">
	<cfparam name="attributes.endDate" default="" type="string">
	<cfparam name="attributes.recurringEndDate" default="" type="string">
	<cfparam name="attributes.event" default="" type="string">
	<cfparam name="attributes.location" default="" type="string">
	<cfparam name="attributes.description" default="" type="string">
	<cfparam name="attributes.emailUsers" default="false" type="boolean">
	<cfparam name="attributes.updateAll" default="false" type="boolean">

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get frequencies --->
	<cfinvoke  
		component="#Request.lookup_cfc#" 
		method="getFreq"
		returnvariable="qryFreq"
		dsn=#Request.DSN#
		frequencyTbl=#Request.frequencyTbl#
	>

	<!--- Get types --->
	<cfinvoke  
		component="#Request.lookup_cfc#" 
		method="getEventTypes"
		returnvariable="qryTypes"
		dsn=#Request.DSN#
		event_typeTbl=#Request.event_typeTbl#
	>

	<cfif VAL(attributes.calendar_id) GT 0>
		<cfset attributes.recurring_event_id = qEvent.recurring_event_id />
		<cfif (attributes.success IS NOT "No")>
			<cfscript>
				attributes.frequency_id = VAL(qEvent.frequency_id);
				attributes.event_type_id = qEvent.event_type_id;
				attributes.startDate = DateFormat(qEvent.startDate,"m/d/yyyy");
				attributes.startTime = TimeFormat(qEvent.startDate,"h:mm TT");
				attributes.endTime = TimeFormat(qEvent.endDate,"h:mm TT");
				attributes.endDate = DateFormat(qEvent.endDate,"m/d/yyyy");
				attributes.recurringEndDate = DateFormat(qEvent.recurringEndDate,"m/d/yyyy");
				attributes.location = qEvent.location;
				attributes.description = qEvent.description;
				attributes.event = qEvent.event;
			</cfscript>
		</cfif>
	</cfif>

	<cfset attributes.startDate = Replace(attributes.startDate,"-","/","ALL")>	
	<cfset attributes.endDate = Replace(attributes.endDate,"-","/","ALL")>	

	<cfif NOT VAL(attributes.calendar_id) OR (VAL(attributes.calendar_id) AND (Secure("Calendar Admin") OR Request.squid.user_id EQ qEvent.created_user))>
		<cfset editable = true />
	<cfelse>
		<cfset editable = false />
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
<form name="eventForm" action="#variables.baseHREF##Request.self#/fuseaction/#XFA.next#.cfm" method="post" onsubmit="return validate(this);">
	<input type="hidden" name="calendar_id" value="#attributes.calendar_id#" />
	<input type="hidden" name="recurring_event_id" value="#attributes.recurring_event_id#" />
	<input type="hidden" name="theMonth" value="#attributes.theMonth#" />
	<input type="hidden" name="theYear" value="#attributes.theYear#" />
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
			<td align="center" colspan="2">
				<a href="#Request.self#/fuseaction/#XFA.calendar#/theMonth/#attributes.theMonth#/theYear/#attributes.theYear#.cfm">Calendar</a>
				> <cfif NOT variables.editable>Event Details<cfelseif (VAL(attributes.calendar_id) GT 0)>Update Event<cfelse>Submit Event</cfif>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Event:</strong>
			</td>
			<td>
			<cfif variables.editable>
				<input type="text" name="event" size="25" maxlength="50" value="#attributes.event#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.event#
			</cfif>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Frequency:</strong>
			</td>
			<td>
			<cfif variables.editable>
				<select name="frequency_id" tabindex="#variables.tabindex#" size="1">
				<cfif VAL(attributes.recurring_event_id) EQ 0>
					<option value="0" <cfif VAL(attributes.frequency_id) EQ 0>selected="selected"</cfif>>One Time</option>
				</cfif>
				<cfloop query="qryFreq">
					<option value="#qryFreq.frequency_id#" <cfif VAL(attributes.frequency_id) EQ qryFreq.frequency_id>selected="selected"</cfif>>#qryFreq.frequency#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#qEvent.frequency#
			</cfif>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Type:</strong>
			</td>
			<td>
			<cfif variables.editable>
				<select name="event_type_id" tabindex="#variables.tabindex#" size="1">
				<cfloop query="qryTypes">
					<option value="#qryTypes.event_type_id#" <cfif VAL(attributes.event_type_id) EQ qryTypes.event_type_id>selected="selected"</cfif>>#qryTypes.event_type#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#qEvent.event_type#
			</cfif>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Event Date:</strong>
			</td>
			<td>
			<cfif variables.editable AND NOT VAL(attributes.recurring_event_id)>
				<input type="text" name="startDate" size="10" maxlength="10" value="#attributes.startDate#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.startDate#
				<input type="hidden" name="startDate" value="#attributes.startDate#" />
			</cfif>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Start Time:</strong>
			</td>
			<td>
			<cfif variables.editable>
				<input type="text" name="startTime" size="8" maxlength="10" value="#attributes.startTime#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.startTime#
			</cfif>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>End Time:</strong>
			</td>
			<td>
			<cfif variables.editable>
				<input type="text" name="endTime" size="8" maxlength="10" value="#attributes.endTime#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.endTime#
			</cfif>
			</td>
		</tr>
		<tr valign="top">
			<td>
				End Date:
			</td>
			<td>
			<cfif variables.editable AND NOT VAL(attributes.recurring_event_id)>
				<input type="text" name="endDate" size="10" maxlength="10" value="#attributes.endDate#" tabindex="#variables.tabindex#" />
				(recurring events only)
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.recurringEndDate#
				<input type="hidden" name="endDate" value="#attributes.recurringEndDate#" />
			</cfif>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Location:</strong>
			</td>
			<td>
			<cfif variables.editable>
				<input type="text" name="location" size="25" maxlength="50" value="#attributes.location#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.location#
			</cfif>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Description:</strong>
			</td>
			<td>
			<cfif variables.editable>
				<textarea name="description" rows="4" cols="40" tabindex="#variables.tabindex#">#attributes.description#</textarea>
				<cfset variables.tabindex = variables.tabindex + 1>
			<cfelse>
				#attributes.description#
			</cfif>
			</td>
		</tr>
	<cfif variables.editable AND VAL(attributes.calendar_id) GT 0 AND VAL(attributes.frequency_id) GT 0>
		<tr valign="top">
			<td>
				&nbsp;
			</td>
			<td>
				<input type="checkbox" name="updateAll" value="true" tabindex="#variables.tabindex#" <cfif attributes.updateAll>checked="checked"</cfif> />
				Apply changes to all occurrences of this event
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	</cfif>
	<cfif variables.editable AND request.squid.user_id EQ 1>
		<tr valign="top">
			<td>
				&nbsp;
			</td>
			<td>
				<input type="checkbox" name="emailUsers" value="true" tabindex="#variables.tabindex#" <cfif attributes.emailUsers>checked="checked"</cfif> />
				E-mail users about this event
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	</cfif>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
		<cfif variables.editable>
				<input type="submit" name="submitBtn" value="Save" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
			<cfif VAL(attributes.calendar_id)>
				<input type="submit" name="submitBtn" value="Delete" class="buttonStyle" tabindex="#variables.tabindex#" onclick="return deleteEvent(this.form);" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
			</cfif>
				<input type="reset" name="resetBtn" value="Reset Values" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
		<cfelse>
				&nbsp;
		</cfif>
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

