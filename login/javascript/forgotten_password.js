function validate(theForm)
{
	with(theForm)
	{
		// Make sure all the fields have something in them
		if (trim(username.value) == '')
		{
			alert('Please enter your e-mail address.');
			username.focus();
			username.select();
			return false;
		}
	}

	return true;
}