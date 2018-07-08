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
<!--- ----------------------------------------
MENU
----------------------------------------- --->
	<cfcase value="start,dsp_start,fusebox.defaultfuseaction">
		<!---This will be the value returned if someone types in "circuitname.", omitting the actual fuseaction request--->
		<cfscript>
			XFA.files = "content.dsp_files";
			XFA.content = "content.dsp_update_content";
			XFA.news = "content.dsp_news";
			XFA.contentGallery = "content.dsp_gallery";
			XFA.links = "content.dsp_links";
			XFA.trainingResources = "content.dsp_trainingResources";

			Request.template = "dsp_start.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

<!--- ----------------------------------------
UPLOAD FILES
----------------------------------------- --->
	<cfcase value="dsp_files">
	<!--- Displays List of Uploaded Files --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Update Files";
			Request.template = "dsp_files.cfm";
			Request.js_validate = "content/javascript/files.js";

			XFA.upload = "content.dsp_files_upload";
			XFA.delete = "content.act_files_delete";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_files_upload">
	<!--- Displays Transaction Edit form--->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Upload Files";
			Request.js_validate = "content/javascript/files_upload.js";
			Request.template = "dsp_files_upload.cfm";

			XFA.next = "content.act_files_upload";
			XFA.files = "content.dsp_files";

			Request.onLoad = Request.onLoad & "document.fileForm.category_id.focus();";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_files_upload">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "content.dsp_files";
			XFA.failure = "content.dsp_files_upload";

			Request.suppressLayout = true;

			Request.validation_template = "val_files_upload.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="act_files_delete">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "content.dsp_files";
			XFA.failure = "content.dsp_files";

			Request.suppressLayout = true;

			Request.validation_template = "val_files_delete.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

<!--- ----------------------------------------
UPDATE CONTENT
----------------------------------------- --->
	<cfcase value="dsp_update_content">
	<!--- Displays Content Edit form--->
		<cfparam name="attributes.page" default="Home" type="string">
		<cfscript>
			Request.page_title = Request.page_title & "<br />Update " & attributes.page & " Page";
			Request.js_validate = "content/javascript/update_content.js";
			Request.template = "dsp_update_content.cfm";
			arrayAppend(request.jsOther,request.htmlEditor);

			XFA.next = "content.act_update_content";
			XFA.file_select = "content.dsp_file_select";
			XFA.preview = "members.dsp_content_preview";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_file_select">
	<!--- Displays File Selection page --->
		<cfparam name="attributes.imageYN" default="" type="string">
		<cfscript>
			Request.page_title = Request.page_title & "<br />Select ";
			if (attributes.imageYN IS "Yes")
			{
				Request.page_title = Request.page_title & "Image";
			}
			else
			{
				Request.page_title = Request.page_title & "File";
			}

			Request.onLoad = Request.onLoad & "this.window.focus();";
			Request.js_validate = "content/javascript/file_select.js";
			Request.template = "dsp_file_select.cfm";

			Request.suppressLayout = true;
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_update_content">
	<cfsilent>
	<!--- Submits info --->
		<cfparam name="attributes.page" default="Home" type="string">
		<cfscript>
			XFA.success = "content.dsp_update_content";
			XFA.failure = "content.dsp_update_content";
			XFA.preview = "content.dsp_content_preview";

			Request.suppressLayout = true;

			Request.validation_template = "val_update_content.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="dsp_content_preview">
		<cfparam name="Request.squid.content.page" default="Home" type="string">
	<!--- Displays Content Preview --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Preview " & Request.squid.content.page & " Page";
			Request.template = "dsp_content_preview.cfm";

			XFA.next = "content.act_update_content";
			XFA.edit = "content.dsp_update_content";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

