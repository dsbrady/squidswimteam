component accessors = "true" extends="squid.Base" {
	property name = "isActive" type="boolean" default = true;
	property name = "createdDate" type = "date";
	property name = "createdUserID" type = "numeric" default = 0;
	property name = "isConfirmed" type = "boolean" default = false;
	property name = "transactionDate" type = "date";
	property name = "defaultSwims" type = "numeric" default = 0;
	property name = "modifiedDate" type = "date";
	property name = "modifiedUserID" type = "numeric" default = 0;
	property name = "memberID" type = "numeric" default = 0;
	property name = "notes" type = "string" default = "";
	property name = "transactionID" type = "numeric" default = 0;

	BaseTransaction function init(required string dsn) {
		super.init(arguments.dsn);

		setCreatedDate(now());
		setModifiedDate(now());
		setTransactionDate(now());

		return this;
	}

	void function insertTransaction() {
		throw(type="squid.transactions.BaseTransaction" message="Implment the insertTransaction() method!" detail="The insertTransaction() method must be overridden in an implementing class");
	}

	void function save() {
		throw(type="squid.transactions.BaseTransaction" message="Implment the save() method!" detail="The save() method must be overridden in an implementing class");
	}
}
