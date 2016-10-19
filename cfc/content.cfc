<cfcomponent displayname="Content Update Components" hint="CFC for Content Update">
	<cffunction name="uploadFile" access="public" displayname="Upload File" hint="Uploads File" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="fileTbl" required="yes" type="string">
		<cfargument name="categoryTbl" required="yes" type="string">
		<cfargument name="file_typeTbl" required="yes" type="string">
		<cfargument name="lookup_cfc" required="yes" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">
		<cfargument name="file_path" required="yes" type="string">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>		

		<!--- Validate data --->
		<cfscript>
			if (VAL(arguments.formfields.category_id) EQ 0)
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please select a category.*";
			}
			else if ((VAL(arguments.formfields.category_id) EQ -1) AND ((len(trim(arguments.formfields.new_category)) EQ 0) OR (LCASE(TRIM(arguments.formfields.new_category)) IS "new category")))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter a new category name.*";
			}
			
			if (VAL(arguments.formfields.file_type_id) EQ 0)
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please select a file type.*";
			}

			if (LEN(trim(arguments.formfields.filename)) EQ 0)
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please select a file to upload.*";
			}
		</cfscript>

		<cfif NOT var.success.success>
			<cfreturn var.success>
		</cfif>

		<cftransaction action="BEGIN">
			<!--- Add new category, if necessary --->
			<cfif arguments.formfields.category_id EQ -1>
				<!--- See if category exists already --->
				<cfquery name="qryCatCheck" datasource="#arguments.dsn#">
					SELECT
						category_id
					FROM
						#arguments.categoryTbl#
					WHERE
						upper(category) = <cfqueryparam value="#UCASE(TRIM(arguments.formfields.new_category))#" cfsqltype="CF_SQL_VARCHAR">
						AND active_code = 1
				</cfquery>
				
				<cfif qryCatCheck.RecordCount>
					<cfset var.success.success = "No">
					<cfset var.success.reason = var.success.reason & """" & arguments.formfields.new_category & """ is already a category.*">
					
					<cfreturn var.success>
				</cfif>
				
				<!--- Add Category--->
				<cfquery name="qryInsertCat" datasource="#arguments.DSN#">
					INSERT INTO
						#arguments.categoryTbl#
					(
						category,
						created_user,
						modified_user
					)
					VALUES
					(
						<cfqueryparam value="#arguments.formfields.new_category#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">
					)
				</cfquery>
				
				<!--- Get new category --->
				<cfquery name="qryCatID" datasource="#arguments.dsn#">
					SELECT
						MAX(category_id) AS newID
					FROM
						#arguments.categoryTbl#
					WHERE
						upper(category) = <cfqueryparam value="#UCASE(TRIM(arguments.formfields.new_category))#" cfsqltype="CF_SQL_VARCHAR">
						AND active_code = 1
				</cfquery>
				
				<cfset arguments.formfields.category_id = qryCatID.newID>
			</cfif>


			<!--- Get acceptable mime types --->
			<cfquery name="qryMime" datasource="#arguments.dsn#">
				SELECT
					mime_types
				FROM
					#arguments.file_TypeTbl#
				WHERE
					file_type_id = <cfqueryparam value="#VAL(arguments.formfields.file_type_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
			
			<!--- Upload the file --->
			<cftry>
				<cffile
					accept="#qryMime.mime_types#"
					action="UPLOAD"
					filefield="filename"
					destination="#arguments.file_path#"
					nameConflict="MAKEUNIQUE"
				>

				<cfset arguments.formfields.filename = CFFILE.serverFile>
				<cfcatch type="Any">
					<cfset var.success.success = "no">
					<cfset var.success.reason = var.success.reason & "There was a problem uploading the file. Please make sure you've selected the proper file type.*">
					
					<cftransaction action="ROLLBACK" />

					<cfreturn var.success>
				</cfcatch>
			</cftry>
			
			<!--- Insert into database --->
			<cfquery name="qryInsertFile" datasource="#arguments.DSN#">
				INSERT INTO
					#arguments.fileTbl#
				(
					filename,
					description,
					category_id,
					file_type_id,
					created_user,
					modified_user
				)
				VALUES
				(
					<cfqueryparam value="#arguments.formfields.filename#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#arguments.formfields.description#" cfsqltype="CF_SQL_VARCHAR">,
					<cfqueryparam value="#arguments.formfields.category_id#" cfsqltype="CF_SQL_INTEGER">,
					<cfqueryparam value="#arguments.formfields.file_type_id#" cfsqltype="CF_SQL_INTEGER">,
					<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
					<cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">
				)
			</cfquery>
		</cftransaction>

		<cfreturn var.success>
	</cffunction>

	<cffunction name="deleteFile" access="public" displayname="Delete File" hint="Deletes File" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="fileTbl" required="yes" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">
		<cfargument name="filePath" required="yes" type="string">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>		
		
		<cftransaction action="BEGIN">
			<!--- Make sure file is in database --->
			<cfquery name="qryCheck" datasource="#arguments.dsn#">
				SELECT
					file_id
				FROM
					#arguments.fileTbl#
				WHERE
					file_id = <cfqueryparam value="#VAL(arguments.formfields.file_id)#" cfsqltype="CF_SQL_INTEGER">
					AND filename = <cfqueryparam value="#arguments.formfields.filename#" cfsqltype="CF_SQL_VARCHAR">
			</cfquery>

			<!--- Also make sure file exists --->
			<cfset fileFound = FileExists(arguments.filePath & "\" & arguments.formfields.filename)>

			<cfif (NOT fileFound) OR (qryCheck.RecordCount EQ 0)>
				<cfset var.success.success = "no">
				<cfset var.success.reason = var.success.reason & "The file was not found.*">

				<cfreturn var.success />
			</cfif>

			<!--- Remove from database first --->
			<cfquery name="qryDelete" datasource="#arguments.dsn#">
				UPDATE
					#arguments.fileTbl#
				SET
					active_code = 0,
					modified_user = <cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
					modified_date = GetDate()
				WHERE
					file_id = <cfqueryparam value="#VAL(arguments.formfields.file_id)#" cfsqltype="CF_SQL_INTEGER">
					AND filename = <cfqueryparam value="#arguments.formfields.filename#" cfsqltype="CF_SQL_VARCHAR">
			</cfquery>

			<!--- Then delete the file --->			
			<cftry>
				<cffile
					action="DELETE"
					file="#arguments.filePath#\#arguments.formfields.filename#"
				>

				<cfcatch type="Any">
					<cfset var.success.success = "no">
					<cfset var.success.reason = var.success.reason & "There was a problem deleting the file. Please try again.*">
					
					<cftransaction action="ROLLBACK" />

					<cfreturn var.success />
				</cfcatch>
			</cftry>
		</cftransaction>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="validateContent" access="public" displayname="Validate Content" hint="Validates Content" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="pageTbl" required="Yes" type="string">
		<cfargument name="updating_user" required="yes" type="string">

		<cfparam name="formfields.from_preview" default="false" type="boolean">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>		

		<!--- Validate data --->
		<cfscript>
			if (NOT LEN(trim(arguments.formfields.title)))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter the title.*";
			}
			if (NOT LEN(trim(arguments.formfields.content)))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter the content.*";
			}
		</cfscript>
		
		<cfif NOT var.success.success>
			<cfreturn var.success />
		</cfif>

		<cfset var.success.title = arguments.formfields.title>
		<cfset var.success.content = arguments.formfields.content>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="updateContent" access="public" displayname="Update Content" hint="Updates Content" output="No" returnType="void">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="pageTbl" required="yes" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>		

		<!--- Update database --->
		<cftransaction>
			<!--- See if it's changed at all --->
			<cfquery name="qryCheckChange" datasource="#arguments.dsn#">
				SELECT
					content,
					title
				FROM
					#arguments.pageTbl#
				WHERE
					page_id = <cfqueryparam value="#VAL(arguments.formfields.page_id)#" cfsqltype="CF_SQL_INTEGER">
					AND active_code = 1
			</cfquery>

			<!--- If so, proceed with update --->
			<cfif (Compare(qryCheckChange.title,arguments.formfields.title) NEQ 0) OR (Compare(qryCheckChange.content,arguments.formfields.content) NEQ 0)>
				<!--- Make existing page inactive --->
				<cfquery name="qryUpdate" datasource="#arguments.dsn#">
					UPDATE
						#arguments.pageTbl#
					SET
						active_code = 0,
						modified_user = <cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
						modified_date = GetDate()
					WHERE
						page_id = <cfqueryparam value="#VAL(arguments.formfields.page_id)#" cfsqltype="CF_SQL_INTEGER">
				</cfquery>
	
				<!--- Insert new page --->			
				<cfquery name="qryInsert" datasource="#arguments.dsn#">
					INSERT INTO
						#arguments.pageTbl#
					(
						page,
						title,
						content,
						created_user,
						modified_user
					)
					VALUES
					(
						<cfqueryparam value="#arguments.formfields.page#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#arguments.formfields.title#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#arguments.formfields.content#" cfsqltype="CF_SQL_LONGVARCHAR">,
						<cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">
					)
				</cfquery>
			</cfif>
		</cftransaction>

		<cfreturn />
	</cffunction>

	<cffunction name="validateNews" access="public" displayname="Validate News" hint="Validates News" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="newsTbl" required="Yes" type="string">
		<cfargument name="updating_user" required="yes" type="string">

		<cfparam name="formfields.from_preview" default="false" type="boolean">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>		

		<!--- Validate data --->
		<cfscript>
			if ((NOT LEN(trim(arguments.formfields.date_start))) OR (NOT IsDate(arguments.formfields.date_start)))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter a valid start date.*";
			}
			if ((NOT LEN(trim(arguments.formfields.date_end))) OR (NOT IsDate(arguments.formfields.date_end)))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter a valid end date.*";
			}
			if (NOT LEN(trim(arguments.formfields.headline)))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter the headline.*";
			}
			if (NOT LEN(trim(arguments.formfields.article)))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter the article.*";
			}
		</cfscript>
		
		<cfif NOT var.success.success>
			<cfreturn var.success />
		</cfif>

		<cfset var.success.date_start = arguments.formfields.date_start>
		<cfset var.success.date_end = arguments.formfields.date_end>
		<cfset var.success.headline = arguments.formfields.headline>
		<cfset var.success.article = arguments.formfields.article>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="updateNews" access="public" displayname="Update News" hint="Updates News" output="No" returnType="void">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="newsTbl" required="yes" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>		

		<!--- Update database --->
		<cftransaction>
			<!--- See if adding or updating --->
			<cfif NOT VAL(arguments.formfields.news_id)>
				<!--- Insert --->
				<cfquery name="qryInsert" datasource="#arguments.dsn#">
					INSERT INTO
						#arguments.newsTbl#
					(
						date_start,
						date_end,
						headline,
						article,
						created_user,
						modified_user
					)
					VALUES
					(
						<cfqueryparam value="#arguments.formfields.date_start#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#arguments.formfields.date_end#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#arguments.formfields.headline#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#arguments.formfields.article#" cfsqltype="CF_SQL_LONGVARCHAR">,
						<cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">
					)
				</cfquery>
			<cfelse>
				<!--- Update --->
				<cfquery name="qryUpdate" datasource="#arguments.dsn#">
					UPDATE
						#arguments.newsTbl#
					SET
						date_start = <cfqueryparam value="#arguments.formfields.date_start#" cfsqltype="CF_SQL_DATE">,
						date_end = <cfqueryparam value="#arguments.formfields.date_end#" cfsqltype="CF_SQL_DATE">,
						headline = <cfqueryparam value="#arguments.formfields.headline#" cfsqltype="CF_SQL_VARCHAR">,
						article = <cfqueryparam value="#arguments.formfields.article#" cfsqltype="CF_SQL_LONGVARCHAR">,
						modified_user = <cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
						modified_date = GetDate()
					WHERE
						news_id = <cfqueryparam value="#VAL(arguments.formfields.news_id)#" cfsqltype="CF_SQL_INTEGER">
				</cfquery>
			</cfif>
		</cftransaction>

		<cfreturn />
	</cffunction>

	<cffunction name="deleteNews" access="public" displayname="Delete News" hint="Deletes News" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="newsTbl" required="yes" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>		
		
		<cftransaction action="BEGIN">
			<!--- Remove from database --->
			<cfquery name="qryDelete" datasource="#arguments.dsn#">
				UPDATE
					#arguments.newsTbl#
				SET
					active_code = 0,
					modified_user = <cfqueryparam value="#arguments.updating_user#" cfsqltype="CF_SQL_INTEGER">,
					modified_date = GetDate()
				WHERE
					news_id = <cfqueryparam value="#VAL(arguments.formfields.news_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
		</cftransaction>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="validateGalleryPage" access="public" displayname="Validate Gallery Page" hint="Validates Gallery Page" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>		

		<!--- Validate data --->
		<cfscript>
			if (NOT LEN(trim(arguments.formfields.title)))
			{
				var.success.success = "No";
				var.success.reason = var.success.reason & "Please enter the title.*";
			}
		</cfscript>
		
		<cfreturn var.success />
	</cffunction>

	<cffunction name="updateGalleryPage" access="public" displayname="Update Gallery Page" hint="Updates Gallery Page" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="pageTbl" required="yes" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">
		<cfargument name="lookup_cfc" required="yes" type="string">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>		

		<!--- Update database --->
		<cftransaction>
			<!--- See if adding or updating --->
			<cfif VAL(arguments.formfields.page_id)>
				<!--- Update --->
				<cfquery name="qryUpdate" datasource="#arguments.dsn#">
					UPDATE
						#arguments.pageTbl#
					SET
						title = <cfqueryparam value="#arguments.formfields.title#" cfsqltype="CF_SQL_VARCHAR">,
						content = <cfqueryparam value="#arguments.formfields.content#" cfsqltype="CF_SQL_LONGVARCHAR">,
						modified_user = <cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
						modified_date = GetDate()
					WHERE
						page_id = <cfqueryparam value="#VAL(arguments.formfields.page_id)#" cfsqltype="CF_SQL_INTEGER">
				</cfquery>
				
				<cfset var.success.page_id = VAL(arguments.formfields.page_id)>
				<cfset var.success.reason = "Page Updated.">
			<cfelse>
				<!--- Get parent ID--->
				<cfinvoke  
					component="#arguments.lookup_cfc#" 
					method="getContent" 
					returnvariable="qryGalleryID"
					dsn=#arguments.DSN#
					pageTbl=#arguments.pageTbl#
					page="Gallery"
					parent_id=0
				>

				<!--- Get new sort order ID --->
				<cfquery name="qrySort" datasource="#arguments.dsn#">
					SELECT
						MAX(display_order) + 1 AS newOrder
					FROM
						#arguments.pageTbl#
					WHERE
						parent_id = <cfqueryparam value="#VAL(qryGalleryID.page_id)#" cfsqltype="CF_SQL_INTEGER">
				</cfquery>
				
				<!--- Insert --->
				<cfquery name="qryInsert" datasource="#arguments.dsn#">
					INSERT INTO
						#arguments.pageTbl#
					(
						page,
						parent_id,
						display_order,
						title,
						content,
						created_user,
						modified_user
					)
					VALUES
					(
						'Gallery',
						<cfqueryparam value="#VAL(qryGalleryID.page_id)#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#VAL(qrySort.newOrder)#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#arguments.formfields.title#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#arguments.formfields.content#" cfsqltype="CF_SQL_LONGVARCHAR">,
						<cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">
					)
				</cfquery>

				<!--- Get new page ID --->
				<cfquery name="qryNewID" datasource="#arguments.dsn#">
					SELECT
						MAX(page_id) AS NewID
					FROM
						#arguments.pageTbl#
					WHERE
						title = <cfqueryparam value="#arguments.formfields.title#" cfsqltype="CF_SQL_VARCHAR">
				</cfquery>
				
				<cfset var.success.page_id = VAL(qryNewID.NewID)>
				<cfset var.success.reason = "Page Added.">
			</cfif>
		</cftransaction>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="updateGalleryFiles" access="public" displayname="Update Gallery Files" hint="Updates Gallery Files for a Page" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="galleryTbl" required="yes" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>		

		<!--- Update database --->
		<cftransaction>
			<!--- First, deactivate any existing files --->
			<cfquery name="qryDeactivate" datasource="#arguments.dsn#">
				UPDATE
					#arguments.galleryTbl#
				SET
					active_code = 0,
					display_order = 0,
					modified_user = <cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
					modified_date = GetDate()
				WHERE
					page_id = <cfqueryparam value="#VAL(arguments.formfields.page_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>

			<!--- Now, loop along new list and insert into table --->
			<cfset aFiles = ListToArray(arguments.formfields.files,",")>
			<cfset aLinks = ListToArray(arguments.formfields.links,",")>
			<cfloop from="1" to="#ArrayLen(aFiles)#" index="i">
				<cfquery name="qryInsert" datasource="#arguments.dsn#">
					INSERT INTO
						#arguments.galleryTbl#
					(
						file_id,
						page_id,
						link_id,
						display_order,
						created_user,
						modified_user
					)
					VALUES
					(
						<cfqueryparam value="#VAL(aFiles[i])#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#VAL(arguments.formfields.page_id)#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#VAL(aLinks[i])#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#i#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">
					)
				</cfquery>
			</cfloop>
		</cftransaction>

		<cfset var.success.reason = "Files Updated.">

		<cfreturn var.success />
	</cffunction>

	<cffunction name="deleteGalleryPage" access="public" displayname="Delete Gallery Page" hint="Deletes Gallery Page" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="pageTbl" required="yes" type="string">
		<cfargument name="galleryTbl" required="yes" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>		

		<!--- Update database --->
		<cftransaction>
			<cfquery name="qryDeleteGallery" datasource="#arguments.dsn#">
				UPDATE
					#arguments.galleryTbl#
				SET
					active_code = 0,
					display_order = 0,
					modified_user = <cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
					modified_date = GetDate()
				WHERE
					page_id = <cfqueryparam value="#VAL(arguments.formfields.page_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>
				
			<cfquery name="qryDeletePage" datasource="#arguments.dsn#">
				UPDATE
					#arguments.pageTbl#
				SET
					active_code = 0,
					display_order = 0,
					modified_user = <cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
					modified_date = GetDate()
				WHERE
					page_id = <cfqueryparam value="#VAL(arguments.formfields.page_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>

			<cfset var.success.reason = "Page Deleted.">
		</cftransaction>

		<cfreturn var.success />
	</cffunction>

	<cffunction name="updateLinkCategories" access="public" displayname="Update Link Categories" hint="Updates Link Categories" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="link_categoryTbl" required="yes" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>		

		<!--- Update database --->
		<cftransaction>
			<!--- First, see if the order has changed --->
			<cfif CompareNoCase(arguments.formfields.categories,arguments.formfields.categories_old) NEQ 0>
				<!--- If so, deactivate all existing ones and set order to 0 --->
				<cfquery name="qryDeactivate" datasource="#arguments.dsn#">
					UPDATE
						#arguments.link_categoryTbl#
					SET
						display_order = 0,
						active_code = 0,
						modified_user = <cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
						modified_date = GetDate()
					WHERE
						active_code = 1
				</cfquery>

				<!--- Loop along the new list --->
				<cfset count = 0>
				<cfloop list="#arguments.formfields.categories#" index="i">
					<cfset count = count + 1>
					<cfset oldPos = ListFindNoCase(arguments.formfields.categories_old,i)>
					<!--- See if the current item exists in the old list --->
					<cfif oldPos GT 0>
						<!--- If so, remove it from the old list and update the database --->
						<cfset arguments.formfields.categories_old = ListDeleteAt(arguments.formfields.categories_old,oldPos)>
						<cfquery name="qryUpdate" datasource="#arguments.dsn#">
							UPDATE
								#arguments.link_categoryTbl#
							SET
								display_order = <cfqueryparam value="#VAL(count)#" cfsqltype="CF_SQL_INTEGER">,
								active_code = 1,
								modified_user = <cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
								modified_date = GetDate()
							WHERE
								category_id = <cfqueryparam value="#VAL(i)#" cfsqltype="CF_SQL_INTEGER">
						</cfquery>
					<cfelse>
						<!--- If not, insert the new one into the database --->
						<cfquery name="qryUpdate" datasource="#arguments.dsn#">
							INSERT INTO
								#arguments.link_categoryTbl#
							(
								display_order,
								active_code,
								created_user,
								modified_user
							)
							VALUES
							(
								<cfqueryparam value="#VAL(count)#" cfsqltype="CF_SQL_INTEGER">,
								1,
								<cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
								<cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">
							)
						</cfquery>
						
						<!--- Get new ID --->
						<cfquery name="qryNewID" datasource="#arguments.dsn#">
							SELECT
								MAX(category_id) AS NewID
							FROM
								#arguments.link_categoryTbl#
							WHERE
								active_code = 1
								AND display_order = <cfqueryparam value="#VAL(count)#" cfsqltype="CF_SQL_INTEGER">
						</cfquery>

						<cfset arguments.formfields['category_' & VAL(qryNewID.newID)] = arguments.formfields['category_' & i]>
						<cfset arguments.formfields.categories = ListSetAt(arguments.formfields.categories,count,VAL(qryNewID.NewID))>
					</cfif>
				</cfloop>
			</cfif>

			<!--- Now, go through and update the names --->
			<cfloop list="#arguments.formfields.categories#" index="i">
				<cfquery name="qryUpdateNames" datasource="#arguments.dsn#">
					UPDATE
						#arguments.link_categoryTbl#
					SET
						category = rtrim(<cfqueryparam value="#arguments.formfields["category_" & i]#" cfsqltype="CF_SQL_VARCHAR">),
						modified_user = <cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
						modified_date = GetDate()
					WHERE
						category_id = <cfqueryparam value="#VAL(i)#" cfsqltype="CF_SQL_INTEGER">
				</cfquery>
			</cfloop>
		</cftransaction>

		<cfset var.success.reason = "Categories Updated.">

		<cfreturn var.success />
	</cffunction>

	<cffunction name="updateLinks" access="public" displayname="Update Links" hint="Updates Links" output="No" returntype="struct">
		<cfargument name="formfields" required="Yes" type="struct">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="linksTbl" required="yes" type="string">
		<cfargument name="updating_user" required="yes" type="numeric">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>		

		<!--- Update database --->
		<cftransaction>
			<!--- First, see if the order has changed --->
			<cfif CompareNoCase(arguments.formfields.links,arguments.formfields.links_old) NEQ 0>
				<!--- If so, deactivate all existing ones and set order to 0 --->
				<cfquery name="qryDeactivate" datasource="#arguments.dsn#">
					UPDATE
						#arguments.linksTbl#
					SET
						display_order = 0,
						active_code = 0,
						modified_user = <cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
						modified_date = GetDate()
					WHERE
						active_code = 1
						AND category_id = <cfqueryparam value="#VAL(arguments.formfields.categoryID)#" cfsqltype="CF_SQL_INTEGER">
				</cfquery>

				<!--- Loop along the new list --->
				<cfset count = 0>
				<cfloop list="#arguments.formfields.links#" index="i">
					<cfset count = count + 1>
					<cfset oldPos = ListFindNoCase(arguments.formfields.links_old,i)>
					<!--- See if the current item exists in the old list --->
					<cfif oldPos GT 0>
						<!--- If so, remove it from the old list and update the database --->
						<cfset arguments.formfields.links_old = ListDeleteAt(arguments.formfields.links_old,oldPos)>
						<cfquery name="qryUpdate" datasource="#arguments.dsn#">
							UPDATE
								#arguments.linksTbl#
							SET
								display_order = <cfqueryparam value="#VAL(count)#" cfsqltype="CF_SQL_INTEGER">,
								active_code = 1,
								modified_user = <cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
								modified_date = GetDate()
							WHERE
								link_id = <cfqueryparam value="#VAL(i)#" cfsqltype="CF_SQL_INTEGER">
								AND category_id = <cfqueryparam value="#VAL(arguments.formfields.categoryID)#" cfsqltype="CF_SQL_INTEGER">
						</cfquery>
					<cfelse>
						<!--- If not, insert the new one into the database --->
						<cfquery name="qryUpdate" datasource="#arguments.dsn#">
							INSERT INTO
								#arguments.linksTbl#
							(
								display_order,
								category_id,
								active_code,
								created_user,
								modified_user
							)
							VALUES
							(
								<cfqueryparam value="#VAL(count)#" cfsqltype="CF_SQL_INTEGER">,
								<cfqueryparam value="#VAL(arguments.formfields.categoryID)#" cfsqltype="CF_SQL_INTEGER">,
								1,
								<cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
								<cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">
							)
						</cfquery>
						
						<!--- Get new ID --->
						<cfquery name="qryNewID" datasource="#arguments.dsn#">
							SELECT
								MAX(link_id) AS NewID
							FROM
								#arguments.linksTbl#
							WHERE
								active_code = 1
								AND category_id = <cfqueryparam value="#VAL(arguments.formfields.categoryID)#" cfsqltype="CF_SQL_INTEGER">
						</cfquery>

						<cfset arguments.formfields['name_' & VAL(qryNewID.newID)] = arguments.formfields['name_' & i]>
						<cfset arguments.formfields['url_' & VAL(qryNewID.newID)] = arguments.formfields['url_' & i]>
						<cfset arguments.formfields['desc_' & VAL(qryNewID.newID)] = arguments.formfields['desc_' & i]>
						<cfset arguments.formfields.links = ListSetAt(arguments.formfields.links,count,VAL(qryNewID.NewID))>
					</cfif>
				</cfloop>
			</cfif>

			<!--- Now, go through and update the text values --->
			<cfloop list="#arguments.formfields.links#" index="i">
				<cfquery name="qryUpdateText" datasource="#arguments.dsn#">
					UPDATE
						#arguments.linksTbl#
					SET
						name = rtrim(<cfqueryparam value="#arguments.formfields["name_" & i]#" cfsqltype="CF_SQL_VARCHAR">),
						url = rtrim(<cfqueryparam value="#arguments.formfields["url_" & i]#" cfsqltype="CF_SQL_VARCHAR">),
						description = rtrim(<cfqueryparam value="#arguments.formfields["desc_" & i]#" cfsqltype="CF_SQL_VARCHAR" null="#IIF(LEN(TRIM(arguments.formfields['desc_' & i])) EQ 0,DE("Yes"),DE("No"))#">),
						modified_user = <cfqueryparam value="#VAL(arguments.updating_user)#" cfsqltype="CF_SQL_INTEGER">,
						modified_date = GetDate()
					WHERE
						link_id = <cfqueryparam value="#VAL(i)#" cfsqltype="CF_SQL_INTEGER">
				</cfquery>
			</cfloop>
		</cftransaction>

		<cfset var.success.reason = "Links Updated.">

		<cfreturn var.success />
	</cffunction>

</cfcomponent>