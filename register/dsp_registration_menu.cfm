<!--- 
<fusedoc 
	fuse="dsp_registration_menu.cfm" language="ColdFusion" specification="3.0">
	<responsibilities>
		I display registrationmenu.
	</responsibilities>	
	<properties>
		<history author="Scott Brady" date="4 April 2004" type="Create" role="Architect">
	</properties>
	<io>
		<in>
			<structure name="XFA">
				<string name="master" />
				<string name="races" />
			</structure>
		</in>
	</io>
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
					Select the registration area you'd like to complete:
				</p>
				<table border="0" cellpadding="3" cellspacing="0" class="plain_text">
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<a href="#Request.self#/fuseaction/#XFA.description#.cfm">View Meet Description</a>
						</td>
					</tr>
					<tr>
						<td>
							<img src="#Request.images_folder2#/checkbox_o<cfif Session.goldrush2009.master>n<cfelse>ff</cfif>.gif" width="19" height="25" alt="Master Information <cfif NOT Session.goldrush2009.master>NOT </cfif>Completed" />
						</td>
						<td>
							<a href="#Request.self#/fuseaction/#XFA.master#.cfm">Update Master Registration Information</a>
						</td>
					</tr>
				<!---
					<tr>
						<td>
							<img src="#Request.images_folder2#/checkbox_o<cfif LEN(Session.goldrush2009.waiverName)>n<cfelse>ff</cfif>.gif" width="19" height="25" alt="Liability Waiver <cfif NOT LEN(Session.goldrush2009.waiverName)>NOT </cfif>Completed" />
						</td>
						<td>
						<cfif NOT LEN(Session.goldrush2009.waiverName)>
							<a href="#Request.self#/fuseaction/#XFA.waiver#.cfm">Sign Liability Waiver</a> <strong>(REQUIRED)</strong>
						<cfelse>
							<a href="#Request.self#/fuseaction/#XFA.waiver#.cfm">View Liability Waiver</a> <strong>(Signed: #DateFormat(Session.goldrush2009.waiverDate,"mmmm d, yyyy")#)</strong>
						</cfif>
						</td>
					</tr>
				 --->
				<cfif Session.goldrush2009.registrationType IS NOT "social">
					<tr>
						<td>
							<img src="#Request.images_folder2#/checkbox_o<cfif Session.goldrush2009.races>n<cfelse>ff</cfif>.gif" width="19" height="25" alt="Meet Events <cfif NOT Session.goldrush2009.races>NOT </cfif>Completed" />
						</td>
						<td>
							<a href="#Request.self#/fuseaction/#XFA.races#.cfm">Update Meet Events</a>
						</td>
					</tr>
				</cfif>
				<cfif Session.goldrush2009.registrationType IS NOT "meet">
					<tr>
						<td>
							<img src="#Request.images_folder2#/checkbox_o<cfif Session.goldrush2009.excursion>n<cfelse>ff</cfif>.gif" width="19" height="25" alt="Sunday Excursions <cfif NOT Session.goldrush2009.excursion>NOT </cfif>Completed" />
						</td>
						<td>
							<a href="#Request.self#/fuseaction/#XFA.excursions#.cfm">Update Sunday Excursions</a> (Optional)
						</td>
					</tr>
				</cfif>
					<tr>
						<td>
							<img src="#Request.images_folder2#/checkbox_o<cfif Session.goldrush2009.housing>n<cfelse>ff</cfif>.gif" width="19" height="25" alt="Hosted Housing <cfif NOT Session.goldrush2009.housing>NOT </cfif>Completed" />
						</td>
						<td>
							<a href="#Request.self#/fuseaction/#XFA.housing#.cfm">Update Hosted Housing</a> (Optional)
						</td>
					</tr>
					<tr>
						<td>
							<img src="#Request.images_folder2#/checkbox_o<cfif Session.goldrush2009.payment>n<cfelse>ff</cfif>.gif" width="19" height="25" alt="Hosted payment <cfif NOT Session.goldrush2009.payment>NOT </cfif>Completed" />
						</td>
						<td>
						<cfif NOT variables.submitOK>
							Submit Payment Info and Complete Registration<br />(not available until all required areas are filled out)
						<cfelseif NOT Session.goldrush2009.payment>
							<a href="#Request.self#/fuseaction/#XFA.payment#.cfm">Submit Payment Info and Complete Registration</a> (One-Time Only)
						<cfelse>
							<a href="#Request.self#/fuseaction/#XFA.confirmation#.cfm">Registration Completed - View Confirmation</a>
						</cfif>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							&nbsp;
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<a href="#Request.waiverURL#" target="_blank">View/Print Liability Waiver</a></strong>
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
						<td>
							<a href="#Request.self#/fuseaction/#XFA.end_session#.cfm">End Session</a>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>
