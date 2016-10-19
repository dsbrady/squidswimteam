var madeChanges = false;

function changeCat(fObj,url)
{
	var confirmYN = true;

	if (madeChanges)
	{
		confirmYN = confirm('Change category without saving changes?');
	}

	if (confirmYN)
		document.location.href = url;
	else
	{
		for (var i=0; i < fObj.length; i++)
		{
			if (fObj[i].defaultSelected)
			{
				fObj.selectedIndex = i;
				return false;
			}
		}

		return false;
	}

}

function validateLinks(theForm)
{
	var fieldName = '';

	for (var i=0; i < theForm.elements.length; i++)
	{
		if ((theForm.elements[i].type.toLowerCase() == 'text') && (trim(theForm.elements[i].value).length == 0) && (theForm.elements[i].name.substring(0,4) != 'desc'))
		{
			switch(theForm.elements[i].name.substring(0,4))
			{
				case 'name':
					fieldName = 'name';
					break;
				case 'url_':
					fieldName = 'URL';
					break;
			}

			alert('Please enter the link\'s ' + fieldName + '.');
			theForm.elements[i].focus();
			return false;
		}
		else if ((theForm.elements[i].name.substring(0,4) == 'url_') && (!isValidURL(theForm.elements[i].value)))
		{
			alert('Please enter a valid URL.');
			theForm.elements[i].focus();
			theForm.elements[i].select();
			return false;
		}
	}

	return true;
}

function validateCats(theForm)
{
	for (var i=0; i < theForm.elements.length; i++)
	{
		if ((theForm.elements[i].type.toLowerCase() == 'text') && (trim(theForm.elements[i].value).length == 0))
		{
			alert('Enter a name for every category.');
			theForm.elements[i].focus();
			return false;
		}
	}

	return true;
}

function addLink()
{
	var tbl = document.getElementById('linkTbl');
	var fObj = document.forms['linkForm'].elements.links;
	var content1, content2, content3, content4, content5, cell1, cell2, cell3, cell4, cell5, newRow;
	var newID;
	var idExists = true;

	var rowBorder = '1px solid rgb(0,150,147)';
	var rowBG0 = '#eeeeee';
	var rowBG1 = '#ffffff';

	// If first row is "noLinks", remove it
	if (tbl.rows[0].id == 'noLinks')
	{
		tbl.deleteRow(0);
	}

	// Create new id
	newID = 'new.' + Math.round(Math.random() * 10000);

	// make sure new ID isn't taken
	aOld = fObj.value.split(',');
	while (idExists)
	{
		idExists = false;

		for (var i=0; (i<tbl.rows.length && !idExists); i++)
		{
			if (aOld[i] == newID)
			{
				idExists = true;
			}
		}

		if (idExists)
			newID = 'new.' + Math.round(Math.random() * 10000);
	}

	// Create content
	content1 = '<a href="#" onclick="return removeLink(\'' + newID + '\');">Remove</a>';
	content2 = '<input type="text" name="name_' + newID + '" size="15" maxlength="50" />';
	content3 = '<input type="text" name="url_' + newID + '" size="15" maxlength="255" />';
	content4 = '<input type="text" name="desc_' + newID + '" size="25" maxlength="255" />';

	// Create new row
	newRow = tbl.insertRow(-1);
	newRow.setAttribute('valign','top');
	newRow.style.border = rowBorder;
	newRow.style.backgroundColor = eval('rowBG' + (tbl.rows.length % 2));
	newRow.id = 'link_' + newID;

	cell1 = newRow.insertCell(0);
	cell1.innerHTML = content1;
	cell2 = newRow.insertCell(1);
	cell2.innerHTML = content2;
	cell2.align = 'left';
	cell3 = newRow.insertCell(2);
	cell3.innerHTML = content3;
	cell3.align = 'left';
	cell4 = newRow.insertCell(3);
	cell4.innerHTML = content4;
	cell4.align = 'left';

	cell5 = newRow.insertCell(4);
	cell5.align = 'right';

	content5 = '';
	if (tbl.rows.length != 1)
	{
		content5 += '<a href="#" onclick="return moveLink(-1,\'' + newID + '\');">U</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
	}
	else
	{
		content5 = '&nbsp;';
	}

	cell5.innerHTML = content5;

	// Add the move down link to the row above this one, if it exists
	if (tbl.rows.length != 1)
	{
		var otherRow = tbl.rows[tbl.rows.length - 2];
		var otherID = otherRow.id.split('_')[1];
		var re = /&nbsp;&nbsp;&nbsp;/;
		otherRow.cells[4].innerHTML = otherRow.cells[4].innerHTML.replace(re,'');
		otherRow.cells[4].innerHTML += '<a href="#" onclick="return moveLink(1,\'' + otherID + '\');">D</a>';
	}

	if (aOld[0] == '')
		aOld[0] = newID;
	else
		aOld[aOld.length] = newID;

	fObj.value = aOld.join(',');

	madeChanges = true;

	return false;
}

