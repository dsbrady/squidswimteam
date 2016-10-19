<!---
<fusedoc
	fuse="dsp_registration_confirmation_printable.cfm"
	language="ColdFusion"
	specification="3.0">
	<responsibilities>
		I display the printable information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="13 April 2004" type="Create" role="Architect">
	</properties>
</fusedoc>
--->
<cfoutput>
<table border="0" cellpadding="0" cellspacing="0" align="center" class="contentSmall">
 	<thead>
		<tr>
			<td class="header1">
				#Request.page_title#
			</td>
		</tr>
	</thead>
	<tbody>
		<tr valign="top">
			<td>
				<br />
				<p>
					You are now registered for "Swim With an Altitude:
					SQUID Long Course Challenge 2004." The information you submitted
					is at the end of this page.
				</p>
				<p style="font-weight:bold;">
				<cfif Session.goldrush2009.registrationType NEQ "social">
					REMINDER: You must submit
					<cfif NOT LEN(Session.goldrush2009.paypal_transaction)>
						a check made payable to "SQUID Swim Team" in the amount of
						US#DollarFormat(Session.goldrush2009.totalFee)#, a copy of your USMS/FINA card, and
					<cfelse>
						a copy of your USMS card
					</cfif>
						and a
						<a href="#Request.waiverURL#" target="_blank">signed Liability Waiver</a> to:
					</p>
					<blockquote style="font-weight:bold;">
						SQUID Swim Team<br />
						P.O. Box 480912<br />
						Denver, CO 80248-0912<br />
					</blockquote>
					<p style="font-weight:bold;">
						If this has not been postmarked by #DateFormat(Session.goldrush2009.paymentDue,"m/d/yyyy")#,
						your registration may be cancelled.
					</p>
				<cfelseif NOT LEN(Session.goldrush2009.paypal_transaction)>
						REMINDER: You must submit
						a check made payable to "SQUID Swim Team" in the amount of
						US#DollarFormat(Session.goldrush2009.totalFee)# to:
					</p>
					<blockquote style="font-weight:bold;">
						SQUID Swim Team<br />
						P.O. Box 480912<br />
						Denver, CO 80248-0912<br />
					</blockquote>
					<p style="font-weight:bold;">
						If this has not been postmarked by #DateFormat(Session.goldrush2009.paymentDue,"m/d/yyyy")#,
						your registration may be cancelled.
					</p>
				</cfif>
			<cfif (VAL(Session.goldrush2009.housing))>
				<p>
					While SQUID makes every effort to provide hosted housing for all who request it,
					we can not guarantee housing for you.  If you have not received information regarding
					your housing request by #DateFormat(DateAdd("D",14,Request.housingResponseDeadline),"m/d/yyyy")#,
					please contact us at <a href="mailto:#Request.from_email#">#Request.from_email#</a>.
				</p>
			</cfif>
			</td>
		</tr>
		<tr>
			<td>
				<table width="600">
					<tbody>
						<tr valign="top">
							<td colspan="2">
								&nbsp;
							</td>
						</tr>
						<tr valign="top">
							<td colspan="2">
								<strong>REGISTRATION INFORMATION</strong>
							</td>
						</tr>
						<tr valign="top">
							<td width="200">
								<strong>Register for:</strong>
							</td>
							<td width="400">
								<cfif Session.goldrush2009.registrationType IS "both">
									<cfset regString = "Swim Meet and Social Events">
								<cfelseif Session.goldrush2009.registrationType IS "meet">
									<cfset regString = "Swim Meet only">
								<cfelse>
									<cfset regString = "Social Events only">
								</cfif>
								#variables.regString# (US#DollarFormat(Session.goldrush2009.registrationFee)#)
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Name:</strong>
							</td>
							<td>
								#Session.goldrush2009.first_name# #Session.goldrush2009.initial# #Session.goldrush2009.last_name# (#Session.goldrush2009.pref_name#)
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Date of Birth:</strong>
							</td>
							<td>
								#Session.goldrush2009.dob#
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Sex:</strong>
							</td>
							<td>
								#Session.goldrush2009.ath_sex#
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Phone:</strong>
							</td>
							<td>
								#Session.goldrush2009.home_daytele#
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>E-mail:</strong>
							</td>
							<td>
								#Session.goldrush2009.home_email#
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Address:</strong>
							</td>
							<td>
								#Session.goldrush2009.home_addr1#<br />
							<cfif LEN(TRIM(Session.goldrush2009.home_addr2))>
								#Session.goldrush2009.home_addr2#<br />
							</cfif>
								#Session.goldrush2009.home_city#, #Session.goldrush2009.home_state# #Session.goldrush2009.home_zip#<br />
								#Session.goldrush2009.home_country#
							</td>
						</tr>
						<tr valign="top">
							<td colspan="2">
								&nbsp;
							</td>
						</tr>
						<tr valign="top">
							<td colspan="2">
								<strong>EVENT INFORMATION</strong>
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>USMS ##:</strong>
							</td>
							<td>
								#Session.goldrush2009.usms#
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Team:</strong>
							</td>
							<td>
								#variables.teamName#
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Races Entered</strong>
							</td>
							<td>
								<cfloop query="qRaces">
									#qRaces.eventDescription# <!--- (#Request.registration_cfc.convertSeed2minutes(VAL(qRaces.convSeed_time))#) --->
								</cfloop>
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Sunday Excursion</strong>
							</td>
							<td>
							<cfif VAL(Session.goldrush2009.excursion)>
								#variables.excursion#
							<cfelse>
								(none selected)
							</cfif>
							</td>
						</tr>
						<tr valign="top">
							<td colspan="2">
								&nbsp;
							</td>
						</tr>
						<tr valign="top">
							<td colspan="2">
								<strong>HOSTED HOUSING REQUEST</strong>
							</td>
						</tr>
					<cfif VAL(session.goldrush2009.housing)>
						<tr valign="top">
							<td>
								<strong>Guests:</strong>
							</td>
							<td>
								#Session.goldrush2009.num_guests#
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Name(s):</strong>
							</td>
							<td>
								#Session.goldrush2009.housing_names#
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Address:</strong>
							</td>
							<td>
								#Session.goldrush2009.housing_address#<br />
								#Session.goldrush2009.housing_city#, #Session.goldrush2009.housing_state# #Session.goldrush2009.housing_zip#<br />
								#Session.goldrush2009.housing_country#
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Phone</strong>
							</td>
							<td>
								#Session.goldrush2009.phone_day# (day)<br />
								#Session.goldrush2009.phone_evening# (evening)
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>E-mail</strong>
							</td>
							<td>
								#Session.goldrush2009.housing_email#
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Nights:</strong>
							</td>
							<td>
								#variables.nights#
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Car?</strong>
							</td>
							<td>
								#YesNoFormat(Session.goldrush2009.car)#
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Near:</strong>
							</td>
							<td>
								#Session.goldrush2009.near_location#
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Smoke?</strong>
							</td>
							<td>
								#YesNoFormat(Session.goldrush2009.smoke)#
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Allergies:</strong>
							</td>
							<td>
								#Session.goldrush2009.allergies#
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Needs:</strong>
							</td>
							<td>
								#Session.goldrush2009.needs#
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Sleeping Arrangements:</strong>
							</td>
							<td>
								#variables.sleeping#
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Temperament:</strong>
							</td>
							<td>
								#variables.temperament#
							</td>
						</tr>
					<cfelse>
						<tr valign="top">
							<td colspan="2">
								(not submitted)
							</td>
						</tr>
					</cfif>
						<tr valign="top">
							<td colspan="2">
								&nbsp;
							</td>
						</tr>
						<tr valign="top">
							<td colspan="2">
								<strong>PAYMENT INFORMATION</strong>
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Registration:</strong>
							</td>
							<td>
								US#DollarFormat(Session.goldrush2009.registrationFee)#
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Donation</strong>
							</td>
							<td>
								US#DollarFormat(Session.goldrush2009.donation)#
							</td>
						</tr>
						<tr valign="top">
							<td>
								&nbsp;
							</td>
							<td>
								------------
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Total:</strong>
							</td>
							<td>
								US#DollarFormat(Session.goldrush2009.totalFee)#
							</td>
						</tr>
						<tr valign="top">
							<td>
								<strong>Payment Method</strong>
							</td>
							<td>
								#Session.goldrush2009.paymentMethod#
							</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>
