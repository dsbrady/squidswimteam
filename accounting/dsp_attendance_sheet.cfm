<!---
<fusedoc
	fuse = "dsp_attendance_sheet.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the blank attendance sheet, pre-populating active swimmers for printing..
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="21 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="print" />
			</structure>
		</in>
		<out>
			<string name="date_practice" scope="formOrUrl" />
			<string name="date_practice2" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.date_practice" default="#Month(DateAdd("M",1,Now()))#-1-#Year(DateAdd("M",1,Now()))#" type="string">
	<cfparam name="attributes.date_practice2" default="#Month(DateAdd("M",1,Now()))#-#DaysInMonth(DateAdd("M",1,Now()))#-#Year(DateAdd("M",1,Now()))#" type="string">
	<cfset attributes.date_practice = Replace(attributes.date_practice,"-","/","ALL")>
	<cfset attributes.date_practice2 = Replace(attributes.date_practice2,"-","/","ALL")>

	<cfset variables.linesPerColumn = 21>
	<!--- Get all members --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getMembers"
		returnvariable="qryAllMembers"
		dsn=#Request.DSN#
		usersTbl=#Request.usersTbl#
		user_statusTbl=#Request.user_statusTbl#
		transactionTbl=#Request.practice_transactionTbl#
		transaction_typeTbl=#Request.transaction_typeTbl#
		activityDays=#Request.activityDays#
	>

	<!--- Get active members --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getMembersActivity"
		returnvariable="qryMembers"
		qrySource=#qryAllMembers#
		activityLevel="active"
		statusType="Member"
	>
</cfsilent>

<cfoutput>
<form name="printForm" action="##" method="post" onsubmit="return validate(this,'#variables.baseHREF##Request.self#?fuseaction=#XFA.print#');">
<table width="600" border="0" cellpadding="0" cellspacing="0" align="center">
	<thead>
		<tr>
			<td align="center">
				<h2>
					#Request.page_title#
					<br />
					from <input type="text" name="date_practice" size="10" maxlength="10" value="#attributes.date_practice#" />
					to <input type="text" name="date_practice2" size="10" maxlength="10" value="#attributes.date_practice2#" />
					<input type="submit" name="submitBtn" class="buttonStyle" value="Print" />
					<br />
					<span class="footer">(Print in Landscape mode)</span>
				</h2>
			</td>
		</tr>
		<tr valign="top">
			<td align="center">
				<a href="#Request.self#?fuseaction=#XFA.menu#">Main Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.acct_menu#">Accounting Menu</a>
				> Attendance Sheet
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</thead>
</table>
<table width="1000" border="0" cellpadding="0" cellspacing="0" align="center">
	<tbody>
		<tr>
			<td align="left">
				<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:rgb(225,236,238)">
					<tbody>
						<tr valign="top">
							<td align="left">
								<table width="600" cellpadding="3" cellspacing="0" class="tableClass">
									<tbody>
									<cfloop from="1" to="#variables.linesPerColumn#" index="i">
										<tr>
											<td width="30" class="tableCell">
												&nbsp;
											</td>
											<td width="170" class="tableCell">
											<cfset count = i>
											<cfif qryMembers.RecordCount GTE count>
												<strong>#qryMembers.preferred_name[count]# #qryMembers.last_name[count]#</strong>
											<cfelse>
												&nbsp;
											</cfif>
											</td>
											<td width="30" class="tableCell">
												&nbsp;
											</td>
											<td width="170" class="tableCell">
											<cfset count = i + variables.linesPerColumn>
											<cfif qryMembers.RecordCount GTE count>
												<strong>#qryMembers.preferred_name[count]# #qryMembers.last_name[count]#</strong>
											<cfelse>
												&nbsp;
											</cfif>
											</td>
											<td width="30" class="tableCell">
												&nbsp;
											</td>
											<td width="170" class="tableCell">
											<cfset count = count + variables.linesPerColumn>
											<cfif qryMembers.RecordCount GTE count>
												<strong>#qryMembers.preferred_name[count]# #qryMembers.last_name[count]#</strong>
											<cfelse>
												&nbsp;
											</cfif>
											</td>
										</tr>
									</cfloop>
									</tbody>
								</table>
							</td>
							<td width="50">
								&nbsp;
							</td>
							<td align="left" width="540">
								<span style="height:25px"><strong>Guests</strong></span>
								<table width="150" cellpadding="3" cellspacing="0" class="tableClass">
									<tbody>
										<tr valign="top">
											<td class="tableCell">
												&nbsp;
											</td>
										</tr>
										<tr valign="top">
											<td class="tableCell">
												&nbsp;
											</td>
										</tr>
										<tr valign="top">
											<td class="tableCell">
												&nbsp;
											</td>
										</tr>
										<tr valign="top">
											<td class="tableCell">
												&nbsp;
											</td>
										</tr>
									</tbody>
								</table>
								<span style="height:45px"><br /></span>
								<table width="275" cellpadding="3" cellspacing="0">
									<tbody>
										<tr valign="top">
											<td class="tableCellNoBorder">
												<strong>Facility</strong>
											</td>
											<td class="tableCellNoBorder">
												_____________
											</td>
										</tr>
										<tr valign="top">
											<td class="tableCellNoBorder">
												<strong>Coach</strong>
											</td>
											<td class="tableCellNoBorder">
												_____________
											</td>
										</tr>
										<tr valign="top">
											<td class="tableCellNoBorder">
												<strong>Attendance Taken By</strong>
											</td>
											<td class="tableCellNoBorder">
												_____________
											</td>
										</tr>
									</tbody>
								</table>
								<span style="height:45px"><br /></span>
								<table width="150" cellpadding="3" cellspacing="0" class="tableClass">
									<tbody>
										<tr valign="top">
											<td class="tableCell" width="30">
												&nbsp;
											</td>
											<td class="tableCell" width="120">
												Members
											</td>
										</tr>
										<tr valign="top">
											<td class="tableCell">
												&nbsp;
											</td>
											<td class="tableCell">
												Guests
											</td>
										</tr>
										<tr valign="top">
											<td class="tableCell">
												&nbsp;
											</td>
											<td class="tableCell">
												Total Attendance
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
	</tbody>
</table>
</form>
<iframe name="PageProcessing" id="PageProcessing" style="height:0px;width:0px;display:inline"></iframe>
</cfoutput>
