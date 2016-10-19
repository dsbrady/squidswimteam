function validate(theForm)
{
/* 12/17/2012 - no longer needed with ckeditor
	try {
		theForm.announcement.value = document.getElementById('edit').contentWindow.document.body.innerHTML;
	}
	catch (e) {
		theForm.announcement.value = document.getElementById('edit').value;
	}

*/
	with(theForm)
	{
	// Validate data
		if (trim(eventDate.value).length > 0 && (isNaN(new Date(eventDate.value))))
		{
			alert('Please enter a valid Event Date.');
			eventDate.focus();
			eventDate.select();
			return false;
		}
		if (trim(subject.value) == '')
		{
			alert('Please enter the subject.');
			subject.focus();
			subject.select();
			return false;
		}
		if (trim(announcement.value) == '')
		{
			alert('Please enter the announcement text.');
			announcement.focus();
			return false;
		}
	}

	return true;
}

function preview(theForm,FA)
{
	try {
		theForm.announcement.value = document.getElementById('edit').contentWindow.document.body.innerHTML;
	}
	catch (e) {
		theForm.announcement.value = document.getElementById('edit').value;
	}

	with(theForm)
	{
		// Validate data
		if (trim(subject.value) == '')
		{
			alert('Please enter the subject.');
			subject.focus();
			subject.select();
			return false;
		}
		if (trim(announcement.value) == '')
		{
			alert('Please enter the announcement text.');
			edit.focus();
			return false;
		}
	}

	theForm.status_id.value = 4;
	theForm.submit();

	return true;
}