<!---
<fusedoc fuse="dsp_start.cfm" language="ColdFusion" specification="3.0">
	<responsibilities>
		I display start page.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="21 March 2004" type="Create" role="Architect">
	</properties>
	<io>
		<in>
			<structure name="XFA">
				<string name="registerNew" />
				<string name="registerRetrun" />
			</structure>
		</in>
	</io>
</fusedoc>
--->
<cfoutput>
<table border="0" cellpadding="0" cellspacing="0" align="center" class="contentSmall">
	<tbody>
		<tr valign="top">
			<td>
				<p>
<!---
					Online registration for the SQUID Long Course Challenge is now closed.
 --->
<!---
					If you have registered and wish to update your information, you may do so
					until Sunday, July 17th.
					If you
					prefer to register by mail, please download the <a href="../pdf/registration.pdf" target="_blank">registration packet</a>.
 --->
				</p>
				<p>
					The 2009 Rocky Mountain Autumn Gold Rush Short Course Invitational is sanctioned by COMSA for USMS, Inc. Sanction## <strong>#Request.sanctioning#</strong> and is IGLA-recognized.
				</p>
				<p>
					Registration Fees are as follows:
				</p>
				<table width="100%" border="1" bordercolor="##cccccc" cellpadding="3" cellspacing="0">
					<thead>
						<tr valign="bottom" class="tblHdr">
							<td>
								If you will be participating in
							</td>
							<td>
								register by #DateFormat(Request.fees.earlyDeadline,"mm/dd/yyyy")#
							</td>
							<td>
								register by #DateFormat(Request.fees.lateDeadline,"mm/dd/yyyy")#
							</td>
						</tr>
					</thead>
					<tbody>
						<tr valign="middle" class="tableBG1">
							<td>
								Swim Meet and Social Events
							</td>
							<td>
								#DollarFormat(Request.fees.earlyIGLAFee)#
							</td>
							<td>
								#DollarFormat(Request.fees.lateIGLAFee)#
							</td>
						</tr>
						<tr valign="middle" class="tableBG0">
							<td>
								Swim Meet only
							</td>
							<td>
								#DollarFormat(Request.fees.earlyCOMSAFee)#
							</td>
							<td>
								#DollarFormat(Request.fees.lateCOMSAFee)#
							</td>
						</tr>
						<tr valign="middle" class="tableBG0">
							<td>
								Swim Meet and Awards Picnic only
							</td>
							<td>
								#DollarFormat(Request.fees.earlyMeetAndPicnicFee)#
							</td>
							<td>
								#DollarFormat(Request.fees.lateMeetAndPicnicFee)#
							</td>
						</tr>
						<tr valign="middle" class="tableBG1">
							<td>
								Social Events only
							</td>
							<td>
								#DollarFormat(Request.fees.earlySOCIALFee)#
							</td>
							<td>
								#DollarFormat(Request.fees.latesocialFee)#
							</td>
						</tr>
						<tr valign="middle" class="tableBG0">
							<td>
								Awards Picnic only
							</td>
							<td>
								#DollarFormat(Request.fees.earlyPicnicFee)#
							</td>
							<td>
								#DollarFormat(Request.fees.latePicnicFee)#
							</td>
						</tr>
					</tbody>
				</table>
				<p>
					<strong>NOTE: Non-swimming partners attending social events must submit separate registrations (but only 1 hosted housing form).</strong>
				</p>
				<p>
					How would you like to proceed?
				</p>
				<ul>
					<li>
						<a href="#Request.self#/fuseaction/#XFA.description#.cfm">View Meet Description</a>
					</li>
<!---
				<cfif IsDefined("Session.squid.permissions") AND ListFindNoCase(Session.squid.permissions,"Update Swim Meet")>
				</cfif>
 --->
					<li>
						<a href="#Request.self#/fuseaction/#XFA.registerNew#.cfm">Start a new registration</a>
					</li>
					<li>
						<a href="#Request.self#/fuseaction/#XFA.registerReturn#.cfm">Modify my registration</a>
					</li>
				</ul>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>
