function validate(theForm)
{
	with(theForm)
	{
		// Validate data
		if (!isValidSeed(seedTime.value))
		{
			alert('Seed times must be in the format: "min:sec.00"');
			seedTime.focus();
			seedTime.select();
			return false;
		}
	}

	return true;
}

function isValidSeed(fObj)
{
	var array1, array2, mins, secs, msecs;

	// First make sure the string format is right (min:sec.msec)
	array1 = fObj.split(':');
	if (array1.length > 2)
	{
		return false;
	}
	else if (array1.length != 2)
	{
		mins = 0;
		array2 = array1[0].split('.');
	}
	else
	{
		mins = array1[0];
		array2 = array1[1].split('.');
	}
	if (array2.length != 2)
	{
		return false;
	}
	
	// Next, divide string into format
	secs = array2[0];
	msecs = array2[1];
	
	// Make sure they're positive numbers
	if ((parseInt(mins,10) != mins) || (parseInt(mins,10) < 0))
	{
		return false;
	}
	if ((parseInt(secs,10) != secs) || (parseInt(secs,10) < 0))
	{
		return false;
	}
	if ((parseInt(msecs,10) != msecs) || (parseInt(msecs,10) < 0))
	{
		return false;
	}

	return true;
}

