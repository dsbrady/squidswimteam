<!---
<fusedoc
	fuse = "act_issues_edit.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I go to the next fuse.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="5 June 2003" type="Create">
	</properties>
	<io>
		<in>
			<string name="self" />
			<structure name="XFA">
				<string name="success" />
				<string name="failure" />
			</structure>
			
			<number name="issue_id" scope="attributes" />
			<number name="status_id" scope="attributes" />
			<number name="severity_id" scope="attributes" />
			<number name="assigned_to" scope="attributes" />
			<number name="submitted_by" scope="attributes" />
			<number name="assigned_by" scope="attributes" />
			<string name="description" scope="attributes" />
		</in>
		<out>
			<number name="issue_id" scope="formOrUrl" />
			<number name="status_id" scope="formOrUrl" />
			<number name="assigned_to" scope="formOrUrl" />
			<number name="severity_id" scope="formOrUrl" />
			<number name="submitted_by" scope="formOrUrl" />
			<number name="assigned_by" scope="formOrUrl" />
			<string name="description" scope="formOrUrl" />

			<boolean name="success" scope="variables" />
			<string name="reason" scope="variables" />
		</out>
	</io>
</fusedoc>
--->

<!--- Go to the next page --->
<cflocation addtoken="no" url="#variables.baseHREF##Request.self#/fuseaction/#XFA.success#/success/yes/reason/Issue%20Saved.cfm">
