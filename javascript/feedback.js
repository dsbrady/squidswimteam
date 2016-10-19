function validate(theForm)
{
	if (theForm.officer_type_id.selectedIndex < 1)
	{
		alert('Please select whom you wish to contact.');
		theForm.officer_type_id.focus();
		return false;
	}
	if (trim(theForm.sender_name.value).length == 0)
	{
		alert('Please enter your name.');
		theForm.sender_name.focus();
		theForm.sender_name.select();
		return false;
	}
	if (trim(theForm.sender_email.value).length == 0)
	{
		alert('Please enter your e-mail address.');
		theForm.sender_email.focus();
		theForm.sender_email.select();
		return false;
	}
	if (trim(theForm.content.value).length == 0)
	{
		alert('Please enter your message.');
		theForm.content.focus();
		theForm.content.select();
		return false;
	}

	return true;
}