<!---
<fusedoc fuse="FBX_Switch.cfm">
	<responsibilities>
		I am the cfswitch statement that handles the fuseaction, delegating work to various fuses.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="15 December 2002" role="Architect">
	</properties>
	<io>
		<in>
			<structure name="fuxebox">
				<string name="fuseaction" />
				<string name="circuit" />
			</structure>
		</in>
	</io>
</fusedoc>
 --->

<cfswitch expression = "#fusebox.fuseaction#">
<!--- ----------------------------------------
LOGIN
----------------------------------------- --->
	<cfcase value="start,dsp_start,fusebox.defaultfuseaction,dsp_login">
	<!--- Displays login page --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Login";
			Request.template = "dsp_login.cfm";

			Request.onLoad = Request.onLoad & "document.loginForm.username.focus();document.loginForm.username.select();";

			XFA.act_login = "login.act_login";
			XFA.forgotten_password = "login.dsp_forgotten_password";
			XFA.act_forgotten_password = "login.act_forgotten_password";
			XFA.forgotten_password_results = "login.dsp_forgotten_password_results";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_login">
	<!--- Submits info --->
		<cfscript>
			XFA.failure = "login.dsp_login";
			XFA.changePassword = "login.dsp_change_password";
			XFA.expired = "login.dsp_membership_expired";

			Request.suppressLayout = true;

			Request.login_cfc = Request.cfcPath & ".login";
			Request.validation_template = "val_login.cfm";
			Request.template = "act_login.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfcase>

<!--- ----------------------------------------
EXPIRED
----------------------------------------- --->
	<cfcase value="dsp_membership_expired">
	<!--- Displays expired membership notice --->
		<cfscript>
			Request.page_title = Request.page_title & " - Membership Expired";
			Request.template = "dsp_membership_expired.cfm";

			XFA.dues = "membership.dsp_membershipForm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

<!--- ----------------------------------------
PASSWORD
----------------------------------------- --->
	<cfcase value="dsp_change_password">
	<!--- Displays change password form --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Change Password";
			Request.js_validate = "login/javascript/change_password.js";
			Request.template = "dsp_change_password.cfm";

			XFA.next = "login.act_change_password";

			Request.onLoad = Request.onLoad & "document.passwordForm.password_old.focus();document.passwordForm.password_old.select();";
		</cfscript>

		<!--- If not logged in, go to login --->
		<cfif VAL(Request.squid.user_id) EQ 0>
			<cflocation addtoken="no" url="#Request.self#?fuseaction=#XFA.login#">
		</cfif>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_change_password">
	<!--- Submits info --->
		<cfscript>
			XFA.success = "login.dsp_change_password_results";
			XFA.failure = "login.dsp_change_password";

			Request.suppressLayout = true;

			Request.password_cfc = Request.cfcPath & ".password";
			Request.validation_template = "val_change_password.cfm";
			Request.template = "act_change_password.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_change_password_results">
	<!--- Displays password change results page --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Password Changed";

			Request.template = "dsp_change_password_results.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_forgotten_password">
	<!--- Displays forgotten password form --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Forgotten Password";
			Request.js_validate = "login/javascript/forgotten_password.js";
			Request.template = "dsp_forgotten_password.cfm";

			XFA.next = "login.act_forgotten_password";

			Request.onLoad = Request.onLoad & "document.passwordForm.username.focus();document.passwordForm.username.select();";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_forgotten_password">
	<!--- Submits info --->
		<cfscript>
			XFA.success = "login.dsp_forgotten_password_results";
			XFA.failure = "login.dsp_forgotten_password";

			Request.suppressLayout = true;

			Request.password_cfc = Request.cfcPath & ".password";
			Request.validation_template = "val_forgotten_password.cfm";
			Request.template = "act_forgotten_password.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_forgotten_password_results">
	<!--- Displays forgotten password results page --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Password Sent";

			Request.template = "dsp_forgotten_password_results.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

<!--- ----------------------------------------
NO ACCESS
----------------------------------------- --->
	<cfcase value="dsp_noaccess">
	<!--- Displays no access page --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Access Denied";
			Request.template = "dsp_noaccess.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>


<!--- ----------------------------------------
LOGOUT
----------------------------------------- --->
	<cfcase value="act_logout">
	<!--- Logs out --->
		<cfscript>
			XFA.success = "login.dsp_logout_results";

			Request.suppressLayout = true;

			Request.login_cfc = Request.cfcPath & ".login";
			Request.validation_template = "val_logout.cfm";
			Request.template = "act_logout.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_logout_results">
	<!--- Displays logout results page --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Logout Successful";

			Request.template = "dsp_logout_results.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>


<!--- ----------------------------------------
DEFAULT
----------------------------------------- --->
	<cfdefaultcase>
		<!---This will just display an error message and is useful in catching typos of fuseaction names while developing--->
		<cfoutput><p>This is the cfdefaultcase tag. I received a fuseaction called <strong>"#attributes.fuseaction#"</strong> and I don't know what to do with it.</p></cfoutput>
	</cfdefaultcase>

</cfswitch>