function addCat()
{
	var tbl = document.getElementById('catTbl');
	var fObj = document.forms['categoryForm'].elements.categories;
	var content1, content2, content3, cell1, cell2, cell3, newRow;
	var newID;
	var idExists = true;

	var rowBorder = '1px solid rgb(0,150,147)';
	var rowBG0 = '#eeeeee';
	var rowBG1 = '#ffffff';

	// If first row is "noCats", remove it
	if (tbl.rows[0].id == 'noCats')
	{
		tbl.deleteRow(0);
	}

	// Create new id
	newID = 'new.' + Math.round(Math.random() * 10000);

	// make sure new ID isn't taken
	aOld = fObj.value.split(',');
	while (idExists)
	{
		idExists = false;

		for (var i=0; (i<tbl.rows.length && !idExists); i++)
		{
			if (aOld[i] == newID)
			{
				idExists = true;
			}
		}

		if (idExists)
			newID = 'new.' + Math.round(Math.random() * 10000);
	}

	// Create content
	content1 = '<a href="#" onclick="return removeCat(\'' + newID + '\');">Remove</a>';
	content2 = '<input type="text" name="category_' + newID + '" size="25" maxlength="50" onblur="this.value = this.value.toUpperCase();" />';

	// Create new row
	newRow = tbl.insertRow();
	newRow.setAttribute('valign','top');
	newRow.style.border = rowBorder;
	newRow.style.backgroundColor = eval('rowBG' + (tbl.rows.length % 2));
	newRow.id = 'cat_' + newID;

	cell1 = newRow.insertCell();
	cell1.innerHTML = content1;
	cell2 = newRow.insertCell();
	cell2.innerHTML = content2;
	cell2.align = 'left';
	cell3 = newRow.insertCell();
	cell3.align = 'right';

	content3 = '';
	if (tbl.rows.length != 1)
	{
		content3 += '<a href="#" onclick="return moveCat(-1,\'' + newID + '\');">U</a>&nbsp;&nbsp;&nbsp;&nbsp;';
	}
	else
	{
		content3 = '&nbsp;';
	}

	cell3.innerHTML = content3;

	// Add the move down link to the row above this one, if it exists
	if (tbl.rows.length != 1)
	{
		var otherRow = tbl.rows[tbl.rows.length - 2];
		var otherID = otherRow.id.split('_')[1];
		otherRow.cells[2].innerHTML += '<a href="#" onclick="return moveCat(1,\'' + otherID + '\');">D</a>';
	}

	if (aOld[0] == '')
		aOld[0] = newID;
	else
		aOld[aOld.length] = newID;

	fObj.value = aOld.join(',');

	return false;
}

