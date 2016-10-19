<!--- 
<fusedoc 
	fuse="dsp_sitemap.cfm" 
	language="ColdFusion" 
	specification="3.0">
	<responsibilities>
		I display the site map.
	</responsibilities>	
	<properties>
		<history author="Scott Brady" date="19 October 2003" type="Create" role="Architect">
	</properties>
	<io>
		<in>
			<structure name="XFA">
				
			</structure>
		</in>
	</io>
</fusedoc>
--->
<cfoutput>
<table width="600" border="0" cellpadding="0" cellspacing="0" align="center">
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
		<tr valign="top">
			<td>
				<p>
					<a href="#Request.self#/fuseaction/#XFA.home#/page/Home.cfm">Home</a>
				</p>
				<p>
					<a href="#Request.self#/fuseaction/#XFA.membership#/page/Membership.cfm">Membership</a>
				</p>
				<p>
					<a href="#Request.self#/fuseaction/#XFA.visiting#/page/Visiting.cfm">Visiting</a>
				</p>
				<p>
					<a href="#Request.self#/fuseaction/#XFA.workouts#/page/Workouts.cfm">Workouts</a>
				</p>
				<p>
					<a href="#Request.self#/fuseaction/#XFA.news#.cfm">News / Events</a>
				</p>
				<p>
					<a href="#Request.self#/fuseaction/#XFA.gallery#.cfm">Gallery</a>
				</p>
				<p>
					<a href="#Request.self#/fuseaction/#XFA.links#/page/Links.cfm">Links</a>
				</p>
				<p>
					<a href="#Request.self#/fuseaction/#XFA.members#.cfm">Member Area</a>
				</p>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>
