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
		if (trim(content.value) == '')
		{
			alert('Please enter the content.');
			edit.focus();
			return false;
		}
	}

	return true;
}