function moveLink(increment,linkID)
{
	var tbl = document.getElementById('linkTbl');
	var fObj = document.forms['linkForm'].elements.links;
	var thisRow = document.getElementById('link_' + linkID);
	var thisIndex;
	var tempCell1, tempCell2, tempCell3, tempCell4, tempCell5, tempID, tempLinkID;
	var otherIndex, otherRow;
	var idLoc, endIdLoc;

	for (var i=0; i < tbl.rows.length; i++)
	{
		if (tbl.rows[i].id == thisRow.id)
		{
			thisIndex = i;
		}
	}

	otherIndex = thisIndex + increment;
	otherRow = tbl.rows[otherIndex];

	tempID = otherRow.id;
	tempLinkID = tempID.split('_')[1];
	tempCell1 = otherRow.cells[0].innerHTML;
	tempCell2 = otherRow.cells[1].innerHTML;
	tempCell3 = otherRow.cells[2].innerHTML;
	tempCell4 = otherRow.cells[3].innerHTML;
	tempCell5 = otherRow.cells[4].innerHTML;

	tbl.rows[otherIndex].id = tbl.rows[thisIndex].id;
	tbl.rows[otherIndex].cells[0].innerHTML = thisRow.cells[0].innerHTML;
	tbl.rows[otherIndex].cells[1].innerHTML = thisRow.cells[1].innerHTML;
	tbl.rows[otherIndex].cells[2].innerHTML = thisRow.cells[2].innerHTML;
	tbl.rows[otherIndex].cells[3].innerHTML = thisRow.cells[3].innerHTML;

	thisRow.id = tempID;
	thisRow.cells[0].innerHTML = tempCell1;
	thisRow.cells[1].innerHTML = tempCell2;
	thisRow.cells[2].innerHTML = tempCell3;
	thisRow.cells[3].innerHTML = tempCell4;

	// Set linkID in moveLink functions in each row
	idLoc = thisRow.cells[4].innerHTML.indexOf('moveLink(1,');
	if (idLoc > -1)
	{
		idLoc += 11;
		endIdLoc = thisRow.cells[4].innerHTML.indexOf(')',idLoc);
		thisRow.cells[4].innerHTML = thisRow.cells[4].innerHTML.substring(0,idLoc) + '\'' + tempLinkID + '\'' + thisRow.cells[4].innerHTML.substring(endIdLoc);
	}

	idLoc = thisRow.cells[4].innerHTML.indexOf('moveLink(-1,');
	if (idLoc > -1)
	{
		idLoc += 12;
		endIdLoc = thisRow.cells[4].innerHTML.indexOf(')',idLoc);
		thisRow.cells[4].innerHTML = thisRow.cells[4].innerHTML.substring(0,idLoc) + '\'' + tempLinkID + '\'' + thisRow.cells[4].innerHTML.substring(endIdLoc);
	}

	idLoc = otherRow.cells[4].innerHTML.indexOf('moveLink(1,');
	if (idLoc > -1)
	{
		idLoc += 11;
		endIdLoc = otherRow.cells[4].innerHTML.indexOf(')',idLoc);
		otherRow.cells[4].innerHTML = otherRow.cells[4].innerHTML.substring(0,idLoc) + '\'' + linkID + '\'' + otherRow.cells[4].innerHTML.substring(endIdLoc);
	}

	idLoc = otherRow.cells[4].innerHTML.indexOf('moveLink(-1,');
	if (idLoc > -1)
	{
		idLoc += 12;
		endIdLoc = otherRow.cells[4].innerHTML.indexOf(')',idLoc);
		otherRow.cells[4].innerHTML = otherRow.cells[4].innerHTML.substring(0,idLoc) + '\'' + linkID + '\'' + otherRow.cells[4].innerHTML.substring(endIdLoc);
	}

	// Swap positions in fObj
	var aOld = fObj.value.split(',');
	aOld[thisIndex] = tempLinkID;
	aOld[otherIndex] = linkID;

	fObj.value = aOld.join(',');

	madeChanges = true;

	return false;
}

