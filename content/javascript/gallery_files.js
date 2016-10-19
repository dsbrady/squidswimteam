function openFileWin(url)
{
	var winAttribs = 'width=600,height=400,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes';
	fileWin = window.open(url,'fileWin',winAttribs);

	return false;
}

function addFile(file_id,FA,page_id)
{
	var pp = document.frames.PageProcessing;
	var url = 'index.cfm?fuseaction=' + FA + '&file_id=' + file_id;

	pp.location.href = url;
}

function addLinkFile(parent_id,file_id)
{
	var pp = document.frames.PageProcessing;
	var FA = document.forms['pageForm'].elements['linkFA'].value;

	var url = 'index.cfm?fuseaction=' + FA + '&file_id=' + file_id + '&parent_id=' + parent_id;

	pp.location.href = url;
}

function insertSelectedLinkFile(file_id,filename,parent_id)
{
	var theRow = document.getElementById('file_' + parent_id);
	var fObj = document.forms['pageForm'].elements.files;
	var lObj = document.forms['pageForm'].elements.links;
	var content4;

	// Set content in cell
	content4 = filename;
	theRow.cells[3].innerHTML = content4;
	
	// Find where in the list of files the parent is, then set the same position in the links list to the file_id
	var aOld = fObj.value.split(',');
	var lOld = lObj.value.split(',');
	for (var i=0; i<aOld.length; i++)
	{
		if (parseInt(aOld[i],10) == parent_id)
		{
			lOld[i] = file_id;
		}
	}

	lObj.value = lOld.join(',');
}

function insertSelectedFile(file_id,filename,file_type)
{
	var linkURL = document.forms['pageForm'].elements['linkURL'].value;

	var tbl = document.getElementById('fileTbl');
	var fObj = document.forms['pageForm'].elements.files;
	var lObj = document.forms['pageForm'].elements.links;
	var content1, content2, content3, content4, content5, cell1, cell2, cell3, cell4, cell5, newRow;

	var rowBorder = '1px solid rgb(0,150,147)';
	var rowBG0 = '#eeeeee';
	var rowBG1 = '#ffffff';

	// Check to see if file is already there
	aOld = fObj.value.split(',');
	aLinks = lObj.value.split(',');
	for (i=0; i < aOld.length; i++)
	{
		if (parseInt(aOld[i],10) == file_id)
		{
			return false;
		}
	}

	// If first row is "noFiles", remove it
	if (tbl.rows[0].id == 'noFiles')
	{
		tbl.deleteRow(0);
	}

	// Create content
	content1 = '<a href="#" onclick="return removeFile(' + file_id + ');">Remove</a>';
	content2 = filename;
	content3 = file_type;
	content4 = '(<a href="#" onclick="return openFileWin(\'' + linkURL + '/finishFunction/opener.addLinkFile(' + file_id + ',file_id).cfm\');this.window.focus();">Add Link</a>)';

	content5 = '';
	if (tbl.rows.length != 1)
	{
		content5 += '<a href="#" onclick="return moveFile(-1,' + file_id + ');">U</a>&nbsp;&nbsp;&nbsp;&nbsp;';
	}
	else
	{
		content5 = '&nbsp;';
	}

	// Create new row
	newRow = tbl.insertRow();
	newRow.setAttribute('valign','top');
	newRow.style.border = rowBorder;
	newRow.style.backgroundColor = eval('rowBG' + (tbl.rows.length % 2));
	newRow.id = 'file_' + file_id;

	cell1 = newRow.insertCell();
	cell1.innerHTML = content1;
	cell2 = newRow.insertCell();
	cell2.innerHTML = content2;
	cell2.align = 'left';
	cell3 = newRow.insertCell();
	cell3.innerHTML = content3;
	cell3.align = 'left';
	cell4 = newRow.insertCell();
	cell4.align = 'right';
	cell4.innerHTML = content4;
	cell5 = newRow.insertCell();
	cell5.align = 'right';
	cell5.innerHTML = content5;

	// Add the move down link to the row above this one, if it exists
	if (tbl.rows.length != 1)
	{
		var otherRow = tbl.rows[tbl.rows.length - 2];
		var otherID = otherRow.id.split('_')[1];
		otherRow.cells[4].innerHTML += '<a href="#" onclick="return moveFile(1,' + otherID + ');">D</a>';
	}


	aOld[aOld.length] = file_id;
	aLinks[aLinks.length] = 0;

	fObj.value = aOld.join(',');
	lObj.value = aLinks.join(',');

	return false;
}

