<!--- 
<fusedoc 
	fuse="dsp_results.cfm" language="ColdFusion" specification="3.0">
	<responsibilities>
		I display the meet results.
	</responsibilities>	
	<properties>
		<history author="Scott Brady" date="28 July 2004" type="Create" role="Architect">
	</properties>
	<io>
		<in>
			<structure name="XFA">
				<string name="splits" />
			</structure>

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">
	<cfparam name="attributes.team_no" default=0 type="numeric">
	<cfparam name="attributes.event_no" default=0 type="numeric">
	<cfparam name="attributes.ath_no" default=0 type="numeric">

	<cfset qRaces = Request.lookup_cfc.getRaces(Request.DSN,Request.eventTbl,Request.strokeTbl) />
	<cfset qTeams = Request.lookup_cfc.getTeams(Request.DSN,Request.teamTbl) />
	<cfset qAthletes = Request.lookup_cfc.getAthletes(Request.DSN,Request.athleteTbl,Request.teamTbl) />

	<!--- Get results --->
	<cfset qResults = Request.lookup_cfc.getResults(Request.DSN,Request.eventTbl,Request.strokeTbl,Request.entryTbl,Request.athleteTbl,Request.teamTbl,Request.MultiageTbl,attributes.ath_no,attributes.team_no,attributes.event_no) />
	<cfset qRelays = Request.lookup_cfc.getRelayResults(Request.DSN,Request.eventTbl,Request.strokeTbl,Request.athleteTbl,Request.teamTbl,Request.RelayTbl,Request.RelayNamesTbl,attributes.ath_no,attributes.team_no,attributes.event_no) />
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
<table border="0" cellpadding="0" cellspacing="0" align="center">
<cfoutput>
 	<thead>
		<tr>
			<td class="header1">
				#Request.page_title#
			</td>
		</tr>
		<tr>
			<td>
				&nbsp;
			</td>
		</tr>
		<tr>
			<td>
				Use the menus below to narrow down the results you wich to see.
			</td>
		</tr>
		<tr>
			<td>
				&nbsp;
			</td>
		</tr>
		<tr>
			<td>
			<form name="inputForm" action="#variables.baseHREF##Request.self#/fuseaction/#attributes.fuseaction#.cfm" method="get">
				<table>
					<tr>
						<td>
							Team:
						</td>
						<td>
							<select name="team_no" size="1">
								<option value="0" <cfif attributes.team_no EQ 0>selected="selected"</cfif>>(All Teams)</option>
							<cfloop query="qTeams">
								<option value="#qTeams.team_no#" <cfif attributes.team_no EQ qTeams.team_no>selected="selected"</cfif>>#qTeams.team_name# (#qTeams.team_abbr#)</option>
							</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td>
							Swimmer:
						</td>
						<td>
							<select name="ath_no" size="1">
								<option value="0" <cfif attributes.ath_no EQ 0>selected="selected"</cfif>>(All Swimmers)</option>
							<cfloop query="qAthletes">
								<option value="#qAthletes.ath_no#" <cfif attributes.ath_no EQ qAthletes.ath_no>selected="selected"</cfif>>#qAthletes.first_name# #qAthletes.last_name# (#qAthletes.team_abbr#)</option>
							</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td>
							Event:
						</td>
						<td>
							<select name="event_no" size="1">
								<option value="0" <cfif attributes.event_no EQ 0>selected="selected"</cfif>>(All Events)</option>
							<cfloop query="qRaces">
								<option value="#qRaces.event_no#" <cfif attributes.event_no EQ qRaces.event_no>selected="selected"</cfif>>#qRaces.eventDescription#</option>
							</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<input type="submit" name="submitBtn" value="Filter Results" class="buttonStyle" />
						</td>
					</tr>
				</table>
			</form>
			</td>
		</tr>
	</thead>
