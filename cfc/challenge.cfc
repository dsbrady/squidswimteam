<cfcomponent displayname="Long-Course Challenge Component" hint="CFC for Swim Meet Administrator">
	<cffunction name="getHousing" access="public" displayname="getHousing" hint="Gets Query of Hosted Housing Requests" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="registrationTbl" required="yes" type="string">
		<cfargument name="athleteTbl" required="yes" type="string">
		<cfargument name="housingTbl" required="yes" type="string">

		<cfset var qData = "">

		<cfquery name="qData" datasource="#dsn#">
			SELECT
				a.first_name,
				a.last_name,
				a.pref_name,
				r.username,
				h.phone_evening,
				h.num_guests,
				h.nights,
				h.car,
				h.near_location,
				h.smoke,
				h.allergies,
				h.needs,
				h.sleeping,
				h.temperament
			FROM
				(
					#registrationTbl# r
					LEFT OUTER JOIN
					#athleteTbl# a
					ON a.ath_no = r.athlete_no
				)
				INNER JOIN
				#housingTbl# h
				ON r.housing_id = h.registrant_housing_id
			WHERE
				r.active_cd = 1
			ORDER BY
				a.last_name,
				a.first_name
		</cfquery>

		<cfreturn qData />
	</cffunction>

	<cffunction name="getExcursions" access="public" displayname="getExcursions" hint="Gets Query of Excursion Requests" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="registrationTbl" required="yes" type="string">
		<cfargument name="athleteTbl" required="yes" type="string">
		<cfargument name="excursionTbl" required="yes" type="string">

		<cfset var qData = "">

		<cfquery name="qData" datasource="#dsn#">
			SELECT
				e.name AS excursion,
				a.pref_name,
				a.first_name,
				a.last_name,
				r.username,
				a.home_daytele
			FROM
				(
					#registrationTbl# r
					LEFT OUTER JOIN
					#athleteTbl# a
					ON a.ath_no = r.athlete_no
				)
				INNER JOIN
				#excursionTbl# e
				ON r.excursion_id = e.excursion_id
			WHERE
				r.active_cd = 1
			ORDER BY
				e.name,
				a.last_name,
				a.first_name
		</cfquery>

		<cfreturn qData />
	</cffunction>

	<cffunction name="getDivingEntries" access="public" hint="Gets Query of Diving Entries" output="false" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="registrationTbl" required="yes" type="string">
		<cfargument name="athleteTbl" required="yes" type="string">
		<cfargument name="teamTbl" required="yes" type="string">

		<cfset var qData = "" />

		<cfquery name="qData" datasource="#dsn#">
			SELECT
				a.ath_sex,
				a.pref_name,
				a.first_name,
				a.last_name,
				a.ath_age,
				t.team_short,
				t.team_abbr
			FROM
				(
					#registrationTbl# r
					INNER JOIN #athleteTbl# a
					ON a.ath_no = r.athlete_no
				)
				INNER JOIN
				#teamTbl# t
				ON t.team_no = a.team_no
			WHERE
				r.isDiving = 1
				AND r.active_cd = 1
			ORDER BY
				a.first_name,
				a.last_name
		</cfquery>

		<cfreturn qData />
	</cffunction>

	<cffunction name="getRaceEntries" access="public" displayname="getRaceEntries" hint="Gets Query of Race Entries" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="registrationTbl" required="yes" type="string">
		<cfargument name="athleteTbl" required="yes" type="string">
		<cfargument name="eventTbl" required="yes" type="string">
		<cfargument name="entryTbl" required="yes" type="string">
		<cfargument name="strokeTbl" required="yes" type="string">
		<cfargument name="teamTbl" required="yes" type="string">

		<cfset var qData = "">

		<cfquery name="qData" datasource="#dsn#">
			SELECT
				evt.event_ptr,
				evt.event_no,
				evt.event_ltr,
				evt.event_dist & 'yd ' & s.stroke & IIF(evt.ind_rel = 'R',' Relay','') AS eventDescription,
				a.ath_sex,
				a.pref_name,
				a.first_name,
				a.last_name,
				a.ath_age,
				ent.convSeed_time,
				t.team_short,
				t.team_abbr
			FROM
				(
					(
						(
							(
								#registrationTbl# r
								INNER JOIN
								#athleteTbl# a
								ON a.ath_no = r.athlete_no
							)
							INNER JOIN
							#entryTbl# ent
							ON a.ath_no = ent.ath_no
						)
						INNER JOIN
						#eventTbl# evt
						ON ent.event_ptr = evt.event_ptr
					)
					INNER JOIN
					#strokeTbl# s
					ON evt.event_stroke = s.stroke_letter
				)
				INNER JOIN
				#teamTbl# t
				ON t.team_no = a.team_no
			WHERE
				r.active_cd = 1
