

///***MINES***///
//Mines have an invisible "tripwire" atom that explodes when crossed
//Stepping directly on the mine will also blow it up
/obj/item/explosive/mine
	name = "\improper M20 Claymore anti-personnel mine"
	desc = "The M20 Claymore is a directional proximity-triggered anti-personnel mine designed by Armat Systems for use by the United States Colonial Marines. The mine is triggered by movement both on the mine itself, and on the space immediately in front of it. Detonation sprays shrapnel forwards in a 120-degree cone. The words \"FRONT TOWARD ENEMY\" are embossed on the front."
	icon = 'icons/obj/items/weapons/grenade.dmi'
	icon_state = "m20"
	force = 5.0
	w_class = SIZE_SMALL
	//layer = MOB_LAYER - 0.1 //You can't just randomly hide claymores under boxes. Booby-trapping bodies is fine though
	throwforce = 5.0
	throw_range = 6
	throw_speed = SPEED_VERY_FAST
	unacidable = TRUE
	flags_atom = FPRINT|CONDUCT
	allowed_sensors = list(/obj/item/device/assembly/prox_sensor)
	max_container_volume = 120
	reaction_limits = list(	"max_ex_power" = 105,	"base_ex_falloff" = 60,	"max_ex_shards" = 32,
							"max_fire_rad" = 5,		"max_fire_int" = 12,	"max_fire_dur" = 18,
							"min_fire_rad" = 2,		"min_fire_int" = 3,		"min_fire_dur" = 3
	)
	angle = 60
	var/shrapnel_count = 12
	var/explosive_power = 60
	use_dir = TRUE
	var/iff_signal = FACTION_MARINE
	var/triggered = FALSE
	var/hard_iff_lock = FALSE
	var/obj/effect/mine_tripwire/tripwire
	var/direct_trip_only = FALSE
	var/needs_digging = FALSE
	var/map_deployed = FALSE
	var/buried = FALSE
	var/arming_time = FALSE
	var/heavy_trigger = FALSE

/obj/item/explosive/mine/examine(mob/user)
	..()
	if(buried)
		to_chat(user, SPAN_NOTICE("\nThis mine is armed."))
	if(heavy_trigger)
		to_chat(user, SPAN_NOTICE("\n It has a heavy trigger."))

/obj/item/explosive/mine/Initialize()
	. = ..()
	if(map_deployed)
		deploy_mine(null)

/obj/item/explosive/mine/Destroy()
	QDEL_NULL(tripwire)
	. = ..()

/obj/item/explosive/mine/ex_act()
	prime() //We don't care about how strong the explosion was.

/obj/item/explosive/mine/emp_act()
	prime() //Same here. Don't care about the effect strength.


//checks for things that would prevent us from placing the mine.
/obj/item/explosive/mine/proc/check_for_obstacles(mob/living/user)
	if(locate(/obj/item/explosive/mine) in get_turf(src))
		to_chat(user, SPAN_WARNING("There already is a mine at this position!"))
		return TRUE
	if(user.loc && (user.loc.density || locate(/obj/structure/fence) in user.loc))
		to_chat(user, SPAN_WARNING("You can't plant a mine here."))
		return TRUE
	if(user.z == GLOB.interior_manager.interior_z)
		to_chat(user, SPAN_WARNING("It's too cramped in here to deploy \a [src]."))
		return TRUE



