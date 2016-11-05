component accessors = "true" extends="squid.Base" {

	property name = "body" type = "string" default = "";
	property name = "recipient" type = "string" default = "";
	property name = "replyTo" type = "string" default = "";
	property name = "sender" type = "string" default = "";
	property name = "server" type = "string" default = "";
	property name = "subject" type = "string" default = "";

	Email function init(required string dsn, required struct config) {
		super.init(arguments.dsn);

		setSender(arguments.config.defaultSender);
		setServer(arguments.config.mailServer);
		setReplyTo(arguments.config.defaultSender);

		return this;
	}

	void function send() {
		local.mailService = new mail();
		local.mailService.setTo(getRecipient());
		local.mailService.setFrom(getSender());
		local.mailService.setReplyTo(getReplyTo());
		local.mailService.setServer(getServer());
		local.mailService.setType("html");
		local.mailService.setSubject(getSubject());
		local.mailService.setBody(getBody());

		local.mailService.send();

		return;
	}
}
