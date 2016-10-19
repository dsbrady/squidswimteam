function validate(theForm)
{
	with (theForm)
	{
		if (waiverName.value.length == 0)
		{
			alert('You must enter your name in order to sign the liability waiver.');
			waiverName.focus();
			waiverName.select();
			return false;
		}
	}
	return true;
}