component accessors = "true" extends="Base" {

	Users function init(required string dsn) {
		super.init(arguments.dsn);
		return this;
	}

	User function getByEmailAddress(required string email) {
		local.userQuery = new Query();
		local.userQuery.setAttributes(datasource = getDSN());
		local.userQuery.setSQL("
			SELECT user_id
			FROM users
			WHERE email = :email
		");
		local.userQuery.addParam(name = "email", value = arguments.email, cfsqltype = "cf_sql_varchar");
		local.userInfo = local.userQuery.execute().getResult();

		local.user = new User(getDSN(), isValid("integer", local.userInfo.user_id) ? local.userInfo.user_id : 0 );

		return local.user;
	}
}
