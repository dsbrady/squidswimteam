<!---
<fusedoc
	fuse = "val_newMemberForm.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate the new member form
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="13 December 2012" type="Create" />
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
	<cfparam name="attributes.email" default="" type="string" />
	<cfparam name="attributes.password" default="" type="string" />
	<cfparam name="attributes.passwordConfirmation" default="" type="string" />
	<cfparam name="attributes.firstName" default="" type="string" />
	<cfparam name="attributes.middleName" default="" type="string" />
	<cfparam name="attributes.lastName" default="" type="string" />
	<cfparam name="attributes.preferredName" default="" type="string" />
	<cfparam name="attributes.address1" default="" type="string" />
	<cfparam name="attributes.address2" default="" type="string" />
	<cfparam name="attributes.city" default="" type="string" />
	<cfparam name="attributes.stateID" default="CO" type="string" />
	<cfparam name="attributes.zip" default="" type="string" />
	<cfparam name="attributes.country" default="USA" type="string" />
	<cfparam name="attributes.phone1" default="" type="string" />
	<cfparam name="attributes.phoneType1" default="cell" type="string" />
	<cfparam name="attributes.phone2" default="" type="string" />
	<cfparam name="attributes.phoneType2" default="daytime" type="string" />
	<cfparam name="attributes.mailingList" default="false" type="boolean" />
	<cfparam name="attributes.emergencyName" default="" type="string" />
	<cfparam name="attributes.emergencyPhone" default="" type="string" />
	<cfparam name="attributes.emergencyRelation" default="" type="string" />
	<cfparam name="attributes.liabilitySignature" default="" type="string" />
	<cfparam name="attributes.liabilitySignatureDate" default="" type="string" />

	<cfset request.stSuccess = structNew() />
	<cfset request.stSuccess.isSuccessful = true />
	<cfset request.stSuccess.aErrors = arrayNew(1) />

	<!--- Validate Info --->
	<cfif len(trim(attributes.email)) EQ 0 OR NOT isValid("email", attributes.email)>
		<cfset request.stSuccess.isSuccessful = false />
		<cfset arrayAppend(request.stSuccess.aErrors,"Please enter a valid e-mail address.") />
	<cfelseif request.profileCFC.emailAddressExists(request.dsn,attributes.email)>
		<cfset request.stSuccess.isSuccessful = false />
		<cfset arrayAppend(request.stSuccess.aErrors,"The e-mail address you entered already exists. Please enter another valid e-mail address.") />
	</cfif>

	<cfif len(trim(attributes.password)) EQ 0 OR NOT request.profileCFC.isValidPassword(attributes.password, request.validPasswordRegularExpression)>
		<cfset request.stSuccess.isSuccessful = false />
		<cfset arrayAppend(request.stSuccess.aErrors,"Please enter a valid password.") />
	</cfif>

	<cfif len(trim(attributes.firstName)) EQ 0>
		<cfset request.stSuccess.isSuccessful = false />
		<cfset arrayAppend(request.stSuccess.aErrors,"Please enter your first name.") />
	</cfif>
	<cfif len(trim(attributes.lastName)) EQ 0>
		<cfset request.stSuccess.isSuccessful = false />
		<cfset arrayAppend(request.stSuccess.aErrors,"Please enter your last name.") />
	</cfif>
	<cfif len(trim(attributes.emergencyName)) EQ 0>
		<cfset request.stSuccess.isSuccessful = false />
		<cfset arrayAppend(request.stSuccess.aErrors,"Please enter the name of your emergency contact.") />
	</cfif>
	<cfif len(trim(attributes.emergencyPhone)) EQ 0>
		<cfset request.stSuccess.isSuccessful = false />
		<cfset arrayAppend(request.stSuccess.aErrors,"Please enter the phone number of your emergency contact.") />
	</cfif>
	<cfif len(trim(attributes.liabilitySignature)) EQ 0 OR NOT request.membersCFC.isValidLiabilitySignature(attributes.liabilitySignature,attributes.firstName,attributes.lastName)>
		<cfset request.stSuccess.isSuccessful = false />
		<cfset arrayAppend(request.stSuccess.aErrors,"Please enter a valid signature.") />
	</cfif>

