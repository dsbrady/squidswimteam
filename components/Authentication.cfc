component accessors = "true" extends="Base" {

	Authentication function init(required string dsn) {
		super.init(argumentCollection = arguments);

		return this;
	}

	numeric function validateLogin(required string username, required string password) {
		local.userID = 0;

		// Because the password is hashed, we need to check the username and get the password salt first
		local.usernameQuery = new Query();
		local.usernameQuery.setAttributes(datasource = getDSN());
		local.usernameQuery.setSQL(
				"SELECT
					user_id,
					password,
					passwordSalt
				FROM users
				WHERE
					active_code = 1
					AND
					(
						UPPER(email) = :username
						OR UPPER(username) = :username
					)"
		);
		local.usernameQuery.addParam(name = "username", value = arguments.username, cfsqltype = "cf_sql_varchar");
		local.userInfo = local.usernameQuery.execute().getResult();

		// Now, make sure there was a result and compare the hashed values
		if (local.userInfo.recordCount > 0 && local.userInfo.password == hash(arguments.password & local.userInfo.passwordSalt)) {
			local.userID = local.userInfo.user_id;
		}

		return local.userID;
	}
}
