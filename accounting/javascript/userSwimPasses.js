function validate(theForm)
{
	with(theForm)
	{
		// Validate data
		if (!isValidDate(startDate.value))
		{
			alert('Please enter a valid start date.');
			startDate.focus();
			startDate.select();
			return false;
		}
		if (!isValidDate(endDate.value))
		{
			alert('Please enter a valid end date.');
			endDate.focus();
			endDate.select();
			return false;
		}

		var startdate = new Date(startDate.value);
		var enddate = new Date(endDate.value);
		
		if (startdate > enddate)
		{
			alert('The end date must be on or before ' + startDate.value + '.');
			endDate.focus();
			endDate.select();
			return false;
		}
	}

	return true;
}