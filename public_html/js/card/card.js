jQuery(document).ready(function($) {
	$(".good_slider").slick({
		infinite: true,
		slidesToShow: 1,
		slidesToScroll: 1,
		prevArrow: $(".good_slider_arrow.prev"),
		nextArrow: $(".good_slider_arrow.next"),
		adaptiveHeight: true,
		asNavFor: '.good_dots_slider'
	});

	$(".good_dots_slider").slick({
		infinite: true,
		slidesToShow: 4,
		slidesToScroll: 1,
		centerMode: false,
		asNavFor: '.good_slider',
		focusOnSelect: true,
		arrows: false,
		variableWidth: true,
		useTransform: false,
		responsive: [
			{
				breakpoint: 1000,
				settings: {
					slidesToShow: 3,
				}
			},
			{
				breakpoint: 800,
				settings: {
					slidesToShow: 5,
				}
			},
			{
				breakpoint: 500,
				settings: {
					slidesToShow: 4,
				}
			},
		]
	});

	if ( ($(".good_dots_slider").outerWidth(true) / $(".good_dots_slide").eq(0).outerWidth(true)) >= $(".good_dots_slide").length ) {
		$(".good_dots_slider").addClass("track_trf_none");
	}
	else{
		$(".good_dots_slider").removeClass("track_trf_none");
	}
});