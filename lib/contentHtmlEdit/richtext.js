var rng;
var theContent;

//Function to format text in the text box
function FormatText(command, option) {
	if ((command == "forecolor") || (command == "hilitecolor")) {
		parent.command = command;
		buttonElement = document.getElementById(command);
		document.getElementById("colorpalette").style.left = getOffsetLeft(buttonElement) - 200 + "px";
		document.getElementById("colorpalette").style.top = (getOffsetTop(buttonElement) + buttonElement.offsetHeight) - 325 + "px";
		if (document.getElementById("colorpalette").style.visibility == "hidden")
			document.getElementById("colorpalette").style.visibility="visible";
		else {
			document.getElementById("colorpalette").style.visibility="hidden";
		}

		//get current selected range
		var sel = document.getElementById('edit').contentWindow.document.selection;
		if (sel!=null) {
			rng = sel.createRange();
		}
	}
	else if (command == "createlink" && browser.isIE5up == false) {
		var szURL = prompt("Enter a URL:", "");
		document.getElementById('edit').contentWindow.document.execCommand("CreateLink",false,szURL)
	}
	else {
		document.getElementById("edit").contentWindow.focus();
	  	document.getElementById("edit").contentWindow.document.execCommand(command, false, option);
		document.getElementById("edit").contentWindow.focus();
	}
}

//Function to set color
function setColor(color) {
	if (browser.isIE5up) {
		//retrieve selected range
		var sel = document.getElementById('edit').contentWindow.document.selection;
		if (sel!=null) {
			var newRng = sel.createRange();
			newRng = rng;
			newRng.select();
		}
	}
	else {
		document.getElementById("edit").contentWindow.focus();
	}
	document.getElementById("edit").contentWindow.document.execCommand(parent.command, false, color);
	document.getElementById("edit").contentWindow.focus();
	document.getElementById("colorpalette").style.visibility="hidden";
}

// Functions to insert non-image file
function AddFile(theServer,fileFA) {
	var sel = document.getElementById('edit').contentWindow.document.selection.createRange().text.length;

	if (sel < 1)
	{
		alert('You must select the text you wish to turn into a link before inserting a non-image file.');
		return false;
	}

	var url = theServer + '/index.cfm?fuseaction=' + fileFA + '&imageYN=no&finishFunction=opener.AddFile2(filePath);window.close();';
	var winAttribs = 'width=600,height=400,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes';
	fileWin = window.open(url,'fileWin',winAttribs);

	return true;
}

function AddFile2(filePath) {
	if ((filePath != null) && (filePath != "")) {
		document.getElementById("edit").contentWindow.focus()
		document.getElementById("edit").contentWindow.document.execCommand('CreateLink', false, filePath);
	}
	document.getElementById("edit").contentWindow.focus()
}


//Functions to add image
function AddImage(theServer,fileFA) {
	var url = theServer + '/index.cfm?fuseaction=' + fileFA + '&imageYN=yes&finishFunction=opener.AddImage2(filePath);window.close();';
	var winAttribs = 'width=500,height=400,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes';
	fileWin = window.open(url,'fileWin',winAttribs);

	return true;
}

function AddImage2(imagePath) {
	if ((imagePath != null) && (imagePath != "")) {
		document.getElementById("edit").contentWindow.focus()
		document.getElementById("edit").contentWindow.document.execCommand('InsertImage', false, imagePath);
	}
	document.getElementById("edit").contentWindow.focus()
}

//Function to clear form
function ResetForm() {
	if (window.confirm('<%=strResetFormConfirm%>')) {
		document.getElementById("edit").contentWindow.focus()
	 	document.getElementById("edit").contentWindow.document.body.innerHTML = '';
	 	return true;
	 }
	 return false;
}

//Function to open pop up window
function openWin(theURL,winName,features) {
  	window.open(theURL,winName,features);
}

//function to perform spell check
function checkspell() {
	try {
		var tmpis = new ActiveXObject("ieSpell.ieSpellExtension");
		tmpis.CheckAllLinkedDocuments(document);
	}
	catch(exception) {
		if(exception.number==-2146827859) {
			if (confirm("ieSpell not detected.  Click Ok to go to download page."))
				window.open("http://www.iespell.com/download.php","DownLoad");
		}
		else
			alert("Error Loading ieSpell: Exception " + exception.number);
	}
}

