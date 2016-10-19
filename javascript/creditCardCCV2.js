$(document).ready
(
	function()
	{
		$("#ccvHelpDiv").dialog
		(
			{
				bgiframe: true,
				autoOpen: false,
				height: 400,
				width: 400,
				draggable: true,
				position: 'center',
				resizable: true,
				modal: false,
				closeOnEscape: true,
				open: function disableScroll()
				{
					document.body.style.overflow="hidden";
				},
				close: function enableScroll()
				{
					document.body.style.overflow="scroll";
				}
			}
		);
	}
);

function showCCVNumberHelp()
{
	var creditCardType = $('#creditCardTypeID option:selected').text();
	switch (creditCardType)
	{
		case 'AMEX':
			$('#ccvHelp3Digits').hide();
			$('#ccvHelpAMEX').show();
			break;
		case 'Discover':
		case 'VISA':
		case 'Mastercard':
			$('#ccvHelp3Digits').show();
			$('#ccvHelpAMEX').hide();
			break;
		default:
			$('#ccvHelpAMEX').show();
			$('#ccvHelp3Digits').show();
	}

	$('#ccvHelpDiv').dialog('open');
}

