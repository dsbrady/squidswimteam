<!---
<fusedoc
	fuse = "dsp_news.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the news items.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="15 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />

			<string name="date_from" scope="attributes" />
			<string name="date_to" scope="attributes" />
		</in>
		<out>
			<string name="date_from" scope="formOrUrl" />
			<string name="date_to" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.date_from" default="#Month(DateAdd("m",-1,Now()))#-1-#Year(DateAdd("m",-1,Now()))#" type="string">
	<cfparam name="attributes.date_to" default="#DateFormat(Request.end_of_time,"M-D-YYYY")#" type="string">

	<cfset attributes.date_from = Replace(attributes.date_from,"-","/","ALL")>	
	<cfset attributes.date_to = Replace(attributes.date_to,"-","/","ALL")>	

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get News --->
	<cfinvoke  
		component="#Request.lookup_cfc#" 
		method="getNews" 
		returnvariable="qryNews"
		dsn=#Request.DSN#
		newsTbl=#Request.newsTbl#
		date_from=#attributes.date_from#
		date_to=#attributes.date_to#
		getAnnouncements=true
	>

	<!--- Get maximum news date if end date is end of time --->
	<cfif attributes.date_to IS DateFormat(Request.end_of_time,"M/D/YYYY")>
		<cfinvoke  
			component="#Request.lookup_cfc#" 
			method="getMinMaxValue" 
			returnvariable="qryMax"
			dsn=#Request.DSN#
			tblName=#Request.newsTbl#
			field="date_end"
		>

		<!--- If the to date is before today, get the end of the current month, otherwise keep it --->
		<cfif DateCompare(Now(),qryMax.maxVal) LT 0>
			<cfset attributes.date_to = DateFormat(qryMax.maxVal,"M/D/YYYY") />
		<cfelse>
			<cfset attributes.date_to = DateFormat(CreateDate(Year(Now()),Month(Now()),DaysInMonth(Now())),"M/D/YYYY") />
		</cfif>
		
	</cfif>
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
	</thead>
	<tbody>
		<tr valign="top">
			<td align="center">
			<form name="searchForm" action="#Request.self#/fuseaction/#attributes.fuseaction#.cfm" method="post">
				Display News from
				<input type="text" name="date_from" size="10" maxlength="10" value="#attributes.date_from#" />
				to
				<input type="text" name="date_to" size="10" maxlength="10" value="#attributes.date_to#" />
				<input type="submit" name="submitBtn" value="Search" />
			</form>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="center">
			<cfif qryNews.RecordCount>
				<table width="500">
					<tbody>
					<cfloop query="qryNews">
						<tr>
							<td align="center">
								<span class="newsHead">#qryNews.headline#</span>
								<span class="newsDate">(Posted #DateFormat(qryNews.date_start,"MMM D, YYYY")#)</span>
							</td>
						</tr>
						<tr>
							<td class="newsBody">
								#qryNews.article#
							</td>
						</tr>
						<tr>
							<td align="center">
								<hr style="width:350px" />
							</td>
						</tr>
					</cfloop>
					</tbody>
				</table>
			<cfelse>
				There are no articles matching your criteria.
			</cfif>
			</td>
		</tr>
	</tbody>
</table>
</cfoutput>

