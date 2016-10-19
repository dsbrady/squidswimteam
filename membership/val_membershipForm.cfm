<!---
<fusedoc
	fuse = "val_membershipForm.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I process the membership and direct them to PayPal.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="2 October 2004" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>

			<number name="numSwims" scope="attributes" />
		</in>
		<out>
			<number name="numSwims" scope="formOrUrl" />
			<number name="totalSwims" scope="formOrUrl" />
			<number name="swimsCost" scope="formOrUrl" />

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

<!--- Get Member Info --->
<cfif VAL(Request.squid.user_id)>
	<cfset stMember = Request.squid />
<cfelse>
	<cfset loginCFC = CreateObject("component",Request.login_cfc) />
	<cfset memberCFC = CreateObject("component",Request.members_cfc) />
	<cfset stMember = StructNew() />
	<cfif VAL(attributes.user_id)>
		<cfset stMember.user_id = attributes.user_id />
	<cfelse>
		<!--- If user is new, create user --->
		<cfif NOT len(attributes.preferred_name)>
			<cfset attributes.preferred_name = attributes.first_name />
		</cfif>
		<cfset stMember.user_id = memberCFC.addUser(attributes,Request.usersTbl,Request.user_statusTbl,lookupCFC,Request.DSN) />
	</cfif>
	<cfset stMember = variables.loginCFC.getUserInfo(stMember,Request.usersTbl,Request.preferenceTbl,Request.developerTbl,Request.testerTbl,Request.user_statusTbl,Request.DSN) />
</cfif>


<!--- Update database --->
<cfset stSuccess = memberCFC.payDues(Request.dsn,Request.membershipTransactionTbl,attributes,Request.squid.user_id,session.squid.stDues) />

<cfset Request.paypal_itemNo = stSuccess.transaction_id />

<!--- Redirect --->
<cfset paypalURL = "https://www.paypal.com/xclick/business=#Request.from_email#&item_name=#Request.paypal_item#&item_number=#URLEncodedFormat(Request.paypal_itemNo)#&amount=#session.squid.stDues.fee[session.squid.stDues.duesIndex]#&no_note=1&currency_code=USD&custom=#session.squid.stDues.membershipYear[session.squid.stDues.duesIndex]#|#stMember.user_id#&rm=1&return=#Request.paypal_returnURL#">
<cflocation addtoken="No" url="#variables.paypalURL#">
