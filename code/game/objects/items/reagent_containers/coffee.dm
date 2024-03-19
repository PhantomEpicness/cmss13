/obj/item/reagent_container/food/folgerscoffee
	name = "Folger's Classic Roast coffee tin"
	desc = "A tin of Folger's ground coffee. Absolutely souless instant coffee made with the cheapest synthetic coffee man can buy.  Burnt to hell, bitter and acidic no matter how much creamer is put in your cup, with a chemical aftertaste that'll leave you disappointed. Some say it's better than nothing, while others say it is nothing."


	//"To make, add 1u of mixture to a cup, then add 20u of water."
/obj/item/reagent_container/food/coffee_pak
	name = "Generic Coffee Package"
	desc = "A cryostablized, vaccum sealed packet of synthcoffee for use in coffee machines. Seems like a generic synthcoffee brand."

	var/roasting = "medium"
	var/list/roasts = ["light", "medium", "dark"]
	var/rand_roast = TRUE //whether the roasting will randomly be selected
	//The package feels like it has an extremely viscous liquid inside it. Typical for synthcoffee.

/obj/item/reagent_container/food/rand
	name = "Generic Coffee Package"
	desc = "A cryostablized, vaccum sealed packet of synthcoffee for use in coffee machines. Seems like a generic synthcoffee brand."

	rand_roast = TRUE //whether the roasting will randomly be selected
	//The package feels like it has an extremely viscous liquid inside it. Typical for synthcoffee.

/obj/item/reagent_container/food/coffee_pak/wygold
	name = "W-Y Executive Select Brew Packet"
	desc = "A cryostablized, vaccum sealed packet of W-Y Executive Selecte Brew. A coffee grown on hydroponics farms in Ganymede station, this coffee is roasted and then cryostablized at location to maintain maximum taste and quality. Because of this, it offers a robust, one of a kind flavor seen nowhere else which makes this both highly coveted and very expensive . Commonly served in W-Y breakrooms for managment staff. "
	var/roasting = "medium"


/obj/item/reagent_container/food/coffee_pak/lunacoffee
	name = "Luna Coffee Co. Medium Roast Coffee Packet"
	desc = "A cryostablized, vaccum sealed packet of Luna Coffee Co. coffee for use in coffee machines. According to the package it has '25% Real Beans', . A nutty roast with cherry undertones, this coffee is a step above even higher quality synthcoffee. And at a price too. "
	var/roasting = "medium"


/obj/item/reagent_container/food/coffee_pak/wy-nebul
	name = "Lasalle Nebula Roast"
	desc = "A cryostablized, vaccum sealed packet of Lasalle Bionational Nebula Roast coffee for use in coffee machines. Lasalle's coffee is widley known and popular in the rim as rumors state that they haveMuch more popular on the rim then the core systems, it features a slight nutty flavor and smooth, fruity undertones."
	var/roasting = "medium"


/obj/item/reagent_container/food/coffee_pak/armat
	name = "MarineRo"
	desc = "A cryostablized, vaccum sealed packet of W-Y branded Nebula Roast synthcoffee for use in coffee machines. A coffee more popular on the rim then the core systems, it features strong nutty undertones with a light pinch of salt and a slight chemical aftertaste. "
	var/roasting = "dark"



/obj/item/reagent_container/food/coffee_pak/stationroast
	name = "Hyperdyne Station Roast
	desc = "A cryostablized, vaccum sealed packet of Hyperdyne branded station roast synthcoffee for use in coffee machines. A much more lighter roast with a small artificial nutty flavor added to it to simulate real light roasts. Somehow lacks the typical chemical aftertaste of synthcoffee."
	roasting = "light"

