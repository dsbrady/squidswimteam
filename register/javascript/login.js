function validate(theForm)
{
	with (theForm)
	{
		if (username.value.length == 0)
		{
			alert('Your user name is required.');
			username.focus();
			username.select();
			return false;
		}
		if (password.value.length == 0)
		{
			alert('Your password is required.');
			password.focus();
			password.select();
			return false;
		}
	}

	return true;
}