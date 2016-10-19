function validate(theForm)
{
	with(theForm)
	{
		// Make sure all the fields have something in them
		if (trim(password_old.value) == '')
		{
			alert('Please enter your old password.');
			password_old.focus();
			password_old.select();
			return false;
		}
		if (trim(password.value) == '')
		{
			alert('Please enter your new password.');
			password.focus();
			password.select();
			return false;
		}
		
		// Make sure new password is different from old password
		if (password.value == password_old.value)
		{
			alert('The new password must be different from the old password.');
			password.focus();
			password.select();
			return false;
		}

		// Make sure two new passwords match and are different from old password
		if (password.value != password_confirm.value)
		{
			alert('The new passwords you entered are not the same. Please ensure that they match to confirm your new password.');
			password.focus();
			password.select();
			return false;
		}

		validChars = 'abcdefghijklmnopqrstuvwxyz1234567890,_';
		hasNumber = false;
		
		// Make sure new password follows rules (only valid characters, at least one non-letter character)
		for (i=0; i < password.value.length; i++)
		{
			if (validChars.indexOf(password.value.charAt(i).toLowerCase()) == -1)
			{
				alert('Your password can contain only letters, numbers, a comma, or an underscore.');
				password.focus();
				password.select();
				return false;
			}
			else if ((!isNaN(parseInt(password.value.charAt(i)))) && (!hasNumber))
			{
				hasNumber = true;
			}
		}
		
		if (!hasNumber)
		{
			alert('Your new password must contain at least 1 number.');
			password.focus();
			password.select();
		}
	}

	return true;
}