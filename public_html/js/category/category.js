jQuery(document).ready(function($) {
	const checkFilterHead = $(".category_head");

	const changeHeightFilter = function() {
		let thisFilterBlock = $(this).parent(".category_block"),
			thisFilterContentHeight = 0;

		let thisArrow = $(this).find("span");

		setTimeout(function() {
			thisFilterContentHeight = thisFilterBlock.find(".c_f_checkbox").outerHeight(true) + thisFilterBlock.find(".c_f_btn_show").outerHeight(true);

			if ( thisFilterBlock.find(".category_filter_wrap").outerHeight(true) == 0 ){
				thisFilterBlock.find(".category_filter_wrap").css( "height", thisFilterContentHeight );
				thisArrow.addClass("a");
			}
			else{
				thisFilterBlock.find(".category_filter_wrap").css( "height", 0 );
				thisArrow.removeClass("a");
			}
		}, 20);
	}

	checkFilterHead.click(changeHeightFilter);
	checkFilterHead.eq(0).click();
	checkFilterHead.eq(1).click();
	checkFilterHead.eq(2).click();

	const btnShowCheck = $(".c_f_btn_show");

	const showCheck = function(evt) {
		evt.preventDefault();
		let thisHiddenCheck = $(this).parents(".category_block").find(".c_f_checkbox li");

		thisHiddenCheck.each(function(i, e) {
			thisHiddenCheck.eq(i).removeClass("hidden");
		});

		$(this).parents(".category_block").find(".category_filter_wrap").css( "height", $(this).parents(".category_block").find(".c_f_checkbox").outerHeight(true) );
		
		$(this).remove();
	}
	btnShowCheck.click(showCheck);

	// Мобильное скрытие блоков----------

	const mBtnCategory = $(".c_f_m-btn_category"),
			mBtnFilter = $(".c_f_m-btn_filter");

	const filterBlock = $(".category_block"),
			categoryBlock1 = $("#category_list_box1");
			categoryBlock2 = $("#category_list_box2");

	const toggleShowCategory = function() {
		if ( categoryBlock1.height() == 0 ) {
			categoryBlock1.css("height", "auto");
		}
		else{
			categoryBlock1.css("height", "0");
		}
		if ( categoryBlock2.height() == 0 ) {
			categoryBlock2.css("height", "auto");
		}
		else{
			categoryBlock2.css("height", "0");
		}
	}
	mBtnCategory.click(toggleShowCategory);

	const toggleShowFilter = function() {
		filterBlock.toggleClass("none");

		if ( !filterBlock.eq(0).hasClass("none") ) {
			filterBlock.eq(0).find(".category_head").click();
			filterBlock.eq(1).find(".category_head").click();
			filterBlock.eq(2).find(".category_head").click();
		}
		else{
			filterBlock.eq(0).find(".category_head").click();
			filterBlock.eq(1).find(".category_head").click();
			filterBlock.eq(2).find(".category_head").click();
		}
	}
	mBtnFilter.click(toggleShowFilter);

	if ( $(window).width() < 1000 ) {
		toggleShowFilter();
	}
});