<!--- 				AND r.paymentSubmitted IS NOT NULL --->
			ORDER BY
				evt.event_no,
				evt.event_ltr,
				evt.event_ptr,
				a.ath_sex,
				a.ath_age,
				ent.convSeed_time
		</cfquery>

		<cfreturn qData />
	</cffunction>

	<cffunction name="getRegistrations" access="public" displayname="getRegistrations" hint="Gets Query of Registrations" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="registrationTbl" required="yes" type="string">
		<cfargument name="athleteTbl" required="yes" type="string">
		<cfargument name="teamTbl" required="yes" type="string">
		<cfargument name="registration_id" required="No" default="0" type="numeric">

		<cfset var qData = "">

		<cfquery name="qData" datasource="#dsn#">
			SELECT
				r.registration_id,
				a.first_name,
				a.pref_name,
				a.last_name,
				a.ath_sex,
				a.ath_age,
				a.home_daytele,
				a.birth_date,
				r.registrationType,
				t.team_abbr,
				t.team_name,
				r.shirt,
				r.registrationSubmitted,
				r.paymentSubmitted,
				r.usms_received,
				r.waiverSigned,
				r.paymentMethod,
				r.username,
				r.paymentDue,
				r.registrationFee,
				r.donation,
				r.totalFee,
				r.paypal_transaction,
				r.usms,
				r.usms_received,
				r.waiverDate,
				r.isDiving
			FROM
				(
					#registrationTbl# r
					LEFT OUTER JOIN
					#athleteTbl# a
					ON a.ath_no = r.athlete_no
				)
				LEFT OUTER JOIN
				#teamTbl# t
				ON a.team_no = t.team_no
			WHERE
				r.active_cd = 1
			<cfif VAL(registration_id)>
				AND r.registration_id = <cfqueryparam value="#VAL(registration_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			ORDER BY
				a.last_name,
				a.first_name
		</cfquery>

		<cfreturn qData />
	</cffunction>

	<cffunction name="updateRegistration" access="public" displayname="updateRegistration" hint="I update the registration" output="No" returntype="struct">
		<cfargument name="formfields" required="yes" type="struct">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="registrationTbl" required="yes" type="string">

		<cfset var stSuccess = StructNew()>
		<cfset stSuccess.success = true>
		<cfset stSuccess.reason = "">

		<!--- Validate data --->
		<cfif formfields.paymentYN AND NOT LEN(TRIM(formfields.paymentSubmitted))>
			<cfset stSuccess.success = false>
			<cfset stSuccess.reason = stSuccess.reason & "You must enter the payment submitted date.*">
		<cfelseif formfields.paymentYN AND NOT isDate(formfields.paymentSubmitted)>
			<cfset stSuccess.success = false>
			<cfset stSuccess.reason = stSuccess.reason & "Please enter a valid payment date.*">
		</cfif>

		<cfif formfields.usms_received AND NOT LEN(trim(formfields.usms))>
			<cfset stSuccess.success = "No">
			<cfset stSuccess.reason = var.success.reason & "You have marked the USMS Card as received, but have not entered the USMS number.*">
		</cfif>

		<cfif formfields.waiverSigned AND NOT LEN(TRIM(formfields.waiverDate))>
			<cfset stSuccess.success = false>
			<cfset stSuccess.reason = stSuccess.reason & "You must enter the waiver signed date.*">
		<cfelseif formfields.waiverSigned AND NOT isDate(formfields.waiverDate)>
			<cfset stSuccess.success = false>
			<cfset stSuccess.reason = stSuccess.reason & "Please enter a valid waiver date.*">
		</cfif>

		<!--- Update information --->
		<cfif stSuccess.success>
			<cfquery name="qUpdate" datasource="#dsn#">
				UPDATE
					#registrationTbl#
				SET
				<cfif formfields.paymentYN>
					payment = <cfqueryparam value="#formfields.paymentYN#" cfsqltype="CF_SQL_BIT">,
				</cfif>
					paymentMethod = <cfqueryparam value="#formfields.paymentMethod#" cfsqltype="CF_SQL_VARCHAR">,
					paymentSubmitted = <cfqueryparam value="#formfields.paymentSubmitted#" cfsqltype="CF_SQL_DATE">,
					paypal_transaction = <cfqueryparam value="#formfields.paypal_transaction#" cfsqltype="CF_SQL_VARCHAR">,
					usms = <cfqueryparam value="#formfields.usms#" cfsqltype="CF_SQL_VARCHAR">,
					usms_received = <cfqueryparam value="#formfields.usms_received#" cfsqltype="CF_SQL_BIT">,
					waiverSigned = <cfqueryparam value="#formfields.waiverSigned#" cfsqltype="CF_SQL_BIT">,
					waiverDate = <cfqueryparam value="#formfields.waiverDate#" cfsqltype="CF_SQL_DATE">
				WHERE
					registration_id = <cfqueryparam value="#VAL(formfields.registration_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
		</cfif>

		<cfreturn stSuccess />
	</cffunction>

	<cffunction name="deleteRegistration" access="public" displayname="deleteRegistration" hint="I delete a registration" output="No" returntype="struct">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="registrationTbl" required="yes" type="string">
		<cfargument name="athleteTbl" required="yes" type="string">
		<cfargument name="entryTbl" required="yes" type="string">
		<cfargument name="housingTbl" required="yes" type="string">
		<cfargument name="registration_id" required="Yes" type="numeric">
		<cfargument name="updatingUser" required="Yes" type="numeric">

		<cfset var stSuccess = StructNew()>
		<cfset stSuccess.success = true>
		<cfset stSuccess.reason = "">


		<cftransaction>
			<!--- Get athlete number --->
			<cfquery name="qAthlete" datasource="#dsn#">
				SELECT
					athlete_no
				FROM
					#registrationTbl#
				WHERE
					registration_id = <cfqueryparam value="#VAL(registration_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>

			<!--- Delete housing --->
			<cfquery name="qHousingDel" datasource="#dsn#">
				DELETE FROM
					#housingTbl#
				WHERE
					registration_id = <cfqueryparam value="#VAL(registration_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>

			<!--- Delete entries --->
			<cfquery name="qEntryDel" datasource="#dsn#">
				DELETE FROM
					#entryTbl#
				WHERE
					ath_no = <cfqueryparam value="#VAL(qAthlete.athlete_no)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>

			<!--- Delete athlete --->
			<cfquery name="qEntryDel" datasource="#dsn#">
				DELETE FROM
					#athleteTbl#
				WHERE
					ath_no = <cfqueryparam value="#VAL(qAthlete.athlete_no)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>

			<!--- Deactivate registration --->
			<cfquery name="qReg" datasource="#dsn#">
				UPDATE
					#registrationTbl#
				SET
					active_cd = 0,
					modified_date = Now(),
					modified_user = <cfqueryparam value="#VAL(updatingUser)#" cfsqltype="CF_SQL_INTEGER">
				WHERE
					registration_id = <cfqueryparam value="#VAL(registration_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
		</cftransaction>

		<cfreturn stSuccess />
	</cffunction>

	<cffunction name="getShirts" access="public" displayname="getShirts" hint="Gets Query of Shirt Sizes" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="registrationTbl" required="yes" type="string">

		<cfset var qData = "">

		<cfquery name="qData" datasource="#dsn#">
			SELECT
				count(r.shirt) as numShirts,
				r.shirt
			FROM
				#registrationTbl# r
			WHERE
				r.active_cd = 1
			GROUP BY
				r.shirt
			ORDER BY
				IIF(r.shirt = 'S',1,IIF(r.shirt = 'M',2,(IIF(r.shirt = 'L',3,IIF(r.shirt = 'XL',4,5)))))
		</cfquery>

		<cfreturn qData />
	</cffunction>

	<cffunction name="getRosters" access="public" displayname="getRosters" hint="Gets Query of Team Rosters" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="registrationTbl" required="yes" type="string">
		<cfargument name="athleteTbl" required="yes" type="string">
		<cfargument name="teamTbl" required="yes" type="string">

		<cfset var qData = "">

		<cfquery name="qData" datasource="#dsn#">
			SELECT
				t.team_no,
				t.team_name,
				t.team_abbr,
				t.team_city,
				a.pref_name,
				a.first_name,
				a.last_name,
				r.registrationType
			FROM
				(
					#athleteTbl# a
					INNER JOIN
					#registrationTbl# r
					ON r.athlete_no = a.ath_no
				)
				INNER JOIN
				#teamTbl# t
				ON t.Team_no = a.Team_no
			WHERE
				r.active_cd = 1
			ORDER BY
				t.team_name,
				a.last_name,
				a.first_name
		</cfquery>

		<cfreturn qData />
	</cffunction>

	<cffunction name="getSponsorships" access="public" displayname="getSponsorships" hint="Gets Query of IGLA Donations" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="registrationTbl" required="yes" type="string">
		<cfargument name="athleteTbl" required="yes" type="string">

		<cfset var qData = "">

		<cfquery name="qData" datasource="#dsn#">
			SELECT
				s.sponsorshipID,
				s.sponsorName,
				s.isAnonymous,
				s.address1,
				s.address2,
				s.city,
				s.state_code,
				s.postalCode,
				s.country,
				s.sponsorshipAmount,
				a.last_name,
				a.first_name,
				a.pref_name
			FROM
			(
				registrationTbl r
				INNER JOIN sponsorships s ON r.registration_id = s.registration_id
			)
			INNER JOIN Athlete a ON r.athlete_no = a.Ath_no
			ORDER BY
				a.last_name,
				a.first_name
		</cfquery>

		<cfreturn qData />
	</cffunction>

</cfcomponent>
