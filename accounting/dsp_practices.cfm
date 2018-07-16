<!---
<fusedoc
	fuse = "dsp_practices.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the practices.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="14 September 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="edit" />
				<string name="delete" />
			</structure>

			<string name="date_start" scope="attributes" />
			<string name="date_end" scope="attributes" />
		</in>
		<out>
			<number name="practice_id" scope="formOrUrl" />
			<string name="date_start" scope="formOrUrl" />
			<string name="date_end" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.date_start" default="#Month(Now())#-1-#Year(Now())#" type="string">
	<cfparam name="attributes.date_end" default="#DateFormat(Now(),"M-D-YYYY")#" type="string">

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<cfscript>
		attributes.date_start = Replace(attributes.date_start,"-","/","ALL");
		attributes.date_end = Replace(attributes.date_end,"-","/","ALL");
	</cfscript>

	<!--- Get Practices --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getPractices"
		returnvariable="qryPractices"
		dsn=#Request.DSN#
		practicesTbl=#Request.practicesTbl#
		usersTbl=#Request.usersTbl#
		facilityTbl=#Request.facilityTbl#
		date_start=#attributes.date_start#
		date_end=#attributes.date_end#
	>
</cfsilent>

<cfif attributes.success IS "no">
	<h2>There were problems with your submission:</h2>
	<ul class="errorText">
		<cfloop list="#attributes.reason#" index="variables.theItem" delimiters="*">
			<li><cfoutput>#variables.theItem#</cfoutput></li>
		</cfloop>
	</ul>
	<p>Please make corrections below and re-submit the information.</p>
<cfelseif attributes.success IS "yes">
	<p class="errorText">
		<cfoutput>#attributes.reason#</cfoutput>
	</p>
</cfif>

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
				<a href="#Request.self#?fuseaction=#XFA.menu#">Main Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.acct_menu#">Accounting Menu</a>
				> Practices
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center">
				<a href="#Request.self#?fuseaction=#XFA.edit#&date_start=#attributes.date_start#&date_end=#attributes.date_end#">Add Practice</a>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center">
			<form name="practiceForm" action="#variables.baseHREF##Request.self#?fuseaction=#attributes.fuseaction#" method="post" onsubmit="return validate(this);">
				<table width="400">
					<tbody>
						<tr valign="middle">
							<td>
								<input type="text" name="date_start" size="10" maxlength="10" tabindex="1" value="#attributes.date_start#" />
							</td>
							<td>
								to
							</td>
							<td>
								<input type="text" name="date_end" size="10" maxlength="10" tabindex="2" value="#attributes.date_end#" />
							</td>
							<td>
								<input type="submit" name="submitBtn" tabindex="3" class="buttonStyle" value="Get Practices" />
							</td>
						</tr>
					</tbody>
				</table>
			</form>
			</td>
		</tr>
		<tr>
			<td>
			<cfif qryPractices.RecordCount>
				<table width="600" cellspacing="0" cellpadding="3" align="center" class="tableClass">
					<thead>
						<tr class="tableHead">
							<td>
								&nbsp;
							</td>
							<td align="center">
								<strong>Date</strong>
							</td>
							<td align="center">
								<strong>Members</strong>
							</td>
							<td align="center">
								<strong>Guests</strong>
							</td>
							<td>
								<strong>Coach</strong>
							</td>
							<td>
								<strong>Facility</strong>
							</td>
							<td>
								<strong>Notes</strong>
							</td>
							<td>
								&nbsp;
							</td>
						</tr>
					</thead>
					<tbody>
					<cfloop query="qryPractices">
						<cfscript>
							variables.rowClass = qryPractices.currentRow MOD 2;
						</cfscript>
						<tr class="tableRow#variables.rowClass#" valign="top">
							<td align="center">
								<a href="#Request.self#?fuseaction=#XFA.delete#&practice_id=#qryPractices.practice_id#&date_start=#attributes.date_start#&date_end=#attributes.date_end#" onclick="return confirm('Delete #DateFormat(qryPractices.date_practice,"M/D/YYYY")#?');">Delete</a>
							</td>
							<td>
								#DateFormat(qryPractices.date_practice,"M/D/YYYY")#
							</td>
							<td align="center">
								#qryPractices.members#
							</td>
							<td align="center">
								#qryPractices.guests#
							</td>
							<td>
								#qryPractices.coach#
							</td>
							<td>
								#qryPractices.facility#
							</td>
							<td>
								#qryPractices.notes#
							</td>
							<td align="center">
								<a href="#Request.self#?fuseaction=#XFA.edit#&practice_id=#qryPractices.practice_id#&date_start=#attributes.date_start#&date_end=#attributes.date_end#">Edit</a>
							</td>
						</tr>
					</cfloop>
					</tbody>
				</table>
			<cfelse>
				There are no practices.
			</cfif>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>

