<cfscript>
function isValidURL(theString)
{
	theString = LCASE(theString);
	
	variables.validChars = "abcdefghijklmnopqrstuvwxyz1234567890/&?._-,:=";
	
	// First, see if there are any invalid characters
	for (i=1; i LTE Len(theString); i = i + 1)
	{
		if (NOT Find(MID(theString,i,1),variables.validChars))
		{
			return false;
		}
	}

	// Next, make sure that it starts with either 'http://' or 'https://'
	if ((LEFT(theString,7) IS NOT "http://") AND (LEFT(theString,8) IS NOT "https://"))
	{
		return false;
	}

	// Next, make sure that the host info has at least one period, by splitting into an array separated by "."
	if (NOT FIND(".",theString))
	{
		return false;
	}

	return true;
}

function secure(requiredPermission) 
{
	var permitted = false;
	if ( StructKeyExists( Request.squid, "permissions" ) ) {
		if ( ListFindNoCase( Request.squid.permissions, requiredPermission ) )
			permitted = true;
	}
	return ( permitted );
}

function truncString(theString,maxLength)
{
	if (Len(theString) GT maxLength)
	{
		return Left(theString,(maxLength - 3)) & "...";
	}
	else
	{
		return theString;
	}
}
</cfscript>

