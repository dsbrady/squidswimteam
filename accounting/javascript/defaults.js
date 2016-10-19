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

		if (facility_id.selectedIndex == -1)
		{
			alert('Please select a facility.');
			facility_id.focus();
			return false;
		}

		if (!(sunday.checked || monday.checked || tuesday.checked || wednesday.checked || thursday.checked || friday.checked || saturday.checked))
		{
			alert('Please select at least one default practice day.');
			return false;
		}
	}

	return true;
}