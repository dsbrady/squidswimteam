component accessors = "true" extends="Base" {

	property name = "address1" type = "string" default = "";
	property name = "address2" type = "string" default = "";
	property name = "birthday" type = "date" default = "";
	property name = "calendarPreference" type = "string" default = "";
	property name = "calendarPreferenceID" type = "numeric" default = 6;
	property name = "cellPhone" type = "string" default = "";
	property name = "city" type = "string" default = "";
	property name = "comments" type = "string" default = "";
	property name = "createdDate" type = "date";
	property name = "createdUserID" type = "numeric" default = 0;
	property name = "country" type = "string" default = "US";
	property name = "email" type = "string" default = "";
	property name = "emailPreference" type = "string" default = "";
	property name = "emailPreferenceID" type = "numeric" default = 1;
	property name = "emergencyContact" type = "string" default = "";
	property name = "emergencyPhone" type = "string" default = "";
	property name = "expirationDate" type = "date" default = "12/31/2999 23:59:59";
	property name = "fax" type = "string" default = "";
	property name = "firstName" type = "string" default = "";
	property name = "firstPractice" type = "date";
	property name = "isOnMailingList" type = "boolean" default = false;
	property name = "isPasswordTemporary" type = "boolean" default = true;
	property name = "isProfileVisible" type = "boolean" default = true;
	property name = "lastName" type = "string" default = "";
	property name = "medicalConditions" type = "string" default = "";
	property name = "middleName" type = "string" default = "";
	property name = "offices" type = "array";
	property name = "permissions" type = "string" default = "";
	property name = "phoneDay" type = "string" default = "";
	property name = "phoneNight" type = "string" default = "";
	property name = "picture" type = "string" default = "";
	property name = "pictureHeight" type = "numeric" default = 0;
	property name = "pictureWidth" type = "numeric" default = 0;
	property name = "postingPreference" type = "string" default = "";
	property name = "postingPreferenceID" type = "numeric" default = 3;
	property name = "preferredName" type = "string" default = "";
	property name = "stateID" type = "string" default = "CO";
	property name = "swimBalance" type = "numeric" default = "0";
	property name = "usedIntroPass" type = "boolean" default = false;
	property name = "userID" type = "numeric" default = "0";
	property name = "username" type = "string" default = "";
	property name = "userStatus" type = "string" default = "";
	property name = "userStatusID" type = "numeric" default = 0;
	property name = "usmsNumber" type = "string" default = "";
	property name = "usmsYear" type = "string" default = "";
	property name = "zip" type = "string" default = "";

	User function init(required string dsn, required numeric userID) {
		super.init(arguments.dsn);
		return load(arguments.userID);
	}

	User function load(required numeric userID) {
		if (arguments.userID > 0) {
			local.userQuery = new Query();
			local.userQuery.setAttributes(datasource = getDSN());
			local.userQuery.setSQL("
					; WITH balances AS (
						SELECT
							member_id,
							SUM(num_swims) AS balance
						FROM practiceTransactions
						WHERE
							active_code = 1
							AND paymentConfirmed = 1
						GROUP BY member_id
					)
					SELECT
						u.user_id,
						u.username,
						u.first_name,
						u.middle_name,
						u.last_name,
						u.preferred_name,
						u.phone_cell,
						u.email,
						u.email_preference,
						ep.preference AS emailPref,
						u.posting_preference,
						pp.preference AS postingPref,
						u.calendar_preference,
						cp.preference AS calendarPref,
						u.address1,
						u.address2,
						u.city,
						u.state_id,
						u.zip,
						u.country,
						u.phone_day,
						u.phone_night,
						u.fax,
						u.comments,
						u.first_practice,
						u.medical_conditions,
						u.contact_emergency,
						u.phone_emergency,
						u.birthday,
						u.usms_number,
						u.usms_year,
						u.intro_pass,
						u.picture,
						u.picture_height,
						u.picture_width,
						u.date_expiration,
						u.profile_visible,
						u.user_status_id,
						st.status,
						ISNULL(b.balance,0) AS swimBalance,
						u.tempPassword,
						u.mailingListYN,
						u.created_date,
						u.created_user
					FROM
						users u
						INNER JOIN preferences ep ON ep.preference_id = u.email_preference
						INNER JOIN preferences pp ON pp.preference_id = u.posting_preference
						INNER JOIN preferences cp ON cp.preference_id = u.calendar_preference
						INNER JOIN userStatuses st ON st.user_status_id = u.user_status_id
						LEFT OUTER JOIN balances b ON u.user_id = b.member_id
					WHERE
						u.user_id = :userID
			");
			local.userQuery.addParam(name = "userID", value = arguments.userID, cfsqltype = "cf_sql_integer");
			local.userInfo = local.userQuery.execute().getResult();

			setAddress1(local.userInfo.address1);
			setAddress2(local.userInfo.address2);
			setBirthday(local.userInfo.birthday);
			setCalendarPreference(local.userInfo.calendarPref);
			setCalendarPreferenceID(local.userInfo.calendar_preference);
			setCellPhone(local.userInfo.phone_cell);
			setCity(local.userInfo.city);
			setComments(local.userInfo.comments);
			setCreatedDate(local.userInfo.created_date);
			setCreatedUserID(local.userInfo.created_user);
			setCountry(local.userInfo.country);
			setEmail(local.userInfo.email);
			setEmailPreference(local.userInfo.emailPref);
			setEmailPreferenceID(local.userInfo.email_preference);
			setEmergencyContact(local.userInfo.contact_emergency);
			setEmergencyPhone(local.userInfo.phone_emergency);
			setExpirationDate(local.userInfo.date_expiration);
			setFax(local.userInfo.fax);
			setFirstName(local.userInfo.first_name);
			setFirstPractice(local.userInfo.first_practice);
			setIsOnMailingList(local.userInfo.mailingListYN);
			setIsPasswordTemporary(local.userInfo.tempPassword);
			setIsProfileVisible(local.userInfo.profile_visible);
			setLastName(local.userInfo.last_name);
			setMedicalConditions(local.userInfo.medical_conditions);
			setMiddleName(local.userInfo.middle_name);
			setPhoneDay(local.userInfo.phone_day);
			setPhoneNight(local.userInfo.phone_night);
			setPicture(local.userInfo.picture);
			setPictureHeight(local.userInfo.picture_height);
			setPictureWidth(local.userInfo.picture_width);
			setPostingPreference(local.userInfo.postingPref);
			setPostingPreferenceID(local.userInfo.posting_preference);
			setPreferredName(local.userInfo.preferred_name);
			setStateID(local.userInfo.state_id);
			setSwimBalance(local.userInfo.swimBalance);
			setUsedIntroPass(local.userInfo.intro_pass);
			setUserID(local.userInfo.user_id);
			setUsername(local.userInfo.username);
			setUserStatus(local.userInfo.status);
			setUserStatusID(local.userInfo.user_status_id);
			setUSMSNumber(local.userInfo.usms_number);
			setUSMSYear(local.userInfo.usms_year);
			setZIP(local.userInfo.zip);

			setPermissions(loadPermissions());
			setOffices(loadOffices());
		}

		return this;
	}

	private array function loadOffices() {
		local.offices = [];
		local.officerQuery = new Query();
		local.officerQuery.setAttributes(datasource = getDSN());
		local.officerQuery.setSQL("
			SELECT
				o.officer_type_id,
				ot.officer_type,
				ot.profile,
				o.date_start,
				o.date_end
			FROM
				officerTypes ot,
				officers o
			WHERE
				o.officer_type_id = ot.officer_type_id
				AND o.active_code = 1
				AND o.user_id = :userID
		");
		local.officerQuery.addParam(name = "userID", value = getUserID(), cfsqltype = "cf_sql_integer");
		local.officerResult = local.officerQuery.execute().getResult();

		for (local.office in local.officerResult) {
			arrayAppend(local.offices, local.office);
		}

		return local.offices;
	}

	private string function loadPermissions() {
		local.permissionsQuery = new Query();
		local.permissionsQuery.setAttributes(datasource = getDSN());
		local.permissionsQuery.setSQL("
			SELECT
				obj.object_name
			FROM
				officerPermissions op,
				officers o,
				objects obj
			WHERE
				o.officer_type_id = op.officer_type_id
				AND op.object_id = obj.object_id
				AND o.active_code = 1
				AND op.active_code = 1
				AND obj.active_code = 1
				AND o.user_id = :userID
		");
		local.permissionsQuery.addParam(name = "userID", value = getUserID(), cfsqltype = "cf_sql_integer");
		local.permissions = local.permissionsQuery.execute().getResult();

		return valueList(local.permissions.object_name);
	}
}
