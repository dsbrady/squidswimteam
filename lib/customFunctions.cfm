<cfscript>
numeric function calculateFreeSwims(required numeric numSwims, required numeric purchasedSwimsPerFreeSwim) {
	local.freeSwims = arguments.numSwims \ arguments.purchasedSwimsPerFreeSwim;

	return local.freeSwims;
}

string function decodeString(required string input) {
	arguments.input = replaceList(arguments.input, "%2F,%2B,%3D, ", "/,+,=,+");

	local.result = "";

	try {
		local.result = decrypt(arguments.input, "OFjsgBDbscVZ8mhqt9O6ow==", "AES", "base64");
	}
	catch (any e) {
		 local.result = arguments.input;
	}

	return local.result;
}

string function encodeString(required string input) {
	local.result = "";

	local.result = encrypt(arguments.input, "OFjsgBDbscVZ8mhqt9O6ow==", "AES", "base64");
	local.result = replaceList(local.result, "/,+,=", "%2F,%2B,%3D");

	return local.result;
}

squid.User function getUser() {
	return session.squid.user;
}

squid.Response function getResponse() {
	if (NOT structKeyExists(request, "_response")) {
		request._response = new squid.Response();
	}

	return request._response;
}

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

string function maskString(required string inputString, firstCharactersToDisplay = 0, lastCharactersToDisplay = 0) {
	local.output = "";
	if (arguments.firstCharactersToDisplay > 0) {
		local.output = left(arguments.inputString, arguments.firstCharactersToDisplay);
	}

	local.output &= repeatString("*", len(arguments.inputString) - arguments.lastCharactersToDisplay - arguments.firstCharactersToDisplay);

	if (arguments.lastCharactersToDisplay > 0) {
		local.output &= right(arguments.inputString, arguments.lastCharactersToDisplay);
	}

	return local.output;
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

