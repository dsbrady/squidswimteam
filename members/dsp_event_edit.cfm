<!---
<fusedoc
	fuse = "dsp_event_edit.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the event edit form.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="23 October 2004" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
				<string name="events" />
			</structure>
			
			<number name="eventID" scope="attributes" />
			<number name="distanceID" scope="attributes" />
			<number name="strokeID" scope="attributes" />
			<number name="distanceTypeID" scope="attributes" />
			<number name="unitID" scope="attributes" />
			<string name="seedTime" scope="attributes" />
			<string name="eventDate" scope="attributes" />
			<string name="eventLocation" scope="attributes" />

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
			<number name="eventID" scope="formOrUrl" />
			<number name="distanceID" scope="formOrUrl" />
			<number name="strokeID" scope="formOrUrl" />
			<number name="distanceTypeID" scope="formOrUrl" />
			<number name="unitID" scope="formOrUrl" />
			<string name="seedTime" scope="formOrUrl" />
			<string name="eventDate" scope="formOrUrl" />
			<string name="eventLocation" scope="formOrUrl" />
		</out>
	</io>

</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.eventID" default="0" type="numeric" />
	<cfparam name="attributes.distanceID" default="0" type="numeric" />
	<cfparam name="attributes.strokeID" default="0" type="numeric" />
	<cfparam name="attributes.distanceTypeID" default="0" type="numeric" />
	<cfparam name="attributes.unitID" default="0" type="numeric" />
	<cfparam name="attributes.seedtime" default="" type="string" />
	<cfparam name="attributes.eventDate" default="" type="string" />
	<cfparam name="attributes.eventLocation" default="" type="string" />
	
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<cfif VAL(attributes.eventID)>
		<cfscript>
			if (attributes.success IS NOT "No")
			{
				attributes.eventID = qEvent.eventID;
				attributes.distanceID = qEvent.distanceID;
				attributes.strokeID = qEvent.strokeID;
				attributes.distanceTypeID = qEvent.distanceTypeID;
				attributes.unitID = qEvent.unitID;
				attributes.seedTime = memberCFC.convertSeed2minutes(qEvent.seedTime);
				attributes.eventDate = DateFormat(qEvent.eventDate,"mm/dd/yyyy");
				attributes.eventLocation = qEvent.eventLocation;
			}
		</cfscript>
	</cfif>

	<cfset attributes.eventDate = Replace(attributes.eventDate,"-","/","ALL") />

	<cfset variables.tabindex = 1 />
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
<form name="inputForm" action="#variables.baseHREF##Request.self#/fuseaction/#XFA.next#.cfm" method="post" onsubmit="return validate(this);">
	<input type="hidden" name="eventID" value="#attributes.eventID#" />
<table width="550" border="0" cellpadding="0" cellspacing="0" align="center">
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
				<a href="#Request.self#/fuseaction/#XFA.menu#.cfm">Menu</a>
				> <a href="#Request.self#/fuseaction/#XFA.times#.cfm">Events/Times</a>
				> <cfif VAL(attributes.eventID)>Update<cfelse>Add</cfif> Event
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
				<select name="distanceID" tabindex="#variables.tabindex#">
				<cfloop query="qDistances">
					<option value="#qDistances.distanceID#" <cfif attributes.distanceID EQ qDistances.distanceID>selected="selected"</cfif>>#qDistances.distance#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>

				<select name="unitID" tabindex="#variables.tabindex#">
				<cfloop query="qUnits">
					<option value="#qUnits.unitID#" <cfif attributes.unitID EQ qUnits.unitID>selected="selected"</cfif>>#qUnits.abbrv#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>

				<select name="strokeID" tabindex="#variables.tabindex#">
				<cfloop query="qStrokes">
					<option value="#qStrokes.strokeID#" <cfif attributes.strokeID EQ qStrokes.strokeID>selected="selected"</cfif>>#qStrokes.stroke#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>

				<select name="distanceTypeID" tabindex="#variables.tabindex#">
				<cfloop query="qDistanceTypes">
					<option value="#qDistanceTypes.distanceTypeID#" <cfif attributes.distanceTypeID EQ qDistanceTypes.distanceTypeID>selected="selected"</cfif>>#qDistanceTypes.abbrv#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Time:</strong>
				<br />(min:sec.00)
			</td>
			<td>
				<input type="text" name="seedTime" size="8" maxlength="10" tabindex="#variables.tabindex#" value="#attributes.seedTime#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Date:</strong>
			</td>
			<td>
				<input type="text" name="eventDate" size="10" maxlength="10" tabindex="#variables.tabindex#" value="#attributes.eventDate#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Location/Meet:</strong>
			</td>
			<td>
				<input type="text" name="eventLocation" size="15" maxlength="50" tabindex="#variables.tabindex#" value="#attributes.eventLocation#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="submitBtn" value="Save" class="buttonStyle" tabindex="#variables.tabindex#" />
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

