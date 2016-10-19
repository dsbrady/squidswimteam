<!---
<fusedoc
	fuse="dsp_meet_description.cfm"
	language="ColdFusion"
	specification="3.0">
	<responsibilities>
		I display meet description.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="24 April 2004" type="Create" role="Architect">
	</properties>
</fusedoc>
--->
<cfparam name="attributes.returnFA" default="home.dsp_start" type="string">
<cfoutput>
<table border="0" cellpadding="0" cellspacing="0" align="center" class="contentSmall">
	<tbody>
		<tr valign="top">
			<td>
				<p align="center">
					<a href="#Request.self#/fuseaction/#attributes.returnFA#.cfm">Back</a>
				</p>
				<table border="0" cellpadding="3" cellspacing="0" class="plain_text">
					<tr valign="top">
						<td>
							<strong>LOCATION:</strong>
						</td>
						<td>
							Auraria Campus - PER Events Center<br />
							Denver, Colorado  80217<br />
							(303) 556-3210
						</td>
					</tr>
					<tr valign="top">
						<td>
							<strong>DATE OF MEET:</strong>
						</td>
						<td>
							Saturday, October 10, 2009
						</td>
					</tr>
					<tr valign="top">
						<td>
							<strong>POOL:</strong>
						</td>
						<td>
							25-Yard Indoor Short-Course Pool<br />
							Pool will have 6 competition lanes and 1 continuous warm-up/warm down area in the diving well.<br />
						</td>
					</tr>
				</table>
				<p>
					<strong>DIRECTIONS TO POOL FROM CAPITOL HILL:</strong>  NEED DIRECTIONS
				</p>
				<p>
					<strong>SCHEDULE:</strong>
				</p>
				<table width="100%" border="1" bordercolor="##cccccc" cellpadding="3" cellspacing="0">
					<tr valign="top" class="tableBG1">
						<td>
							Warm Up:
						</td>
						<td>
							8:00 a.m.
						</td>
					</tr>
					<tr valign="top" class="tableBG0">
						<td>
							Meet Start:
						</td>
						<td>
							9:00 a.m.
						</td>
					</tr>
					<tr valign="top" class="tableBG1">
						<td>
							Estimated End Time:
						</td>
						<td>
							2:00 p.m.
						</td>
					</tr>
				</table>
				<p>
					<strong>ORDER OF EVENTS:</strong> (odd numbers are female, even numbers are male)
				</p>
				<table width="100%" border="1" bordercolor="##cccccc" cellpadding="3" cellspacing="0">
					<thead>
						<tr valign="bottom" class="tblHdr">
							<td>
								##
							</td>
							<td>
								EVENT
							</td>
							<td>
								##
							</td>
							<td>
								EVENT
							</td>
						</tr>
					</thead>
					<tbody>
						<tr valign="bottom" class="tblHdr">
							<td colspan="2" align="center">
								(Warm-Up)
							</td>
							<td align="center">
								17
							</td>
							<td>
								200 FREE MIXED RELAY
							</td>
						</tr>
						<tr valign="middle" class="tableBG1">
							<td align="center">
								1 / 2
							</td>
							<td>
								200 MEDLEY RELAY
							</td>
							<td colspan="2" align="center">
								Diving Competition and Break
							</td>
						</tr>
						<tr valign="middle" class="tableBG1">
							<td align="center">
								3 / 4
							</td>
							<td>
								200 FREE
							</td>
							<td align="center">
								18
							</td>
							<td>
								200 MEDLEY MIXED RELAY
							</td>
						</tr>
						<tr valign="middle" class="tableBG1">
							<td align="center">
								5 / 6
							</td>
							<td>
								50 BREAST
							</td>
							<td align="center">
								19 / 20
							</td>
							<td>
								100 IM
							</td>
						</tr>
						<tr valign="middle" class="tableBG1">
							<td align="center">
								7 / 8
							</td>
							<td>
								200 IM
							</td>
							<td align="center">
								21 / 22
							</td>
							<td>
								100 BACK
							</td>
						</tr>
						<tr valign="middle" class="tableBG1">
							<td align="center">
								9 / 10
							</td>
							<td>
								50 FREE
							</td>
							<td align="center">
								23 / 24
							</td>
							<td>
								50 FLY
							</td>
						</tr>
						<tr valign="middle" class="tableBG1">
							<td align="center">
								11 / 12
							</td>
							<td>
								100 FLY
							</td>
							<td align="center">
								25 / 26
							</td>
							<td>
								100 BREAST
							</td>
						</tr>
						<tr valign="middle" class="tableBG1">
							<td align="center">
								13 / 14
							</td>
							<td>
								50 BACK
							</td>
							<td align="center">
								27 / 28
							</td>
							<td>
								500 FREE / 400 IM
							</td>
						</tr>
						<tr valign="middle" class="tableBG1">
							<td align="center">
								15 / 16
							</td>
							<td>
								100 FREE
							</td>
							<td align="center">
								29 / 30
							</td>
							<td>
								200 FREE RELAY
							</td>
						</tr>
					</tbody>
				</table>
				<p>
					<strong>SANCTION:</strong>  Sanctioned by COMSA for USMS, Inc. Sanction ## <strong>#Request.sanctioning#</strong> and Recognized by IGLA.
				</p>
				<p>
					<strong>TIMING:</strong>  Electronic timing will be used for all events, with back-up hand timing.
				</p>
				<p>
					<strong>ELIGIBILITY:</strong>  Only Masters swimmers with 2009 USMS Registration or foreign equivalent may participate.  A copy of your current (2009) USMS card or card from foreign master's equivalent must be sent via USPS following registration. A one-day USMS registration will be available for $10 on the day of the meet.
				</p>
				<p>
					<strong>RULES:</strong>  Current USMS Rules govern the competition.  Age as of 12/31/09 determines competition age.  Seeding will be done from slow to fast by time, with ages mixed.  Men and women will be seeded separately, and event results will be separated.  <strong>Be sure to enter short-course 25-yard times on your registration.</strong>  All events are timed finals.
				</p>
				<p>
					<strong>NUMBER OF ENTRIES:</strong>  Entries are limited to 5 individual events plus the 2 relays.  All entries are to be submitted via the Swim Meet Registration system.  (No individual time cards are required).  A heat sheet and meet program will be available on the day of the meet.
				</p>
				<p>
					<strong>SCORING:</strong>  Individual events will be scored (by age group) from 1st to 6th place as follows: 7-5-4-3-2-1 points.  Relay events will be scored (by age group) from 1st to 6th place as follows: 14-10-8-6-4-2 points.  500 Free / 400 I.M. swimmers must select one event during registration; the results will be segregated and scored separately.
				</p>
				<p>
					<strong>TEAM RELAYS:</strong>  Relay time cards will be available at the Registration Reception, <strong>and must be turned in by 9:00 a.m. on October 10th at the pool.</strong>  Relays may be composed of 4 men (all men), 4 women (all women), or 2 men and 2 women (mixed), and will be scored in those categories.  To be officially scored and recorded, all 4 swimmers on a relay must belong to the same team.  Swimmers may only swim one medley relay and one freestyle relay. Four swimmers from separate <strong>COMSA</strong> teams may swim on the same relay as an officially-scored competitive team -- that team will be listed as swimming for "Colorado Masters Swimming".
				</p>
				<p>
					<strong>RELAY AGE GROUPS:</strong>  Relays will be run together according to seed time, but will be scored by the <strong>age of the youngest swimmer on the relay</strong>.  Any swimmer who is only participating in the relay must still pay a registration fee AND Sign the Liability Release.
				</p>
				<p>
					<strong>EXHIBITION RELAYS:</strong>  For those unaffiliated swimmers, or swimmers with insufficient teammates to form a relay, <em>separate exhibition relays will be arranged at the Registration Party</em>.  <strong>You must sign-up by 8:30 a.m. on October 10th at the pool.</strong>  These swimmers may participate in the relay, but will not be officially scored or reported.
				</p>
				<p>
					<strong>LONG DISTANCE EVENTS:</strong>  The 500 Free / 400 I.M. event requires advance check-in.  500 Free / 400 I.M. check-in will be by 10:30 a.m. Saturday at the pool.  500 Free / 400 I.M. swimmers must select the event they will complete event during registration.  500 Free swimmers must provide their own Counters.  Lap cards will be available.
				</p>
				<p>
					<strong>RESULTS:</strong>  Results will be posted at the Swim Meet as soon as possible after each event.  Final results will be posted on this web site (<a href="http://www.squidswimteam.org/goldrush2009">http://www.squidswimteam.org/goldrush2009</a>)
				</p>
				<p>
					<strong>AWARDS:</strong>  Individual and team awards will be given.  The team awards will be given at the Sunday afternoon awards picnic.
					Additionally, awards will be given for the Male and Female High-Points and for the Short and Long Pentathlon.
				</p>
				<p>
					For more information regarding the swim meet, please contact Andrew LeVasseur at <a href"mailto:swimmin4fun@msn.com">swimmin4fun@msn.com</a> or (303) 722-3907.
				</p>
				<p align="center">
					<a href="#Request.self#/fuseaction/#attributes.returnFA#.cfm">Back</a>
				</p>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>
