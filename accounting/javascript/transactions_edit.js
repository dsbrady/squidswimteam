function changeType(sObj, fObj, idList, swimList)
{
	var index = sObj.selectedIndex - 1;
	
	var numSwims = parseInt(swimList.split(',')[index],10);

	fObj.num_swims.value = numSwims;

	return true;
}

function validate(theForm)
{
	with(theForm)
	{
		// Validate data
		if (!isValidDate(date_transaction.value))
		{
			alert('Please enter a valid date.');
			date_transaction.focus();
			date_transaction.select();
			return false;
		}

		if (transaction_type_id.selectedIndex < 1)
		{
			alert('Please select a transaction type.');
			transaction_type_id.focus();
			return false;
		}

		if (member_id.selectedIndex < 0)
		{
			alert('Please select a Member.');
			member_id.focus();
			return false;
		}

		if (parseInt(num_swims.value,10) != trim(num_swims.value))
		{
			alert('Please enter an integer for the swims.');
			num_swims.focus();
			num_swims.select();
			return false;
		}
	}

	return true;
}