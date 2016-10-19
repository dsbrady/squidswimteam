<cfswitch expression = "#fusebox.fuseaction#">
<!--- ----------------------------------------
QUERY TO JSON
----------------------------------------- --->
	<cfcase value="act_query2Yahoo">
		<cfsilent>
			<cfparam name="attributes.componentPath" default="" type="string" />
			<cfparam name="attributes.methodName" default="" type="string" />
			<cfparam name="attributes.argumentList" default="" type="string" />

			<cfif NOT (len(attributes.componentPath))>
				<cfthrow message="Utility act_query2Json not properly called!" detail="No component provided" type="application" />
			</cfif>
			<cfif NOT (len(attributes.methodName))>
				<cfthrow message="Utility act_query2Json not properly called!" detail="No method provided" type="application" />
			</cfif>

			<cfset qResults = Request.utilitiesCFC.runQueryMethod(attributes.componentPath,attributes.methodName,attributes.argumentList) />
<!---
			<cfset yahooObject = Request.utilitiesCFC.query2PlainText(qResults,"|",false) />
			<cfset yahooObject = Request.jsonCFC.encode(qResults,"array") />
 --->
			<cfset yahooObject = Request.utilitiesCFC.query2Json(qResults) />

			<cfset Request.suppressLayout = true />
		</cfsilent>
		<cfcontent reset="true" /><cfoutput>#yahooObject#</cfoutput>
	</cfcase>

	<cfdefaultcase>
		<!---This will just display an error message and is useful in catching typos of fuseaction names while developing--->
		<cfoutput><p>This is the cfdefaultcase tag. I received a fuseaction called <strong>"#attributes.fuseaction#"</strong> and I don't know what to do with it.</p></cfoutput>
	</cfdefaultcase>

</cfswitch>
