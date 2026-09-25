jQuery(document).ready(function($) {
	$(".popular_slider").slick({
		infinite: true,
		slidesToShow: 4,
		slidesToScroll: 1,
		prevArrow: $(".popular_arrow_box .prev"),
		nextArrow: $(".popular_arrow_box .next"),
		responsive: [
			{
				breakpoint: 770,
				settings: {
					slidesToShow: 3,
				}
			},
			{
				breakpoint: 700,
				settings: {
					slidesToShow: 2,
				}
			},
		]
	});

	$(window).scroll(function() {
		if ( $(this).scrollTop() > 5 ) {
			$("#header").removeClass("bg_transparent");
		}
		else{
			$("#header").addClass("bg_transparent");
		}
	});
});