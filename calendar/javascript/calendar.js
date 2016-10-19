function validate(theForm)
{
	with(theForm)
	{
		// Validate data
		if (trim(theYear.value) != parseInt(theYear.value,10))
		{
			alert('Please enter a valid year.');
			theYear.focus();
			theYear.select();
			return false;
		}
		else if (parseInt(theYear.value,10) < 1900)
		{
			alert('Please enter a year greater than 1900.');
			theYear.focus();
			theYear.select();
			return false;
		}
	}
	
	return true;
}

function showDetails(theString,ed,visString,spn)
{
	var obj = spn;
	var offsetL = -180;
	var offsetT = -120;

	if (visString == 'visible')
		spn.title = '';
	else
		spn.title = ed.innerHTML;

	// Calculate offset
	while (obj.offsetParent)
	{
		offsetL += obj.offsetParent.offsetLeft;
		offsetT += obj.offsetParent.offsetTop;
		obj = obj.offsetParent;
	}
	offsetL += spn.offsetLeft;
	offsetT += spn.offsetTop;

	ed.style.left = offsetL + 'px';
	ed.style.top = offsetT + 'px';
	ed.innerHTML = theString;
	ed.style.visibility = visString;

	return false;
}