<!---
<fusedoc
	fuse = "dsp_membership_expired.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the membership expired page.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="10 December 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
		</in>
	</io>

</fusedoc>
--->
<cfparam name="attributes.reason" default="Expired" type="string">
<cfparam name="attributes.first_name" default="Swimmer" type="string">
<cfparam name="attributes.date_expiration" default="#DateFormat(Now(),"MMMM D, YYYY")#" type="string">

<table width="500" border="0" cellpadding="0" cellspacing="0" align="center">
<cfoutput>
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
		<tr>
			<td>
			<p>
				#attributes.first_name#,
			</p>
	<cfswitch expression="#attributes.reason#">
		<cfcase value="Expired">
			<p>
				Your membership expired on #attributes.date_expiration#.
			</p>
		</cfcase>
		<cfcase value="Guest">
			<p>
				You are listed as a Guest Member of SQUID.
			</p>
		</cfcase>
	</cfswitch>
			<p>
				The Member Area is only available to active members.  For more information on
				membership (and a membership form), please see the <a href="#Request.self#?fuseaction=#XFA.membership#&page=Membership">Membership</a> page.
			</p>
			<p>
				<a href="#Request.self#?fuseaction=#XFA.dues#&user_id=#attributes.user_id#&username=#attributes.username#&created_date=#attributes.created_date#&created_user=#attributes.created_user#">Pay Dues Online</a> via PayPal.
			</p>
			<p>
				If you feel this is an error, please <a href="#Request.self#?fuseaction=#XFA.contact#">Contact Us</a>.
			</p>
			</td>
		</tr>
	</tbody>
</cfoutput>
</table>

