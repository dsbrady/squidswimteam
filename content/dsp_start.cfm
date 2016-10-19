<!---
<fusedoc
	fuse = "dsp_start.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the home page.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="9 September 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="files" />
				<string name="content" />
			</structure>
		</in>
	</io>

</fusedoc>
--->
<table width="500" border="0" cellpadding="2" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td align="center">
				<h2>
					<cfoutput>#Request.page_title#</cfoutput>
				</h2>
			</td>
		</tr>
	<cfoutput>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.files#">Upload / Delete Files</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.content#&page=Home">Update Home Page</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.content#&page=Membership">Update Membership Page</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.content#&page=Visiting">Update Visiting Page</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.content#&page=Workouts">Update Workouts Page</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.news#">Update News Page</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.contentGallery#">Update Gallery Pages</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.links#">Update Links Page</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.content#&page=Diving">Update Diving Page</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.trainingResources#">Update Training Resources</a>
			</td>
		</tr>
		<tr>
			<td>
				&nbsp;
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.menu#">Return to Main Menu</a>
			</td>
		</tr>
		<tr>
			<td>
				&nbsp;
			</td>
		</tr>
		<tr>
			<td>
				<a href="#Request.self#?fuseaction=#XFA.logout#&returnFA=#XFA.home#">Logout</a>
			</td>
		</tr>
	</cfoutput>
	</tbody>
</table>
