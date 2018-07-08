<!---
<fusedoc
	fuse = "dsp_news_update"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the news edit form.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="14 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
				<string name="news" />
				<string name="preview" />
			</structure>

			<string name="date_from" scope="attributes" />
			<string name="date_to" scope="attributes" />

			<string name="date_start" scope="attributes" />
			<string name="date_end" scope="attributes" />
			<string name="headline" scope="attributes" />
			<string name="article" scope="attributes" />
			<number name="news_id" scope="attributes" />

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
			<string name="date_from" scope="formOrUrl" />
			<string name="date_to" scope="formOrUrl" />

			<string name="date_start" scope="formOrUrl" />
			<string name="date_end" scope="formOrUrl" />
			<string name="headline" scope="formOrUrl" />
			<string name="article" scope="formOrUrl" />
			<number name="news_id" scope="formOrUrl" />

			<string name="success" scope="formOrUrl" />
			<string name="reason" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.date_from" default="#DateFormat(Now(),"M-D-YYYY")#" type="string">
	<cfparam name="attributes.date_to" default="#DateFormat(DateAdd("M",1,Now()),"M-D-YYYY")#" type="string">

	<cfset attributes.date_from = Replace(attributes.date_from,"-","/","ALL")>
	<cfset attributes.date_to = Replace(attributes.date_to,"-","/","ALL")>

	<cfparam name="Request.squid.news.date_start" default="#DateFormat(Now(),"M/D/YYYY")#" type="string">
	<cfparam name="Request.squid.news.date_end" default="#DateFormat(DateAdd("M",1,Now()),"M/D/YYYY")#" type="string">
	<cfparam name="Request.squid.news.news_id" default=0 type="numeric">
	<cfparam name="Request.squid.news.headline" default="" type="string">
	<cfparam name="Request.squid.news.article" default="" type="string">
	<cfparam name="attributes.from_preview" default="false" type="boolean">

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<cfif attributes.news_id GT 0 AND attributes.success IS NOT "">
		<!--- Get current item --->
		<cfinvoke
			component="#Request.lookup_cfc#"
			method="getNews"
			returnvariable="qryNews"
			dsn=#Request.DSN#
			newsTbl=#Request.newsTbl#
			news_id=#VAL(attributes.news_id)#
		>

		<cfscript>
			if (attributes.success IS NOT "No")
			{
				Session.squid.news.article = qryNews.article;
				Session.squid.news.headline = qryNews.headline;
				Session.squid.news.date_start = qryNews.date_start;
				Session.squid.news.date_end = qryNews.date_end;

				Request.squid = StructCopy(Session.squid);
			}
		</cfscript>
	</cfif>

	<cfset variables.tabindex = 1>
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
<form id="newsForm" name="newsForm" action="#variables.baseHREF##Request.self#/fuseaction/#XFA.next#.cfm" method="post" onsubmit="return validate(this);">
	<input type="hidden" name="news_id" value="#VAL(attributes.news_id)#" />
	<input type="hidden" name="date_from" value="#attributes.date_from#" />
	<input type="hidden" name="date_to" value="#attributes.date_to#" />
<table width="550" border="0" cellpadding="0" cellspacing="0" align="center">
 	<thead>
		<tr>
			<td align="center" colspan="2">
				<h2>
					#Request.page_title#
				</h2>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr valign="top">
			<td align="center" colspan="2">
				<a href="#Request.self#/fuseaction/#XFA.menu#.cfm">Menu</a>
				> <a href="#Request.self#/fuseaction/#XFA.content_menu#.cfm">Content Menu</a>
				> <a href="#Request.self#/fuseaction/#XFA.news#/date_from/#Replace(attributes.date_from,"/","-","ALL")#/date_to/#Replace(attributes.date_to,"/","-","ALL")#.cfm">News</a>
				> <cfif VAL(attributes.news_id)>Update<cfelse>Post</cfif> News
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Start:</strong>
			</td>
			<td>
				<input type="text" name="date_start" size="10" maxlength="10" value="#DateFormat(Request.squid.news.date_start,"M/D/YYYY")#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>End:</strong>
			</td>
			<td>
				<input type="text" name="date_end" size="10" maxlength="10" value="#DateFormat(Request.squid.news.date_end,"M/D/YYYY")#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Headline:</strong>
			</td>
			<td>
				<input type="text" name="headline" size="35" maxlength="255" value="#Request.squid.news.headline#" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Article:</strong>
			</td>
			<td>
				<script type="text/javascript">
				Start('#JSStringFormat(Request.contentHtmlEditPath)#','#JSStringFormat(Request.squid.news.article)#','#JsStringFormat(Request.theServer)#','#JSStringFormat(XFA.file_select)#');
				</script>
				<iframe id="testFrame" style="position: absolute; visibility: hidden; width: 0px; height: 0px;"></iframe>
				<cfset variables.tabindex = variables.tabindex + 1>
				<input type="hidden" name="article" value="" />
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="previewBtn" value="Preview" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
				<input type="submit" name="submitBtn" value="Save" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
				<input type="reset" name="resetBtn" value="Reset Values" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

