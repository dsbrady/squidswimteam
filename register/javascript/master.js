function validate(theForm)
{
	with (theForm)
	{
		if (first_name.value.length == 0)
		{
			alert('Your first name is required.');
			first_name.focus();
			first_name.select();
			return false;
		}
		if (last_name.value.length == 0)
		{
			alert('Your last name is required.');
			last_name.focus();
			last_name.select();
			return false;
		}
	
		if (dob.value.length == 0)
		{
			alert('Your date of birth is required.');
			dob.focus();
			dob.select();
			return false;
		}
		else if (!isValidDate(dob.value))
		{
			alert('Please enter a valid date of birth.');
			dob.focus();
			dob.select();
			return false;
		}

		if (Home_daytele.value.length < 10)
		{
			alert('Your phone number is required and must be at least 10 characters in length.');
			Home_daytele.focus();
			Home_daytele.select();
			return false;
		}

		if (Home_email.value.length == 0)
		{
			alert('Your e-mail address is required.');
			Home_email.focus();
			Home_email.select();
			return false;
		}
		else if (!isValidEmail(Home_email.value))
		{
			alert('Please enter a valid e-mail address.');
			Home_email.focus();
			Home_email.select();
			return false;
		}
		if (Home_addr1.value.length == 0)
		{
			alert('Your address is required.');
			Home_addr1.focus();
			Home_addr1.select();
			return false;
		}
		if (Home_city.value.length == 0)
		{
			alert('Your city is required.');
			Home_city.focus();
			Home_city.select();
			return false;
		}
	}
	return true;
}