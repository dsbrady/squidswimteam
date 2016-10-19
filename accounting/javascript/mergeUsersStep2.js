function selectValue(tbody,tbCell,fElement)
{
	var className = 'selected';

	if (tbCell.className == className)
	{
		return true;
	}

	for (var i = 0; i < tbody.rows.length; ++i)
	{
		for (var j = 0; j < tbody.rows[i].cells.length; ++ j)
		{
			if ((tbody.rows[i].cells[j].id.split('_')[0] == tbCell.id.split('_')[0]) && (tbody.rows[i].cells[j].id.split('_')[1] != tbCell.id.split('_')[1]))
			{
				tbody.rows[i].cells[j].className = '';
			}
		}
	}

	tbCell.className = className;
	fElement.value = trim(tbCell.innerHTML);

/*
	if (tbody.id == 'primaryUserList')
	{
		for (var i=0; i < tbody.rows.length; ++i)
		{
			tbody.rows[i].className = '';
		}

		tbRow.className = className;

		userObj = fObj.elements['primaryUserID']
		userObj.value = userID;
	}
	else
	{
		userObj = fObj.elements['secondaryUsers']
		userObj.value = '';

		if (tbRow.className == className)
		{
			tbRow.className = '';
		}
		else
		{
			tbRow.className = className;
		}

		for (var i = 0; i < tbody.rows.length; ++i)
		{
			if (tbody.rows[i].className == className)
			{
				userObj.value += tbody.rows[i].id.split('_')[1] + ',';
			}
		}
	}
*/
}
