<!---
<fusedoc
	fuse = "dsp_attendance_graph.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the attendance graph.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="5 July 2004" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<datetime name="fromDate" />
			<datetime name="toDate" />
			<list name="dow" />
		</in>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.fromDate" default="#DateFormat(CreateDate(Year(Now()),1,1),"m/d/yyyy")#" type="string">
	<cfparam name="attributes.toDate" default="#DateFormat(Now(),"m/d/yyyy")#" type="string">
	<cfparam name="attributes.dow" default="3,5,7" type="string">
	<cfparam name="attributes.includeVisitors" default="false" type="boolean">

	<cfset attributes.fromDate = Replace(attributes.fromDate,"-","/","ALL")>
	<cfset attributes.toDate = Replace(attributes.toDate,"-","/","ALL")>

	<!--- Get Attendance Data --->
	<cfinvoke
		component="#Request.accounting_cfc#"
		method="getAttendanceData"
		returnvariable="qAttendance"
		dsn=#Request.DSN#
		transactionTbl=#Request.practice_transactionTbl#
		transactionTypeTbl=#Request.transaction_typeTbl#
		fromDate=#attributes.fromDate#
		toDate=#attributes.toDate#
		dow=#attributes.dow#
		includeVisitors=#attributes.includeVisitors#
	>
</cfsilent>

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
		<tr valign="top">
			<td align="center">
				<a href="#Request.self#?fuseaction=#XFA.menu#">Main Menu</a>
				> <a href="#Request.self#?fuseaction=#XFA.acct_menu#">Accounting Menu</a>
				> Attendance Graph
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td align="center">
			<form name="graphForm" action="#variables.baseHREF##Request.self#?fuseaction=#attributes.fuseaction#" method="post">
				<table width="500">
					<tbody>
						<tr valign="middle">
							<td align="center">
								<input type="text" name="fromDate" size="10" maxlength="10" tabindex="1" value="#attributes.fromDate#" />
							</td>
							<td align="center">
								to
							</td>
							<td align="center">
								<input type="text" name="toDate" size="10" maxlength="10" tabindex="2" value="#attributes.toDate#" />
							</td>
							<td>
								<input type="checkbox" name="includeVisitors" tabindex="3" value="true" <cfif attributes.includeVisitors>checked="checked"</cfif> />
								Include Visitors
							</td>
							<td rowspan="2">
								<input type="submit" name="submitBtn" tabindex="3" class="buttonStyle" value="Get Graph" />
							</td>
						</tr>
						<tr valign="middle">
							<td align="center" colspan="4">
							<cfloop from="1" to="7" index="i">
								#Left(DayOfWeekAsString(i),3)#
								<input type="checkbox" name="dow" value="#i#" <cfif ListFind(attributes.dow,i)>checked="checked"</cfif> />
							</cfloop>
							</td>
						</tr>
					</tbody>
				</table>
			</form>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="center">
				<div align="left">
					Total Attendance for #attributes.fromDate#<cfif attributes.fromDate NEQ attributes.toDate> - #attributes.toDate#</cfif>:
					<strong>#VAL(ArraySum(ListToArray(ValueList(qAttendance.numSwimmers))))#</strong>
				</div>
				<cfchart
					format="jpg"
					chartHeight="500"
					chartWidth="700"
					scaleFrom="0"
					scaleTo="36"
					showXGridlines="Yes"
					showYGridlines="Yes"
					gridlines="10"
					foregroundcolor="black"
					databackgroundcolor="white"
					showBorder="yes"
					font="arial"
					fontSize="11"
					fontBold="yes"
					labelFormat="number"
					xAxisTitle="Practice Dates"
					yAxisTitle="Number of Swimmers"
					sortXAxis="no"
					show3D="no"
					showMarkers="yes"
					url="#Request.self#?fuseaction=#XFA.practice#&practiceDate=$ITEMLABEL$"
				>
					<cfchartseries
						type="bar"
					>
						<cfloop query="qAttendance">
							<cfchartdata
								item="#DateFormat(qAttendance.date_transaction,"m-d-yyyy")#"
								value="#qAttendance.numSwimmers#"
							>
						</cfloop>
					</cfchartseries>
				</cfchart>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>
