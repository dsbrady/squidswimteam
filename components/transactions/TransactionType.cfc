component accessors = "true" extends="squid.Base" {
	property name = "activeCode" type="boolean" default = true;
	property name = "createdDate" type = "date";
	property name = "createdUserID" type = "numeric" default = 0;
	property name = "defaultSwims" type = "numeric" default = 0;
	property name = "modifiedDate" type = "date";
	property name = "modifiedUserID" type = "numeric" default = 0;
	property name = "transactionType" type = "string" default = "";
	property name = "transactionTypeID" type = "numeric" default = 0;

	TransactionType function init(required string dsn) {
		super.init(arguments.dsn);
		setCreatedDate(now());
		setModifiedDate(now());
		return this;
	}

	TransactionType function getByTransactionType(required string transactionType) {
		local.query = new Query();
		local.query.setAttributes(datasource = getDSN());
		local.query.setSQL("
			SELECT
				transaction_type_id,
				transaction_type,
				default_swims,
				created_user,
				created_date,
				modified_user,
				modified_date,
				active_code
			FROM
				transactionTypes
			WHERE
				active_code = 1
				AND transaction_type = :transactionType
		");

		local.query.addParam(name = "transactionType", value = arguments.transactionType, cfsqltype = "cf_sql_varchar");
		local.transactionType = local.query.execute().getResult();

		if (local.transactionType.recordCount > 0) {
			setTransactionTypeID(local.transactionType.transaction_type_id);
			setTransactionType(local.transactionType.transaction_type);
			setDefaultSwims(local.transactionType.default_swims);
			setCreatedDate(local.transactionType.created_date);
			setCreatedUserID(local.transactionType.created_user);
			setModifiedDate(local.transactionType.modified_date);
			setModifiedUserID(local.transactionType.modified_user);
			setActiveCode(local.transactionType.active_code);
		}

		return this;
	}
}
