function validate(theForm)
{
	with(theForm)
	{
		// Validate data
		if (trim(first_name.value) == '')
		{
			alert('Please enter the first name.');
			first_name.focus();
			first_name.select();
			return false;
		}
		if (trim(last_name.value) == '')
		{
			alert('Please enter the last name.');
			last_name.focus();
			last_name.select();
			return false;
		}
		if (trim(email.value) == '')
		{
			alert('Please enter the e-mail address.');
			email.focus();
			email.select();
			return false;
		}
		if (trim(birthday.value).length > 0 && (!isValidDate(birthday.value)))
		{
			alert('Please enter a valid date for the birthday.');
			birthday.focus();
			birthday.select();
			return false;
		}
	}

	return true;
}