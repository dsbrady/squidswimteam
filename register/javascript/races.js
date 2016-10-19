function validate(theForm)
{
	var raceCount = 0;
	with (theForm)
	{
		if (usms.value.length == 0)
		{
			alert('Your USMS Number is required.');
			usms.focus();
			usms.select();
			return false;
		}
		if (team_no.selectedIndex == 0)
		{
			alert('Select a team (or "Not listed" if your team is not listed).');
			team_no.focus();
			return false;
		
		}
		else if (team_no[team_no.selectedIndex].value == -1)
		{
			if ((trim(team_name.value).length == 0) || (trim(team_short.value).length == 0) || (trim(team_abbr.value).length == 0))
			{
				alert('If your team is not currently listed, please enter the name, shortened name, and abbreviation of your team.');
				team_name.focus();
				team_name.select();
				return false;
			}
		}

		// Loop along events and make sure that they put in a seed time if they selected the event
		for (var i=5; i < theForm.length; i++)
		{
			if ((theForm[i].type == 'checkbox') && theForm[i].checked)
			{
				if (trim(theForm['seed_' + theForm[i].name.split('_')[1]].value).length == 0)
				{
					alert('Please enter a seed time.');
					theForm['seed_' + theForm[i].name.split('_')[1]].focus();
					theForm['seed_' + theForm[i].name.split('_')[1]].select();
					return false;
				}
				else if (!isValidSeed(theForm['seed_' + theForm[i].name.split('_')[1]].value))
				{
					alert('Seed times must be in the format: "min:sec.00"');
					theForm['seed_' + theForm[i].name.split('_')[1]].focus();
					theForm['seed_' + theForm[i].name.split('_')[1]].select();
					return false;
				}
				
				raceCount++;
			}
		}

		if (raceCount == 0)
		{
			alert('You must select at least 1 race to swim.');
			return false;
		}
		else if (raceCount > 4)
		{
			alert('Please select only up to 4 races.');
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
	if (array1.length != 2)
	{
		return false;
	}
	array2 = array1[1].split('.');
	if (array2.length != 2)
	{
		return false;
	}
	
	// Next, divide string into format
	mins = array1[0];
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

function changeTeam(theForm)
{
	var fBox = theForm.elements['team_no'];
	var tName = theForm.elements['team_name'];
	var tShort = theForm.elements['team_short'];
	var tAbbr = theForm.elements['team_abbr'];

	if (parseInt(fBox[fBox.selectedIndex].value,10) >= 0)
	{
		tName.value = '';
		tShort.value = '';
		tAbbr.value = '';
		theForm.elements[5].focus();
	}

	return true;
}