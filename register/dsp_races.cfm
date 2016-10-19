<!---
<fusedoc
	fuse="dsp_races.cfm" language="ColdFusion" specification="3.0">
	<responsibilities>
		I display the meet events regstration page.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="5 April 2004" type="Create" role="Architect">
	</properties>
	<io>
		<in>
			<structure name="XFA">
				<string name="next" />
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
	<cfparam name="attributes.usms" default="" type="string">
	<cfparam name="attributes.team_no" default=0 type="numeric">
	<cfparam name="attributes.team_name" default="" type="string">
	<cfparam name="attributes.team_short" default="" type="string">
	<cfparam name="attributes.team_abbr" default="" type="string">
	<cfloop query="qRaces">
		<cfparam name="attributes[""event_"" & qRaces.event_ptr]" default="0" type="boolean">
		<cfparam name="attributes[""seed_"" & qRaces.event_ptr]" default="" type="string">
	</cfloop>
	<cfparam name="Session.goldrush2009.aRaces" default="#ArrayNew(1)#" type="array">
	<cfparam name="Session.goldrush2009.usms" default="" type="string">
	<cfparam name="Session.goldrush2009.team_no" default="0" type="numeric">

	<!--- If exists, populate data --->
	<cfif (attributes.success IS NOT "No")>
		<cfscript>
			attributes.usms = Session.goldrush2009.usms;
			attributes.team_no = Session.goldrush2009.team_no;
		</cfscript>
		<cfloop from="1" to="#ArrayLen(Session.goldrush2009.aRaces)#" index="i">
			<cfscript>
				attributes["event_" & VAL(Session.goldrush2009.aRaces[i].event_ptr)] = 1;
				attributes["seed_" & VAL(Session.goldrush2009.aRaces[i].event_ptr)] = Session.goldrush2009.aRaces[i].seedTime;
			</cfscript>
		</cfloop>
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
<form name="inputForm" action="#variables.baseHREF##Request.self#/fuseaction/#XFA.next#.cfm" method="post" onsubmit="return validate(this);">
<table border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td class="header1" colspan="2">
				#Request.page_title#
			</td>
		</tr>
		<tr>
			<td colspan="2">
				&nbsp;
			</td>
		</tr>
		<tr>
			<td colspan="2">
				The SQUID Long-Course challenge is sanctioned by COMSA for USMS, Inc.
				<br />Sanction## #Request.sanctioning#
			</td>
		</tr>
		<tr>
			<td colspan="2">
				&nbsp;
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<a href="#Request.self#/fuseaction/#XFA.registration_menu#.cfm">Registration Menu</a>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td colspan="2">
				&nbsp;
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>USMS No.<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<input type="text" name="usms" size="10" maxlength="15" tabindex="#variables.tabindex#" value="#attributes.usms#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Team<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<select name="team_no" tabindex="#variables.tabindex#" onchange="return changeTeam(this.form);">
					<option value="0" <cfif attributes.team_no EQ 0>selected="selected"</cfif>>(Select a team)</option>
				<cfloop query="qTeams">
					<option value="#qTeams.team_no#" <cfif attributes.team_no EQ qTeams.team_no>selected="selected"</cfif>>#qTeams.team_name#</option>
				</cfloop>
					<option value="-1" <cfif attributes.team_no EQ -1>selected="selected"</cfif>>Not Listed (Enter information below)</option>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				If your team is not listed, please enter your team information below.
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>New Team Name:</strong>
			</td>
			<td>
				<input type="text" name="team_name" size="20" maxlength="30" tabindex="#variables.tabindex#" value="#attributes.team_name#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>New Team Name (Shortened):</strong>
			</td>
			<td>
				<input type="text" name="team_short" size="16" maxlength="16" tabindex="#variables.tabindex#" value="#attributes.team_short#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>New Team Abbreviation:</strong>
			</td>
			<td>
				<input type="text" name="team_abbr" size="5" maxlength="5" tabindex="#variables.tabindex#" value="#attributes.team_abbr#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
</cfoutput>
		<tr valign="top">
			<td colspan="2">
				Select up to 4 individual events and enter your seed time for each event.
				NOTE: Your time should be for a 25-yard Short-Course Pool.
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2">
				<table width="100%" border="1" bordercolor="#cccccc" cellpadding="3" cellspacing="0">
					<thead>
						<tr valign="bottom" class="tblHdr">
							<td>
								&nbsp;
							</td>
							<td align="center">
								#
							</td>
							<td>
								Event
							</td>
							<td align="center">
								Seed Time<br />
								(min:sec.00)
							</td>
						</tr>
					</thead>
					<tbody>
					<cfoutput query="qRaces">
						<cfif qRaces.CurrentRow MOD 2 EQ 1>
							<cfset rowClass = "tableBG1">
						<cfelse>
							<cfset rowClass = "tableBG0">
						</cfif>
						<tr valign="middle" class="#variables.rowClass#">
							<td align="center">
							<cfif qRaces.ind_rel IS "I">
								<input type="checkbox" name="event_#qRaces.event_ptr#" value="1" tabindex="#variables.tabindex#" <cfif attributes["event_" & qRaces.event_ptr]>checked="checked"</cfif> />
								<cfset variables.tabindex = variables.tabindex + 1>
							<cfelse>
								&nbsp;
							</cfif>
							</td>
							<td align="center">
								#qRaces.event_ptr#
							</td>
							<td>
								#qRaces.eventDescription#
							</td>
							<td align="center">
							<cfif qRaces.ind_rel IS "I">
								<input type="text" name="seed_#qRaces.event_ptr#" size="8" maxlength="8" tabindex="#variables.tabindex#" value="#attributes["seed_" & qRaces.event_ptr]#" />
								<cfset variables.tabindex = variables.tabindex + 1>
							<cfelse>
								&nbsp;
							</cfif>
							</td>
						</tr>
					</cfoutput>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
<cfoutput>
		<tr valign="top">
			<td align="center" colspan="2">
				<input type="submit" name="submitBtn" value="Save Changes" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>
