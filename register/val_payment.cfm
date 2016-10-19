<!---
<fusedoc
	fuse = "val_payment.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="13 April 2004" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>
			
		</in>
		<out>
			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.paymentMethod" default="" type="string">
<cfparam name="attributes.donation" default="" type="string">
<cfparam name="attributes.returnFromPayPal" default="false" type="boolean">

<cfparam name="strSuccess" default="#StructNew()#" type="struct">
<cfparam name="strSuccess.success" default="yes" type="boolean">
<cfparam name="strSuccess.reason" default="" type="string">

<!--- If NOT coming back from PayPal --->
<cfif NOT attributes.returnFromPayPal>
	<cfset strSuccess = Request.registration_cfc.valPayment(attributes)>
	
	<cfif NOT strSuccess.success>
		<cfscript>
			variables.theURL = Request.self & "/fuseaction/" & XFA.failure;
		</cfscript>
	
		<cfloop collection="#attributes#" item="variables.theItem">
			<cfscript>
				if ((variables.theItem IS NOT "SubmitBtn") AND (variables.theItem IS NOT "PreviewBtn") AND (variables.theItem IS NOT "fieldnames") AND (variables.theItem IS NOT "fuseaction") AND (LEN(attributes[variables.theItem])))
				{
					variables.theURL = variables.theURL & "/" & variables.theItem & "/" & attributes[variables.theItem];
				}
			</cfscript>
		</cfloop>
	
		<cfscript>
			variables.theURL = variables.theURL & "/success/" & strSuccess.success & "/reason/" & strSuccess.reason;
		</cfscript>
	
		<cfset variables.theURL = variables.theURL & ".cfm">
	
		<cflocation addtoken="no" url="#variables.theURL#"> 
	</cfif>
	
	<!--- Submit fees into database and set session values --->
	<cfset strSuccess = Request.registration_cfc.updatePayment(attributes,Request.DSN,Request.registrationTbl,Session.goldrush2009.registration_id,variables.registrationFee)>
	<cfset strSuccess = Request.registration_cfc.setPayment(attributes,variables.registrationFee)>
	
	<!--- If paying via PayPal, go there --->
	<cfif CompareNoCase(attributes.paymentMethod,"PayPal") EQ 0>
		<cflocation addtoken="No" url="#Request.self#/fuseaction/#XFA.paypal#.cfm">
	<cfelse>
		<cfset variables.transaction_id = "">
		<cfset Session.goldrush2009.paypal = StructNew()>
		<cfset Session.goldrush2009.paypal.txn_id = "">
	</cfif>
</cfif>

<!--- Finalize the database submission --->
<cfset strSuccess = Request.registration_cfc.finalizeRegistration(Request.DSN,Request.registrationTbl,Session.goldrush2009.registration_id,Session.goldrush2009.paypal)>

<!--- Finalize session variables --->
<cfset strSuccess = Request.registration_cfc.finalizeRegistrationSession(Session.goldrush2009.paypal)>

<!--- Get data needed for e-mail (team name, etc) --->
<cfset variables.teamName = Request.lookup_cfc.getTeams(Request.dsn,Request.teamTbl,Session.goldrush2009.team_no).team_name>
<cfset variables.qRaces = Request.lookup_cfc.getRaces(Request.dsn,Request.eventTbl,Request.strokeTbl,Request.entryTbl,Session.goldrush2009.athlete_no)>
<cfset variables.excursion = "">
<cfif Session.goldrush2009.excursion>
	<cfset variables.excursion = Request.lookup_cfc.getExcursions(Request.dsn,Request.excursionTbl,Session.goldrush2009.excursion).name>
</cfif>

<cfset variables.nights = "">
<cfif ListLen(Session.goldrush2009.nights)>
	<cfif ListFindNoCase(Session.goldrush2009.nights,"Th")>
		<cfset variables.nights = ListAppend(variables.nights," Thursday")>
	</cfif>
	<cfif ListFindNoCase(Session.goldrush2009.nights,"F")>
		<cfset variables.nights = ListAppend(variables.nights," Friday")>
	</cfif>
	<cfif ListFindNoCase(Session.goldrush2009.nights,"Sat")>
		<cfset variables.nights = ListAppend(variables.nights," Saturday")>
	</cfif>
	<cfif ListFindNoCase(Session.goldrush2009.nights,"Sun")>
		<cfset variables.nights = ListAppend(variables.nights," Sunday")>
	</cfif>
</cfif>

<cfset variables.sleeping = "">
<cfif ListLen(Session.goldrush2009.sleeping)>
	<cfif ListFindNoCase(Session.goldrush2009.sleeping,"couch")>
		<cfset variables.sleeping = ListAppend(variables.sleeping," Couch")>
	</cfif>
	<cfif ListFindNoCase(Session.goldrush2009.sleeping,"own")>
		<cfset variables.sleeping = ListAppend(variables.sleeping," Own bed")>
	</cfif>
	<cfif ListFindNoCase(Session.goldrush2009.sleeping,"share")>
		<cfset variables.sleeping = ListAppend(variables.sleeping," Share with " & Session.goldrush2009.sleeping_share)>
	</cfif>
	<cfif ListFindNoCase(Session.goldrush2009.sleeping,"partner")>
		<cfset variables.sleeping = ListAppend(variables.sleeping," With partner")>
	</cfif>
</cfif>

<cfset variables.temperament = "">
<cfif ListLen(Session.goldrush2009.temperament)>
	<cfif ListFindNoCase(Session.goldrush2009.temperament,"quiet")>
		<cfset variables.temperament = ListAppend(variables.temperament," Quiet")>
	</cfif>
	<cfif ListFindNoCase(Session.goldrush2009.temperament,"moderate")>
		<cfset variables.temperament = ListAppend(variables.temperament," Party reasonably")>
	</cfif>
	<cfif ListFindNoCase(Session.goldrush2009.temperament,"party")>
		<cfset variables.temperament = ListAppend(variables.temperament," Party some")>
	</cfif>
	<cfif ListFindNoCase(Session.goldrush2009.temperament,"monster")>
		<cfset variables.temperament = ListAppend(variables.temperament," Party monster")>
	</cfif>
</cfif>

<!--- Send e-mails --->
<cfset strSuccess = Request.registration_cfc.finalizeRegistrationEmail(Request.from_email,Request.submit_email,Session.goldrush2009,DateAdd("D",14,Request.housingResponseDeadline),Request.mailServer,variables.teamName,variables.qRaces,variables.excursion,TRIM(variables.nights),TRIM(variables.sleeping),TRIM(variables.temperament))>

<cfset variables.success = "yes">
<cfset variables.reason = "Registration Submitted.">
