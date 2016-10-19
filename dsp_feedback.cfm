<!---
<fusedoc fuse="dsp_feedback.cfm" language="ColdFusion" specification="3.0">
	<responsibilities>
		I display feedback page.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="26 October 2003" type="Create" role="Architect">
	</properties>
	<io>
		<in>
			<structure name="XFA">
				<string name="next" />
			</structure>

			<number name="officer_type_id" scope="attributes" />
			<string name="sender_name" scope="attributes" />
			<string name="sender_email" scope="attributes" />
			<string name="sender_phone" scope="attributes" />
			<string email="subject" scope="attributes" />
			<string name="content" scope="attributes" />

			<string name="success" scope="attributes" />
			<string name="reason" scope="attributes" />
		</in>
		<out>
			<number name="officer_type_id" scope="formOrUrl" />
			<string name="sender_name" scope="formOrUrl" />
			<string name="sender_email" scope="formOrUrl" />
			<string name="sender_phone" scope="formOrUrl" />
			<string email="subject" scope="formOrUrl" />
			<string name="content" scope="formOrUrl" />
		</out>
	</io>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.officer_type_id" default=0 type="numeric">
	<cfparam name="attributes.sender_name" default="" type="string">
	<cfparam name="attributes.sender_email" default="" type="string">
	<cfparam name="attributes.sender_phone" default="" type="string">
	<cfparam name="attributes.subject" default="" type="string">
	<cfparam name="attributes.content" default="" type="string">

	<cfparam name="attributes.success" default="" type="string">
	<cfparam name="attributes.reason" default="" type="string">

	<!--- Get Officer Types --->
	<cfinvoke
		component="#Request.lookup_cfc#"
		method="getOfficerTypes"
		returnvariable="qryOfficers"
		dsn=#Request.DSN#
		officerTypeTbl=#Request.officer_typeTbl#
		feedbackOnly=true
	>

	<cfset variables.tabindex = 1>
	
	<cfset Cffp = createObject("component","cfformprotect.cffpVerify").init() />
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
<form name="feedbackForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post" onsubmit="return validate(this);">
<cfinclude template="/cfformprotect/cffp.cfm" />

<table width="600" border="0" cellpadding="0" cellspacing="0" align="center">
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
			<td colspan="2">
				Fill out the following form to send your feedback/comments/questions to SQUID.
				<br />
				Fields marked with <span class="errorText">*</span> are required.
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Send To<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<select name="officer_type_id" tabindex="#variables.tabindex#">
					<option value="0" <cfif VAL(attributes.officer_type_id) EQ 0>selected="selected"</cfif>>(Select From Below)</option>
				<cfloop query="qryOfficers">
					<option value="#qryOfficers.officer_type_id#" <cfif VAL(attributes.officer_type_id) EQ qryOfficers.officer_type_id>selected="selected"</cfif>>#qryOfficers.officer_type#</option>
				</cfloop>
				</select>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Your Name<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<input type="text" name="sender_name" size="35" maxlength="255" tabindex="#variables.tabindex#" value="#attributes.sender_name#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Your E-mail<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<input type="text" name="sender_email" size="35" maxlength="255" tabindex="#variables.tabindex#" value="#attributes.sender_email#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Your Phone:</strong>
			</td>
			<td>
				<input type="text" name="sender_phone" size="20" maxlength="255" tabindex="#variables.tabindex#" value="#attributes.sender_phone#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Subject:</strong>
			</td>
			<td>
				<input type="text" name="subject" size="35" maxlength="255" tabindex="#variables.tabindex#" value="#attributes.subject#" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Message<span class="errorText">*</span>:</strong>
			</td>
			<td>
				<textarea name="content" rows="10" cols="50" tabindex="#variables.tabindex#">#attributes.content#</textarea>
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="2" align="center">
				<input type="submit" name="submitBtn" value="Send Inquiry" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1>
				&nbsp;&nbsp;&nbsp;
				<input type="reset" name="resetBtn" value="Reset Form" tabindex="#variables.tabindex#" class="buttonStyle" />
				<cfset variables.tabindex = variables.tabindex + 1>
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>
