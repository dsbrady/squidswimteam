$(document).ready
(
	function()
	{
		$("#useContactAddress").click(populateBillingAddress);
		$("#paymentForm").submit(validatePayment);
	}
);

function populateBillingAddress()
{
	if ($("#useContactAddress").attr('checked'))
	{
		$("#billingStreet").val($("#address1").val());
		$("#billingCity").val($("#city").val());
		$("#billingState").val($("#stateID").val());
		$("#billingZip").val($("#zip").val());
		$("#billingCountry").val($("#country").val().slice(0,2));
	}
	else
	{
		$("#billingStreet").val('');
		$("#billingCity").val('');
		$("#billingState").val('CO');
		$("#billingZip").val('');
		$("#billingCountry").val('US');
		$("#billingStreet").focus();
	}
	
	return true;
}
function validatePayment()
{
	var isSuccessful = true;
	var aErrors = [];
	var firstErrorField = '';
	var currentDate = new Date();

	$("#submitBtn").attr('disabled',true);
	if (trim($("#creditCardTypeID").val()).length == 0)
	{
		isSuccessful = false;
		aErrors[aErrors.length] = "Please select a credit card type.";
		if (firstErrorField == '')
		{
			firstErrorField = $("#creditCardTypeID");
		}
	}

	if (trim($("#creditCardNumber").val()).length == 0 || !checkCreditCard($("#creditCardNumber").val(),$('#creditCardTypeID option:selected').text()))
	{
		isSuccessful = false;
		aErrors[aErrors.length] = "Please enter a valid credit card number.";
		if (firstErrorField == '')
		{
			firstErrorField = $("#creditCardNumber");
		}
	}

	if (($("#creditCardExpirationYear").val() <= currentDate.getFullYear()) && $("#creditCardExpirationMonth").val() < (currentDate.getMonth() + 1))
	{
		isSuccessful = false;
		aErrors[aErrors.length] = "Please select a valid expiration date.";
		if (firstErrorField == '')
		{
			firstErrorField = $("#creditCardExpirationMonth");
		}
	}

	if (trim($("#creditCardVerificationNumber").val()).length == 0)
	{
		isSuccessful = false;
		aErrors[aErrors.length] = "Please enter the card verification number.";
		if (firstErrorField == '')
		{
			firstErrorField = $("#creditCardVerificationNumber");
		}
	}

	if (trim($("#nameOnCard").val()).length == 0)
	{
		isSuccessful = false;
		aErrors[aErrors.length] = "Please enter the name on your card.";
		if (firstErrorField == '')
		{
			firstErrorField = $("#nameOnCard");
		}
	}

	if (trim($("#billingStreet").val()).length == 0)
	{
		isSuccessful = false;
		aErrors[aErrors.length] = "Please enter the billing address.";
		if (firstErrorField == '')
		{
			firstErrorField = $("#billingStreet");
		}
	}

	if (trim($("#billingCity").val()).length == 0)
	{
		isSuccessful = false;
		aErrors[aErrors.length] = "Please enter the billing city.";
		if (firstErrorField == '')
		{
			firstErrorField = $("#billingCity");
		}
	}

	if (trim($("#billingZip").val()).length == 0)
	{
		isSuccessful = false;
		aErrors[aErrors.length] = "Please enter the billing ZIP/Postal Code.";
		if (firstErrorField == '')
		{
			firstErrorField = $("#billingZip");
		}
	}

	if (!isSuccessful)
	{
		alert('Please correct the following errors:\n\n* ' + aErrors.join('\n* '));
		firstErrorField.focus();
		firstErrorField.select();
		$("#submitBtn").attr('disabled',false);
		return false;
	}

	return true;
}
