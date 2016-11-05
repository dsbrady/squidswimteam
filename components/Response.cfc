component accessors = "true" {

	property name = "statusCode" type = "numeric" default = "200" setter = "false";
	property name = "statusText" type = "string" default = "OK";

	Response function init() {
		variables.fieldErrors = {};
		variables.values = {};

		return this;
	}

	void function clearFieldErrors() {
		clearStatus();
		structClear(variables.fieldErrors);
	}

	void function clearStatus() {
		variables.statusCode = 200;
		variables.statusText = "OK";
	}

	void function clearValues() {
		structClear(variables.values);
	}

	void function deleteFieldError(required string field) {
		structDelete(variables.fieldErrors, arguments.field);

		if(structIsEmpty(variables.fieldErrors)) {
			clearStatus();
		}
	}

	void function deleteValue(required string key) {
		structDelete(variables.values, arguments.key);
	}

	string function getFieldError(required string field) {
		return hasFieldError(arguments.field) ? variables.fieldErrors[arguments.field] : "";
	}

	struct function getFieldErrors() {
		return variables.fieldErrors;
	}

	string function getValue(required string key) {
		return hasValue(arguments.key) ? variables.values[arguments.key] : "";
	}

	struct function getValues() {
		return variables.values;
	}

	boolean function hasFieldError(required string field) {
		return structKeyExists(variables.fieldErrors, arguments.field);
	}

	boolean function hasFieldErrors() {
		return !structIsEmpty(variables.fieldErrors);
	}

	boolean function hasValue(required string key) {
		return structKeyExists(variables.values, arguments.key);
	}

	boolean function hasValues() {
		return !structIsEmpty(variables.values);
	}

	void function setBadRequest(string message = "") {
		variables.statusCode = 400;
		variables.statusText = arguments.message;
	}

	void function setFieldError(required string field, required string message) {
		if(getStatusCode() == 200) {
			// welp, ya blew that one...
			setBadRequest("Please correct your errors");
		}

		variables.fieldErrors[arguments.field] = arguments.message;
	}

	void function setUnauthorized(string message = "") {
		variables.statusCode = 401;
		variables.statusText = arguments.message;
	}

	void function setValue(required string key, required any value) {
		if(isSimpleValue(arguments.value)) {
			variables.values[arguments.key] = arguments.value;
		}
	}

}