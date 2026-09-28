jQuery(document).ready(function($) {
	const popupBtn = $(".havproblen"),
			popupBox = $("#error_popup"),
			popupBg = $(".er_p_bg"),
			popupClose = $(".error_popup_close");

	const toggleErrPopup = function() {
		popupBox.toggleClass("a");
		popupBg.css("min-height", popupBox.find(".error_popup").outerHeight(true));
	}

	popupBtn.click(toggleErrPopup);
	popupClose.click(toggleErrPopup);
	popupBg.click(toggleErrPopup);

	// --------------------------------------

	const errInputBlock = $(".error_popup_input"),
			errInput = $(".error_popup_input input"),
			errBtn = $(".error_popup_form button");

	const focusInput = function() {
		$(this).parents(".error_popup_input").addClass("a");
	}

	const clickFocusInput = function() {
		let thisInput = $(this).find("input");

		$(this).addClass("a");
		thisInput.focus();
	}

	const unFocusInput = function() {
		if ( $(this).val() == "" ){
			let thisInputBlock = $(this).parents(".error_popup_input");
			thisInputBlock.removeClass("a");
		}
	}

	errInputBlock.click(clickFocusInput);
	errInput.focus(focusInput);
	errInput.blur(unFocusInput);


	// ----
	const errTextareaBlock = $(".error_popup_textarea"),
			errTextarea = $(".error_popup_textarea textarea");

	const clickFocusTextarea = function() {
		let thisTextarea = $(this).find("textarea");

		$(this).addClass("a");
		thisTextarea.focus();
	}

	const unFocusTextarea = function() {
		if ( $(this).val() == "" ){
			let thisTextareaBlock = $(this).parents(".error_popup_textarea");
			thisTextareaBlock.removeClass("a");
		}
	}

	errTextareaBlock.click(clickFocusTextarea);
	errTextarea.blur(unFocusTextarea);
});