<!--- ----------------------------------------
UPDATE TRAINING RESOURCES
----------------------------------------- --->
	<cfcase value="dsp_trainingResources">
	<!--- Displays Training Resources --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Training Resources";
			Request.template = "dsp_trainingResources.cfm";

			XFA.viewTrainingResource = "members.dsp_viewTrainingResource";
			XFA.edit = "content.dsp_editTrainingResource";
			XFA.delete = "content.act_deleteTrainingResource";
		</cfscript>

		<cfset request.qTrainingResources = request.objTrainingResources.getRecentTrainingResourcesByUserIDAsQuery(request.dsn,0,0) />

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_editTrainingResource">
	<!--- Displays Training Resource update page --->
		<cfparam name="attributes.trainingResourceID" default="0" type="numeric" />
		<cfparam name="attributes.trainingResourceTypeID" default="1" type="numeric" />
		<cfparam name="attributes.trainingResource" default="" type="string" />
		<cfparam name="attributes.description" default="" type="string" />
		<cfparam name="attributes.resourceContent" default="" type="string" />

		<cfparam name="attributes.success" default="true" type="boolean" />
		<cfparam name="attributes.reason" default="" type="string" />

		<cfif attributes.trainingResourceID GT 0>
			<cfset request.pageSubtitle = "Update Training Resource" />
		<cfelse>
			<cfset request.pageSubtitle = "Add Training Resource" />
		</cfif>
		<cfset request.page_title = Request.page_title & "<br />" & request.pageSubtitle />
		<cfset request.template = "dsp_editTrainingResource.cfm" />
		<cfset request.onLoad = Request.onLoad & "document.forms['editForm'].elements['trainingResource'].focus();document.forms['editForm'].elements['trainingResource'].select();" />

		<cfset XFA.viewTrainingResource = "members.dsp_viewTrainingResource" />
		<cfset XFA.trainingResources = "content.dsp_trainingResources" />
		<cfset XFA.next = "content.act_editTrainingResource" />

		<cfset request.qTrainingResource = request.objTrainingResources.getTrainingResourcesByIDAndUserIDAsQuery(request.dsn,attributes.trainingResourceID,0) />

		<cfinclude template="#request.template#">
	</cfcase>

	<cfcase value="act_editTrainingResource">
	<cfsilent>
	<!--- Submits info --->
		<cfparam name="attributes.trainingResourceID" default="0" type="numeric" />
		<cfparam name="attributes.trainingResourceTypeID" default="1" type="numeric" />
		<cfparam name="attributes.trainingResource" default="" type="string" />
		<cfparam name="attributes.description" default="" type="string" />
		<cfparam name="attributes.resourceContent" default="" type="string" />

		<cfscript>
			XFA.success = "content.dsp_trainingResources";
			XFA.failure = "content.dsp_editTrainingResource";

			Request.suppressLayout = true;

			Request.validation_template = "val_editTrainingResource.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#request.validation_template#" />
		<cfinclude template="#Request.template#" />
	</cfsilent>
	</cfcase>

	<cfcase value="act_deleteTrainingResource">
	<cfsilent>
	<!--- Submits info --->
		<cfparam name="attributes.trainingResourceID" default="0" type="numeric" />

		<cfscript>
			XFA.success = "content.dsp_trainingResources";
			XFA.failure = "content.dsp_editTrainingResource";

			Request.suppressLayout = true;

			Request.validation_template = "val_deleteTrainingResource.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#request.validation_template#" />
		<cfinclude template="#Request.template#" />
	</cfsilent>
	</cfcase>

<!--- ----------------------------------------
UPDATE LINKS
----------------------------------------- --->
	<cfcase value="dsp_links">
	<!--- Displays Link update page --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Update Links";
			Request.template = "dsp_links.cfm";
			Request.js_validate = "content/javascript/links.js";
			Request.onLoad = Request.onLoad & "document.forms['linkForm'].elements['categoryID'].focus();";

			XFA.categories = "content.dsp_link_categories";
			XFA.next = "content.act_links";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_links">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "content.dsp_links";
			XFA.failure = "content.dsp_links";

			Request.suppressLayout = true;

			Request.validation_template = "val_links.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="dsp_link_categories">
	<!--- Displays Link Categories update page --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Update Link Categories";
			Request.template = "dsp_link_categories.cfm";
			Request.js_validate = "content/javascript/links.js";

			XFA.updateLinks = "content.dsp_links";
			XFA.next = "content.act_link_categories";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_link_categories">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "content.dsp_link_categories";
			XFA.failure = "content.dsp_link_categories";

			Request.suppressLayout = true;

			Request.validation_template = "val_link_categories.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

