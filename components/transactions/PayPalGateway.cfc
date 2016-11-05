component accessors = "true" extends="squid.Base" {
	property name = "config" type = "struct";

	PayPalGateway function init(required string dsn, required struct config) {
		super.init(arguments.dsn);
		setConfig(arguments.config);

		return this;
	}

	struct function makeDirectPayment(required struct transactionSettings) {
		local.results = {
			"errors": [],
			"isSuccessful": true,
			"payPalResults": {}
		};

		local.payPalService = new http();
		local.payPalService.setMethod("GET");
		local.payPalService.setURL(getConfig().apiURL);
		local.payPalService.addParam(type="URL", name="user", value="#getConfig().apiUsername#");
		local.payPalService.addParam(type="URL", name="pwd", value="#getConfig().apiPassword#");
		local.payPalService.addParam(type="URL", name="signature", value="#getConfig().apiSignature#");
		local.payPalService.addParam(type="URL", name="version", value="#getConfig().apiVersion#");
		local.payPalService.addParam(type="URL", name="method", value="DoDirectPayment");
		local.payPalService.addParam(type="URL", name="paymentAction", value="#arguments.transactionSettings.paymentAction#");
		local.payPalService.addParam(type="URL", name="ipAddress", value="#arguments.transactionSettings.ipAddress#");
		local.payPalService.addParam(type="URL", name="returnFMFDetails", value="#arguments.transactionSettings.returnFMFDetails#");
		local.payPalService.addParam(type="URL", name="creditCardType", value="#arguments.transactionSettings.creditCardType#");
		local.payPalService.addParam(type="URL", name="acct", value="#arguments.transactionSettings.acct#");
		local.payPalService.addParam(type="URL", name="expDate", value="#arguments.transactionSettings.expDate#");
		local.payPalService.addParam(type="URL", name="amt", value="#arguments.transactionSettings.amt#");
		local.payPalService.addParam(type="URL", name="email", value="#arguments.transactionSettings.email#");
		local.payPalService.addParam(type="URL", name="street", value="#arguments.transactionSettings.street#");
		local.payPalService.addParam(type="URL", name="city", value="#arguments.transactionSettings.city#");
		local.payPalService.addParam(type="URL", name="state", value="#arguments.transactionSettings.state#");
		local.payPalService.addParam(type="URL", name="COUNTRYCODE", value="#arguments.transactionSettings.countryCode#");
		local.payPalService.addParam(type="URL", name="ZIP", value="#arguments.transactionSettings.zip#");
		local.payPalService.addParam(type="URL", name="firstname", value="#arguments.transactionSettings.firstName#");
		local.payPalService.addParam(type="URL", name="lastname", value="#arguments.transactionSettings.lastName#");
		local.payPalService.addParam(type="URL", name="desc", value="#arguments.transactionSettings.desc#");

		local.httpResult = local.payPalService.send().getPrefix();
		local.results.payPalResults = parseResponse(local.httpResult.fileContent);

		if (local.results.payPalResults.ack DOES NOT CONTAIN "Success") {
			local.results.isSuccessful = false;
			arrayAppend(local.results.errors,"There was a problem processing your payment. If you feel this is an error, please contact us.");
		}

		return local.results;
	}

	private struct function parseResponse(required string fileContent) {
		local.response = {};

		local.contentArray = listToArray(arguments.fileContent, "&");

		for (local.item in local.contentARray) {
			local.response[listFirst(local.item,"=")] = urlDecode(listRest(local.item,"="));
		}

		return local.response;
	}
}