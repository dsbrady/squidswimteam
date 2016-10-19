$(document).ready
(
	function()
	{
		$("#additionalFeesDiv").dialog
		(
			{
				bgiframe: true,
				autoOpen: false,
				height: 475,
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

function showAdditionalFees()
{
	$('#additionalFeesDiv').dialog('open');
}

