function validate(theForm)
{
	var monthFrom = parseInt(theForm.monthFrom[theForm.monthFrom.selectedIndex].value,10) - 1;
	var yearFrom = parseInt(theForm.yearFrom[theForm.yearFrom.selectedIndex].value,10);
	var monthTo = parseInt(theForm.monthTo[theForm.monthTo.selectedIndex].value,10) - 1;
	var yearTo = parseInt(theForm.yearTo[theForm.yearTo.selectedIndex].value,10);
	var fromDate = new Date(yearFrom,monthFrom,1,0,0,0);
	var toDate = new Date(yearTo,monthTo,1,0,0,0);

	if (fromDate > toDate)
	{
		alert('The date "From" can not be after the date "To".');
		theForm.monthFrom.focus();
		return false;
	}

	return true;
}