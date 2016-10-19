function changeCat(selBox,url)
{
	url += selBox[selBox.selectedIndex].value;

	location.href = url;

	return true;
}

function selectFile(filePath,finishFunction,file_id)
{
	eval(finishFunction);

	return false;
}

