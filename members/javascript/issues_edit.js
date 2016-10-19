function validate(theForm)
{
	with(theForm)
	{
		// Validate data
		if (trim(description.value) == '')
		{
			alert('Please enter the description.');
			description.focus();
			description.select();
			return false;
		}
	}

	return true;
}