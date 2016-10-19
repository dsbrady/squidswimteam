function validate(theForm)
{
	try {
		theForm.article.value = document.getElementById('edit').contentWindow.document.body.innerHTML;
	}
	catch (e) {
		theForm.article.value = document.getElementById('edit').value;
	}

	with(theForm)
	{
		// Validate data
		if ((trim(date_start.value) == '') || (!isValidDate(date_start.value)))
		{
			alert('Please enter a valid start date.');
			date_start.focus();
			date_start.select();
			return false;
		}
		if ((trim(date_end.value) == '') || (!isValidDate(date_end.value)))
		{
			alert('Please enter a valid end date.');
			date_end.focus();
			date_end.select();
			return false;
		}
		if (trim(headline.value) == '')
		{
			alert('Please enter the headline.');
			headline.focus();
			headline.select();
			return false;
		}
		if (trim(article.value) == '')
		{
			alert('Please enter the article.');
			edit.focus();
			return false;
		}
	}

	return true;
}

