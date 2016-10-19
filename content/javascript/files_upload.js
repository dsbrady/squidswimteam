function changeCat(selBox,textBox)
{
	if (selBox[selBox.selectedIndex].value == -1)
	{
		textBox.value = 'New Category'
		textBox.style.visibility = 'visible';
		textBox.focus();
		textBox.select();
	}
	else
	{
		textBox.value = ''
		textBox.style.visibility = 'hidden';
	}

	return true;
}

function validate(theForm)
{
	with(theForm)
	{
		// Validate data
		if (category_id.selectedIndex == 0)
		{
			alert('Please select a category.');
			category_id.focus();
			return false;
		}
		else if ((parseInt(category_id[category_id.selectedIndex].value,10) == -1) && ((trim(new_category.value).length == 0) || (new_category.value.toLowerCase() == 'new category')))
		{
			alert('Please enter a new category name.');
			new_category.focus();
			new_category.select();
			return false;
		}

		if (file_type_id.selectedIndex == 0)
		{
			alert('Please select a file type.');
			file_type_id.focus();
			return false;
		}

		if (trim(filename.value).length == 0)
		{
			alert('Please select a file to upload.');
			filename.focus();
			filename.select();
			return false;
		}
	}

	return true;
}