function getOffsetTop(elm) {
	var mOffsetTop = elm.offsetTop;
	var mOffsetParent = elm.offsetParent;

	while(mOffsetParent){
		mOffsetTop += mOffsetParent.offsetTop;
		mOffsetParent = mOffsetParent.offsetParent;
	}

	return mOffsetTop;
}

function getOffsetLeft(elm) {
	var mOffsetLeft = elm.offsetLeft;
	var mOffsetParent = elm.offsetParent;

	while(mOffsetParent) {
		mOffsetLeft += mOffsetParent.offsetLeft;
		mOffsetParent = mOffsetParent.offsetParent;
	}

	return mOffsetLeft;
}

function Select(selectname)
{
	var cursel = document.getElementById(selectname).selectedIndex;
	// First one is always a label
	if (cursel != 0) {
		var selected = document.getElementById(selectname).options[cursel].value;
		document.getElementById('edit').contentWindow.document.execCommand(selectname, false, selected);
		document.getElementById(selectname).selectedIndex = 0;
	}
	document.getElementById("edit").contentWindow.focus();
}

function Start(imageFolder,defaultContent,theServer,fileFA)
{
	if (!defaultContent)
		defaultContent = '';

	theContent = defaultContent;
	//write html based on browser type
	if (browser.isIE5up) {
		writeRTE(imageFolder,theServer,fileFA);
	}
	else if (browser.isGecko) {
		//check to see if midas is enabled
		var isMidasEnabled = false;

		try {
			document.getElementById('testFrame').contentDocument.designMode = "on";
			document.getElementById('testFrame').contentWindow.document.execCommand("undo", false, null);
			isMidasEnabled = true;
		}  catch (e) {
			isMidasEnabled = false;
		}

		if (isMidasEnabled) {
			writeRTE(imageFolder,theServer,fileFA);
		} else {
			writeDefault();
		}
	}
	else {
		//other browser
		writeDefault()
	}
}

