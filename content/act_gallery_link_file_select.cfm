<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!---
<fusedoc
	fuse = "act_gallery_link_file_select.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I perform the action.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="11 November 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			
			<number name="file_id" scope="attributes" />
			<number name="parent_id" scope="attributes" />
		</in>
		<out>
			<number name="file_id" scope="formOrUrl" />
			<string name="filename" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->
<cfparam name="attributes.file_id" default=0 type="numeric">
<cfparam name="attributes.parent_id" default=0 type="numeric">

<!--- Get file info --->
<cfinvoke  
	component="#Request.lookup_cfc#" 
	method="getFiles" 
	returnvariable="qryFile"
	dsn=#Request.DSN#
	fileTbl=#Request.fileTbl#
	file_categoryTbl=#Request.file_categoryTbl#
	file_typeTbl=#Request.file_typeTbl#
	file_id=#VAL(attributes.file_id)#
>

<html>
<head>
<cfoutput>
	<script type="text/javascript">
		parent.insertSelectedLinkFile(#qryFile.file_id#,'#qryFile.filename#',#attributes.parent_id#);
	</script>
</cfoutput>
</head>
</html>
