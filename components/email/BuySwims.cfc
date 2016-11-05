component accessors = "true" extends="Email" {

	property name = "adminRecipients" type = "string" default = "";

	BuySwims function init(required string dsn, required struct config) {
		super.init(arguments.dsn, arguments.config);
		setAdminRecipients("dsbrady@protonmail.com,treasurer@squidswimteam.org");

		return this;
	}

	void function buildUserEmail(required squid.User user, required struct transactionInfo) {
		local.subject = "SQUID Swims Purchase";
		local.body = "<p>#len(arguments.user.getPreferredName()) GT 0 ? arguments.user.getPreferredName() : arguments.user.getEmail()#,</p><p>You have successfully purchased #arguments.transactionInfo.swims# swims via PayPal. The details of your transaction are below.</p>";
		local.body &= buildCommonContent(arguments.user, arguments.transactionInfo);
		local.body &= "<p>If you have any questions, please contact us at #getReplyTo()#.</p>";

		setSubject(local.subject);
		setBody(local.body);
		setRecipient(arguments.user.getEmail());

		return;
	}

	void function buildAdminEmail(required squid.User user, required struct transactionInfo) {
		local.subject = "SQUID Swims Purchase - #arguments.user.getPreferredName()# #arguments.user.getLastName()#";
		local.body = "<p>#len(arguments.user.getPreferredName()) GT 0 ? "#arguments.user.getPreferredName()# #arguments.user.getLastName()#" : arguments.user.getEmail()# has successfully purchased #arguments.transactionInfo.swims# swims via PayPal. The details of the transaction are below.</p>";
		local.body &= buildCommonContent(arguments.user, arguments.transactionInfo);

		setSubject(local.subject);
		setBody(local.body);
		setRecipient(getAdminRecipients());

		return;
	}

	private string function buildCommonContent(required squid.User user, required struct transactionInfo) {
		local.content = "<table>";

		if (len(arguments.user.getPreferredName()) > 0) {
			local.content &= "<tr><td>Name:</td><td>#arguments.user.getPreferredName()# #arguments.user.getLastName()#</td></tr>";
		}
		local.content &= "
			<tr><td>Email:</td><td>#arguments.user.getEmail()#</td></tr>
			<tr><td>Swims:</td><td>#arguments.transactionInfo.swims#</td></tr>
			<tr><td>Cost:</td><td>#dollarFormat(arguments.transactionInfo.cost)#</td></tr>
			<tr><td>PayPal Transaction ID:</td><td>#arguments.transactionInfo.paypalTransactionID#</td></tr></table>
		";

		return local.content;
	}
}
