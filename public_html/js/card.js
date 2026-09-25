jQuery(document).ready(function($) {

// Подсчет скидки-----------------------------------
const card = $(".card");
card.each(function(i, e) {
	if ( card.eq(i).hasClass("c_sale") ){
		let thisElem = card.eq(i);

		let numberSale,
			numberPriseActual = Number(thisElem.find(".card_prise p span").text().replace(/\s+/g, '')),
			numberPriseOld = Number(thisElem.find(".card_prise strike span").text().replace(/\s+/g, ''));

			numberSale = ( numberPriseOld - numberPriseActual ) / numberPriseOld * 100;

		thisElem.find(".card_sale_number p span").text(numberSale.toFixed());
	}
});

});