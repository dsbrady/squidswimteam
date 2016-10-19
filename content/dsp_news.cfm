<!---
<fusedoc
	fuse = "dsp_news.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the news items.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="14 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="edit" />
				<string name="delete" />
			</structure>

			<string name="date_from" scope="attributes" />
			<string name="date_to" scope="attributes" />
		</in>
		<out>
			<string name="date_from" scope="formOrUrl" />
			<string name="date_to" scope="formOrUrl" />
			<number name="news_id" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.date_from" default="#DateFormat(Now(),"M/D/YYYY")#" type="string">
	<cfparam name="attributes.date_to" default="#DateFormat(DateAdd("M",1,Now()),"M/D/YYYY")#" type="string">

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
				<a href="#Request.self#/fuseaction/#XFA.menu#.cfm">Main Menu</a>
				> <a href="#Request.self#/fuseaction/#XFA.content_menu#.cfm">Content Menu</a>
				> News
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr valign="top">
			<td align="center">
				<a href="#Request.self#/fuseaction/#XFA.edit#/date_from/#Replace(attributes.date_from,"/","-","ALL")#/date_to/#Replace(attributes.date_to,"/","-","ALL")#.cfm">Add News</a>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
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
			<td align="center">
			<cfif qryNews.RecordCount>
				<table width="600" cellspacing="0" cellpadding="3" align="center" class="tableClass">
					<thead>
						<tr class="tableHead">
							<td>
								&nbsp;
							</td>
							<td align="center">
								<strong>Start</strong>
							</td>
							<td align="center">
								<strong>End</strong>
							</td>
							<td align="center">
								<strong>Headline</strong>
							</td>
							<td>
								&nbsp;
							</td>
						</tr>
					</thead>
					<tbody>
					<cfloop query="qryNews">
						<cfscript>
							variables.rowClass = qryNews.currentRow MOD 2;
						</cfscript>
						<tr class="tableRow#variables.rowClass#" valign="top">
							<td>
								<a href="#Request.self#/fuseaction/#XFA.edit#/success/maybe/news_id/#qryNews.news_id#/date_from/#Replace(attributes.date_from,"/","-","ALL")#/date_to/#Replace(attributes.date_to,"/","-","ALL")#.cfm">Edit</a>
							</td>
							<td>
								#DateFormat(qryNews.date_start,"M/D/YYYY")#
							</td>
							<td align="center">
								#DateFormat(qryNews.date_end,"M/D/YYYY")#
							</td>
							<td>
								#truncString(qryNews.headline,50)#
							</td>
							<td align="center">
								<a href="#Request.self#/fuseaction/#XFA.delete#/news_id/#qryNews.news_id#/date_from/#Replace(attributes.date_from,"/","-","ALL")#/date_to/#Replace(attributes.date_to,"/","-","ALL")#.cfm" onclick="return confirm('Delete #JsStringFormat(qryNews.headline)#?');">Delete</a>
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