//Arming
/obj/item/explosive/mine/attack_self(mob/living/user)
	if(!..())
		return
	if(needs_digging && user.loc && (user.loc.density)) //  || is_mainship_level(user.z)
		to_chat(user, SPAN_WARNING("You can't plant a mine here."))
		return
	if(check_for_obstacles(user))
		return

	if(active || user.action_busy)
		return

	user.visible_message(SPAN_NOTICE("[user] starts deploying [src]."), \
		SPAN_NOTICE("You start deploying [src]."))
	playsound(loc, 'sound/machines/click.ogg', 25, 1)
	if(!do_after(user, 40, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		user.visible_message(SPAN_NOTICE("[user] stops deploying [src]."), \
			SPAN_NOTICE("You stop deploying \the [src]."))
		return

	if(active)
		return

	if(check_for_obstacles(user))
		return
	user.visible_message(SPAN_NOTICE("[user] finishes deploying [src]."), \
		SPAN_NOTICE("You finish deploying [src]."))
	if(needs_digging)
		playsound(loc, 'sound/weapons/flipblade.ogg', 25, 1)
		user.visible_message(SPAN_NOTICE("[user] pulls the pin on \the [src]."), \
			SPAN_NOTICE("You pull the activation pin and prepare it to be buried."))
		user.drop_inv_item_on_ground(src)
		anchored = TRUE
		return
	deploy_mine(user)

/obj/item/explosive/mine/proc/deploy_mine(var/mob/user)
	if(!hard_iff_lock && user)
		iff_signal = user.faction
	cause_data = create_cause_data(initial(name), user)
	anchored = TRUE
	playsound(loc, 'sound/weapons/mine_armed.ogg', 25, 1)
	if(user && !buried)
		user.drop_inv_item_on_ground(src)
		setDir(user ? user.dir : dir) //The direction it is planted in is the direction the user faces at that time
	activate_sensors()
	if(buried)
		update_icon()


//Disarming
/obj/item/explosive/mine/attackby(obj/item/W, mob/user)
	if(needs_digging && istype(W, /obj/item/tool/shovel) && !active && anchored)
		user.visible_message(SPAN_NOTICE("[user] starts burying \the [src]."), \
			SPAN_NOTICE("You start burying \the [src]."))
		playsound(user.loc, 'sound/effects/thud.ogg', 40, 1, 6)
		if(!do_after(user, 30, INTERRUPT_NO_NEEDHAND, BUSY_ICON_BUILD))
			user.visible_message(SPAN_WARNING("[user] stops burying \the [src]."), \
			SPAN_WARNING("You stop burying [src]."))

		user.visible_message(SPAN_NOTICE("[user] finished burying \the [src]."), \
		SPAN_NOTICE("You finish burying \the [src]."))
		buried = TRUE
		addtimer(CALLBACK(src, .proc/deploy_mine, user), arming_time)
	if(HAS_TRAIT(W, TRAIT_TOOL_MULTITOOL))
		if(active)
			if(user.action_busy)
				return
			if(user.faction == iff_signal)
				user.visible_message(SPAN_NOTICE("[user] starts disarming [src]."), \
				SPAN_NOTICE("You start disarming [src]."))
			else
				user.visible_message(SPAN_NOTICE("[user] starts fiddling with \the [src], trying to disarm it."), \
				SPAN_NOTICE("You start disarming [src], but you don't know its IFF data. This might end badly..."))
			if(!do_after(user, 30, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY))
				user.visible_message(SPAN_WARNING("[user] stops disarming [src]."), \
					SPAN_WARNING("You stop disarming [src]."))
				return
			if(user.faction != iff_signal) //ow!
				if(prob(75))
					triggered = TRUE
					if(tripwire)
						var/direction = reverse_dir[src.dir]
						var/step_direction = get_step(src, direction)
						tripwire.forceMove(step_direction)
					prime()
			if(!active)//someone beat us to it
				return
			user.visible_message(SPAN_NOTICE("[user] finishes disarming [src]."), \
			SPAN_NOTICE("You finish disarming [src]."))
			disarm()

	else
		return ..()

/obj/item/explosive/mine/proc/disarm()
	if(customizable)
		activate_sensors()
	anchored = FALSE
	active = FALSE
	triggered = FALSE
	update_icon()
	QDEL_NULL(tripwire)

/obj/item/explosive/mine/activate_sensors()
	if(active)
		return

	if(!customizable)
		set_tripwire()
		return;

	if(!detonator)
		active = TRUE
		return

	if(customizable && assembly_stage == ASSEMBLY_LOCKED)
		if(isigniter(detonator.a_right) && isigniter(detonator.a_left))
			set_tripwire()
			return
		else
			..()
			use_dir = FALSE // Claymore defaults to radial in these case. Poor man C4
			triggered = TRUE // Delegating the tripwire/crossed function to the sensor.


/obj/item/explosive/mine/proc/set_tripwire()
	if(direct_trip_only)
		active = TRUE
		return
	if(!active && !tripwire)
		var/tripwire_loc = get_turf(get_step(loc, dir))
		tripwire = new(tripwire_loc)
		tripwire.linked_claymore = src
		active = TRUE


//Mine can also be triggered if you "cross right in front of it" (same tile)
/obj/item/explosive/mine/Crossed(atom/A)
	..()
	if(isliving(A))
		var/mob/living/L = A
		if(heavy_trigger && buried)
			L.visible_message(SPAN_DANGER("[icon2html(src, viewers(src))] The [name] clicks as [L] moves in front of it."), \
			SPAN_DANGER("[icon2html(src, L)] The [name] clicks as you move in front of it."), \
			SPAN_DANGER("You hear a click."))
			playsound(loc, 'sound/weapons/flipblade.ogg', 35, 1)
		if(!L.stat == DEAD)//so dragged corpses don't trigger mines.
			return
		else
			try_to_prime(A)

/obj/item/explosive/mine/Collided(atom/movable/AM)
	try_to_prime(AM)


/obj/item/explosive/mine/proc/try_to_prime(mob/living/L)
	if(!active || triggered || (customizable && !detonator))
		return
	if(!istype(L))
		return
	if(L.stat == DEAD)
		return
	if(L.get_target_lock(iff_signal) || isrobot(L))
		return
	if(heavy_trigger)
		if(isXeno(L))
			var/mob/living/carbon/Xenomorph/X = L
			if(X.tier < 2)
				return
		if(prob(75) && ishuman(L))
			var/mob/living/carbon/human/H = L
			if(!H.wear_suit)
				return
			if(H.wear_suit.slowdown < SLOWDOWN_ARMOR_MEDIUM) // "Nice hustle, 'tons-a-fun'! Next time, eat a salad!"
				return
	L.visible_message(SPAN_DANGER("[icon2html(src, viewers(src))] The [name] clicks as [L] moves in front of it."), \
	SPAN_DANGER("[icon2html(src, L)] The [name] clicks as you move in front of it."), \
	SPAN_DANGER("You hear a click."))

	triggered = TRUE
	playsound(loc, 'sound/weapons/mine_tripped.ogg', 25, 1)
	prime()



//Note : May not be actual explosion depending on linked method
/obj/item/explosive/mine/prime()
	set waitfor = 0

	if(!customizable)
		create_shrapnel(loc, 12, dir, angle, , cause_data)
		sleep(2) //so that shrapnel has time to hit mobs before they are knocked over by the explosion
		cell_explosion(loc, explosive_power, 20, EXPLOSION_FALLOFF_SHAPE_LINEAR, dir, cause_data)
		qdel(src)
	else
		. = ..()
		if(!QDELETED(src))
			disarm()


/obj/item/explosive/mine/attack_alien(mob/living/carbon/Xenomorph/M)
	if(triggered) //Mine is already set to go off
		return XENO_NO_DELAY_ACTION

	if(M.a_intent == INTENT_HELP)
		to_chat(M, SPAN_XENONOTICE("If you hit this hard enough, it would probably explode."))
		return XENO_NO_DELAY_ACTION

	M.animation_attack_on(src)
	M.visible_message(SPAN_DANGER("[M] has slashed [src]!"), \
		SPAN_DANGER("You slash [src]!"))
	playsound(loc, 'sound/weapons/slice.ogg', 25, 1)

	//We move the tripwire randomly in either of the four cardinal directions
	triggered = TRUE
	if(tripwire)
		var/direction = pick(cardinal)
		var/step_direction = get_step(src, direction)
		tripwire.forceMove(step_direction)
	prime()
	if(!QDELETED(src))
		disarm()
	return XENO_ATTACK_ACTION

/obj/item/explosive/mine/flamer_fire_act(damage, flame_cause_data) //adding mine explosions
	cause_data = flame_cause_data
	prime()
	if(!QDELETED(src))
		disarm()


/obj/effect/mine_tripwire
	name = "claymore tripwire"
	anchored = TRUE
	mouse_opacity = 0
	invisibility = 101
	unacidable = TRUE //You never know
	var/obj/item/explosive/mine/linked_claymore

/obj/effect/mine_tripwire/Destroy()
	if(linked_claymore)
		linked_claymore = null
	. = ..()

//immune to explosions.
/obj/effect/mine_tripwire/ex_act(severity)
	return

/obj/effect/mine_tripwire/Crossed(atom/movable/AM)
	if(!linked_claymore)
		qdel(src)
		return

	if(linked_claymore.triggered) //Mine is already set to go off
		return

	if(linked_claymore)
		linked_claymore.try_to_prime(AM)

/obj/item/explosive/mine/active
	icon_state = "m20_active"
	base_icon_state = "m20"
	map_deployed = TRUE

/obj/item/explosive/mine/bury
	direct_trip_only = TRUE
	needs_digging = TRUE
	map_deployed = FALSE
	buried = FALSE
	arming_time = 3 SECONDS
	use_dir = FALSE
	unacidable = TRUE
	var/datum/effect_system/spark_spread/sparks = new

/obj/item/explosive/mine/bury/examine(mob/user)
	. = ..()
	if(!buried)
		to_chat(user, SPAN_NOTICE("\n Deployment is easy, simply pull the pin to activate it and dig it in with your standard issue e-tool."))
	else
		to_chat(user, SPAN_NOTICE("\n This unit is armed and ready"))

/obj/item/explosive/mine/bury/Initialize(mapload, ...)
	. = ..()
	sparks.set_up(5, 0, src)
	sparks.attach(src)

/obj/item/explosive/mine/bury/antitank
	name = "\improper M19 Anti-Tank Mine"
	desc = "This older anti tank mine from the 21st century was rolled back into service simply due to the currently-used M307 EMP anti tank mines being too overkill for the minimally armored vehicles commonly used by CLF. Featuring a 250 pound minimum detonation threshold, it can be employed against all but the lightest of vehicles. Despite being outdated, it can still pack a punch against APCs and lighter vehicles, while its plastic construction prevents detection by simple methods."
	icon_state = "antitank_mine"
	w_class = SIZE_LARGE
	//layer = MOB_LAYER - 0.1 //You can't just randomly hide claymores under boxes. Booby-trapping bodies is fine though
	allowed_sensors = list(/obj/item/device/assembly/prox_sensor)
	max_container_volume = 120
	reaction_limits = list(	"max_ex_power" = 105,	"base_ex_falloff" = 60,	"max_ex_shards" = 32,
							"max_fire_rad" = 5,		"max_fire_int" = 12,	"max_fire_dur" = 18,
							"min_fire_rad" = 2,		"min_fire_int" = 3,		"min_fire_dur" = 3
	)
	explosive_power = 200
	heavy_trigger = TRUE

/obj/item/explosive/mine/bury/antitank/prime()
	set waitfor = 0
	create_shrapnel(loc, shrapnel_count, , ,/datum/ammo/bullet/shrapnel, cause_data)
	sleep(2) //so that shrapnel has time to hit mobs before they are knocked over by the explosion
	cell_explosion(loc, explosive_power, 25, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL_HALF, dir, cause_data)
	for(var/mob/living/carbon/M in oview(1, src))
		M.AdjustStunned(4)
		M.KnockDown(4)
		to_chat(M, SPAN_HIGHDANGER("Molten copper rips through your lower body!"))
		M.apply_damage(50,BURN)
		if(ishuman(M))
			sparks.start()
			var/mob/living/carbon/human/H = M
			var/obj/limb/L = H.get_limb("l_leg")
			var/obj/limb/R = H.get_limb("r_leg")
			R.droplimb()
			L.droplimb()
			playsound(M.loc, "bone_break", 45, TRUE)
			playsound(M.loc, "bone_break", 45, TRUE)
	for(var/mob/living/carbon/M in view())
		if(M && M.client)
			shake_camera(M, 10, 1)
	qdel(src)
	if(!QDELETED(src))
		disarm()


/obj/item/explosive/mine/bury/cluster
	name = "\improper M307 \"Platoon Wiper\" Cluster Mine"
	desc = "A rather cumbersome, but extremely deadly anti-personal mine. Upon triggering, it launches up to 6 mini grenades up in the air, which spread around before obliterating the area. It's large area of effect has been known to wipe out entire squads of enemy combatants, making it a weapon that is truly feared. Due to high demand, numbers of these are limited, especially for low priority units on the rim."
	icon = 'icons/obj/items/weapons/grenade.dmi'
	icon_state = "antitank_mine"
	w_class = SIZE_LARGE
	var/list/nade_amount[8]

/obj/item/explosive/mine/bury/cluster/prime()  // I spent way too much time on this
	set waitfor = 0
	var/list/dirlist[]
	if(nade_amount.len <= 4)
		dirlist = cardinal
	else
		dirlist = alldirs
	sparks.start()
	for(var/i=1, i < nade_amount, ++i)
		to_chat_immediate(world,"A")
		nade_amount[i] = new /obj/item/explosive/grenade/HE/micro/cluster(src.loc)
		var/throw_dir = get_ranged_target_turf(nade_amount[i],dirlist[i],2) // diff dir every time
		step(nade_amount[i], throw_dir,5)

	sleep(5) // wait for nades to catch up
	cell_explosion(loc, explosive_power, 25, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL_HALF, dir, cause_data) //Spread em out a lil
	qdel(src)
	if(!QDELETED(src))
		disarm()

/obj/item/explosive/grenade/HE/micro
	name = "\improper M43 HEDP grenade"
	desc = "An almost cute, if not deadly half-sized version of the M40 HEDP grenade meant to be used in close quarters enviorments and in cluster mutions. Despite only being designated for these purposes, they still show up at the frontline every now and then due to being mistaken with it's bigger brother, the M40."
	icon_state = "grenade_micro"
	item_state = "grenade_micro"
	force = 10
	det_time = 30
	w_class = SIZE_SMALL
	throwforce = 15
	throw_speed = SPEED_FAST
	throw_range = 10
	dangerous = 1
	underslug_launchable = TRUE
	explosion_power = 60
	shrapnel_count = 3
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_LINEAR

/obj/item/explosive/grenade/HE/micro/cluster
	name = "\improper M43 cluster munition"
	desc = "Aww what cute lil grenad- Oh shit it's angry!"
	det_time = 2 SECONDS

/obj/item/explosive/grenade/HE/micro/cluster/New()
	..()
	if(!cause_data)
		cause_data = create_cause_data("M43 Cluster Munition") // cause data bitching runtime moment
	var/temploc = get_turf(src)
	//scatter in all directions
	walk_away(src,temploc,rand(1,2))
	addtimer(CALLBACK(src, .proc/activate), rand(10,20))

/obj/item/explosive/mine/pmc
	name = "\improper M20P Claymore anti-personnel mine"
	desc = "The M20P Claymore is a directional proximity triggered anti-personnel mine designed by Armat Systems for use by the United States Colonial Marines. It has been modified for use by the Wey-Yu PMC forces."
	icon_state = "m20p"
	iff_signal = FACTION_PMC
	hard_iff_lock = TRUE

/obj/item/explosive/mine/pmc/active
	icon_state = "m20p_active"
	base_icon_state = "m20p"
	map_deployed = TRUE

/obj/item/explosive/mine/custom
	name = "Custom mine"
	desc = "A custom chemical mine built from an M20 casing."
	icon_state = "m20_custom"
	customizable = TRUE
	matter = list("metal" = 3750)
	has_blast_wave_dampener = TRUE
