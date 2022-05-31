// Praetorian Neurotoxin grenade.
/obj/item/explosive/grenade/xeno
	name = "Xeno grenade"
	icon_state = "neuro_nade_greyscale"
	item_state = "neuro_nade_greyscale"
	var/smoke_duration = 5 SECONDS
	var/hivedata = XENO_HIVE_NORMAL // fallback
	// doing all this retarded shit because cause_data is a bitch
	var/mob/living/carbon/Xenomorph/thrower
	var/xenotype
	rebounds = FALSE

/obj/item/explosive/grenade/xeno/xeno_acid_grenade
	name = "acid ball"
	desc = "A small, pulsating ball of gas."
	icon_state = "neuro_nade"
	det_time = 30
	item_state = "neuro_nade"

	var/shrapnel_count = 14
	var/shrapnel_type = /datum/ammo/xeno/acid/prae_nade

/obj/item/explosive/grenade/xeno/xeno_acid_grenade/prime()
	create_shrapnel(loc, shrapnel_count, , ,shrapnel_type, cause_data)
	qdel(src)
	..()
// Splasher boiler glob
// Splashes acid in a radius and melts cades in a radius aswell
/obj/item/explosive/grenade/xeno/splasher_acid_glob
	name = "acid ball"
	desc = "A bulging, pulsating ball of gas."
	icon_state = "neuro_nade"
	item_state = "neuro_nade"
	det_time = 45
	color = COLOR_GREEN
	// you got beamed with a fat fucking ball of acid, rip
	throwforce = 30

	var/shrapnel_count = 20
	var/shrapnel_type = /datum/ammo/xeno/acid/acidsplash
	//var/spray_type = /obj/effect/xenomorph/spray
	var/range = 3

/obj/item/explosive/grenade/xeno/splasher_acid_glob/prime()
	create_shrapnel(loc, shrapnel_count, , ,shrapnel_type, cause_data)
	//new spray_type(loc, cause_data, hivenumber)
	var/datum/automata_cell/acid/boiler/E = new /datum/automata_cell/acid/boiler(get_turf(loc))
	E.source = initial(name)
	E.range = range
	E.hivenumber = hivedata
	// something went wrong :(
	if(QDELETED(E))
		return

/obj/item/explosive/grenade/xeno/base_gas_glob
	name = "acid ball"
	desc = "A bulging, pulsating ball of gas."
	det_time = 5 SECONDS
	color = COLOR_GREEN
	// you got beamed with a fat fucking ball of acid, rip
	throwforce = 30
	//var/spray_type = /obj/effect/xenomorph/spray
	var/range = 5
	var/datum/effect_system/smoke_spread/xeno_acid/smoke
	//var/hivenumber = XENO_HIVE_NORMAL
	// trapper warning below

	//for(var/turf/T in orange(range, loc)/*range(range,loc)*/)
	//	var/obj/effect/xenomorph/spray/SP = new spray_type(T, cause_data,hivenumber)
	//	new /obj/effect/xenomorph/acid_damage_delay(T, damage, 7, TRUE, "You are blasted with a stream of high-velocity acid!")
	//	for(var/mob/living/carbon/H in T)
	//		SP.apply_spray(H)

/obj/item/explosive/grenade/xeno/base_gas_glob/Initialize()
	..()
	smoke = new /datum/effect_system/smoke_spread/xeno_acid
	smoke.attach(src)

/obj/item/explosive/grenade/xeno/base_gas_glob/prime(range,smoke_duration, cause_data, thrower,xenotype, hivenumber)
	var/datum/cause_data/cause = create_cause_data(initial(xenotype), thrower)
	playsound(src.loc, 'sound/effects/smoke.ogg', 25, 1, 4)
	smoke.set_up(range, 0, get_turf(src), TRUE , smoke_duration, cause)
	smoke.start()
	qdel(src)


/obj/item/explosive/grenade/xeno/base_gas_glob/neuro
	name = "acid ball"
	desc = "A bulging, pulsating ball of gas."
	icon_state = "neuro_nade_greyscale"
	item_state = "neuro_nade_greyscale"
	det_time = 5 SECONDS
	color = COLOR_ORANGE
	// you got beamed with a fat fucking ball of acid, rip
	throwforce = 30
	//var/spray_type = /obj/effect/xenomorph/spray
	range = 5
	smoke_duration = 5 SECONDS
	smoke = /datum/effect_system/smoke_spread/xeno_weaken
	//var/hivenumber = XENO_HIVE_NORMAL
	// trapper warning below


/obj/item/explosive/grenade/splasher_slime_glob
	name = "slime ball"
	desc = "A bulging, pulsating ball of slime."
	icon_state = "neuro_nade"
	item_state = "neuro_nade"
	// you got beamed with a fat fucking ball of acid, rip
	throwforce = 30
	color = COLOR_PINK

	rebounds = FALSE
	var/shrapnel_count = 1
	var/shrapnel_type = /datum/ammo/xeno/toxin
	var/range = 1
	var/hivenumber = XENO_HIVE_NORMAL

/obj/item/explosive/grenade/splasher_slime_glob/prime()
	create_shrapnel(loc, shrapnel_count, , ,shrapnel_type, cause_data)
	var/datum/automata_cell/acid/slime/E = new /datum/automata_cell/acid/slime(get_turf(loc))
	E.source = initial(name)
	E.range = range
	E.hivenumber = hivenumber
	// something went wrong :(
	if(QDELETED(E))
		return



	playsound(loc, 'sound/effects/blobattack.ogg', 25, 1)
	qdel(src)
	..()
