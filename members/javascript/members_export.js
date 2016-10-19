function selectAll(theForm,cbx)
{
	for (var i=0; i<theForm.elements.length; i++)
	{
		if ((theForm.elements[i].type.toLowerCase() == 'checkbox') && (theForm.elements[i].name.substring(0,12).toLowerCase() == 'exportmember'))
		{
			theForm.elements[i].checked = cbx.checked;
		}
	}

	return true;
}

function validate(theForm)
{
	for (var i=0; i<theForm.elements.length; i++)
	{
		if ((theForm.elements[i].type.toLowerCase() == 'checkbox') && (theForm.elements[i].name.substring(0,12).toLowerCase() == 'exportmember') && (theForm.elements[i].checked))
		{
			return true;
		}
	}

	alert('You must check at least one member to export.');

	return false;
}