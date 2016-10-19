function validate(theForm)
{
/* 12/17/2012 - no longer needed with ckeditor
	try {
		theForm.content.value = document.getElementById('edit').contentWindow.document.body.innerHTML;
	}
	catch (e) {
		theForm.content.value = document.getElementById('edit').value;
	}
*/
	with(theForm)
	{
		// Validate data
		if (trim(title.value) == '')
		{
			alert('Please enter the title.');
			title.focus();
			title.select();
			return false;
		}
		if (trim(content.value) == '')
		{
			alert('Please enter the content.');
			edit.focus();
			return false;
		}
	}

	return true;
}
