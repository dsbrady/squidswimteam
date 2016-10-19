<cfcomponent displayname="Lookup Queries" hint="Lookup Queries">
	<cffunction name="getStates" access="public" displayname="Gets Query of States" hint="Gets Query of States" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="stateTbl" required="yes" type="string">
		<cfargument name="state_code" required="no" default="" type="string">

		<cfquery name="qryStates" datasource="#arguments.DSN#">
			SELECT
				s.state_code,
				s.state_name
			FROM
				#arguments.stateTbl# s
			WHERE
				s.state_code <> '--'
		<cfif LEN(TRIM(arguments.state_code))>
				AND UCASE(s.state_code) = <cfqueryparam value="#UCASE(arguments.state_code)#" cfsqltype="CF_SQL_VARCHAR">
		</cfif>
			ORDER BY
				s.state_name
		</cfquery>

		<cfreturn qryStates>
	</cffunction>

	<cffunction name="getCountries" access="public" displayname="Gets Query of States" hint="Gets Query of Countries" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="countryTbl" required="yes" type="string">
		<cfargument name="country_code" required="no" default="" type="string">

		<cfquery name="qryCountries" datasource="#arguments.DSN#">
			SELECT
				c.cntry_code,
				c.cntry_name
			FROM
				#arguments.countryTbl# c
			WHERE
				c.cntry_code <> '--'
		<cfif LEN(TRIM(arguments.country_code))>
				AND UCASE(c.cntry_code) = <cfqueryparam value="#UCASE(arguments.country_code)#" cfsqltype="CF_SQL_VARCHAR">
		</cfif>
			ORDER BY
				c.cntry_name
		</cfquery>

		<cfreturn qryCountries>
	</cffunction>

	<cffunction name="checkCompletion" access="public" displayname="Check Completion of Sections" hint="Checks Completion of different sections" output="No" returntype="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="registrationTbl" required="yes" type="string">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>

		<cfquery name="qryCompletion" datasource="#arguments.DSN#">
			SELECT
				r.master,
				r.races
			FROM
				#arguments.registrationTbl# r
			WHERE
				r.registration_id = <cfqueryparam value="#VAL(Session.goldrush2009.registration_id)#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>

		<cfscript>
			var.success.master = qryCompletion.master;
			var.success.races = qryCompletion.races;
		</cfscript>

		<cfreturn var.success>
	</cffunction>

	<cffunction name="getRaces" access="public" displayname="Query of Races" hint="Gets Query of Races" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="eventTbl" required="yes" type="string">
		<cfargument name="strokeTbl" required="yes" type="string">
		<cfargument name="entryTbl" required="No" default="" type="string">
		<cfargument name="ath_no" required="No" default="0" type="numeric">

		<cfquery name="qRaces" datasource="#arguments.DSN#">
			SELECT
				e.event_no,
				e.event_ltr,
				e.event_ptr,
				e.ind_rel,
				iif(e.ind_rel = 'I','Individual','Relay') AS eventType,
				e.event_dist,
				e.event_stroke,
				s.stroke,
			<cfif LEN(TRIM(arguments.entryTbl)) AND VAL(arguments.ath_no)>
				en.convSeed_time,
			</cfif>
				e.event_dist & 'M ' & IIF(e.suppress_stroke = 0, s.stroke, e.event_note) & iif(e.ind_rel = 'R',' Relay','') AS eventDescription
			FROM
				#arguments.eventTbl# e,
			<cfif LEN(TRIM(arguments.entryTbl)) AND VAL(arguments.ath_no)>
				#arguments.entryTbl# en,
			</cfif>
				#arguments.strokeTbl# s
			WHERE
				e.event_stroke = s.stroke_letter
			<cfif LEN(TRIM(arguments.entryTbl)) AND VAL(arguments.ath_no)>
				AND en.event_ptr = e.event_ptr
				AND en.ath_no = <cfqueryparam value="#VAL(arguments.ath_no)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			ORDER BY
				e.event_ptr
		</cfquery>

		<cfreturn qRaces>
	</cffunction>

	<cffunction name="getTeams" access="public" displayname="Query of Teams" hint="Gets Query of Teams" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="teamTbl" required="yes" type="string">
		<cfargument name="team_no" required="no" default="0" type="string">

		<cfquery name="qTeams" datasource="#arguments.DSN#">
			SELECT
				t.team_no,
				t.team_name,
				t.team_short,
				t.team_abbr
			FROM
				#arguments.teamTbl# t
			WHERE
				1 = 1
			<cfif VAL(arguments.team_no)>
				AND t.team_no = <cfqueryparam value="#VAL(arguments.team_no)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			ORDER BY
				t.team_name
		</cfquery>

		<cfreturn qTeams>
	</cffunction>

	<cffunction name="getExcursions" access="public" displayname="Get Excursions" hint="Gets Query of Excursions" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="excursionTbl" required="yes" type="string">
		<cfargument name="excursion_id" required="no" default="0" type="numeric">

		<cfquery name="qExcursions" datasource="#arguments.DSN#">
			SELECT
				e.excursion_id,
				e.name,
				e.description
			FROM
				#arguments.excursionTbl# e
			WHERE
				1 = 1
			<cfif VAL(arguments.excursion_id)>
				AND e.excursion_id = <cfqueryparam value="#VAL(arguments.excursion_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			ORDER BY
				e.name
		</cfquery>

		<cfreturn qExcursions>
	</cffunction>

	<cffunction name="getRegistrationFee" access="public" displayname="Get Registration Fee" hint="Returns Registration Fee" output="No" returntype="numeric">
		<cfargument name="fees" required="yes" type="struct">
		<cfargument name="registrationType" required="yes" type="string">
		<cfargument name="getEarly" required="No" default="false" type="boolean">

		<cfset var fee = 0>
		<cfset var feeString = "">
		<cfset var earlyDeadline = CreateDateTime(Year(arguments.fees.earlyDeadline),Month(arguments.fees.earlyDeadline),Day(arguments.fees.earlyDeadline),23,59,59)>

		<cfif (DateCompare(Now(),earlyDeadline) LTE 0) OR (arguments.getEarly)>
			<cfset feeString = "early">
		<cfelse>
			<cfset feeString = "late">
		</cfif>
		<cfif arguments.registrationType IS "both">
			<cfset feeString = feeString & "IGLA">
		<cfelseif arguments.registrationType IS "meet">
			<cfset feeString = feeString & "COMSA">
		<cfelseif arguments.registrationType IS "meetPicnic">
			<cfset feeString = feeString & "MeetAndPicnic">
		<cfelse>
			<cfset feeString = feeString & "SOCIAL">
		</cfif>
		<cfset fee = arguments.fees[feeString & "Fee"]>

		<cfreturn fee>
	</cffunction>

	<cffunction name="getAthletes" access="public" displayname="getAthletes" hint="Gets Query of Athletes" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="athleteTbl" required="yes" type="string">
		<cfargument name="teamTbl" required="yes" type="string">
		<cfargument name="team_no" required="no" default="0" type="numeric">

		<cfquery name="qData" datasource="#arguments.DSN#">
			SELECT
				a.ath_no,
				a.last_name,
				a.first_name,
				a.initial,
				a.ath_sex,
				a.ath_age,
				a.team_no,
				a.pref_name,
				t.team_abbr
			FROM
				#arguments.athleteTbl# a,
				#arguments.teamTbl# t
			WHERE
				a.team_no = t.team_no
			<cfif VAL(arguments.team_no)>
				AND t.team_no = <cfqueryparam value="#VAL(arguments.team_no)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			ORDER BY
				a.last_name, a.first_name
		</cfquery>

		<cfreturn qData>
	</cffunction>

	<cffunction name="getResults" access="public" displayname="getResults" hint="Gets Query of Results" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="eventTbl" required="yes" type="string">
		<cfargument name="strokeTbl" required="yes" type="string">
		<cfargument name="entryTbl" required="No" default="" type="string">
		<cfargument name="athleteTbl" required="yes" type="string">
		<cfargument name="teamTbl" required="yes" type="string">
		<cfargument name="MultiageTbl" required="yes" type="string">
		<cfargument name="ath_no" required="No" default="0" type="numeric">
		<cfargument name="team_no" required="no" default="0" type="numeric">
		<cfargument name="event_no" required="no" default="0" type="numeric">

		<cfquery name="qData" datasource="#arguments.DSN#">
			SELECT
				a.ath_no,
				a.last_name,
				a.first_name,
				a.initial,
				a.ath_sex,
				a.ath_age,
				a.team_no,
				a.pref_name,
				t.team_abbr,
				e.event_no,
				e.event_ltr,
				e.event_ptr,
				e.ind_rel,
				iif(e.ind_rel = 'I','Individual','Relay') AS eventType,
				e.event_dist,
				e.event_stroke,
				s.stroke,
				IIF(en.convSeed_time IS NULL,'NT',en.convSeed_time) AS convSeed_time,
				iif(en.fin_stat = 'Q', 'DQ', iif(en.scr_stat = -1 OR en.fin_time = 0,'SCR',en.fin_time)) AS result,
				iif(en.fin_place > 0 AND en.fin_place < 6,en.fin_place,'') AS place,
				e.event_dist & 'M ' & IIF(e.suppress_stroke = 0, s.stroke, e.event_note) & iif(e.ind_rel = 'R',' Relay','') AS eventDescription
			FROM
				#arguments.athleteTbl# a,
				#arguments.teamTbl# t,
				#arguments.eventTbl# e,
				#arguments.entryTbl# en,
				#arguments.strokeTbl# s,
				#arguments.multiAgeTbl# ma
			WHERE
				a.team_no = t.team_no
				AND e.event_stroke = s.stroke_letter
				AND en.event_ptr = e.event_ptr
				AND en.ath_no = a.ath_no
				AND a.ath_age >= ma.low_age
				AND a.ath_age <= ma.high_age
				AND e.event_ptr = ma.event_ptr
			<cfif VAL(arguments.ath_no)>
				AND en.ath_no = <cfqueryparam value="#VAL(arguments.ath_no)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			<cfif VAL(arguments.team_no)>
				AND t.team_no = <cfqueryparam value="#VAL(arguments.team_no)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			<cfif VAL(arguments.event_no)>
				AND e.event_no = <cfqueryparam value="#VAL(arguments.event_no)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			ORDER BY
				e.event_ptr,
				a.ath_sex,
				ma.high_age,
				iif(en.fin_place > 0 AND en.fin_place < 6,en.fin_place,''),
				iif(en.fin_stat = 'Q', 'DQ', iif(en.scr_stat = -1 OR en.fin_time = 0,'SCR',en.fin_time)),
				a.last_name,
				a.first_name
		</cfquery>

		<cfreturn qData>
	</cffunction>

	<cffunction name="getRelayResults" access="public" displayname="getRelayResults" hint="Gets Query of Relay Results" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="eventTbl" required="yes" type="string">
		<cfargument name="strokeTbl" required="yes" type="string">
		<cfargument name="athleteTbl" required="yes" type="string">
		<cfargument name="teamTbl" required="yes" type="string">
		<cfargument name="RelayTbl" required="yes" type="string">
		<cfargument name="RelayNamesTbl" required="yes" type="string">
		<cfargument name="ath_no" required="No" default="0" type="numeric">
		<cfargument name="team_no" required="no" default="0" type="numeric">
		<cfargument name="event_no" required="no" default="0" type="numeric">

		<cfquery name="qData" datasource="#arguments.DSN#">
			SELECT
				r.event_ptr,
				r.team_no,
				r.team_ltr,
				r.rel_age,
				r.rel_sex,
				r.relay_no,
				rn.ath_no,
				rn.pos_no,
				a.ath_no,
				a.last_name,
				a.first_name,
				a.initial,
				a.ath_sex,
				a.ath_age,
				a.team_no,
				a.pref_name,
				t.team_abbr,
				t.team_name,
				e.event_no,
				e.event_ltr,
				e.event_ptr,
				e.ind_rel,
				iif(e.ind_rel = 'I','Individual','Relay') AS eventType,
				e.event_dist,
				e.event_stroke,
				iif(r.fin_stat = 'Q', 'DQ', iif(r.scr_stat = -1 OR r.fin_time = 0,'SCR',r.fin_time)) AS result,
				iif(r.fin_place > 0 AND r.fin_place < 6,r.fin_place,'') AS place,
				e.event_dist & 'M ' & IIF(e.suppress_stroke = 0, s.stroke, e.event_note) & ' Relay' AS eventDescription
			FROM
				#Request.relayTbl# r,
				#Request.relayNamesTbl# rn,
				#Request.athleteTbl# a,
				#Request.eventTbl# e,
				#Request.strokeTbl# s,
				#Request.teamTbl# t
			WHERE
				r.relay_no = rn.relay_no
				AND rn.ath_no = a.ath_no
				AND r.event_ptr = e.event_ptr
				AND e.event_stroke = s.stroke_letter
				AND r.team_no = t.team_no
			<cfif VAL(arguments.ath_no)>
				AND <cfqueryparam value="#VAL(arguments.ath_no)#" cfsqltype="CF_SQL_INTEGER"> IN
				(
					SELECT
						rn2.ath_no
					FROM
						#Request.relayNamesTbl# rn2
					WHERE
						rn2.relay_no = rn.relay_no
				)
			</cfif>
			<cfif VAL(arguments.team_no)>
				AND r.team_no = <cfqueryparam value="#VAL(arguments.team_no)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			<cfif VAL(arguments.event_no)>
				AND e.event_no = <cfqueryparam value="#VAL(arguments.event_no)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			ORDER BY
				e.event_ptr,
				r.rel_age,
				iif(r.fin_place > 0 AND r.fin_place < 6,r.fin_place,''),
				iif(r.fin_stat = 'Q', 'DQ', iif(r.scr_stat = -1 OR r.fin_time = 0,'SCR',r.fin_time)),
				rn.pos_no
		</cfquery>

		<cfreturn qData>
	</cffunction>

	<cffunction name="getIndSplits" access="public" displayname="getIndSplits" hint="Gets Query of an Individual's Splits for an Event" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="eventTbl" required="yes" type="string">
		<cfargument name="strokeTbl" required="yes" type="string">
		<cfargument name="athleteTbl" required="yes" type="string">
		<cfargument name="entryTbl" required="yes" type="string">
		<cfargument name="splitTbl" required="yes" type="string">
		<cfargument name="ath_no" required="No" default="0" type="numeric">
		<cfargument name="event_no" required="no" default="0" type="numeric">

		<cfquery name="qData" datasource="#arguments.DSN#">
			SELECT
				a.ath_no,
				a.last_name,
				a.first_name,
				a.initial,
				a.ath_sex,
				a.ath_age,
				a.pref_name,
				e.event_no,
				e.event_ltr,
				e.event_ptr,
				sp.split_no,
				sp.split_time,
				en.fin_time,
				e.event_dist & 'M ' & IIF(e.suppress_stroke = 0, s.stroke, e.event_note) AS eventDescription
			FROM
				#arguments.athleteTbl# a,
				#arguments.eventTbl# e,
				#arguments.entryTbl# en,
				#arguments.strokeTbl# s,
				#arguments.splitTbl# sp
			WHERE
				e.event_stroke = s.stroke_letter
				AND a.ath_no = en.ath_no
				AND e.event_ptr = en.event_ptr
				AND e.event_ptr = sp.event_ptr
				AND a.ath_no = sp.ath_no
				AND sp.ath_no = <cfqueryparam value="#VAL(arguments.ath_no)#" cfsqltype="CF_SQL_INTEGER">
				AND e.event_no = <cfqueryparam value="#VAL(arguments.event_no)#" cfsqltype="CF_SQL_INTEGER">
			ORDER BY
				sp.split_no
		</cfquery>

		<cfreturn qData>
	</cffunction>

	<cffunction name="getRelaySplits" access="public" displayname="getRelaySplits" hint="Gets Query of an Relay Team's Splits for an Event" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="eventTbl" required="yes" type="string">
		<cfargument name="strokeTbl" required="yes" type="string">
		<cfargument name="teamTbl" required="yes" type="string">
		<cfargument name="RelayTbl" required="yes" type="string">
		<cfargument name="splitTbl" required="yes" type="string">
		<cfargument name="relay_no" required="No" default="0" type="numeric">

		<cfquery name="qData" datasource="#arguments.DSN#">
			SELECT
				r.event_ptr,
				r.team_no,
				r.team_ltr,
				r.rel_age,
				r.rel_sex,
				r.relay_no,
				t.team_abbr,
				t.team_name,
				e.event_no,
				e.event_ltr,
				e.event_ptr,
				e.ind_rel,
				iif(e.ind_rel = 'I','Individual','Relay') AS eventType,
				e.event_dist,
				e.event_stroke,
				sp.split_no,
				sp.split_time,
				r.fin_time,
				e.event_dist & 'M ' & IIF(e.suppress_stroke = 0, s.stroke, e.event_note) & ' Relay' AS eventDescription
			FROM
				#Request.relayTbl# r,
				#Request.eventTbl# e,
				#Request.strokeTbl# s,
				#Request.teamTbl# t,
				#arguments.splitTbl# sp
			WHERE
				r.event_ptr = e.event_ptr
				AND e.event_stroke = s.stroke_letter
				AND r.team_no = t.team_no
				AND r.relay_no = sp.relay_no
				AND sp.relay_no = <cfqueryparam value="#VAL(arguments.relay_no)#" cfsqltype="CF_SQL_INTEGER">
			ORDER BY
				sp.split_no
		</cfquery>

		<cfreturn qData>
	</cffunction>

</cfcomponent>