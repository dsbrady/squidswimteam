function validate(theForm)
{
	with(theForm)
	{
		// Validate data
		if (coach_id.selectedIndex == -1)
		{
			alert('Please select a coach.');
			coach_id.focus();
			return false;
		}
	}

	return true;
}