<!--- ----------------------------------------
UPDATE NEWS
----------------------------------------- --->
	<cfcase value="dsp_news">
	<!--- Displays News update page --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Update News";
			Request.template = "dsp_news.cfm";

			XFA.edit = "content.dsp_news_update";
			XFA.delete = "content.act_news_delete";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_news_update">
		<cfparam name="attributes.news_id" default="0" type="numeric">
	<!--- Displays News Edit form--->
		<cfscript>
			if (VAL(attributes.news_id))
			{
				Request.page_title = Request.page_title & "<br />Update News";
			}
			else
			{
				Request.page_title = Request.page_title & "<br />Post News";
			}
			Request.js_validate = "content/javascript/news_update.js";
			Request.template = "dsp_news_update.cfm";

			XFA.next = "content.act_news_update";
			XFA.news = "content.dsp_news";
			XFA.file_select = "content.dsp_file_select";
			XFA.preview = "content.dsp_news_preview";

			Request.onLoad = Request.onLoad & "document.newsForm.date_start.focus();document.newsForm.date_start.select();";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_news_update">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "content.dsp_news";
			XFA.failure = "content.dsp_news_update";
			XFA.preview = "content.dsp_news_preview";

			Request.suppressLayout = true;

			Request.validation_template = "val_news_update.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="dsp_news_preview">
	<!--- Displays News Preview --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Preview News";
			Request.template = "dsp_news_preview.cfm";

			XFA.next = "content.act_news_update";
			XFA.news = "content.dsp_news";
			XFA.edit = "content.dsp_news_update";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_news_delete">
	<cfsilent>
	<!--- Deletes news --->
		<cfscript>
			XFA.success = "content.dsp_news";
			XFA.failure = "content.dsp_news";

			Request.suppressLayout = true;

			Request.validation_template = "val_news_delete.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

<!--- ----------------------------------------
UPDATE GALLERY
----------------------------------------- --->
	<cfcase value="dsp_gallery">
	<!--- Displays Gallery update --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Update Gallery";
			Request.template = "dsp_gallery.cfm";

			XFA.edit = "content.dsp_gallery_update";
			XFA.delete = "content.act_gallery_delete";
			XFA.preview = "content.dsp_gallery_preview";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_gallery_update">
		<cfparam name="attributes.page_id" default="0" type="numeric">
	<!--- Displays gallery Page Edit form--->
		<cfscript>
			if (VAL(attributes.page_id))
			{
				Request.page_title = Request.page_title & "<br />Update Gallery Page";
			}
			else
			{
				Request.page_title = Request.page_title & "<br />Add Gallery Page";
			}
			Request.js_validate = "content/javascript/gallery_update.js";
			Request.template = "dsp_gallery_update.cfm";

			XFA.next = "content.act_gallery_update";
			XFA.contentGallery = "content.dsp_gallery";
			XFA.files = "content.dsp_gallery_files";

			Request.onLoad = Request.onLoad & "document.pageForm.title.focus();document.pageForm.title.select();";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_gallery_update">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "content.dsp_gallery_update";
			XFA.failure = "content.dsp_gallery_update";

			Request.suppressLayout = true;

			Request.validation_template = "val_gallery_update.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="act_gallery_delete">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "content.dsp_gallery";
			XFA.failure = "content.dsp_gallery";

			Request.suppressLayout = true;

			Request.validation_template = "val_gallery_delete.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="dsp_gallery_files">
		<cfparam name="attributes.page_id" default="0" type="numeric">
	<!--- Displays gallery files page --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Add/Remove Gallery Files";
			Request.js_validate = "content/javascript/gallery_files.js";
			Request.template = "dsp_gallery_files.cfm";

			XFA.next = "content.act_gallery_files";
			XFA.contentGallery = "content.dsp_gallery";
			XFA.page = "content.dsp_gallery_update";
			XFA.file_select = "content.dsp_file_select";
			XFA.act_add_file = "content.act_gallery_file_select";
			XFA.act_add_link_file = "content.act_gallery_link_file_select";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_gallery_file_select">
	<!--- Submits info --->
		<cfscript>
			Request.suppressLayout = true;

			Request.template = "act_gallery_file_select.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_gallery_link_file_select">
	<!--- Submits info --->
		<cfscript>
			Request.suppressLayout = true;

			Request.template = "act_gallery_link_file_select.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_gallery_files">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "content.dsp_gallery_update";
			XFA.failure = "content.dsp_gallery_files";

			Request.suppressLayout = true;

			Request.validation_template = "val_gallery_files.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>


	<cfdefaultcase>
		<!---This will just display an error message and is useful in catching typos of fuseaction names while developing--->
		<cfoutput><p>This is the cfdefaultcase tag. I received a fuseaction called <strong>"#attributes.fuseaction#"</strong> and I don't know what to do with it.</p></cfoutput>
	</cfdefaultcase>

</cfswitch>
