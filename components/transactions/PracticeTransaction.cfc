component accessors = "true" extends="BaseTransaction" {
	property name = "swims" type = "numeric" default = 0;
	property name = "practiceID" type = "numeric" default = 0;
	property name = "transactionType" type = "TransactionType";

	PracticeTransaction function init(required string dsn) {
		super.init(arguments.dsn);
		setTransactionType(new TransactionType(arguments.dsn));

		return this;
	}

	void function insertTransaction(required numeric memberID, numeric swims = 0, numeric practiceID = 0, required TransactionType transactionType, transactionDate = now(), isConfirmed = false, notes = "", userID = 0) {
		setMemberID(arguments.memberID);
		setSwims(arguments.swims);
		setPracticeID(arguments.practiceID);
		setTransactionType(arguments.transactionType);
		setTransactionDate(arguments.transactionDate);
		setIsConfirmed(arguments.isConfirmed);
		setNotes(arguments.notes);
		setCreatedDate(now());
		setCreatedUserID(arguments.userID);
		setModifiedDate(now());
		setModifiedUserID(arguments.userID);

		save();

		return;
	}

	void function save() {
		local.query = new Query();
		local.query.setAttributes(datasource = getDSN());

		local.query.setSQL("
			DECLARE @transactionID INT
			SET @transactionID = :transactionID

			IF NOT EXISTS( SELECT 1 FROM practiceTransactions WHERE transaction_id = :transactionID )
			BEGIN
				SET NOCOUNT ON;

				INSERT INTO practiceTransactions
				(
					member_id,
					num_swims,
					practice_id,
					transaction_type_id,
					date_transaction,
					paymentConfirmed,
					notes,
					created_user,
					created_date,
					modified_user,
					modified_date
				)
				VALUES
				(
					:memberID,
					:swims,
					:practiceID,
					:transactionTypeID,
					:transactionDate,
					:isConfirmed,
					:notes,
					:createdUserID,
					:createdDate,
					:modifiedUserID,
					:modifiedDate
				);

				SET NOCOUNT OFF;

				SELECT ident_current('practiceTransactions') AS transactionID
			END
			ELSE
			BEGIN
				SET NOCOUNT ON;

				UPDATE practiceTransactions
				SET
					member_id = :memberID,
					num_swims = :swims,
					practice_id = :practiceID,
					transaction_type_id = :transactionTypeID,
					date_transaction = :transactionDate,
					paymentConfirmed = :isConfirmed,
					notes = :notes,
					modified_user = :modifiedUserID,
					modified_date = :modifiedDate,
					active_code = :isActive
				WHERE transaction_id = @transactionID

				SET NOCOUNT OFF;

				SELECT @transactionID AS transactionID
			END
		");

		local.query.addParam(name = "transactionID", value = getTransactionID(), cfsqltype = "cf_sql_integer");
		local.query.addParam(name = "memberID", value = getMemberID(), cfsqltype = "cf_sql_integer");
		local.query.addParam(name = "swims", value = getSwims(), cfsqltype = "cf_sql_integer");
		local.query.addParam(name = "practiceID", value = getPracticeID(), cfsqltype = "cf_sql_integer");
		local.query.addParam(name = "transactionTypeID", value = geTtransactionType().getTransactionTypeID(), cfsqltype = "cf_sql_integer");
		local.query.addParam(name = "transactionDate", value = getTransactionDate(), cfsqltype = "cf_sql_date");
		local.query.addParam(name = "isConfirmed", value = getIsConfirmed(), cfsqltype = "cf_sql_bit");
		local.query.addParam(name = "notes", value = getNotes(), cfsqltype = "cf_sql_varchar");
		local.query.addParam(name = "createdUserID", value = getCreatedUserID(), cfsqltype = "cf_sql_integer");
		local.query.addParam(name = "createdDate", value = getCreatedDate(), cfsqltype = "cf_sql_timestamp");
		local.query.addParam(name = "modifiedUserID", value = getModifiedUserID(), cfsqltype = "cf_sql_integer");
		local.query.addParam(name = "modifiedDate", value = getModifiedDate(), cfsqltype = "cf_sql_timestamp");
		local.query.addParam(name = "isActive", value = getIsActive(), cfsqltype = "cf_sql_bit");

		local.transaction = local.query.execute().getResult();

		if (getTransactionID() == 0) {
			setTransactionID(local.transaction.transactionID);
		}

		return;
	}
}
