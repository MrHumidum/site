jQuery(document).ready(function($) {
	const inputBlock = $(".input_block");

	const focusInput = function() {
		let thisInput, thisText;
		if ( $(this).hasClass("input_block") ) {
			let thisInput = $(this).find("input"),
				thisText = $(this).find("span");

			thisText.addClass("a");
			thisInput.focus();
		}
		else {
			let thisInput = $(this),
				thisText = $(this).parent(".input_block").find("span");

			thisText.addClass("a");
		}
	}

	inputBlock.click(focusInput);

	const unFocusInput = function() {
		if ( $(this).val() == "" ) {
			let thisText = $(this).parents(".input_block").find("span");

			thisText.removeClass("a");
		}
	}

	inputBlock.find("input").blur(unFocusInput);
	inputBlock.find("input").focus(focusInput);
});