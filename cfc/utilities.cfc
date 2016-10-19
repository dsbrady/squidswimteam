<cfcomponent displayname="Utilities" hint="Utilitiy methods">
	<cffunction name="runQueryMethod" access="public" hint="Runs a CFC method that returns a query" output="false" returntype="query">
		<cfargument name="componentPath" required="true" type="string" />
		<cfargument name="methodName" required="true" type="string" />
		<cfargument name="argumentList" required="true" type="string" />
		<cfset var cfc = structNew() />

		<cfinvoke component="#arguments.componentPath#" method="#arguments.methodName#" returnvariable="cfc.qResults">
		<cfloop list="#arguments.argumentList#" index="i">
			<cfinvokeargument name="#ListFirst(i,"|")#" value="#ListLast(i,"|")#" />
		</cfloop>
		</cfinvoke>

		<cfreturn cfc.qResults />
	</cffunction>

	<cffunction name="query2Json" access="public" hint="Converts a query object to a Json object" output="false" returntype="string">
		<cfargument name="qInput" type="query" required="true" />

		<cfset var cfc = structNew() />
		<cfset cfc.jsObject = "" />

		<cfset cfc.jsObject = cfc.jsObject & "{recordset:{totalItems:#arguments.qInput.recordCount#, itemsFound:#arguments.qInput.recordCount#, items: [" />
		<cfloop query="arguments.qInput">
			<cfset cfc.jsObject = cfc.jsObject & "{" />
			<cfloop list="#arguments.qInput.columnList#" index="cfc.i">
				<cfset cfc.jsObject = cfc.jsObject & lcase(cfc.i) & ":" & """#arguments.qInput[cfc.i][arguments.qInput.currentRow]#""" />
				<cfif cfc.i IS NOT ListLast(arguments.qInput.columnList)>
					<cfset cfc.jsObject = cfc.jsObject & "," />
				</cfif>
			</cfloop>
			<cfset cfc.jsObject = cfc.jsObject & "}" />
			<cfif arguments.qInput.currentRow NEQ arguments.qInput.recordCount>
				<cfset cfc.jsObject = cfc.jsObject & "," />
			</cfif>
		</cfloop>

		<cfset cfc.jsObject = cfc.jsObject & "]}}" />

		<cfreturn cfc.jsObject />
	</cffunction>

	<cffunction name="query2PlainText" access="public" hint="Converts a query object to a plain text output" output="false" returntype="string">
		<cfargument name="qInput" type="query" required="true" />
		<cfargument name="delim" type="string" required="true" />
		<cfargument name="displayHeader" type="boolean" required="true" />

		<cfset var cfc = structNew() />
		<cfset cfc.output = "" />

			<cfset cfc.output = cfc.output & ListChangeDelims(arguments.qInput.columnList,"|",",") & CHR(13) & CHR(10) />
		<cfif arguments.displayHeader>
		</cfif>
		<cfloop query="arguments.qInput">
			<cfloop list="#arguments.qInput.columnList#" index="cfc.i">
				<cfset cfc.output = cfc.output & arguments.qInput[cfc.i][arguments.qInput.currentRow] />
				<cfif cfc.i IS NOT listLen(arguments.qInput.columnList)>
					<cfset cfc.output = cfc.output & "|" />
				</cfif>
			</cfloop>
			<cfif arguments.qInput.currentRow NEQ arguments.qInput.recordCount>
				<cfset cfc.output = cfc.output & CHR(13) & CHR(10) />
			</cfif>
		</cfloop>

		<cfreturn cfc.output />
	</cffunction>
</cfcomponent>