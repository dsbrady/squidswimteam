<cfoutput>
<script type="text/javascript">
$(function() {
	$('##forgotpassword').on('click', function() {
		parent.location.href = $(this).attr('href');

		return false;
	});

	$('##loginform').validate({
		errorClass: 'errorText',
		messages: {
			password: {
				required: 'Enter your password.'
			},
			username: {
				required: 'Enter your username.'
			}
		},
		rules: {
			password: {
				required: true
			},
			username: {
				required: true
			}
		},
		submitHandler: function (form) {
			$(form).ajaxSubmit({
				success: processLogin
			});
		}
	});

	processLogin = function(response, statusText, xhr, $form) {
		if (response.statusCode == 400) {
			if (response.statusText == 'NONMEMBER') {
				$('.error').html('You do not currently have access to the SQUID website (your membership may have expired).').show();
			}
			else if (response.statusText == 'EXPIRED') {
				$('.error').html('Your membership to SQUID has expired.').show();
			}
			else {
				// Display error message
				$('.error').html(response.statusText).show();
			}
		}
		else if (response.statusText == 'TEMPORARY') {
			parent.location.href = '#request.self#?fuseaction=#XFA.changePassword#&returnFA=#attributes.returnFA#';
		}
		else {
			// It's all good, reload the parent
			parent.location.reload();
		}
	}
});
</script>

<style>
	.error {
		display: none;
		color: ##ff0000;
		font-weight: bold;
	}
</style>

<div class="error">
</div>

<form name="loginForm" id="loginform" action="#request.self#" method="post">
	<input type="hidden" name="fuseaction" value="#XFA.submit#" />

<table border="0" cellpadding="0" cellspacing="0" align="center">
	<tbody>
		<tr valign="top">
			<td>
				<strong>E-mail / Username:</strong>
			</td>
			<td>
				<input type="text" name="username" size="25" maxlength="255" />
			</td>
		</tr>
		<tr valign="top">
			<td>
				<strong>Password:</strong>
			</td>
			<td>
				<input type="password" name="password" size="10" maxlength="20" />
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="submit" name="submit" value="Login" class="buttonStyle" />
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<a id="forgotpassword" href="#Request.self#?fuseaction=#XFA.forgottenPassword#&returnFA=#attributes.returnFA#">I don't know my password</a>
			</td>
		</tr>
	</tbody>
</table>
</form>
</cfoutput>

