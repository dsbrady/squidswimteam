<!---
<fusedoc
	fuse = "dsp_times"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the events/times.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="18 October 2004" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="edit" />
			</structure>
		</in>
		<out>
			<number name="eventID" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">
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
<table width="725" border="0" cellpadding="0" cellspacing="0" align="center">
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
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center">
				<a href="#Request.self#/fuseaction/#XFA.edit#.cfm">Add Event</a>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
				Show
				<form name="filterForm" action="#variables.baseHREF##Request.self#/fuseaction/#attributes.fuseaction#.cfm" method="get" style="display:inline">
					<select name="distanceID">
						<option value="0" <cfif attributes.distanceID EQ 0>selected="true"</cfif>>(All Distances)</option>
					<cfloop query="qDistances">
						<option value="#qDistances.distanceID#" <cfif attributes.distanceID EQ qDistances.distanceID>selected="true"</cfif>>#qDistances.distance#</option>
					</cfloop>
					</select>

					<select name="unitID">
						<option value="0" <cfif attributes.unitID EQ 0>selected="true"</cfif>>(All Units)</option>
					<cfloop query="qUnits">
						<option value="#qUnits.unitID#" <cfif attributes.unitID EQ qUnits.unitID>selected="true"</cfif>>#qUnits.abbrv#</option>
					</cfloop>
					</select>

					<select name="strokeID">
						<option value="0" <cfif attributes.strokeID EQ 0>selected="true"</cfif>>(All Strokes)</option>
					<cfloop query="qStrokes">
						<option value="#qStrokes.strokeID#" <cfif attributes.strokeID EQ qStrokes.strokeID>selected="true"</cfif>>#qStrokes.stroke#</option>
					</cfloop>
					</select>

					<select name="distanceTypeID">
						<option value="0" <cfif attributes.distanceTypeID EQ 0>selected="true"</cfif>>(All Types)</option>
					<cfloop query="qDistanceTypes">
						<option value="#qDistanceTypes.distanceTypeID#" <cfif attributes.distanceTypeID EQ qDistanceTypes.distanceTypeID>selected="true"</cfif>>#qDistanceTypes.abbrv#</option>
					</cfloop>
					</select>

					From:
					<input type="text" name="startDate" size="10" maxlength="10" value="#attributes.startDate#" />
					To:
					<input type="text" name="endDate" size="10" maxlength="10" value="#attributes.endDate#" />

					<input type="submit" name="submitBtn" value="Go" />
				</form>
			</td>
		</tr>
		<tr>
			<td>
			<cfif qEvents.RecordCount>
				<table cellspacing="0" cellpadding="3" align="center" class="tableClass" width="100%">
					<thead>
						<tr class="tableHead">
							<td>
								<strong>Event</strong>
							</td>
							<td>
								<strong>Date</strong>
							</td>
							<td>
								<strong>Location</strong>
							</td>
							<td>
								<strong>Time</strong>
							</td>
							<td>
								&nbsp;
							</td>
						</tr>
					</thead>
					<tbody>
					<cfloop query="qEvents">
						<cfscript>
							variables.rowClass = qEvents.currentRow MOD 2;
						</cfscript>
						<tr class="tableRow#variables.rowClass#">
							<td>
								#qEvents.distance# #qEvents.unit# #qEvents.typeAbbrv# #qEvents.stroke#
							</td>
							<td>
								#DateFormat(qEvents.eventDate,"m/d/yyyy")#
							</td>
							<td>
								#qEvents.eventLocation#
							</td>
							<td>
								#memberCFC.convertSeed2minutes(qEvents.seedTime)#
							</td>
							<td>
								<a href="#Request.self#/fuseaction/#XFA.edit#/eventID/#qEvents.eventID#.cfm">Edit</a>
							</td>
						</tr>
					</cfloop>
					</tbody>
				</table>
			<cfelse>
				You currently have no event times listed.
			</cfif>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>

