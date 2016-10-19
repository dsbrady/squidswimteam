function calculate(cbox, theForm)
{
	var increment = 1;
	var theName = cbox.name + 'Tot';
	
	if (!cbox.checked)
		increment = -1;

	if (theName.indexOf('newguest') != -1)
		theName = 'guestsTot';
	else if (theName.indexOf('newmember') != -1)
		theName = 'membersTot';

	theForm.elements[theName].value = parseInt(theForm.elements[theName].value,10) + increment;
	theForm.elements['attendanceTot'].value = parseInt(theForm.elements['membersTot'].value,10) + parseInt(theForm.elements['guestsTot'].value,10);

	return true;
}

function addRow(tb,theForm,rowType)
{

	// Set up content for cells
	var theDate = new Date();
	var newCbID = 'new' + rowType + '_' + theDate.valueOf();

	var content1 = '<input type="checkbox" name="' + newCbID + '" value="yes" checked="checked" onclick="return calculate(this,this.form);" />';
	var content2 = 'First: <input type="text" name="first_' + newCbID + '" size="10" maxlength="50" />';
	var content3 = 'Last: <input type="text" name="last_' + newCbID + '" size="10" maxlength="50" />';
	var content4 = '&nbsp;';

	var newRow = tb.insertRow(tb.rows.length);

	var cell1 = newRow.insertCell(0);
	cell1.innerHTML = content1;
	var cell2 = newRow.insertCell(1);
	cell2.innerHTML = content2;
	var cell3 = newRow.insertCell(2);
	cell3.setAttribute('colSpan',2);
	cell3.innerHTML = content3;

	// Delete "No Active Guests" or "No Active Members" row, if necessary
	var lastRow = tb.rows[tb.rows.length - 2];

	if (lastRow.cells.length == 1)
		tb.deleteRow(tb.rows.length - 2);

	calculate(theForm.elements[newCbID],theForm);

	return false;
}

function showMembers(activity, memberType)
{
	var tObj = document.getElementById(activity + memberType);
	var textObj = document.getElementById(activity + memberType +'Txt');
	var oldVis = tObj.style.display;
	var vis, visTxt;
	
	if (oldVis == 'none')
	{
		vis = 'inline';
		visTxt = 'Hide';
	}
	else
	{
		vis = 'none';
		visTxt = 'Show';
	}

	tObj.style.display = vis;
	textObj.innerHTML = visTxt;

	return false;
}

function validate(theForm)
{
	var firstName, lastName;

	with(theForm)
	{
		// Validate data
		if (!isValidDate(date_practice.value))
		{
			alert('Please enter a valid date.');
			date_practice.focus();
			date_practice.select();
			return false;
		}
	}
	for (i=0; i < theForm.length; i++)
	{
		if ((theForm.elements[i].name.substr(0,9) == 'newguest_') && (theForm.elements[i].type == 'checkbox') && (theForm.elements[i].checked))
		{
			firstName = theForm.elements[i+1];
			lastName = theForm.elements[i + 2];

			if (trim(firstName.value).length == 0)
			{
				alert('Please enter the new guest\'s first name.');
				firstName.focus();
				firstName.select();
				return false;
			}
			else if (trim(lastName.value).length == 0)
			{
				alert('Please enter the new guest\'s last name.');
				lastName.focus();
				lastName.select();
				return false;
			}
		}
		else if ((theForm.elements[i].name.substr(0,10) == 'newmember_') && (theForm.elements[i].type == 'checkbox') && (theForm.elements[i].checked))
		{
			firstName = theForm.elements[i+1];
			lastName = theForm.elements[i + 2];

			if (trim(firstName.value).length == 0)
			{
				alert('Please enter the new member\'s first name.');
				firstName.focus();
				firstName.select();
				return false;
			}
			else if (trim(lastName.value).length == 0)
			{
				alert('Please enter the new member\'s last name.');
				lastName.focus();
				lastName.select();
				return false;
			}
		}
	}

	return true;
}