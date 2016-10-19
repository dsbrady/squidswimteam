<!---
<fusedoc
	fuse = "val_news_update.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="14 October 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
				<string name="preview" />
			</structure>
			
			<string name="date_from" scope="attributes" />
			<string name="date_to" scope="attributes" />

			<string name="date_start" scope="attributes" />
			<string name="date_end" scope="attributes" />
			<string name="headline" scope="attributes" />
			<string name="article" scope="attributes" />
			<number name="news_id" scope="attributes" />

			<string name="previewBtn" scope="attributes" />
			<string name="submitBtn" scope="attributes" />
			<string name="editBtn" scope="attributes" />
			<boolean name="from_preview" scope="attributes" />
		</in>
		<out>
			<string name="date_from" scope="formOrUrl" />
			<string name="date_to" scope="formOrUrl" />

			<string name="date_start" scope="formOrUrl" />
			<string name="date_end" scope="formOrUrl" />
			<string name="headline" scope="formOrUrl" />
			<string name="article" scope="formOrUrl" />
			<number name="news_id" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.date_from" default="#DateFormat(Now(),"M-D-YYYY")#" type="string">
<cfparam name="attributes.date_to" default="#DateFormat(DateAdd("M",1,Now()),"M-D-YYYY")#" type="string">

<cfset attributes.date_from = Replace(attributes.date_from,"/","-","ALL")>	
<cfset attributes.date_to = Replace(attributes.date_to,"/","-","ALL")>	

<cfparam name="attributes.date_start" default="#DateFormat(Now(),"M/D/YYYY")#" type="string">
<cfparam name="attributes.date_end" default="#DateFormat(DateAdd("M",1,Now()),"M/D/YYYY")#" type="string">
<cfparam name="attributes.news_id" default=0 type="numeric">
<cfparam name="attributes.headline" default="" type="string">
<cfparam name="attributes.article" default="" type="string">
<cfparam name="attributes.from_preview" default="false" type="boolean">
<cfparam name="attributes.previewBtn" default="" type="string">
<cfparam name="attributes.submitBtn" default="" type="string">
<cfparam name="attributes.editBtn" default="" type="string">
<cfparam name="attributes.from_preview" default="false" type="boolean">

<cfparam name="strSuccess" default="#StructNew()#" type="struct">
<cfparam name="strSuccess.success" default="yes" type="boolean">
<cfparam name="strSuccess.reason" default="" type="string">

<!--- If previewing, set new XFA --->
<cfif LEN(attributes.previewBtn) GT 0>
	<cfset XFA.success = XFA.preview>
<cfelseif LEN(attributes.editBtn) GT 0>
	<cfset XFA.success = XFA.failure>
	<cflocation addtoken="no" url="#Request.self#/fuseaction/#XFA.success#/news_id/#attributes.news_id#/from_preview/true.cfm">
</cfif>

<!--- If coming from preview, set form values equal to session values --->
<!--- Else Validate data --->
<cfif (attributes.from_preview)>
	<cfscript>
		attributes.news_id = Request.squid.news.news_id;
		attributes.date_start = Request.squid.news.date_start;
		attributes.date_end = Request.squid.news.date_end;
		attributes.headline = Request.squid.news.headline;
		attributes.article = Request.squid.news.article;
	</cfscript>
<cfelse>
	<cfinvoke  
		component="#Request.content_cfc#" 
		method="validateNews" 
		returnvariable="strSuccess"
		formfields=#attributes#
		dsn=#Request.DSN#
		newsTbl=#Request.newsTbl#
		updating_user=#Request.squid.user_id#
	>
</cfif>

<cfif NOT strSuccess.success>
	<cfscript>
		variables.theURL = Request.self & "/fuseaction/" & XFA.failure;
		variables.theURL = variables.theURL & "/success/" & strSuccess.success & "/reason/" & strSuccess.reason;
		variables.theURL = variables.theURL & "/date_from/" & attributes.date_from & "/date_to/" & attributes.date_to;
	</cfscript>

	<cfset variables.theURL = variables.theURL & ".cfm">

	<cflocation addtoken="no" url="#variables.theURL#"> 
</cfif>

<!--- If final submission, update database --->
<cfif LEN(attributes.submitBtn) GT 0>
	<cfinvoke  
		component="#Request.content_cfc#" 
		method="updateNews" 
		formfields=#attributes#
		dsn=#Request.DSN#
		newsTbl=#Request.newsTbl#
		updating_user=#Request.squid.user_id#
	>

	<!--- Kill session variables for news and set reason --->
	<cfscript>
		StructDelete(Session.squid,"news",true);
		variables.reason = "News Updated./date_from/" & attributes.date_from & "/date_to/" & attributes.date_to;
	</cfscript>
<cfelse>
	<cfset Session.squid.news = StructNew()>
	<cfset Session.squid.news.news_id = attributes.news_id>
	<cfset Session.squid.news.date_start = strSuccess.date_start>
	<cfset Session.squid.news.date_end = strSuccess.date_end>
	<cfset Session.squid.news.headline = strSuccess.headline>
	<cfset Session.squid.news.article = strSuccess.article>
</cfif>

	
