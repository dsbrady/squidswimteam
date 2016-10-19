<!---
<fusedoc
	fuse = "dsp_coachingSummary.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the summary of coaching for specified time frame.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="24 April 2005" type="Create" />
	</properties>
	<io>
		<in>
			<string name="self" />
			<number name="monthFrom" scope="attributes" />
			<datetime name="yearFrom" scope="attributes" />
			<number name="monthTo" scope="attributes" />
			<datetime name="yearTo" scope="attributes" />
		</in>
		<out>
			<number name="monthFrom" scope="formOrUrl" />
			<datetime name="yearFrom" scope="formOrUrl" />
			<number name="monthTo" scope="formOrUrl" />
			<datetime name="yearTo" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfoutput>
<form name="summaryForm" action="#variables.baseHREF##Request.self#?fuseaction=#attributes.fuseaction#" method="post" onsubmit="return validate(this);">
<table width="600" border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td align="center">
				<h2>
					#Request.page_title#
					<br />
					from
					<select name="monthFrom">
					<cfloop from="1" to="12" index="i">
						<option value="#i#" <cfif i EQ attributes.monthFrom>selected="selected"</cfif>>#i#</option>
					</cfloop>
					</select>
					/
					<select name="yearFrom">
					<cfloop from="#variables.firstYear#" to="#Year(Now())#" index="i">
						<option value="#i#" <cfif i EQ attributes.yearFrom>selected="selected"</cfif>>#i#</option>
					</cfloop>
					</select>
					to
					<select name="monthTo">
					<cfloop from="1" to="12" index="i">
						<option value="#i#" <cfif i EQ attributes.monthTo>selected="selected"</cfif>>#i#</option>
					</cfloop>
					</select>
					/
					<select name="yearTo">
					<cfloop from="#variables.firstYear#" to="#Year(Now())#" index="i">
						<option value="#i#" <cfif i EQ attributes.yearTo>selected="selected"</cfif>>#i#</option>
					</cfloop>
					</select>
					<input type="submit" name="submitBtn" class="buttonStyle" value="Get Summary" />
				</h2>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr valign="top">
			<td align="center">
				<a href="#Request.self#?fuseaction=#XFA.menu#">Main Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.acct_menu#">Accounting Menu</a>
				> Coaching Summary
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
</cfoutput>
		<tr>
			<td>
			<cfif qSummary.RecordCount>
				<cfoutput query="qSummary" group="practiceMonth">
					<table width="400" cellspacing="0" cellpadding="3" align="center" class="tableClass">
						<thead>
							<tr class="tableHead">
								<td colspan="2">
									<strong>#qSummary.practiceMonth#</strong>
								</td>
							</tr>
						</thead>
					<tbody>
					<cfset variables.rowClass = 1 />
					<cfoutput>
						<tr class="tableRow#variables.rowClass#">
						<cfif variables.rowClass EQ 1>
							<cfset variables.rowClass = 0 />
						<cfelse>
							<cfset variables.rowClass = 1 />
						</cfif>
							<td>#qSummary.preferred_name# #qSummary.last_name#</td>
							<td>#qSummary.numPractices#</td>
						</tr>
					</cfoutput>
					</tbody>
					</table>
					<br /><br />
				</cfoutput>
			<cfelse>
				There are no practices in the month<cfif attributes.monthFrom NEQ attributes.monthTo OR attributes.yearFrom NEQ attributes.yearTo>s</cfif> specified.
			</cfif>
			</td>
		</tr>
	</tbody>
</table>
</form>

