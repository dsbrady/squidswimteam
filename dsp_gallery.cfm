<!---
<fusedoc
	fuse = "dsp_gallery.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the gallery page list.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="19 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="edit" />
				<string name="delete" />
			</structure>

		</in>
		<out>
		</out>
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
		<tr>
			<td>
				<strong><a href="https://www.facebook.com/groups/squidswimteam/photos/" target="squidGallery">SQUID Facebook Photos</a></strong>
			</td>
		</tr>
		<tr>
			<td>
				&nbsp;
			</td>
		</tr>
		<tr>
			<td>
				<!-- InstaWidget -->
				<a href="https://instawidget.net/v/user/squidswimteam" id="link-3e13f2a2ba5f9564a89306d9311c600c525d61ef4c9f69a4000e5b2495ef8319">@squidswimteam</a>
				<script src="https://instawidget.net/js/instawidget.js?u=3e13f2a2ba5f9564a89306d9311c600c525d61ef4c9f69a4000e5b2495ef8319&width=500px"></script>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>

