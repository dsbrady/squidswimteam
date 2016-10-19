<!---
<fusedoc
	fuse = "val_registrant_login.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate and process the information.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="5 April 2004" type="Create">
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
<cfparam name="attributes.username" default="" type="string">
<cfparam name="attributes.password" default="" type="string">
<cfparam name="paypalRegistrationIDBlast" default="0" type="numeric">

<cfparam name="strSuccess" default="#StructNew()#" type="struct">
<cfparam name="strSuccess.success" default="yes" type="boolean">
<cfparam name="strSuccess.reason" default="" type="string">

<cfif LEN(attributes.username)>
	<cfset strSuccess = Request.registration_cfc.valLogin(Request.dsn,attributes,Request.registrationTbl,"registration_id")>

	<cfif NOT strSuccess.success>
		<cfscript>
			variables.theURL = Request.self & "/fuseaction/" & XFA.failure;
			variables.theURL = variables.theURL & "/success/" & strSuccess.success & "/reason/" & strSuccess.reason;
		</cfscript>

		<cfloop collection="#attributes#" item="variables.theItem">
			<cfscript>
				if ((variables.theItem IS NOT "SubmitBtn") AND (variables.theItem IS NOT "PreviewBtn") AND (variables.theItem IS NOT "fieldnames") AND (variables.theItem IS NOT "fuseaction") AND (LEN(attributes[variables.theItem])))
				{
					variables.theURL = variables.theURL & "/" & variables.theItem & "/" & attributes[variables.theItem];
				}
			</cfscript>
		</cfloop>

		<cfset variables.theURL = variables.theURL & ".cfm">

		<cflocation addtoken="no" url="#variables.theURL#">
	</cfif>
<cfelseif VAL(attributes.paypalRegistrationIDBlast)>
	<cfset strSuccess.user_id = VAL(attributes.paypalRegistrationIDBlast)>
</cfif>

