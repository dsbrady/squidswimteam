var xmlHttp;
var filterObject;

var primaryColumnHeaders = new Array();
var secondaryColumnHeaders = new Array();
var primaryColumnSet, secondaryColumnSet, primaryDataSource, secondaryDataSource, primaryDataTable, secondaryDataTable, primaryQuery, secondaryQuery;
var oConfigs;

function checkForAjax()
{
	var primaryFilterRow = document.getElementById('primaryFilterRow');
	var primaryFilterText = document.getElementById('primaryilterText');
	var secondaryFilterRow = document.getElementById('secondaryFilterRow');
	var secondaryFilterText = document.getElementById('secondaryilterText');

	try
	{
		// Firefox, Opera8+, Safari, IE7+
		xmlHttp = new XMLHttpRequest();
	}
	catch (e)
	{
		// IE 6 and earlier
		try
		{
			xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
		}
		catch (e)
		{
			try
			{
				xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
			}
			catch (e)
			{
				// No AJAX support
				primaryfilterRow.style.display = 'none';
				primaryfilterText.style.display = 'none';
				secondaryfilterRow.style.display = 'none';
				secondaryfilterText.style.display = 'none';
				return false;
			}

		}
	}

	return true;
}

function populateYahooData(columnHeaderList,xhrURL,xhrParameters)
{
/*
	primaryColumnHeaders = [
		{key:"last_name", text:"Last Name",type:"string"},
		{key:"first_name", text:"First Name",type:"string"},
		{key:"username", text:"User Name",type:"string"},
		{key:"email", text:"E-Mail",type:"email"},
		{key:"status", text:"Status",type:"string"}
	];

	primaryColumnSet = new YAHOO.widget.ColumnSet(primaryColumnHeaders);

	primaryQuery = [
		{last_name:"Brady",first_name:"Scott",username:"dsbrady",email:"dsbrady@scottbrady.net",status:"Member"},
		{last_name:"Johanson",first_name:"Brent",username:"bjohanson",email:"bjohanson@scottbrady.net",status:"Swimming Non-Member"},
		{last_name:"Parker",first_name:"Cory",username:"cparker",email:"cparker@scottbrady.net",status:"Swimming Non-Member"},
		{last_name:"Barnhardt",first_name:"Mick",username:"mbarnhardt",email:"mbarnhardt@scottbrady.net",status:"Member"}
	];

	primaryDataSource = new YAHOO.util.DataSource(primaryQuery);
	primaryDataSource.responseType = YAHOO.util.DataSource.TYPE_JSARRAY;
	primaryDataSource.responseSchema = {
		fields: ["last_name","first_name","username","email","status"]
	};

	primaryDataTable = new YAHOO.widget.DataTable("primaryUserDivNew",primaryColumnSet,primaryDataSource);

*/
// this comes from functions
	var aColumnHeaders = columnHeaderList.split(',');

	for (var i = 0; i < aColumnHeaders.length; ++i)
	{
		primaryColumnHeaders[primaryColumnHeaders.length] = new Column(aColumnHeaders[i]);
//		secondaryColumnHeaders[secondaryColumnHeaders.length] = new Column(aColumnHeaders[i]);
	}

	primaryColumnSet = new YAHOO.widget.ColumnSet(primaryColumnHeaders);
//	secondaryColumnSet = new YAHOO.widget.ColumnSet(secondaryColumnHeaders);

	primaryDataSource = new YAHOO.util.DataSource(xhrURL + xhrParameters);
//	secondaryDataSource = new YAHOO.util.DataSource(xhrURL);

	primaryDataSource.responseType = YAHOO.util.DataSource.TYPE_JSON;
//	secondaryDataSource.responseType = YAHOO.util.DataSource.TYPE_JSON;

	primaryDataSource.responseSchema = {
		resultsList: "recordset.items",
		fields: ["user_id","first_name","last_name","username","email","status"]
	};
/*
	secondaryDataSource.responseSchema = {
		resultsList: "recordset.items",
		fields: ["user_id","first_name","last_name","username","email","status"]
	};
*/
//alert(xhrURL);
//alert(xhrParameters);
	oConfigs = {
		initialRequest: xhrParameters
	};
//document.getElementById('primaryUserDivNew').innerHTML = xhrURL;
//	primaryDataTable = new YAHOO.widget.DataTable("primaryUserDivNew",primaryColumnSet,primaryDataSource);
/*
	populateColumnSets(columnHeaderList);
	populateDatasources(xhrURL);
	primaryDataTable = new YAHOO.widget.DataTable('primaryUserDivNew',primaryColumnSet,primaryDataSource);
alert(primaryDataTable);
*/
}

function populateColumnSets(columnHeaderList)
{
	var aColumnHeaders = columnHeaderList.split(',');

	for (var i = 0; i < aColumnHeaders.length; ++i)
	{
		primaryColumnHeaders[primaryColumnHeaders.length] = new Column(aColumnHeaders[i]);
		secondaryColumnHeaders[secondaryColumnHeaders.length] = new Column(aColumnHeaders[i]);
	}

	primaryColumnSet = new YAHOO.widget.ColumnSet(primaryColumnHeaders);
	secondaryColumnSet = new YAHOO.widget.ColumnSet(secondaryColumnHeaders);
}

