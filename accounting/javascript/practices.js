function validate(theForm)
{
	with(theForm)
	{
		// Validate data
		if (!isValidDate(date_start.value))
		{
			alert('Please enter a valid start date.');
			date_start.focus();
			date_start.select();
			return false;
		}
		if (!isValidDate(date_end.value))
		{
			alert('Please enter a valid end date.');
			date_end.focus();
			date_end.select();
			return false;
		}

		var startdate = new Date(date_start.value);
		var enddate = new Date(date_end.value);
		
		if (startdate > enddate)
		{
			alert('The end date must be on or before ' + date_start.value + '.');
			date_end.focus();
			date_end.select();
			return false;
		}
	}

	return true;
}