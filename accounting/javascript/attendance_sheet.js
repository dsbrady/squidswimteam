function validate(theForm,url)
{
	var pp = document.getElementById('PageProcessing');
	var date1, date2;

	with(theForm)
	{
		// Validate data
		if (!isValidDate(date_practice.value))
		{
			alert('Please enter a valid start date.');
			date_practice.focus();
			date_practice.select();
			return false;
		}
		if (!isValidDate(date_practice2.value))
		{
			alert('Please enter a valid end date.');
			date_practice2.focus();
			date_practice2.select();
			return false;
		}

		date1 = new Date(date_practice.value);
		date2 = new Date(date_practice2.value);

		if (date2 < date1)
		{
			alert('The end date can not be earlier than the start date.');
			date_practice2.focus();
			date_practice2.select();
			return false;
		}
		url += '&date_practice=' + date_practice.value;
		url += '&date_practice2=' + date_practice2.value;
	}

	pp.src = url;

	return false;
}

function printFrame()
{
	var pp = frames['PageProcessing'];

	pp.focus();
	pp.print();
	pp.src = 'about:blank;';
	pp.parent.focus();
}