function writeRTE(imageFolder,theServer,fileFA)
{
	document.writeln('<table>');
	document.writeln('	<tr>');
	document.writeln('		<td>');
	document.writeln('			<select id="formatblock" onchange="Select(this.id);">');
	document.writeln('				<option value="<p>">Normal</option>');
	document.writeln('				<option value="<p>">Paragraph</option>');
	document.writeln('				<option value="<h1>">Heading 1 <h1></option>');
	document.writeln('				<option value="<h2>">Heading 2 <h2></option>');
	document.writeln('				<option value="<h3>">Heading 3 <h3></option>');
	document.writeln('				<option value="<h4>">Heading 4 <h4></option>');
	document.writeln('				<option value="<h5>">Heading 5 <h5></option>');
	document.writeln('				<option value="<h6>">Heading 6 <h6></option>');
	document.writeln('				<option value="<address>">Address <ADDR></option>');
	document.writeln('				<option value="<pre>">Formatted <pre></option>');
	document.writeln('			</select>');
	document.writeln('		</td>');
	document.writeln('		<td>');
	document.writeln('			<select id="fontname" name="selectFont" onchange="Select(this.id)">');
	document.writeln('				<option value="Font" selected>Font</option>');
	document.writeln('				<option value="Arial, Helvetica, sans-serif">Arial</option>');
	document.writeln('				<option value="Courier New, Courier, mono">Courier New</option>');
	document.writeln('				<option value="Times New Roman, Times, serif">Times New Roman</option>');
	document.writeln('				<option value="Verdana, Arial, Helvetica, sans-serif">Verdana</option>');
	document.writeln('			</select>');
	document.writeln('		</td>');
	document.writeln('		<td>');
	document.writeln('			<select unselectable="on" id="fontsize" onchange="Select(this.id);">');
	document.writeln('				<option value="Size">Size</option>');
	document.writeln('				<option value="1">1</option>');
	document.writeln('				<option value="2">2</option>');
	document.writeln('				<option value="3">3</option>');
	document.writeln('				<option value="4">4</option>');
	document.writeln('				<option value="5">5</option>');
	document.writeln('				<option value="6">6</option>');
	document.writeln('				<option value="7">7</option>');
	document.writeln('			</select>');
	document.writeln('		</td>');
	document.writeln('	</tr>');
	document.writeln('</table>');
	document.writeln('<table cellpadding="1" cellspacing="0">');
	document.writeln('	<tr>');
	document.writeln('		<td><img class="btnImage" src="' + imageFolder + '/images/post_button_bold.gif" width="25" height="24" alt="Bold" title="Bold" onClick="FormatText(\'bold\', \'\')"></td>');
	document.writeln('		<td><img class="btnImage" src="' + imageFolder + '/images/post_button_italic.gif" width="25" height="24" alt="Italic" title="Italic" onClick="FormatText(\'italic\', \'\')"></td>');
	document.writeln('		<td><img class="btnImage" src="' + imageFolder + '/images/post_button_underline.gif" width="25" height="24" alt="Underline" title="Underline" onClick="FormatText(\'underline\', \'\')"></td>');
	document.writeln('		<td>&nbsp;</td>');
	document.writeln('		<td><img class="btnImage" src="' + imageFolder + '/images/post_button_left_just.gif" width="25" height="24" alt="Align Left" title="Align Left" onClick="FormatText(\'justifyleft\', \'\')"></td>');
	document.writeln('		<td><img class="btnImage" src="' + imageFolder + '/images/post_button_centre.gif" width="25" height="24" alt="Center" title="Center" onClick="FormatText(\'justifycenter\', \'\')"></td>');
	document.writeln('		<td><img class="btnImage" src="' + imageFolder + '/images/post_button_right_just.gif" width="25" height="24" alt="Align Right" title="Align Right" onClick="FormatText(\'justifyright\', \'\')"></td>');
	document.writeln('		<td>&nbsp;</td>');
	document.writeln('		<td><img class="btnImage" src="' + imageFolder + '/images/post_button_numbered_list.gif" width="25" height="24" alt="Ordered List" title="Ordered List" onClick="FormatText(\'insertorderedlist\', \'\')"></td>');
	document.writeln('		<td><img class="btnImage" src="' + imageFolder + '/images/post_button_list.gif" width="25" height="24" alt="Unordered List" title="Unordered List" onClick="FormatText(\'insertunorderedlist\', \'\')"></td>');
	document.writeln('		<td>&nbsp;</td>');
	document.writeln('		<td><img class="btnImage" src="' + imageFolder + '/images/post_button_outdent.gif" width="25" height="24" alt="Outdent" title="Outdent" onClick="FormatText(\'outdent\', \'\')"></td>');
	document.writeln('		<td><img class="btnImage" src="' + imageFolder + '/images/post_button_indent.gif" width="25" height="24" alt="Indent" title="Indent" onClick="FormatText(\'indent\', \'\')"></td>');
	document.writeln('		<td><div id="forecolor"><img class="btnImage" src="' + imageFolder + '/images/post_button_textcolor.gif" width="25" height="24" alt="Text Color" title="Text Color" onClick="FormatText(\'forecolor\', \'\')"></div></td>');
	document.writeln('		<td>&nbsp;</td>');
	document.writeln('		<td><img class="btnImage" src="' + imageFolder + '/images/post_button_hyperlink.gif" width="25" height="24" alt="Insert Link" title="Insert Link" onClick="FormatText(\'createlink\')"></td>');
	document.writeln('		<td><img class="btnImage" src="' + imageFolder + '/images/post_button_image.gif" width="25" height="24" alt="Add Image" title="Add Image" onClick="AddImage(\'' + theServer + '\',\'' + fileFA + '\')"></td>');
	document.writeln('		<td><img class="btnImage" src="' + imageFolder + '/images/post_button_nonimage.gif" width="25" height="24" alt="Insert Non-Image File" title="Insert Non-Image File" onClick="AddFile(\'' + theServer + '\',\'' + fileFA + '\')"></td>');
	document.writeln('	</tr>');
	document.writeln('</table>');
	document.writeln('<br>');
	document.writeln('<iframe id="edit" width="400px" height="200px"></iframe>');
	document.writeln('<iframe width="275" height="170" id="colorpalette" src="' + imageFolder + '/palette.htm" style="visibility:hidden; position: absolute; left: 0px; top: 0px;"></iframe>');
	setTimeout('enableDesignMode()', 10);
}

function writeDefault()
{
	document.writeln('<textarea name="edit" id="edit" style="width: 510px; height: 200px;">' + theContent + '</textarea>');
}

function enableDesignMode() {
	if (browser.isIE5up) {
		frames.edit.document.designMode = "On";
	}
	else {
		document.getElementById('edit').contentDocument.designMode = "on"
	}

	setTimeout('setDefaultContent();',1000);
}

function setDefaultContent()
{
	try {
		document.getElementById('edit').contentWindow.document.body.innerHTML = theContent;
	}
	catch (e) {
		document.getElementById('edit').value = theContent;
	}
}
