<cfcomponent displayname="Training Resources Components" hint="CFC for Training Resources">
	<cffunction name="getRecentTrainingResourcesByUserIDAsQuery" access="public" hint="Gets query of resources for a user ID" output="false" returntype="query">
		<cfargument name="dsn" required="true" type="string" />
		<cfargument name="userID" required="yes" type="numeric" />
		<cfargument name="maximumRecords" required="yes" type="numeric" />

		<cfset var local = structNew() />
		<cfset local.qData = "" />

		<cfquery name="local.qData" datasource="#arguments.dsn#">
			SELECT
			<cfif arguments.maximumRecords GT 0>
				TOP #arguments.maximumRecords#
			</cfif>
				tr.trainingResourceID,
				tr.trainingResource,
				tr.description,
				tr.resourceContent,
				tr.userID,
				tr.created,
				trt.trainingResourceTypeID,
				trt.trainingResourceType
			FROM
				trainingResources tr
				INNER JOIN trainingResourceTypes trt
				ON tr.trainingResourceTypeID = trt.trainingResourceTypeID
			WHERE
				tr.active = 1
				AND
				(
					tr.userID = 0
				<cfif arguments.userID GT 0>
					OR tr.userID = <cfqueryparam value="#arguments.userID#" cfsqltype="cf_sql_integer" />
				</cfif>
				)
			ORDER BY
				tr.created DESC
		</cfquery>

		<cfreturn local.qData />
	</cffunction>

	<cffunction name="getTrainingResourcesByIDAndUserIDAsQuery" access="public" hint="Gets query of a resource for an ID and a user ID" output="false" returntype="query">
		<cfargument name="dsn" required="true" type="string" />
		<cfargument name="trainingResourceID" required="yes" type="numeric" />
		<cfargument name="userID" required="yes" type="numeric" />

		<cfset var local = structNew() />
		<cfset local.qData = "" />

		<cfquery name="local.qData" datasource="#arguments.dsn#">
			SELECT
				tr.trainingResourceID,
				tr.trainingResource,
				tr.description,
				tr.resourceContent,
				tr.userID,
				trt.trainingResourceTypeID,
				trt.trainingResourceType
			FROM
				trainingResources tr
				INNER JOIN trainingResourceTypes trt
				ON tr.trainingResourceTypeID = trt.trainingResourceTypeID
			WHERE
				tr.active = 1
				AND tr.trainingResourceID = <cfqueryparam value="#arguments.trainingResourceID#" cfsqltype="cf_sql_integer" />
				AND
				(
					tr.userID = 0
				<cfif arguments.userID GT 0>
					OR tr.userID = <cfqueryparam value="#arguments.userID#" cfsqltype="cf_sql_integer" />
				</cfif>
				)
		</cfquery>

		<cfreturn local.qData />
	</cffunction>

	<cffunction name="saveResource" hint="saves a training resource" access="public" output="false" returnType="struct">
		<cfargument name="dsn" required="true" type="string" />
		<cfargument name="formfields" required="true" type="struct" />
		<cfargument name="userID" required="true" type="numeric" />

		<cfset var local = structNew() />
		<cfset local.stResults = structNew() />

		<cfif arguments.formFields.trainingResourceID GT 0>
			<cfset local.stResults = updateResource(arguments.dsn,arguments.formFields,arguments.userID) />
		<cfelse>
			<cfset local.stResults = insertResource(arguments.dsn,arguments.formFields,arguments.userID) />
		</cfif>

		<cfreturn local.stResults />
	</cffunction>

	<cffunction name="updateResource" hint="updates a training resource" access="private" output="false" returnType="struct">
		<cfargument name="dsn" required="true" type="string" />
		<cfargument name="formfields" required="true" type="struct" />
		<cfargument name="userID" required="true" type="numeric" />

		<cfset var local = structNew() />
		<cfset local.stResults = structNew() />
		<cfset local.stResults.isSuccessful = true />
		<cfset local.stResults.reason = "" />

		<cfquery name="local.qSave" datasource="#arguments.dsn#">
			UPDATE trainingResources
			SET
				trainingResourceTypeID = <cfqueryparam value="#arguments.formfields.trainingResourceTypeID#" cfsqltype="cf_sql_integer" />,
				trainingResource = <cfqueryparam value="#arguments.formfields.trainingResource#" cfsqltype="cf_sql_varchar" />,
				description = <cfqueryparam value="#arguments.formfields.description#" cfsqltype="cf_sql_varchar" />,
				resourceContent = <cfqueryparam value="#arguments.formfields.resourceContent#" cfsqltype="cf_sql_varchar" />,
				modified = getdate(),
				modifiedBy = <cfqueryparam value="#arguments.userID#" cfsqltype="cf_sql_integer" />
			WHERE
				trainingResourceID = <cfqueryparam value="#arguments.formfields.trainingResourceID#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfreturn local.stResults />
	</cffunction>

	<cffunction name="insertResource" hint="inserts a training resource" access="private" output="false" returnType="struct">
		<cfargument name="dsn" required="true" type="string" />
		<cfargument name="formfields" required="true" type="struct" />
		<cfargument name="userID" required="true" type="numeric" />

		<cfset var local = structNew() />
		<cfset local.stResults = structNew() />
		<cfset local.stResults.isSuccessful = true />
		<cfset local.stResults.reason = "" />

		<cfquery name="local.qSave" datasource="#arguments.dsn#">
			INSERT INTO trainingResources
			(
				trainingResourceTypeID,
				trainingResource,
				description,
				resourceContent,
				createdBy,
				modifiedBy
			)
			VALUES
			(
				<cfqueryparam value="#arguments.formfields.trainingResourceTypeID#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.formfields.trainingResource#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formfields.description#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.formfields.resourceContent#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.userID#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.userID#" cfsqltype="cf_sql_integer" />
			)
		</cfquery>

		<cfreturn local.stResults />
	</cffunction>

	<cffunction name="deleteResource" hint="deletes a training resource" access="public" output="false" returnType="struct">
		<cfargument name="dsn" required="true" type="string" />
		<cfargument name="formfields" required="true" type="struct" />
		<cfargument name="userID" required="true" type="numeric" />

		<cfset var local = structNew() />
		<cfset local.stResults = structNew() />
		<cfset local.stResults.isSuccessful = true />
		<cfset local.stResults.reason = "" />

		<cfquery name="local.qSave" datasource="#arguments.dsn#">
			UPDATE trainingResources
			SET
				active = 0,
				modified = getdate(),
				modifiedBy = <cfqueryparam value="#arguments.userID#" cfsqltype="cf_sql_integer" />
			WHERE
				trainingResourceID = <cfqueryparam value="#arguments.formfields.trainingResourceID#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfreturn local.stResults />
	</cffunction>
</cfcomponent>