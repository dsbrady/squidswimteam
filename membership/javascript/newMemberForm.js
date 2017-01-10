$(document).ready
(
	function()
	{
		$('#email').focus();
		$('#email').select();
	}
);

function validate()
{
	var isSuccessful = true;
	var aErrors = [];
	var firstErrorField = '';

	if (trim($("#firstName").val()).length == 0)
	{
		isSuccessful = false;
		aErrors[aErrors.length] = "Please enter your first name.";
		if (firstErrorField == '')
		{
			firstErrorField = $("#firstName");
		}
	}
	if ($("#password").val().length == 0)
	{
		isSuccessful = false;
		aErrors[aErrors.length] = "Please enter your password.";
		if (firstErrorField == '')
		{
			firstErrorField = $("#password");
		}
	}
	else if (!isValidPassword($("#password").val()))
	{
		isSuccessful = false;
		aErrors[aErrors.length] = "The password you entered does not meet the security requirements.";
		if (firstErrorField == '')
		{
			firstErrorField = $("#password");
		}
	}
	else if ($("#password").val() != $("#passwordConfirmation").val())
	{
		isSuccessful = false;
		aErrors[aErrors.length] = "Your two passwords do not match.";
		if (firstErrorField == '')
		{
			firstErrorField = $("#passwordConfirmation");
		}
	}
	if (trim($("#lastName").val()).length == 0)
	{
		isSuccessful = false;
		aErrors[aErrors.length] = "Please enter your last name.";
		if (firstErrorField == '')
		{
			firstErrorField = $("#lastName");
		}
	}
	if (trim($("#emergencyName").val()).length == 0)
	{
		isSuccessful = false;
		aErrors[aErrors.length] = "Please enter the emergency contact name.";
		if (firstErrorField == '')
		{
			firstErrorField = $("#emergencyName");
		}
	}
	if (trim($("#emergencyPhone").val()).length == 0)
	{
		isSuccessful = false;
		aErrors[aErrors.length] = "Please enter the emergency contact phone number.";
		if (firstErrorField == '')
		{
			firstErrorField = $("#emergencyPhone");
		}
	}
	if (!isValidSignature($("#liabilitySignature").val(),$("#firstName").val(),$("#lastName").val()))
	{
		isSuccessful = false;
		aErrors[aErrors.length] = "Please enter your initials to acknowledge your agreement with the viability waiver.";
		if (firstErrorField == '')
		{
			firstErrorField = $("#liabilitySignature");
		}
	}

	if (!isSuccessful)
	{
		alert('Please correct the following errors:\n\n* ' + aErrors.join('\n* '));
		firstErrorField.focus();
		firstErrorField.select();
		return false;
	}

	return true;
}

function isValidSignature(signature, firstName, lastName)
{
	var isValid = true;

	// Make sure the first and last characters of the signature match the first characters of the first and last names
	if (trim(signature).length == 0 || trim(firstName).length == 0 || trim(lastName).length == 0)
	{
		isValid = false;
	}
	else if (signature.charAt(0).toLowerCase() != firstName.charAt(0).toLowerCase() || signature.charAt(signature.length - 1).toLowerCase() != lastName.charAt(0).toLowerCase())
	{
		isValid = false;
	}

	return isValid;
}

