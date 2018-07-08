<cfsetting enablecfoutputonly="true" />
<cfswitch expression="#thisTag.executionMode#">
	<cfcase value="end">
		<cfimport prefix="squid" taglib="/customTags" />

		<cfparam name="attributes.fieldID" default="content" />
		<cfparam name="attriutes.fieldName" default="content" />
		<cfparam name="attriutes.height" default="420" />
		<cfparam name="attriutes.width" default="100%" />

		<cfoutput>
			<squid:savecontenttohead>
				<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
				<script src="https://cdn.ckeditor.com/4.8.0/standard/ckeditor.js"></script>
				<script type="text/javascript">
					jQuery(document).ready(function($) {
						CKEDITOR.plugins.addExternal( 'imageuploader', '/lib/ckeditor/plugins/imageuploader/', 'plugin.js' );

						CKEDITOR.replace('#attributes.fieldID#', {
								extraPlugins: 'imageuploader',
								skins: 'Moono_blue,/lib/ckeditor/skins/Moono_blue/'
							});
					});
				</script>
			</squid:savecontenttohead>
			<textarea id="#attributes.fieldID#" name="#attributes.fieldName#">#htmlEditFormat(thisTag.generatedContent)#</textarea>
		</cfoutput>
	</cfcase>
	<cfcase value="start">
		<!--- Do nothing --->
	</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false" />
