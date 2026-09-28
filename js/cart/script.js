jQuery(document).ready(function($) {



	// ----------------------------------

	const totalInputBlock = $(".c_tl_promocode_input");

	const focusInputTotal = function() {
		$(this).parents(".c_tl_promocode_input").addClass("a");
	}

	const clickFocusInputTotal = function() {
		let thisInput = $(this).find("input"),	
			thisText = $(this).find("span");

		$(this).addClass("a");
		thisInput.focus();
	}

	const unFocusInputTotal = function() {
		if ( $(this).val() == "" ){
			let thisInputBlock = $(this).parents(".c_tl_promocode_input");
			thisInputBlock.removeClass("a");
		}
	}

	totalInputBlock.click(clickFocusInputTotal);
	totalInputBlock.find("input").focus(focusInputTotal);
	totalInputBlock.find("input").blur(unFocusInputTotal);

	// ----------------------------------------

	if ( $(window).width() > 770 ) {
		const totalBlock = $(".cart_total_block"),
				totalBox = $(".cart_total_box");

		const totalTop = totalBlock.offset().top;

		$(window).scroll(function() {
			if ( totalBox.offset().top < $(window).scrollTop() ) {
				totalBlock.css("top", ( $(window).scrollTop() - totalTop + 20 ) );
				if ( $(".cart_box").outerHeight(true) - totalBlock.outerHeight(true) <= ( $(window).scrollTop() - totalTop + 20 ) ) {
					totalBlock.css("top", ( $(".cart_box").outerHeight(true) - totalBlock.outerHeight(true) ) );
				}
			}
			else{
				totalBlock.css("top", 0)
			}
		});
	}
});