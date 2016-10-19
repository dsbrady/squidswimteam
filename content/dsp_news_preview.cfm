<!---
<fusedoc
	fuse = "dsp_news_preview.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the news preview.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="14 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
				<string name="edit" />
				<string name="news" />
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
</cfif>

<cfoutput>
<form name="newsForm" action="#variables.baseHREF##Request.self#/fuseaction/#XFA.next#.cfm" method="post">
	<input type="hidden" name="news_id" value="#Request.squid.news.news_id#" />
	<input type="hidden" name="date_from" value="#attributes.date_from#" />
	<input type="hidden" name="date_to" value="#attributes.date_to#" />
	<input type="hidden" name="from_preview" value="true" />
<table width="500" border="0" cellpadding="0" cellspacing="0" align="center">
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
				> <a href="#Request.self#/fuseaction/#XFA.edit#/date_from/#Replace(attributes.date_from,"/","-","ALL")#/date_to/#Replace(attributes.date_to,"/","-","ALL")#.cfm">Edit</a>
				> Preview News
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td width="200">
				<strong>Start:</strong>
			</td>
			<td width="300">
				#Request.squid.news.date_start#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>End:</strong>
			</td>
			<td>
				#Request.squid.news.date_end#
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Headline:</strong>
			</td>
			<td class="newsHead">
				#Request.squid.news.headline#
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Article:</strong>
			</td>
			<td class="newsBody">
				#Request.squid.news.article#
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="editBtn" value="Edit" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
				<input type="submit" name="submitBtn" value="Save" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
				<input type="submit" name="cancelBtn" value="Cancel" class="buttonStyle" tabindex="#variables.tabindex#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