<!--- Set registration session values --->
<cfset Session.goldrush2009.registration_id = variables.strSuccess.user_id>
<cfset strSuccess = Request.registration_cfc.getRegistrationInfo(Request.dsn,Request.athleteTbl,Request.registrationTbl,Request.entryTbl,Request.registrant_housingTbl,Session.goldrush2009.registration_id)>
<cfscript>
	Session.goldrush2009.athlete_no = VAL(strSuccess.qReg.athlete_no);
	Session.goldrush2009.last_name = strSuccess.qReg.last_name;
	Session.goldrush2009.first_name = strSuccess.qReg.first_name;
	Session.goldrush2009.initial = strSuccess.qReg.initial;
	Session.goldrush2009.pref_name = strSuccess.qReg.pref_name;
	Session.goldrush2009.dob = DateFormat(strSuccess.qReg.birth_date,"m/d/yyyy");
	Session.goldrush2009.ath_sex = strSuccess.qReg.ath_sex;
	Session.goldrush2009.Home_daytele = strSuccess.qReg.Home_daytele;
	Session.goldrush2009.Home_email = strSuccess.qReg.Home_email;
	Session.goldrush2009.Home_addr1 = strSuccess.qReg.Home_addr1;
	Session.goldrush2009.Home_addr2 = strSuccess.qReg.Home_addr2;
	Session.goldrush2009.Home_city = strSuccess.qReg.Home_city;
	Session.goldrush2009.Home_state = strSuccess.qReg.Home_statenew;
	Session.goldrush2009.Home_zip = strSuccess.qReg.Home_zip;
	Session.goldrush2009.Home_country = strSuccess.qReg.Home_cntry;
	Session.goldrush2009.registrationType = strSuccess.qReg.registrationType;
	Session.goldrush2009.donation = VAL(strSuccess.qReg.donation);
	Session.goldrush2009.totalFee = VAL(strSuccess.qReg.totalFee);
	Session.goldrush2009.usms = strSuccess.qReg.usms;
	Session.goldrush2009.team_no = VAL(strSuccess.qReg.team_no);
	Session.goldrush2009.host_id = VAL(strSuccess.qReg.host_id);
	Session.goldrush2009.num_guests = VAL(strSuccess.qReg.num_guests);
	Session.goldrush2009.housing_names = strSuccess.qReg.housing_names;
	Session.goldrush2009.housing_address = strSuccess.qReg.housing_address;
	Session.goldrush2009.housing_city = strSuccess.qReg.housing_city;
	Session.goldrush2009.housing_state = strSuccess.qReg.housing_state;
	Session.goldrush2009.housing_zip = strSuccess.qReg.housing_zip;
	Session.goldrush2009.housing_country = strSuccess.qReg.housing_country;
	Session.goldrush2009.phone_day = strSuccess.qReg.phone_day;
	Session.goldrush2009.phone_evening = strSuccess.qReg.phone_evening;
	Session.goldrush2009.housing_email = strSuccess.qReg.housing_email;
	Session.goldrush2009.nights = VAL(strSuccess.qReg.nights);
	Session.goldrush2009.car = VAL(strSuccess.qReg.car);
	Session.goldrush2009.near_location = strSuccess.qReg.near_location;
	Session.goldrush2009.smoke = VAL(strSuccess.qReg.smoke);
	Session.goldrush2009.allergies = strSuccess.qReg.allergies;
	Session.goldrush2009.needs = strSuccess.qReg.needs;
	Session.goldrush2009.sleeping = strSuccess.qReg.sleeping;
	Session.goldrush2009.sleeping_share = strSuccess.qReg.sleeping_share;
	Session.goldrush2009.temperament = strSuccess.qReg.temperament;
	Session.goldrush2009.payment = strSuccess.qReg.payment;
	Session.goldrush2009.paypal_transaction = strSuccess.qReg.paypal_transaction;
	Session.goldrush2009.registrationFee = VAL(strSuccess.qReg.registrationFee);
	Session.goldrush2009.paymentSubmitted = strSuccess.qReg.paymentSubmitted;
	Session.goldrush2009.registrationSubmitted = strSuccess.qReg.registrationSubmitted;
	Session.goldrush2009.registrationStarted = strSuccess.qReg.registrationStarted;
	Session.goldrush2009.paymentMethod = strSuccess.qReg.paymentMethod;
	Session.goldrush2009.usms_received = strSuccess.qReg.usms_received;
	Session.goldrush2009.races = strSuccess.qReg.races;
	Session.goldrush2009.master = strSuccess.qReg.master;
	Session.goldrush2009.excursion = VAL(strSuccess.qReg.excursion_id);
	Session.goldrush2009.housing = VAL(strSuccess.qReg.housing_id);
	Session.goldrush2009.paypalStatus = strSuccess.qReg.paypalStatus;
	Session.goldrush2009.waiverName = strSuccess.qReg.waiverName;
	Session.goldrush2009.waiverDate = strSuccess.qReg.waiverDate;
	Session.goldrush2009.waiverText = strSuccess.qReg.waiverText;
	Session.goldrush2009.waiverSigned = strSuccess.qReg.waiverSigned;

	Session.goldrush2009.aRaces = ArrayNew(1);
</cfscript>

<cfloop query="strSuccess.qRaces">
	<cfscript>
		ArrayAppend(Session.goldrush2009.aRaces,StructNew());
		Session.goldrush2009.aRaces[ArrayLen(Session.goldrush2009.aRaces)].event_ptr = strSuccess.qRaces.event_ptr;
		Session.goldrush2009.aRaces[ArrayLen(Session.goldrush2009.aRaces)].seedTime = Request.registration_cfc.convertSeed2Minutes(strSuccess.qRaces.seedTime);
	</cfscript>
</cfloop>

<cfset variables.success = "yes">
<cfset variables.reason = "Login Successful.">
