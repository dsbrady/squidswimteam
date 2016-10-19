function validate(theForm)
{
	with(theForm)
	{
		// Validate data
		if (trim(facility.value) == '')
		{
			alert('Please enter the facility.');
			facility.focus();
			facility.select();
			return false;
		}
	}

	return true;
}