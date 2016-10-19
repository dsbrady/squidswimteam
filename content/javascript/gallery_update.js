function validate(theForm)
{
	with(theForm)
	{
		// Validate data
		if (trim(title.value) == '')
		{
			alert('Please enter the title.');
			title.focus();
			title.select();
			return false;
		}
	}

	return true;
}