function moveCat(increment,catID)
{
	var tbl = document.getElementById('catTbl');
	var fObj = document.forms['categoryForm'].elements.categories;
	var thisRow = document.getElementById('cat_' + catID);
	var thisIndex;
	var tempCell1, tempCell2, tempCell3, tempID, tempCatID;
	var otherIndex, otherRow;
	var idLoc, endIdLoc;

	for (var i=0; i < tbl.rows.length; i++)
	{
		if (tbl.rows[i].id == thisRow.id)
		{
			thisIndex = i;
		}
	}

	otherIndex = thisIndex + increment;
	otherRow = tbl.rows[otherIndex];

	tempID = otherRow.id;
	tempCatID = tempID.split('_')[1];
	tempCell1 = otherRow.cells[0].innerHTML;
	tempCell2 = otherRow.cells[1].innerHTML;
	tempCell3 = otherRow.cells[2].innerHTML;

	tbl.rows[otherIndex].id = tbl.rows[thisIndex].id;
	tbl.rows[otherIndex].cells[0].innerHTML = thisRow.cells[0].innerHTML;
	tbl.rows[otherIndex].cells[1].innerHTML = thisRow.cells[1].innerHTML;

	thisRow.id = tempID;
	thisRow.cells[0].innerHTML = tempCell1;
	thisRow.cells[1].innerHTML = tempCell2;

	// Set catID in moveCat functions in each row
	idLoc = thisRow.cells[2].innerHTML.indexOf('moveCat(1,');
	if (idLoc > -1)
	{
		idLoc += 10;
		endIdLoc = thisRow.cells[2].innerHTML.indexOf(')',idLoc);
		thisRow.cells[2].innerHTML = thisRow.cells[2].innerHTML.substring(0,idLoc) + '\'' + tempCatID + '\'' + thisRow.cells[2].innerHTML.substring(endIdLoc);
	}

	idLoc = thisRow.cells[2].innerHTML.indexOf('moveCat(-1,');
	if (idLoc > -1)
	{
		idLoc += 11;
		endIdLoc = thisRow.cells[2].innerHTML.indexOf(')',idLoc);
		thisRow.cells[2].innerHTML = thisRow.cells[2].innerHTML.substring(0,idLoc) + '\'' + tempCatID + '\'' + thisRow.cells[2].innerHTML.substring(endIdLoc);
	}

	idLoc = otherRow.cells[2].innerHTML.indexOf('moveCat(1,');
	if (idLoc > -1)
	{
		idLoc += 10;
		endIdLoc = otherRow.cells[2].innerHTML.indexOf(')',idLoc);
		otherRow.cells[2].innerHTML = otherRow.cells[2].innerHTML.substring(0,idLoc) + '\'' + catID + '\'' + otherRow.cells[2].innerHTML.substring(endIdLoc);
	}

	idLoc = otherRow.cells[2].innerHTML.indexOf('moveCat(-1,');
	if (idLoc > -1)
	{
		idLoc += 11;
		endIdLoc = otherRow.cells[2].innerHTML.indexOf(')',idLoc);
		otherRow.cells[2].innerHTML = otherRow.cells[2].innerHTML.substring(0,idLoc) + '\'' + catID + '\'' + otherRow.cells[2].innerHTML.substring(endIdLoc);
	}

	// Swap positions in fObj
	var aOld = fObj.value.split(',');
	aOld[thisIndex] = tempCatID;
	aOld[otherIndex] = catID;

	fObj.value = aOld.join(',');

	return false;
}