function Column(headerSet)
{
	var aKeys = headerSet.split('|');
	for (var i = 0; i < aKeys.length; ++i )
	{
		this[aKeys[i].split(':')[0]] = aKeys[i].split(':')[1];
	}
}

function populateDatasources(xhrURL)
{
	primaryDataSource = new YAHOO.util.DataSource(xhrURL);
	secondaryDataSource = new YAHOO.util.DataSource(xhrURL);

	primaryDataSource.responseType = YAHOO.util.DataSource.TYPE_JSON;
	secondaryDataSource.responseType = YAHOO.util.DataSource.TYPE_JSON;

	primaryDataSource.responseSchema = {
		resultsList: "data",
		fields: ["user_id","first_name","last_name","username","email","status"]
	};
	secondaryDataSource.responseSchema = {
		resultsList: "data",
		fields: ["user_id","first_name","last_name","username","email","status"]
	};

	return true;
}




function filterPrimaryUsers(fObj,tbody,sUrl)
{
	filterObject = fObj;
	sUrl = sUrl + fObj.value;

	xmlHttp.onreadystatchange = processPrimaryUserFilter();

	xmlHttp.open('GET',sUrl,true);
	xmlHttp.send(null);
}

function processPrimaryUserFilter()
{
		processUserFilter('primary');
}

function filterSecondaryUsers(fObj,tbody,sUrl)
{
	filterObject = fObj;
	sUrl = sUrl + fObj.value;

	xmlHttp.onreadystatchange = processSecondaryUserFilter();

	xmlHttp.open('GET',sUrl,true);
	xmlHttp.send(null);
}

function processSecondaryUserFilter()
{
	processUserFilter('secondary');
}

function processUserFilter(listType)
{
	var jsonObj;
	var tbody = document.getElementById(listType + 'UserList');
	var userID, firstName, lastName, username, email, status;
	var newRow, newCell;

	if (xmlHttp.readyState == 4)
	{
		jsonObj = eval('(' + xmlHttp.responseText + ')');
// 		Delete all the rows
		if (tbody.rows.length > 0)
		{
			for (var i = tbody.rows.length - 1; i >= 0; i--)
			{
				tbody.deleteRow(i);
			}
		}

//		Now, add the rows that were returned

		for (var i = 0; i <= jsonObj.recordcount; ++i)
		{
			userID = jsonObj.data.user_id[i];
			lastName = jsonObj.data.last_name[i];
			firstName = jsonObj.data.first_name[i];
			username = jsonObj.data.username[i];
			email = jsonObj.data.email[i];
			status = jsonObj.data.status[i];

			newRow = tbody.insertRow(i);
			newRow.id = listType + 'User_' + userID;
			newCell = newRow.insertCell(0);
			newCell.innerHTML = lastName;
			newCell = newRow.insertCell(1);
			newCell.innerHTML = firstName;
			newCell = newRow.insertCell(2);
			newCell.innerHTML = username;
			newCell = newRow.insertCell(3);
			newCell.innerHTML = email;
			newCell = newRow.insertCell(4);
			newCell.innerHTML = status;

			newRow.addEventListener('click',function()
			{
				var tbody, tbodyID;
				var tbRow = this;
				var fObj = document.forms['mergeUserForm'];
				var userID = this.id.split('_')[1];

				tbodyID = this.id.split('_')[0] + 'List';
				tbody = document.getElementById(tbodyID);

				selectUser(tbody,tbRow,fObj,userID);
			},false)
		}
	}
}

function selectUser(tbody,tbRow,fObj,userID,otherRow,otherBody)
{
	var selectedClassName = 'selected';
	var disabledClassName = 'disabled';
	var idList;
	var userObj;
	var other

	if (tbRow.className == disabledClassName)
	{
		return true;
	}
	if (tbody.id == 'primaryUserList')
	{
		for (var i=0; i < tbody.rows.length; ++i)
		{
			tbody.rows[i].className = '';
		}
		for (var i=0; i < otherBody.rows.length; ++i)
		{
			otherBody.rows[i].className = '';
		}

		tbRow.className = selectedClassName;
		otherRow.className = disabledClassName;

		userObj = fObj.elements['primaryUserID']
		userObj.value = userID;
	}
	else
	{
		userObj = fObj.elements['secondaryUsers']
		userObj.value = '';

		if (tbRow.className == selectedClassName)
		{
			tbRow.className = '';
		}
		else
		{
			tbRow.className = selectedClassName;
		}

		for (var i = 0; i < tbody.rows.length; ++i)
		{
			if (tbody.rows[i].className == selectedClassName)
			{
				userObj.value += tbody.rows[i].id.split('_')[1] + ',';
			}
		}
	}
}

function validate(fObj)
{
	var aErrors = new Array();

	if ((fObj.elements['primaryUserID'].value == ''))
	{
		aErrors[aErrors.length] = 'Select a user to merge the other users INTO.';
	}

	if ((fObj.elements['secondaryUsers'].value == ''))
	{
		aErrors[aErrors.length] = 'Select user(s) to merge into the first user you selected..';
	}

	if (aErrors.length)
	{
		alert('There is a problem with your submission:\n* ' + aErrors.join('\n* '));
		return false;
	}

	return true;
}