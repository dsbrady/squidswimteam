<cfparam name="attributes.username" default="" type="string">
<cfparam name="attributes.password" default="" type="string">
<cfparam name="attributes.returnFA" default="" type="string">

<cfset authentication = new squid.Authentication(request.dsn) />

<cfset userID = authentication.validateLogin(
		username = attributes.userName,
		password = attributes.password
	) />

<cfif userID EQ 0>
	<cfset getResponse().setBadRequest("The e-mail/password combination you entered was not found") />
<cfelse>
	<!--- Now, we'll load the user into a local object (we won't load into the session until we're sure they're still a member) --->
	<cfset user = new squid.User(application.dsn, userID) />

	<cfif user.getUserStatus() IS NOT "Member">
		<cfset getResponse().setBadRequest("NONMEMBER") />
	<cfelseif dateCompare(user.getExpirationDate(),now()) LT 0>
		<cfset getResponse().setBadRequest("EXPIRED") />
	<cfelse>
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

		<!--- See if the password is temporary --->
		<cfif user.getIsPasswordTemporary()>
			<cfset getResponse().setStatusText("TEMPORARY") />
		</cfif>
	</cfif>
</cfif>
