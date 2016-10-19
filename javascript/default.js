var validPasswordRE;

function preloader()
{
	if (document.images)
	{
		var numFiles = arguments.length;
		var imgArray = new Array();
		
		for (i=0; i < numFiles; i++)
		{
			imgArray[i] = new Image;
			imgArray[i].src = arguments[i];
		}
	}
}

function imgSwap(imgOld, newSrc)
{
	if (document.images)
		imgOld.src = newSrc;
	
	return true;
}

function trim(theString)
{
	s = theString.replace(/^(\s)*/, '');
	s = s.replace(/(\s)*$/, '');
	return s;
}

function isValidURL(theString)
{
	theString = theString.toLowerCase();
	
	var validChars = "abcdefghijklmnopqrstuvwxyz1234567890/&?._-,:=";
	
	// First, see if there are any invalid characters
	for (i=0; i<theString.length; i++)
	{
		if (validChars.indexOf(theString.charAt(i)) == -1)
		{
			return false;
		}
	}

	// Next, make sure that it starts with either 'http://' or 'https://'
	if ((theString.substring(0,7) != 'http://') && (theString.substring(0,8) != 'https://'))
	{
		return false;
	}

	// Next, make sure that the host info has at least one period, by splitting into an array separated by "."
	var aHost = theString.substring(8,theString.length).split('.');		

	// If the array isn't a size of at least 2, reject
	if (aHost.length < 2)
	{
		return false;
	}

	return true;
}

function isInteger(theString)
{
	var validChars = '-0123456789';
	
	for (i=0; i<theString.length; i++)
	{
		if (validChars.indexOf(theString.charAt(i)) == -1)
		{
			return false;
		}
		// Negative signs can only be the first character
		if ((theString.charAt(i) == '-') && (i != 0))
		{
			return false;
		}
	}
	
	return true;
}

function isValidDate(theString)
{
	var theDate = new Date(theString);

	if (isNaN(theDate))
		return false;
	else
		return true;
}

function isValidTime(theString)
{
// String must be in the format "h:mm AM" or "h:mm PM". Hours must be from 1-12. Minutes must be from 0-59.

// First, treat the string as a list with colon delimeters [size must then be 2]
	var aTime = theString.split(":");

	if (aTime.length != 2)
	{
		return false;
	}

// The hours will be the first string item.
	theHours = aTime[0];

// Set a variable for the remaining list item, which we'll also parse.
	var aTime2 = aTime[1].split(" ");

	if (aTime2.length != 2)
	{
		return false;
	}

	theMinutes = aTime2[0];
	timeString = aTime2[1].toUpperCase();

	// Check the values now.
	if (!isInteger(theHours))
	{
		return false;
	}
	else if ((theHours < 1) || (theHours > 12))
	{
		return false;
	}

	if (!isInteger(theMinutes))
	{
		return false;
	}
	else if ((theMinutes < 0) || (theMinutes > 59))
	{
		return false;
	}

	if ((timeString.toUpperCase() != 'AM') && (timeString.toUpperCase() != 'PM'))
	{
		return false;
	}

	// Everything checks out.  
	return true;
}

// Swaps select box values
function moveSelect(theBox,increment,hiddenElement)
{
	var tempOption = new Array(); // Holds values/text for option being swapped

	// Make sure they selected something
	if (theBox.selectedIndex == -1)
		return false;

	// First, if moving up (increment = -1), make sure it's not the first item 
	// or if moving down (increment = 1), make sure it's not the last item
	if (((theBox.selectedIndex == 0) && (increment == -1)) || ((theBox.selectedIndex == (theBox.length - 1)) && (increment == 1)))
		return false

	// Perform swap
	tempOption[0] = theBox[theBox.selectedIndex + increment].value;
	tempOption[1] = theBox[theBox.selectedIndex + increment].text;

	theBox[theBox.selectedIndex + increment].value = theBox[theBox.selectedIndex].value;
	theBox[theBox.selectedIndex + increment].text = theBox[theBox.selectedIndex].text;
	theBox[theBox.selectedIndex].value = tempOption[0];
	theBox[theBox.selectedIndex].text = tempOption[1];

	theBox.selectedIndex = theBox.selectedIndex + increment;

	// Set the hidden field's value
	hiddenElement.value = '';
	
	for (i=0; i < theBox.length; i++)
	{
		if (i > 0)
			hiddenElement.value += ',';

		hiddenElement.value += theBox[i].value;
	}
	
	return true;	
}

function isValidEmailAddress(emailAddress,isRequired)
{
	var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
	if (isRequired && trim(emailAddress).length == 0)
	{
		return false;
	}
	else if (!emailReg.test(emailAddress))
	{
		return false;
	}
	
	return true;
}

function isValidPassword(password)
{
	var isValid = true;
	// This should match any letter, number, underscore, or space, and be between 8 and 255 characters long
	var passwordReg = new RegExp(validPasswordRE);

	if (!passwordReg.test(password))
	{
		isValid = false;
	}

	return isValid;
}