#define QUEEN_OVIPOSITOR_DECAY_TIME 500
#define OVI_AUTOPLANT_RANGE 7
/obj/ovipositor
	name = "Egg Sac"
	icon_state = "ovipositor"
	unacidable = TRUE
	var/begin_decay_time = 0
	health = 50
	var/decay_ready = 0
	var/decayed = 0		// This is here so later on we can use the ovpositor molt for research. ~BMC777
	var/destroyed = 0
	var/queen_mounted
	var/stored_eggs
	var/hivenumber
	var/autoplant = TRUE

/obj/ovipositor/Initialize(mapload, ...)
	. = ..()
	icon = get_icon_from_source(CONFIG_GET(string/alien_queen_ovipositor))
	begin_decay_time = world.timeofday + QUEEN_OVIPOSITOR_DECAY_TIME
	process_decay()

/obj/ovipositor/proc/create_egg(loc,hivenumber, var/mob/living/carbon/Xenomorph/Queen)
	var/obj/effect/alien/egg/Egg
	if(!Queen.check_state())
		return
	stored_eggs ++
	if(autoplant)
		autoplant()
	else
	new /obj/item/xeno_egg(loc, hivenumber)

/obj/ovipositor/proc/autoplant()
	for(var/turf/Turf in range(OVI_AUTOPLANT_RANGE, src.loc) )
	if(!X.check_state())
		return FALSE

	if(isstorage(A.loc) || X.contains(A) || istype(A, /atom/movable/screen)) return FALSE

	//Make sure construction is unrestricted
	if(X.hive && X.hive.construction_allowed == XENO_LEADER && X.hive_pos == NORMAL_XENO)
		to_chat(X, SPAN_WARNING("Construction is currently restricted to Leaders only!"))
		return FALSE
	else if(X.hive && X.hive.construction_allowed == XENO_QUEEN && !istype(X.caste, /datum/caste_datum/queen))
		to_chat(X, SPAN_WARNING("Construction is currently restricted to Queen only!"))
		return FALSE

	var/turf/T = get_turf(A)

	var/area/AR = get_area(T)
	if(isnull(AR) || !(AR.is_resin_allowed))
		to_chat(X, SPAN_XENOWARNING("It's too early to spread the hive this far."))
		return FALSE

	if(T.z != X.z)
		to_chat(X, SPAN_XENOWARNING("This area is too far away to affect!"))
		return FALSE

	if(GLOB.interior_manager.interior_z == X.z)
		to_chat(X, SPAN_XENOWARNING("It's too tight in here to build."))
		return FALSE

	if(!spacecheck(X,T,structure_template))
		return FALSE

	if(!do_after(X, XENO_STRUCTURE_BUILD_TIME, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return FALSE

	if(!spacecheck(X,T,structure_template)) //doublechecking
		return FALSE

/obj/ovipositor/proc/process_decay()
	set background = 1

	spawn while (!decayed && !destroyed)
		if (world.timeofday > begin_decay_time)
			decayed = 1
			do_decay()

		if (health < 0)
			destroyed = 1
			explode()

		sleep(10)	// Process every second.

/obj/ovipositor/proc/do_decay()
	icon_state = "ovipositor_molted"
	flick("ovipositor_decay", src)
	sleep(15)

	var/turf/T = get_turf(src)
	if (T)
		T.overlays += image(get_icon_from_source(CONFIG_GET(string/alien_queen_ovipositor)), "ovipositor_molted", ATMOS_DEVICE_LAYER) //ATMOS_DEVICE_LAYER so that the ovi is above weeds, blood, and resin weed nodes.

	qdel(src)

/obj/ovipositor/proc/explode()
	icon_state = "ovipositor_gibbed"
	flick("ovipositor_explosion", src)
	sleep(15)

	var/turf/T = get_turf(src)
	if (T)
		T.overlays += image(get_icon_from_source(CONFIG_GET(string/alien_queen_ovipositor)), "ovipositor_gibbed", ATMOS_DEVICE_LAYER)

	qdel(src)

/obj/ovipositor/ex_act(severity)
	health -= severity/4

//Every other type of nonhuman mob
/obj/ovipositor/attack_alien(mob/living/carbon/Xenomorph/M)
	switch(M.a_intent)
		if(INTENT_HELP)
			M.visible_message(SPAN_NOTICE("\The [M] caresses [src] with its claws."), \
			SPAN_NOTICE("You caress [src] with your claws."))

		if(INTENT_GRAB)
			if(M == src || anchored)
				return XENO_NO_DELAY_ACTION

			if(Adjacent(M)) //Logic!
				M.start_pulling(src)

		else
			M.animation_attack_on(src)
			var/damage = (rand(M.melee_damage_lower, M.melee_damage_upper) + 3)
			M.visible_message(SPAN_DANGER("\The [M] bites [src]!"), \
			SPAN_DANGER("You bite [src]!"))
			health -= damage

	return XENO_ATTACK_ACTION

/obj/ovipositor/attack_larva(mob/living/carbon/Xenomorph/Larva/M)
	M.visible_message(SPAN_DANGER("[M] nudges its head against [src]."), \
	SPAN_DANGER("You nudge your head against [src]."))

// Density override
/obj/ovipositor/get_projectile_hit_boolean(obj/item/projectile/P)
	return TRUE

/obj/ovipositor/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	return 1