function removeLink(linkID)
{
	var tbl = document.getElementById('linkTbl');
	var fObj = document.forms['linkForm'].elements.links;
	var thisRow = document.getElementById('link_' + linkID);
	var thisIndex;
	var cell5;
	var aOld = fObj.value.split(',');

	var rowBorder = '1px solid rgb(0,150,147)';
	var rowBG0 = '#eeeeee';
	var rowBG1 = '#ffffff';

	for (i=0; i < tbl.rows.length; i++)
	{
		if (tbl.rows[i].id == thisRow.id)
		{
			thisIndex = i;
		}
	}

	// If I'm removing the bottom row and there are rows above it, adjust content of row above
	if ((thisIndex == (tbl.rows.length - 1)) && (thisIndex != 0))
	{
		var otherRow = tbl.rows[thisIndex - 1];
		// If the current is the 2nd, set the 5th cell of the row above to be blank
		if (thisIndex == 1)
		{
			otherRow.cells[4].innerHTML = '&nbsp;';
		}
		// Else, set the 5th cell of the row above to only show the "Up" link
		else
		{
			otherRow.cells[4].innerHTML = '<a href="#" onclick="return moveLink(-1,\'' + otherRow.id.split('_')[1] + '\');">U</a>&nbsp;&nbsp;&nbsp;&nbsp;';
		}
	}

	// Delete row
	tbl.deleteRow(thisIndex);

	// Either add blank row or adjust cell 5 in next row

	if (tbl.rows[thisIndex])
	{
		thisRow = tbl.rows[thisIndex];
		thisRow.style.backgroundColor = eval('rowBG' + ((thisIndex + 1) % 2));

		// If it's the top row, remove the "Move up" feature
		if (thisIndex == 0)
		{
			if (tbl.rows.length > (thisIndex + 1))
			{
				thisRow.cells[4].innerHTML = '<a href="#" onclick="return moveLink(1,\'' + thisRow.id.split('_')[1] + '\');">D</a>'
			}
			else
			{
				thisRow.cells[4].innerHTML = '&nbsp;'
			}
		}
	}
	else if (thisIndex == 0)
	{
		thisRow = tbl.insertRow();
		thisRow.id = 'noLinks';
		thisRow.style.border = rowBorder;
		thisRow.style.backgroundColor = rowBG1;
		cell5 = thisRow.insertCell();
		cell5.colSpan = 5;
		cell5.innerHTML = 'There are no links in this category.';
	}

	// Adjust form value
	aOld.splice(thisIndex,1);
	fObj.value = aOld.join(',');

	madeChanges = true;

	return false;
}

function removeCat(catID)
{
	var tbl = document.getElementById('catTbl');
	var fObj = document.forms['categoryForm'].elements.categories;
	var thisRow = document.getElementById('cat_' + catID);
	var thisIndex;
	var cell3;
	var aOld = fObj.value.split(',');

	var rowBorder = '1px solid rgb(0,150,147)';
	var rowBG0 = '#eeeeee';
	var rowBG1 = '#ffffff';

	for (i=0; i < tbl.rows.length; i++)
	{
		if (tbl.rows[i].id == thisRow.id)
		{
			thisIndex = i;
		}
	}

	// If I'm removing the bottom row and there are rows above it, adjust content of row above
	if ((thisIndex == (tbl.rows.length - 1)) && (thisIndex != 0))
	{
		var otherRow = tbl.rows[thisIndex - 1];
		// If the current is the 2nd, set the 3rd cell of the row above to be blank
		if (thisIndex == 1)
		{
			otherRow.cells[2].innerHTML = '&nbsp;';
		}
		// Else, set the 3rd cell of the row above to only show the "Up" link
		else
		{
			otherRow.cells[2].innerHTML = '<a href="#" onclick="return moveCat(-1,\'' + otherRow.id.split('_')[1] + '\');">U</a>&nbsp;&nbsp;&nbsp;&nbsp;';
		}
	}

	// Delete row
	tbl.deleteRow(thisIndex);

	// Either add blank row or adjust cell 3 in next row

	if (tbl.rows[thisIndex])
	{
		thisRow = tbl.rows[thisIndex];
		thisRow.style.backgroundColor = eval('rowBG' + ((thisIndex + 1) % 2));

		// If it's the top row, remove the "Move up" feature
		if (thisIndex == 0)
		{
			if (tbl.rows.length > (thisIndex + 1))
			{
				thisRow.cells[2].innerHTML = '<a href="#" onclick="return moveCat(1,\'' + thisRow.id.split('_')[1] + '\');">D</a>'
			}
			else
			{
				thisRow.cells[2].innerHTML = '&nbsp;'
			}
		}
	}
	else if (thisIndex == 0)
	{
		thisRow = tbl.insertRow();
		thisRow.id = 'noCats';
		thisRow.style.border = rowBorder;
		thisRow.style.backgroundColor = rowBG1;
		cell3 = thisRow.insertCell();
		cell3.colSpan = 3;
		cell3.innerHTML = 'There are no categories.';
	}

	// Adjust form value
	aOld.splice(thisIndex,1);
	fObj.value = aOld.join(',');

	return false;
}

