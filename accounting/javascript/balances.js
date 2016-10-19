function validate(theForm,url,debugMode)
{
	var pp = frames['PageProcessing'];

	if (!debugMode)
	{
		pp.location.href = url + '&activityLevel=' + theForm.elements['activityLevel'][theForm.elements['activityLevel'].selectedIndex].value + '&statusType=' + theForm.elements['statusType'][theForm.elements['statusType'].selectedIndex].value;
		return false;
	}
	else
	{
		return true;
	}
}

function printFrame()
{
	var pp = frames['PageProcessing'];

	pp.focus();
	pp.print();
}

function getData(url,objForm)
{
	var activityLevel = objForm.elements['activityLevel'][objForm.elements['activityLevel'].selectedIndex].value;
	var statusType = objForm.elements['statusType'][objForm.elements['statusType'].selectedIndex].value;

	window.location.href = url + '&activityLevel=' + activityLevel + '&statusType=' + statusType;
}