<!---
<fusedoc
	fuse = "dsp_officers_edit.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the officers edit form.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="30 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="next" />
				<string name="officers" />
			</structure>
			
			<number name="officer_type_id" scope="attributes" />
			<string name="user_id" scope="attributes" />

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
			<number name="officer_type_id" scope="formOrUrl" />
			<string name="user_id" scope="formOrUrl" />
		</out>
	</io>

</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.officer_type_id" default="0" type="numeric">
	<cfparam name="attributes.user_id" default="" type="string">
	<cfparam name="attributes.user_id_old" default="" type="string">
	
	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get officers --->
	<cfinvoke  
		component="#Request.lookup_cfc#" 
		method="getOfficers"
		returnvariable="qryOfficers"
		dsn=#Request.DSN#
		officer_typeTbl=#Request.officer_typeTbl#
		officerTbl=#Request.officerTbl#
		usersTbl=#Request.usersTbl#
		officer_type_id=#VAL(attributes.officer_type_id)#
		displayCoaches=false
		displayInactive=false
	>

	<!--- Get members --->
	<cfinvoke  
		component="#Request.lookup_cfc#" 
		method="getMembers"
		returnvariable="qryMembers"
		dsn=#Request.DSN#
		usersTbl=#Request.usersTbl#
		user_statusTbl=#Request.user_statusTbl#
		transaction_typeTbl=#Request.transaction_typeTbl#
		transactionTbl=#Request.practice_transactionTbl#
	>

	<cfscript>
		if (attributes.success IS NOT "No")
		{
			attributes.user_id = ValueList(qryOfficers.user_id);
			attributes.user_id_old = ValueList(qryOfficers.user_id);
		}
	</cfscript>

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
<form name="officerForm" action="#variables.baseHREF##Request.self#/fuseaction/#XFA.next#.cfm" method="post">
	<input type="hidden" name="officer_type_id" value="#attributes.officer_type_id#" />
	<input type="hidden" name="user_id_old" value="#attributes.user_id_old#" />
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
				> <a href="#Request.self#/fuseaction/#XFA.officers#.cfm">Officers</a>
				> Update #qryOfficers.officer_type#
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Officer:</strong>
			</td>
			<td>
				#qryOfficers.officer_type#
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr class="footer" valign="top">
			<td>
				&nbsp;
			</td>
			<td align="left">
				(Hold CTRL [Option on the Mac] to select multiple people)
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Members:</strong>
			</td>
			<td>
				<select name="user_id" tabindex="#variables.tabindex#" multiple="multiple" size="15">
				<cfloop query="qryOfficers">
					<option value="#qryOfficers.user_id#" <cfif ListFind(attributes.user_id,qryOfficers.user_id)>selected="selected"</cfif>>#qryOfficers.preferred_name# #qryOfficers.last_name#</option>
				</cfloop>
			<cfloop query="qryMembers">
				<cfif NOT ListFind(ValueList(qryOfficers.user_id),qryMembers.user_id)>
					<option value="#qryMembers.user_id#" <cfif ListFind(attributes.user_id,qryMembers.user_id)>selected="selected"</cfif>>#qryMembers.preferred_name# #qryMembers.last_name#</option>
				</cfif>
			</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
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

