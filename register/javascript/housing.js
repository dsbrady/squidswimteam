function validate(theForm)
{
	var cbFlag = false;

	with (theForm)
	{
		if (names.value.length == 0)
		{
			alert('The guests\' names are required.');
			names.focus();
			names.select();
			return false;
		}

		if (address.value.length == 0)
		{
			alert('Your address is required.');
			address.focus();
			address.select();
			return false;
		}

		if (city.value.length == 0)
		{
			alert('Your city is required.');
			city.focus();
			city.select();
			return false;
		}

		if (email.value.length == 0)
		{
			alert('Your e-mail address is required.');
			email.focus();
			email.select();
			return false;
		}
		else if (!isValidEmail(email.value))
		{
			alert('Please enter a valid e-mail address.');
			email.focus();
			email.select();
			return false;
		}

		nightsLoop:
		for (var i = 0; i<nights.length; i++)
		{
			if (nights[i].checked)
			{
				cbFlag = true;
				break nightsLoop;
			}
		}
		if (!cbFlag)
		{
			alert('Please select the nights for which you are requesting housing.');
			nights[0].focus();
			return false;
		}

		cbFlag = false;

		sleepingLoop:
		for (var i = 0; i<sleeping.length; i++)
		{
			if (sleeping[i].checked)
			{
				cbFlag = true;
				break sleepingLoop;
			}
		}
		if (!cbFlag)
		{
			alert('Please select sleeping arrangements you would prefer.');
			sleeping[0].focus();
			return false;
		}

		cbFlag = false;

		temperamentLoop:
		for (var i = 0; i<temperament.length; i++)
		{
			if (temperament[i].checked)
			{
				cbFlag = true;
				break temperamentLoop;
			}
		}
		if (!cbFlag)
		{
			alert('Please select your temperament style.');
			temperament[0].focus();
			return false;
		}
	}

	return true;
}