function moveFile(increment,file_id)
{
	var tbl = document.getElementById('fileTbl');
	var fObj = document.forms['pageForm'].elements.files;
	var lObj = document.forms['pageForm'].elements.links;
	var thisRow = document.getElementById('file_' + file_id);
	var thisIndex;
	var tempCell1, tempCell2, tempCell3, tempCell4, tempCell5, tempID, tempFileID, tempLinkID;
	var otherIndex, otherRow;
	var idLoc, endIdLoc;

	for (i=0; i < tbl.rows.length; i++)
	{
		if (tbl.rows[i].id == thisRow.id)
		{
			thisIndex = i;
		}
	}

	otherIndex = thisIndex + increment;
	otherRow = tbl.rows[otherIndex];

	tempID = otherRow.id;
	tempFileID = tempID.split('_')[1];
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

	// Set file_id in moveFile functions in each row
	idLoc = thisRow.cells[4].innerHTML.indexOf('moveFile(1,');
	if (idLoc > -1)
	{
		idLoc += 11;
		endIdLoc = thisRow.cells[4].innerHTML.indexOf(')',idLoc);
		thisRow.cells[4].innerHTML = thisRow.cells[4].innerHTML.substring(0,idLoc) + tempFileID + thisRow.cells[4].innerHTML.substring(endIdLoc);
	}

	idLoc = thisRow.cells[4].innerHTML.indexOf('moveFile(-1,');
	if (idLoc > -1)
	{
		idLoc += 12;
		endIdLoc = thisRow.cells[4].innerHTML.indexOf(')',idLoc);
		thisRow.cells[4].innerHTML = thisRow.cells[4].innerHTML.substring(0,idLoc) + tempFileID + thisRow.cells[4].innerHTML.substring(endIdLoc);
	}
	
	idLoc = otherRow.cells[4].innerHTML.indexOf('moveFile(1,');
	if (idLoc > -1)
	{
		idLoc += 11;
		endIdLoc = otherRow.cells[4].innerHTML.indexOf(')',idLoc);
		otherRow.cells[4].innerHTML = otherRow.cells[4].innerHTML.substring(0,idLoc) + file_id + otherRow.cells[4].innerHTML.substring(endIdLoc);
	}

	idLoc = otherRow.cells[4].innerHTML.indexOf('moveFile(-1,');
	if (idLoc > -1)
	{
		idLoc += 12;
		endIdLoc = otherRow.cells[4].innerHTML.indexOf(')',idLoc);
		otherRow.cells[4].innerHTML = otherRow.cells[4].innerHTML.substring(0,idLoc) + file_id + otherRow.cells[4].innerHTML.substring(endIdLoc);
	}

	// Swap positions in fObj and lObj
	var aOld = fObj.value.split(',');
	aOld[thisIndex] = tempFileID;
	aOld[otherIndex] = file_id;

	fObj.value = aOld.join(',');

	var lOld = lObj.value.split(',');
	tempLinkID = lOld[otherIndex];
	lOld[otherIndex] = lOld[thisIndex];
	lOld[thisIndex] = tempLinkID;

	lObj.value = lOld.join(',');

	return false;
}

function removeFile(file_id)
{
	var tbl = document.getElementById('fileTbl');
	var fObj = document.forms['pageForm'].elements.files;
	var lObj = document.forms['pageForm'].elements.links;
	var thisRow = document.getElementById('file_' + file_id);
	var thisIndex;
	var cell5;
	var aOld = fObj.value.split(',');
	var lOld = lObj.value.split(',');

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
			otherRow.cells[4].innerHTML = '<a href="#" onclick="return moveFile(-1,' + otherRow.id.split('_')[1] + ');">U</a>&nbsp;&nbsp;&nbsp;&nbsp;';
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
				thisRow.cells[4].innerHTML = '<a href="#" onclick="return moveFile(1,' + thisRow.id.split('_')[1] + ');">D</a>'
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
		thisRow.id = 'noFiles';
		thisRow.style.border = rowBorder;
		thisRow.style.backgroundColor = rowBG1;
		cell5 = thisRow.insertCell();
		cell5.colSpan = 5;
		cell5.innerHTML = 'There are no files on this page.';
	}

	// Adjust form values
	aOld.splice(thisIndex,1);
	fObj.value = aOld.join(',');

	lOld.splice(thisIndex,1);
	lObj.value = lOld.join(',');

	return false;
}