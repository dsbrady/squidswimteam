<!---
<fusedoc
	fuse = "val_login.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I validate the login.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="27 May 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
				<string name="changePassword" />
			</structure>

			<string name="username" scope="attributes" />
			<string name="password" scope="attributes" />
			<string name="returnFA" scope="attributes" />

			<structure name="strUser">
				<number name="user_id" />
				<string name="username" />
				<string name="password" />
				<boolean name="tempPassword" />
				<number name="created_user" />
				<datetime name="created_date" />
				<number name="modified_user" />
				<datetime name="modified_date" />
				<number name="active_code" />
			</recordset>
		</in>
		<out>
			<string name="username" scope="formOrUrl" />
			<string name="password" scope="formOrUrl" />
			<string name="returnFA" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>

</fusedoc>
--->
<cfparam name="variables.success" default="true" type="boolean">
<cfparam name="variables.reason" default="" type="string">
<cfparam name="attributes.username" default="" type="string">
<cfparam name="attributes.password" default="" type="string">
<cfparam name="attributes.returnFA" default="" type="string">

<cfset authentication = new squid.Authentication(request.dsn) />

<cfset userID = authentication.validateLogin(
		username = attributes.userName,
		password = attributes.password
	) />

<cfif userID EQ 0>
	<cfset success = false />
	<cfset reason = "The e-mail/password combination you entered was not found.*" />
<cfelse>
	<!--- Now, we'll load the user into a local object (we won't load into the session until we're sure they're still a member) --->
	<cfset user = new squid.User(application.dsn, userID) />

	<cfif user.getUserStatus() IS NOT "Member">
		<cflocation addtoken="false" url="#Request.self#?fuseaction=#XFA.expired#&reason=Guest&first_name=#user.getPreferredName()#&user_id=#user.getUserID()#&username=#user.getUserName()#&created_date=#user.getCreatedDate()#&created_user=#user.getCreatedUserID()#" />
	</cfif>

	<cfif dateCompare(user.getExpirationDate(),now()) LT 0>
		<cflocation addtoken="false" url="#Request.self#?fuseaction=#XFA.expired#&reason=Expired&date_expiration=#dateFormat(user.getExpirationDate(), "MMMM D, YYYY")#&first_name=#user.getPreferredName()#&user_id=#user.getUserID()#&username=#user.getUserName()#&created_date=#user.getCreatedDate()#&created_user=#user.getCreatedUserID()#" />
	</cfif>

	<!--- If we got this far, we're good to log them in --->
	<!--- TODO: We're adding these things to a separate struct until a refactor of the app is done --->
	<cfset session.squid = {
		"user": user,
		"address1": user.getAddress1(),
		"address2": user.getAddress2(),
		"birthday": user.getBirthday(),
		"calendarPref": user.getCalendarPreference(),
		"calendar_preference": user.getCalendarPreferenceID(),
		"city": user.getCity(),
		"comments": user.getComments(),
		"contact_emergency": user.getEmergencyContact(),
		"created_date": user.getCreatedDate(),
		"created_user": user.getCreatedUserID(),
		"country": user.getCountry(),
		"date_expiration": user.getExpirationDate(),
		"email": user.getEmail(),
		"email_preference": user.getEmailPreferenceID(),
		"emailPref": user.getEmailPreference(),
		"fax": user.getFax(),
		"first_name": user.getFirstName(),
		"first_practice": user.getFirstPractice(),
		"intro_pass": user.getUsedIntroPass(),
		"last_name": user.getLastName(),
		"mailingListYN": user.getIsOnMailingList(),
		"medical_conditions": user.getMedicalConditions(),
		"middle_name": user.getMiddleName(),
		"officer": user.getOffices(),
		"permissions": user.getPermissions(),
		"phone_cell": user.getCellPhone(),
		"phone_day": user.getPhoneDay(),
		"phone_emergency": user.getEmergencyPhone(),
		"phone_night": user.getPhoneNight(),
		"picture": user.getPicture(),
		"picture_height": user.getPictureHeight(),
		"picture_width": user.getPictureWidth(),
		"postingPref": user.getPostingPreference(),
		"posting_preference": user.getPostingPreferenceID(),
		"preferred_name": user.getPreferredName(),
		"profile_visible": user.getIsProfileVisible(),
		"state_id": user.getStateID(),
		"status": user.getUserStatusID(),
		"statusType": user.getUserStatus(),
		"tempPassword": user.getIsPasswordTemporary(),
		"username": user.getUserName(),
		"user_id": user.getUserID(),
		"usms_number": user.getUSMSNumber(),
		"usms_year": user.getUSMSYear(),
		"zip": user.getZip()
	} />

	<cfset request.squid = structCopy(session.squid) />
</cfif>

<cfif NOT variables.success>
	<cflocation addtoken="No" url="#Request.self#?fuseaction=#XFA.failure#&username=#attributes.username#&returnFA=#attributes.returnFA#&success=#variables.success#&reason=#variables.reason#">
</cfif>

<!--- See if the password is temporary --->
<cfscript>
	if (Request.squid.tempPassword)
	{
		XFA.success = XFA.changePassword & "&returnFA=" & attributes.returnFA;
	}
	else
	{
		XFA.success = attributes.returnFA;
	}
</cfscript>

