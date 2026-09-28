jQuery(document).ready(function($) {
	// Добавление в корзину--------------------------
	const cardBtn = $(".addcart"),
			cardBgPopup = $(".acp_bg"),
			removecartbtn =$(".removecart"),
			cardAddPopup = $("#add_card_popup");

	const addCard = function(evt) {
		evt.preventDefault();
		cardAddPopup.addClass("a");
	}
	const removecart = function(evt) {
		evt.preventDefault();
		//cardAddPopup.addClass("a");
	}
	const hideCardPopup = function() {
		cardAddPopup.removeClass("a");
	}
	cardBtn.click(addCard);
	removecartbtn.click(removecart);
	cardBgPopup.click(hideCardPopup);
	cardAddPopup.find(".add_card_popup button").click(hideCardPopup);

	// "How to buy" popup -----------------------
	const sipBtn = $(".sip_btn"),
			sipPopup = $("#sale_info_popup"),
			sipBg = $(".sip_bg"),
			sipClose =  $(".sip_close");

	const addSipPopup = function(evt) {
		sipPopup.addClass("a");
		sipBg.css("height", sipPopup.find(".sale_info_popup").outerHeight(true) );
	};

	const hideSipPopup = function() {
		sipPopup.removeClass("a");
	}

	sipBtn.click(addSipPopup);
	sipClose.click(hideSipPopup);
	sipBg.click(hideSipPopup);

	// Авторы на площадке - попап--------------------------
	const authorPopBtn = $(".ap_btn"),
			authorPopup = $("#author_popup"),
			authorBg = $(".ap_bg"),
			authorClose = $(".ap_close");

	const addAuthorPopup = function(evt) {
		evt.preventDefault();
		$("#mob-menu").removeClass("a");
		$(".h_btn_mob-menu").removeClass("a");

		authorPopup.addClass("a");
		authorBg.css("height", authorPopup.find(".author_popup").outerHeight(true));
	}
	const hideAuthorPopup = function() {
		authorPopup.removeClass("a");
	}

	authorPopBtn.click(addAuthorPopup);
	authorBg.click(hideAuthorPopup);
	authorClose.click(hideAuthorPopup);
});