</cfoutput>
	<tbody>
		<tr valign="top">
			<td>
	<cfif qResults.RecordCount OR qRelays.RecordCount>
				<p>
					Click on a result time to view the split times for that swimmer.
				</p>
		<cfif qResults.RecordCount>
				<p class="header1">
					INDIVIDUAL EVENTS
				</p>
			<cfoutput query="qResults" group="event_ptr">
				<span style="font-weight:bold;">#qResults.event_ptr#) #qResults.eventDescription#</span>
				<table width="100%" border="1" bordercolor="##cccccc" cellpadding="3" cellspacing="0">
					<thead>
						<tr valign="bottom" class="tblHdr">
							<td>
								Swimmer
							</td>
							<td>
								Team
							</td>
							<td align="center">
								Seed<br />
								(mm:ss.00)
							</td>
							<td align="center">
								Result<br />
								(mm:ss.00)
							</td>
							<td align="center">
								Place
							</td>
						</tr>
					</thead>
					<tbody>
					<cfset thisRow = 0>
					<cfoutput>
						<cfif thisRow EQ 1>
							<cfset thisRow = 0>
						<cfelse>
							<cfset thisRow = 1>
						</cfif>
						<tr valign="middle" class="tableBG#thisRow#">
							<td>
								#qResults.first_name#
								#qResults.last_name#
								(#qResults.ath_sex##qResults.ath_age#)
							</td>
							<td>
								#qResults.team_abbr#
							</td>
							<td align="center">
								#Request.registration_cfc.convertSeed2minutes(qResults.convSeed_time)#
							</td>
							<td align="center">
							<cfif qResults.event_dist GT 50 AND qResults.result NEQ "SCR" AND qResults.result NEQ "DQ">
								<a href="#Request.self#/fuseaction/#XFA.splits#/ath_no/#qResults.ath_no#/event_no/#qResults.event_no#/returnTeam/#attributes.team_no#/returnAth/#attributes.ath_no#/returnEvent/#attributes.event_no#.cfm">
							</cfif>
								#Request.registration_cfc.convertSeed2minutes(qResults.result)#
							<cfif qResults.event_dist GT 50 AND qResults.result NEQ "SCR" AND qResults.result NEQ "DQ">
								</a>
							</cfif>
							</td>
							<td align="center">
								#qResults.place#
							</td>
						</tr>
					</cfoutput>
					</tbody>
				</table>
				<br />
				<br />
			</cfoutput>
		</cfif>
		<cfif qRelays.RecordCount>
			<cfoutput query="qRelays" group="event_ptr">
				<p class="header1">
					RELAYS
				</p>
				<span style="font-weight:bold;">#qRelays.event_ptr#) #qRelays.eventDescription#</span>
				<table width="100%" border="1" bordercolor="##cccccc" cellpadding="3" cellspacing="0">
					<thead>
						<tr valign="bottom" class="tblHdr">
							<td>
								Team
							</td>
							<td>
								Swimmers
							</td>
							<td align="center">
								Age
							</td>
							<td align="center">
								Result<br />
								(mm:ss.00)
							</td>
							<td align="center">
								Place
							</td>
						</tr>
					</thead>
					<tbody>
					<cfset thisRow = 0>
					<cfoutput group="relay_no">
						<cfif thisRow EQ 1>
							<cfset thisRow = 0>
						<cfelse>
							<cfset thisRow = 1>
						</cfif>
						<tr valign="top" class="tableBG#thisRow#">
							<td>
								#qRelays.team_abbr# (#qRelays.team_ltr#)
							</td>
							<td>
							<cfoutput>
								#qRelays.first_name#
								#qRelays.last_name#
								(#qRelays.ath_sex##qRelays.ath_age#)
								<br />
							</cfoutput>
							</td>
							<td align="center">
								#qRelays.rel_age#
							</td>
							<td align="center">
							<cfif qRelays.result NEQ "SCR" AND qRelays.result NEQ "DQ">
								<a href="#Request.self#/fuseaction/#XFA.splits#/relay_no/#qRelays.relay_no#/returnTeam/#attributes.team_no#/returnAth/#attributes.ath_no#/returnEvent/#attributes.event_no#.cfm">
							</cfif>
								#Request.registration_cfc.convertSeed2minutes(qRelays.result)#
							<cfif qRelays.result NEQ "SCR" AND qRelays.result NEQ "DQ">
								</a>
							</cfif>
							</td>
							<td align="center">
								#qRelays.place#
							</td>
						</tr>
					</cfoutput>
					</tbody>
				</table>
				<br />
				<br />
			</cfoutput>
		</cfif>
	<cfelse>
				No results were returned for your criteria.
	</cfif>
			</td>
		</tr>
	</tbody>
</table>
