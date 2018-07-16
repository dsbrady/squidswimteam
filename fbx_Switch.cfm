<!---
<fusedoc fuse="FBX_Switch.cfm">
	<responsibilities>
		I am the cfswitch statement that handles the fuseaction, delegating work to various fuses.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="15 December 2002" role="Architect">
	</properties>
	<io>
		<in>
			<structure name="fuxebox">
				<string name="fuseaction" />
				<string name="circuit" />
			</structure>
		</in>
	</io>
</fusedoc>
 --->

<cfswitch expression = "#fusebox.fuseaction#">
	<cfcase value="dsp_content,start,dsp_start,fusebox.defaultfuseaction">
		<cfsilent>
			<!--- This will display content pages (for any regular pages) --->
			<cfparam name="attributes.page" default="Home" type="string">
			<cfscript>
				contentCFC = createObject("component","#Request.lookup_cfc#");
				qryContent = contentCFC.getContent(dsn = Request.dsn, pageTbl=Request.pageTbl, page=URLDecode(attributes.page));

				Request.page_title = Request.page_title & " - " & qryContent.title;
				Request.template = "dsp_content.cfm";
			</cfscript>
		</cfsilent>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_unsubscribe">
	<cfsilent>
	<!--- Submits info --->
		<cfparam name="attributes.uid" type="string" />

		<cfset XFA.success = "home.dsp_unsubscribeResults" />

		<cfset Request.suppressLayout = true />

		<cfset Request.membersCFC = createObject("component","cfc.members") />

		<cfset Request.results = Request.membersCFC.unsubscribe(Request.dsn,attributes.uid,Request.encryptionKey,Request.encryptionAlgorithm,Request.encryptionEncoding) />
		<cfset Request.template = "act_next.cfm" />

		<cfset success = Request.results.success />
		<cfset reason = Request.results.reason />

		<cfinclude template="#Request.template#" />
	</cfsilent>
	</cfcase>

	<cfcase value="dsp_unsubscribeResults">
	<!--- Displays Unsubscribe Results --->
		<cfparam name="attributes.success" default="true" type="boolean" />
		<cfparam name="attributes.reason" default="" type="string" />

		<cfset Request.template = "dsp_unsubscribeResults.cfm" />
		<cfif attributes.success>
			<cfset Request.page_title = Request.page_title & "<br />Unsubscribe Succeeded" />
		<cfelse>
			<cfset Request.page_title = Request.page_title & "<br />Unsubscribe Failed" />
		</cfif>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_feedback">
		<cfscript>
			Request.page_title = Request.page_title & " - Contact Us";
			Request.js_validate = "javascript/feedback.js";
			Request.template = "dsp_feedback.cfm";
			Request.onLoad = Request.onLoad & "document.forms['feedbackForm'].elements.officer_type_id.focus();";

			XFA.next ="home.act_feedback";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_feedback">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "home.dsp_feedback_results";
			XFA.failure = "home.dsp_feedback";

			Request.suppressLayout = true;

			Request.feedback_cfc = Request.cfcPath & ".feedback";
			Request.validation_template = "val_feedback.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="dsp_feedback_results">
		<cfscript>
			Request.page_title = Request.page_title & " - Feedback Submitted";
			Request.template = "dsp_feedback_results.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_news">
		<cfsilent>
		<!--- Displays News  --->
			<cfscript>
				contentCFC = createObject("component","#Request.lookup_cfc#");
				qryContent = contentCFC.getContent(dsn = Request.dsn, pageTbl=Request.pageTbl, page="News");

				Request.page_title = Request.page_title & " - " & qryContent.title;
				Request.template = "dsp_news.cfm";
			</cfscript>
		</cfsilent>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_gallery">
	<!--- Displays Gallery --->
		<cfscript>
			Request.page_title = Request.page_title & " - Gallery";
			Request.template = "dsp_gallery.cfm";

			XFA.details = "home.dsp_gallery_page";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_gallery_page">
	<!--- Displays Gallery Page --->
		<cfscript>
			Request.image_cfc = Request.cfcPath & ".image";
			Request.page_title = Request.page_title & " - Gallery";

			Request.template = "dsp_gallery_page.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_links">
		<cfsilent>
		<!--- Displays Links  --->
			<cfscript>
				contentCFC = createObject("component","#Request.lookup_cfc#");
				qryContent = contentCFC.getContent(dsn = Request.dsn, pageTbl=Request.pageTbl, page="Links");

				Request.page_title = Request.page_title & " - " & qryContent.title;
				Request.template = "dsp_links.cfm";
			</cfscript>
		</cfsilent>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_sitemap">
		<cfscript>
			Request.page_title = Request.page_title & " - Site Map";
			Request.template = "dsp_sitemap.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_tester_email">
		<cfscript>
			Request.page_title = Request.page_title & " - Tester E-mail";
			Request.lookup_cfc = Request.cfcPath & ".lookup_queries";
			Request.template = "dsp_tester_email.cfm";

			XFA.next = "home.act_tester_email";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_tester_email">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "home.dsp_tester_email";
			XFA.failure = "members.dsp_tester_email";

			Request.suppressLayout = true;

			Request.lookup_cfc = Request.cfcPath & ".lookup_queries";
			Request.validation_template = "val_tester_email.cfm";
			Request.template = "act_tester_email.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>


	<cfdefaultcase>
		<!---This will just display an error message and is useful in catching typos of fuseaction names while developing--->
		<cfoutput>This is the cfdefaultcase tag. I received a fuseaction called <strong>"#attributes.fuseaction#"</strong> and I don't know what to do with it.</cfoutput>
	</cfdefaultcase>

</cfswitch>
