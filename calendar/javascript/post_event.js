function validate(theForm)
{
	with(theForm)
	{
		// Validate data
		if (!isValidDate(startDate.value))
		{
			alert('Please enter a valid event date.');
			startDate.focus();
			startDate.select();
			return false;
		}
		if (!isValidTime(startTime.value))
		{
			alert('Please enter a valid start time.');
			startTime.focus();
			startTime.select();
			return false;
		}
		if (!isValidTime(endTime.value))
		{
			alert('Please enter a valid end time.');
			endTime.focus();
			endTime.select();
			return false;
		}
		if ((frequency_id[frequency_id.selectedIndex].value != 0) && trim(endDate.value).length > 0 && !isValidDate(endDate.value))
		{
			alert('Please enter a valid end date.');
			endDate.focus();
			endDate.select();
			return false;
		}
		if (trim(location.value).length == 0)
		{
			alert('Please enter the location.');
			location.focus();
			location.select();
			return false;
		}
		if (trim(description.value).length == 0)
		{
			alert('Please enter the description.');
			description.focus();
			description.select();
			return false;
		}
	}
	
	return true;
}

function deleteEvent(fObj)
{
	var confirmString = 'Delete this event?';
	var results;
	
	if (fObj.elements.updateAll && fObj.elements.updateAll.checked)
	{
		confirmString = 'Delete all occurrences of this event?';
	}
	
	results = confirm(confirmString);
	
	if (!results)
		return false;

	return true;
}