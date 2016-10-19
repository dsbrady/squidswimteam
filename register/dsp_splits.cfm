<!--- 
<fusedoc 
	fuse="dsp_splits.cfm" language="ColdFusion" specification="3.0">
	<responsibilities>
		I display the meet result split times for an event/swimmer.
	</responsibilities>	
	<properties>
		<history author="Scott Brady" date="30 July 2004" type="Create" role="Architect">
	</properties>
	<io>
		<in>
			<structure name="XFA">
				<string name="results" />
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
	<cfparam name="attributes.returnTeam" default=0 type="numeric">
	<cfparam name="attributes.returnEvent" default=0 type="numeric">
	<cfparam name="attributes.returnAth" default=0 type="numeric">
	<cfparam name="attributes.event_no" default=0 type="numeric">
	<cfparam name="attributes.ath_no" default=0 type="numeric">
	<cfparam name="attributes.relay_no" default=0 type="numeric">

	<!--- Get splits --->
	<cfif VAL(attributes.ath_no)>
		<cfset qSplits = Request.lookup_cfc.getIndSplits(Request.DSN,Request.eventTbl,Request.strokeTbl,Request.athleteTbl,Request.entryTbl,Request.splitTbl,attributes.ath_no,attributes.event_no) />
	<cfelse>
		<cfset qSplits = Request.lookup_cfc.getRelaySplits(Request.DSN,Request.eventTbl,Request.strokeTbl,Request.teamTbl,Request.RelayTbl,Request.splitTbl,attributes.relay_no) />
	</cfif>
</cfsilent>

<!--- 
<cfdump var="#qSplits#">
<cfabort>
 --->
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
	</thead>
</cfoutput>
	<tbody>
		<tr valign="top">
			<td>
	<cfif qSplits.RecordCount>
			<cfoutput>
				<p class="header1">
					#qSplits.eventDescription# - 
				<cfif VAL(attributes.ath_no)>
					#qSplits.first_name# #qSplits.last_name#
				<cfelse>
					#qSplits.team_abbr# #qSplits.team_ltr#
				</cfif>
				</p>
				<p align="center">
					<a href="#Request.self#/fuseaction/#XFA.results#/ath_no/#attributes.returnAth#/team_no/#attributes.returnTeam#/event_no/#attributes.returnEvent#.cfm">Back</a>
				</p>
			</cfoutput>
				<table width="300" border="1" bordercolor="##cccccc" cellpadding="3" cellspacing="0" align="center">
					<thead>
						<tr valign="bottom" class="tblHdr">
							<td align="center">
								#
							</td>
							<td align="center">
								Split<br />
								(mm:ss.00)
							</td>
						</tr>
					</thead>
					<tbody>
					<cfoutput query="qSplits">
						<tr valign="middle" class="tableBG1">
							<td align="center">
								#qSplits.split_no#
							</td>
							<td align="center">
								#Request.registration_cfc.convertSeed2minutes(qSplits.split_time)#
							</td>
						</tr>
					</cfoutput>
					<cfoutput>
						<tr valign="middle" class="tableBG0">
							<td align="center">
								Final
							</td>
							<td align="center">
								#Request.registration_cfc.convertSeed2minutes(qSplits.fin_time)#
							</td>
						</tr>
					</cfoutput>
					</tbody>
				</table>
	<cfelse>
				No splits were returned for your criteria.
	</cfif>
			</td>
		</tr>
	</tbody>
</table>
