jQuery(document).ready(function($) {
	const btnMobMenu = $(".h_btn_mob-menu"),
			bgMenu = $(".mm_bg"),
			mobMenu = $("#mob-menu");

	const toggleMobMenu = function() {
		btnMobMenu.toggleClass('a');
		mobMenu.toggleClass('a');
	}
	btnMobMenu.click(toggleMobMenu);
	bgMenu.click(toggleMobMenu);

	const btnDopMobMenu = $(".mm_menu li"),
			closeDopMobMenu = $(".mm_menu_dop-menu_close");

	const showDopMobMenu = function(evt) {
		if ( $(this).find(".mm_menu_dop-menu").length > 0 ) {
			evt.preventDefault();

			$(this).find(".mm_menu_dop-menu").addClass("a");
			$("#mob-menu").addClass("zi100");
			$(this).unbind("click", showDopMobMenu);
		}
	}
	btnDopMobMenu.click(showDopMobMenu);

	const hideDopMobMenu = function() {
		$(this).parent(".mm_menu_dop-menu").removeClass("a");
		$("#mob-menu").removeClass("zi100");
		setTimeout(function() {
			btnDopMobMenu.click(showDopMobMenu);
		}, 10);
	}
	closeDopMobMenu.click(hideDopMobMenu);
});	