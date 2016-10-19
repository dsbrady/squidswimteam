<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!---
<fusedoc
	fuse = "dsp_attendance_sheet_print.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I print the blank attendance sheet, pre-populating active swimmers.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="21 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />

			<string name="date_practice" scope="attributes" />
			<string name="date_practice2" scope="attributes" />
		</in>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.date_practice" default="#Month(DateAdd("M",1,Now()))#-1-#Year(DateAdd("M",1,Now()))#" type="string">
	<cfparam name="attributes.date_practice2" default="#Month(DateAdd("M",1,Now()))#-#DaysInMonth(DateAdd("M",1,Now()))#-#Year(DateAdd("M",1,Now()))#" type="string">

	<cfset attributes.date_practice = Replace(attributes.date_practice,"-","/","ALL")>
	<cfset attributes.date_practice2 = Replace(attributes.date_practice2,"-","/","ALL")>

	<!--- Validate dates --->
	</cfsilent>
	<cfif NOT isDate(attributes.date_practice)>
		<script type="text/javascript">
			alert('The start date is not a valid date.');
			parent.document.forms['printForm'].elements['date_practice'].focus();
			parent.document.forms['printForm'].elements['date_practice'].select();
		</script>
		<cfabort>
	</cfif>
	<cfsilent>
	
	</cfsilent>
	<cfif NOT isDate(attributes.date_practice2)>
		<script type="text/javascript">
			alert('The end date is not a valid date.');
			parent.document.forms['printForm'].elements['date_practice2'].focus();
			parent.document.forms['printForm'].elements['date_practice2'].select();
		</script>
		<cfabort>
	</cfif>
	<cfsilent>

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

	<!--- Calculate practice dates in date range --->
	<cfinvoke  
		component="#Request.accounting_cfc#" 
		method="getPracticeDates" 
		returnvariable="aDates"
		dsn=#Request.DSN#
		defaultsTbl=#Request.practice_defaultTbl#
		date_begin=#attributes.date_practice#
		date_end=#attributes.date_practice2#
	>
</cfsilent>

<html>
<head>
	<link rel="P3Pv1" href="<cfoutput>#Request.theServer#</cfoutput>/w3c/p3p.xml">
<!--- SES stuff --->
<CFIF IsDefined("variables.baseHref")>
    <cfoutput><base href="#variables.baseHref#"></cfoutput>
</CFIF>
	<title><cfoutput>#Request.page_title#</cfoutput></title>
<cfif Request.js_validate IS NOT "">
	<script src="<cfoutput>#Request.js_validate#</cfoutput>" type="text/javascript"></script>
</cfif>
	<script src="<cfoutput>#Request.js_default#</cfoutput>" type="text/javascript"></script>
	<link media="print" rel="stylesheet" href="<cfoutput>#Request.ss_print#</cfoutput>">
</head>
<cfoutput>
<body onload="#Request.onLoad#">
<cfloop from="1" to="#ArrayLen(aDates)#" index="dateCount">
<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
	<thead>
		<tr>
			<td align="center">
				<h2>
					#Request.page_title# for #DateFormat(aDates[dateCount],"dddd, mmmm d, yyyy")#
				</h2>
			</td>
		</tr>
		<tr>
			<td>
				&nbsp;
			</td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td align="left">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tbody>
						<tr valign="top">
							<td align="left" width="200">
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
	<cfif dateCount LT ArrayLen(aDates)>
		<div id="pageBreak"></div>
	</cfif>
</cfloop>
</cfoutput>
</body>
</html>
