<!---
<fusedoc
	fuse = "dsp_minutes.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the meeting minutes.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="17 June 2006" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
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
			<td align="center">
				<a href="#Request.self#?fuseaction=#XFA.menu#">Menu</a>
				> Meeting Minutes
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
			<cfif qMinutes.RecordCount>
				<table cellspacing="0" cellpadding="3" align="center" class="tableClass" width="80%">
					<thead>
						<tr class="tableHead">
							<td>
								<strong>File Type</strong>
							</td>
							<td>
								<strong>Description</strong>
							</td>
						</tr>
					</thead>
					<tbody>
					<cfloop query="qMinutes">
						<cfscript>
							variables.rowClass = qMinutes.currentRow MOD 2;
						</cfscript>
						<tr class="tableRow#variables.rowClass#" valign="top">
							<td>
								#qMinutes.file_type#
							</td>
							<td>
								<a href="#Request.theServer#/files/#qMinutes.fileName#" target="_blank">#qMinutes.description#</a>
							</td>
						</tr>
					</cfloop>
					</tbody>
				</table>
			<cfelse>
				There are no meeting minutes at this time.
			</cfif>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>

