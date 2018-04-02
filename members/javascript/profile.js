function validate(theForm)
{
	with(theForm)
	{
		// Validate data
		if (date_expiration && trim(date_expiration.value).length > 0 && (!isValidDate(date_expiration.value)))
		{
			alert('Please enter a valid date for the "Member Until" date.');
			date_expiration.focus();
			date_expiration.select();
			return false;
		}
/* (11/30/2012) This is no longer used
		if (username && (trim(username.value) == ''))
		{
			alert('Please enter the user name.');
			username.focus();
			username.select();
			return false;
		}
*/
		if (email && (trim(email.value) == ''))
		{
			alert('Please enter the e-mail address.');
			email.focus();
			email.select();
			return false;
		}
		if (first_name && (trim(first_name.value) == ''))
		{
			alert('Please enter the first name.');
			first_name.focus();
			first_name.select();
			return false;
		}
		if (last_name && (trim(last_name.value) == ''))
		{
			alert('Please enter the last name.');
			last_name.focus();
			last_name.select();
			return false;
		}
		if (first_practice && trim(first_practice.value).length > 0 && (!isValidDate(first_practice.value)))
		{
			alert('Please enter a valid date for the first practice.');
			first_practice.focus();
			first_practice.select();
			return false;
		}
		if (usms_no && usms_year && trim(usms_no.value).length > 0 && (usms_year.value.length == 0))
		{
			alert('Please enter the year for which your USMS Number is valid.');
			usms_year.focus();
			usms_year.select();
			return false;
		}
		if (birthday && trim(birthday.value).length > 0 && (!isValidDate(birthday.value)))
		{
			alert('Please enter a valid date for the birthday.');
			birthday.focus();
			birthday.select();
			return false;
		}
		if (comments && (trim(comments.value).length > 255))
		{
			alert('The "Comments" field is limited to 255 characters.');
			comments.focus();
			comments.select();
			return false;
		}
	}

	return true;
}