$(function() {
	// Add a rule for the expiration date
	$.validator.addMethod('ccexpiration', function(value, element, params) {
		var expirationMonth = $('#' + params['monthField']).val(),
			// By not adding 1 to the expirationMonth and setting the day to 0, we get the end of the actual month we want
			expiration = new Date(value, expirationMonth, 0 ),
			today = new Date();

		return expiration > today;
	}, '<br />Expiration must be after today');

	// Add a rule for the CVV field
	$.validator.addMethod('cvv2', function(value, element, params) {
		var requiredDigits = $(params['ccType']).val() == 'AMEX' ? 4 : 3;

		return value.length == requiredDigits;
	}, '<br />Enter a valid verification number');


	$('#buyswims').validate({
		errorClass: 'errorText',
		messages: {
			billingCity: {
				required: 'Enter your billing city'
			},
			billingStreet: {
				required: '<br />Enter your billing address'
			},
			billingZip: {
				required: '<br />Enter your billing ZIP Code'
			},
			creditCardNumber: {
				required: '<br />Enter your credit card number',
				creditcard: '<br />Credit card number is not valid'
			},
			creditCardTypeID: {
				required: '<br />Select a credit card type'
			},
			creditCardVerificationNumber: {
				required: '<br />Verification number is required'
			},
			email: {
				required: '<br />Enter your email address.',
				email: '<br />Enter a valid email address'
			},
			nameOnCard: {
				required: '<br />Enter the name on the card.'
			}
		},
		rules: {
			billingCity: {
				required: true
			},
			billingStreet: {
				required: true
			},
			billingZip: {
				required: true
			},
			creditCardExpirationYear: {
				ccexpiration: {
					monthField: 'creditCardExpirationMonth'
				}
			},
			creditCardNumber: {
				required: true,
				creditcard: true
			},
			creditCardTypeID: {
				required: true
			},
			creditCardVerificationNumber: {
				required: true,
				cvv2: {
					ccType: '#creditCardTypeID'
				}
			},
			email: {
				required: true,
				email: true
			},
			nameOnCard: {
				required: true
			}
		}
	});

	$('.cvv-help, .login').fancybox({
		type: 'iframe',
		helpers: {
				title: null
			}
	});

	$('#usecontactaddress').on('click', function() {
			if ($(this).prop('checked')) {
				$('#billingstreet').val($('#address1').val());
				$('#billingcity').val($('#city').val());
				$('#billingstate').val($('#state').val());
				$('#billingzip').val($('#zip').val());
				$('#billingcountry').val($('#country').val());
			}
			else {
				$('#billingstreet').val('').focus();
				$('#billingcity').val('');
				$('#billingstate').val('CO');
				$('#billingzip').val('');
				$('#billingcountry').val('US');
			}
		});
});
