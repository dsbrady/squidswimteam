component accessors = "true" {

	property name = "dsn" type = "string" default = "squidsql";

	Base function init(required string dsn) {
		setDSN(arguments.dsn);

		return this;
	}
}
