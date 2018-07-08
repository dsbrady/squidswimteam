<cfsilent>
	 <cfswitch expression="#thisTag.executionMode#">
	 	<cfcase value="end">
			<cfhtmlhead text="#thisTag.generatedContent#" />
			<!--- flush out generated content --->
			<cfset thisTag.generatedContent = "" />
		</cfcase>
	 	<cfdefaultcase>
			<!--- do nothing --->
		</cfdefaultcase>
	 </cfswitch>
</cfsilent>