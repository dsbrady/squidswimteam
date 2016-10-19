<!---
<fusedoc
	fuse = "val_membershipPayment.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I process the PayPal payment and membership (if successful)
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="7 January 2013" type="Create" />
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
<cfparam name="attributes.user_id" default="#Request.squid.user_id#" type="numeric" />
<cfparam name="attributes.first_name" default="" type="string" />
<cfparam name="attributes.middle_name" default="" type="string" />
<cfparam name="attributes.last_name" default="" type="string" />
<cfparam name="attributes.preferred_name" default="" type="string" />
<cfparam name="attributes.address1" default="" type="string" />
<cfparam name="attributes.address2" default="" type="string" />
<cfparam name="attributes.city" default="" type="string" />
<cfparam name="attributes.state_id" default="CO" type="string" />
<cfparam name="attributes.zip" default="" type="string" />
<cfparam name="attributes.country" default="" type="string" />
<cfparam name="attributes.email" default="" type="string" />
<cfparam name="attributes.email_format" default="plain" type="string" />
<cfparam name="attributes.birthday" default="" type="string" />
<cfparam name="attributes.phone_cell" default="" type="string" />
<cfparam name="attributes.phone_day" default="" type="string" />
<cfparam name="attributes.phone_night" default="" type="string" />
<cfparam name="attributes.fax" default="" type="string" />
<cfparam name="attributes.contact_emergency" default="" type="string" />
<cfparam name="attributes.phone_emergency" default="" type="string" />
<cfparam name="attributes.usms_no" default="" type="string" />
<cfparam name="attributes.medical_conditions" default="" type="string" />
<cfparam name="attributes.creditCardTypeID" default="" type="string" />
<cfparam name="attributes.creditCardNumber" default="" type="string" />
<cfparam name="attributes.creditCardExpirationMonth" default="0" type="numeric" />
<cfparam name="attributes.creditCardExpirationYear" default="0" type="numeric" />
<cfparam name="attributes.creditCardVerificationNumber" default="" type="string" />
<cfparam name="attributes.nameOnCard" default="" type="string" />
<cfparam name="attributes.billingStreet" default="" type="string" />
<cfparam name="attributes.billingCity" default="" type="string" />
<cfparam name="attributes.billingState" default="" type="string" />
<cfparam name="attributes.billingZip" default="" type="string" />
<cfparam name="attributes.billingCountry" default="" type="string" />

<!--- Get Member Info --->
<cfif VAL(Request.squid.user_id)>
	<cfset stMember = Request.squid />
<cfelse>
	<cfset request.loginCFC = createObject("component",Request.login_cfc) />
	<cfset stMember = StructNew() />
	<cfif VAL(attributes.user_id)>
		<cfset stMember.user_id = attributes.user_id />
	<cfelse>
		<!--- If user is new, create user --->
		<cfif NOT len(attributes.preferred_name)>
			<cfset attributes.preferred_name = attributes.first_name />
		</cfif>
		<cfset stMember.user_id = membersCFC.addUser(attributes,Request.usersTbl,Request.user_statusTbl,lookupCFC,Request.DSN) />
	</cfif>
	<cfset stMember = request.loginCFC.getUserInfo(stMember,Request.usersTbl,Request.preferenceTbl,Request.developerTbl,Request.testerTbl,Request.user_statusTbl,Request.DSN) />
</cfif>


<!--- Update database --->
<cfset request.stSuccess = request.membersCFC.payDues(Request.dsn,Request.membershipTransactionTbl,attributes,Request.squid.user_id,session.squid.stDues) />

<cfset request.stPaypal = structNew() />
<cfset request.stPaypal.paymentAction = "Sale" />
<cfset request.stPaypal.ipAddress = cgi.remote_addr />
<cfset request.stPaypal.desc = "SQUID Dues" />
<cfset request.stPaypal.invNumber = request.stSuccess.transaction_id />
<cfset request.stPaypal.returnFMFDetails = 1 />
<cfset request.stPaypal.creditCardType = attributes.creditCardTypeID />
<cfset request.stPaypal.acct = attributes.creditCardNumber />
<cfset request.stPaypal.expDate = numberFormat(attributes.creditCardExpirationMonth,"00") & attributes.creditCardExpirationYear />
<cfset request.stPaypal.cvv2 = attributes.creditCardVerificationNumber />
<cfset request.stPaypal.amt = session.squid.stDues.fee[session.squid.stDues.duesIndex] />
<cfset request.stPaypal.email = attributes.email />
<cfset request.stPaypal.street = attributes.billingStreet />
<cfset request.stPaypal.city = attributes.billingCity />
<cfset request.stPaypal.state = attributes.billingState />
<cfset request.stPaypal.COUNTRYCODE = attributes.billingCountry />
<cfset request.stPaypal.ZIP = attributes.billingZip />
<cfset request.stPaypal.firstname = listFirst(attributes.nameOnCard," ") />
<cfset request.stPaypal.lastname = listRest(attributes.nameOnCard," ") />

<cfset request.objPayPal = createObject("component",request.paypal_cfc) />
<cfset request.stSuccess = request.objPayPal.doDirectPayment(application.stPayPalSettings,request.stPaypal) />

<!--- If it wasn't successful, error out --->
<cfif NOT request.stSuccess.isSuccessful>
	<cfset success = "No" />
	<cfset reason = "There was a problem verifying your transaction. Please contact the Treasurer.*" />

	<cflocation addtoken="false" url="#Request.self#?fuseaction=#XFA.next#&transaction_id=#request.stPaypal.invNumber#&success=#variables.success#&reason=#variables.reason#" />
</cfif>

<!--- Update Membership and transaction Info --->
<cfset request.membersCFC.payDuesConfirm(Request.dsn,Request.usersTbl,Request.user_statusTbl,request.lookupCFC,attributes.user_id,session.squid.stDues.membershipYear[session.squid.stDues.duesIndex],"PayPal Transaction ###request.stSuccess.stPaypalResults.transactionID#",request.stPaypal.invNumber) />

<!--- Set up e-mail content --->
<cfset qMember = request.lookupCFC.getMembers(Request.dsn,Request.usersTbl,Request.user_statusTbl,Request.practice_transactionTbl,Request.transaction_typeTbl,attributes.user_id) />
<cfset stEmail = request.membersCFC.payDuesEmail(Request.dsn,Request.usersTbl,qMember,request.stSuccess.stPaypalResults,session.squid.stDues.membershipYear[session.squid.stDues.duesIndex]) />

<!--- Send e-mail to user --->
<cfif LEN(trim(qMember.email))>
<cfmail from="#Request.from_email#" to="#qMember.email#" subject="SQUID Membership Dues - #session.squid.stDues.membershipYear[session.squid.stDues.duesIndex]#" server="mail.squidswimteam.org">
#stEmail.userMail#
</cfmail>
</cfif>

<!--- Send e-mail to squid --->
<cfmail from="#Request.from_email#" to="dsbrady@protonmail.com,treasurer@squidswimteam.org" subject="SQUID Membership Dues (#session.squid.stDues.membershipYear[session.squid.stDues.duesIndex]#) - #qMember.preferred_name# #qMember.last_name#" server="mail.squidswimteam.org">
#stEmail.squidMail#
</cfmail>

<!--- Redirect --->
<cflocation addtoken="false" url="#Request.self#?fuseaction=#XFA.next#&transaction_id=#request.stPaypal.invNumber#&paypalTransactionID=#request.stSuccess.stPaypalResults.transactionID#" />
