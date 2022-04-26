/*
todos
- proper logging for admemes

- Create makeshift detonator

- makeshift detonator crafting recipe

- add in a way to disarm because non seems to exist

- add deadchecks

- cause death funnies

- finish pickup()

- show # of charges in examine on the detonator

Bugs:


why the fuck does the detonator just trigger on click
	- clicked() is a retarded method, messes with things like examining and probably causes above
	- make it unique action

0 checks to see if the explosives are ready to activate

0 checks to see if detonator is already added
	- Doesn't remove last detonator from the list, breaking the last one

recently unlinked charges being able to armed and thrown
	cannot relink charges (related)

can arm it multiple times in a row
	- add arm var check to arming

zero explosions

some possible other improvements/creative freedoms
	- Make so detonators can link and detonate other explosives such as C4

	- base it around hl2 SLAMS? ( mountable on walls with laser tripwire, arming time, directional explosives while in tripwire mode, harder sprite to do but cooler)

















*/

/obj/item/satchel_charge_detonator
	name = "M38-D Multipurpose Detonator"
	desc = "An ergonomic detonator capable of detonating multiple types of command explosives, notable being satchel charges, detcords and plastic explosives."
	icon = 'icons/obj/items/assemblies.dmi'
	icon_state = "valve_1" // PLACEHOLDER

	var/list/linked_charges = list()
	// list of linked explosives to handle

/obj/item/satchel_charge_detonator/attack_self(mob/user, parameters) // when attackl_self, detonate charges
	. = ..()
	flick("detonator_pressed", src)
	var/detonation_count = 0
	for(var/obj/item/explosive/satchel_charge/SC in linked_charges)
		if(SC.z != src.loc.z)
			message_admins("")
		SC.detonate(src)
		detonation_count++
	to_chat(user, SPAN_NOTICE("[detonation_count] charges detonated."))

/obj/item/satchel_charge_detonator/clicked(mob/user, list/mods)  // kill me
	if (isobserver(user) || isXeno(user)) return

	if (mods["alt"]) // alt+click to ping charges?
		to_chat(SPAN_NOTICE("You ping the detonator's [length(linked_charges)] linked charges."))
		for(var/obj/item/explosive/satchel_charge/SC in linked_charges)
			flick("satchel_primed", SC)
			SC.beep(TRUE)
		return 1
	return

/obj/item/satchel_charge_detonator/makeshift
	name = "Makeshift detonator"
	desc = "An poor zippo lighter that has sodomized into becoming a crappy makeshift explosive detonator."
	icon = 'icons/obj/items/assemblies.dmi'
	icon_state = "makeshift_detonator"

/obj/item/explosive/satchel_charge
	name = "M17 Satchel Charge"
	desc = "The m17 is an old, yet robust satchel charge system dating back to the late 21st century that still hasn't been replaced yet. In addition to command detonation, it also features a laser tripwire mode where it can be mounted onto a wall and detonate to anything the crosses it without IFF. Finally it features a seldomly used auto disarm mode where it automatically disarms after a time period to reduce collateral damage from UXO. Not that collateral matters nowadays anyways...\nTo detonate it, it requires linking with the included M38-D universal detonator beforehand and tossing it ."
	//desc = "After linked to a detonator, and thrown, will become primed and able to be detonated."
	gender = PLURAL
	icon = 'icons/obj/items/assemblies.dmi'
	icon_state = "phoron" //PLACEHOLDER
	flags_item = NOBLUDGEON
	w_class = SIZE_SMALL
	max_container_volume = 180
	reaction_limits = list(	"max_ex_power" = 260,	"base_ex_falloff" = 90,	"max_ex_shards" = 64,
							"max_fire_rad" = 6,		"max_fire_int" = 26,	"max_fire_dur" = 30,
							"min_fire_rad" = 2,		"min_fire_int" = 4,		"min_fire_dur" = 5
	)

	var/prime_time  = 3 SECONDS
	var/prime_timer  = null
	var/obj/item/satchel_charge_detonator/linked_detonator = null
	var/activated = FALSE
	var/armed = FALSE

/obj/item/explosive/satchel_charge/attack_self(mob/user)
	. = ..()
	if(!linked_detonator)
		to_chat(user, SPAN_NOTICE("This Charge is not linked to any detonator"))
		return
	icon_state = "satchel_triggered"
	playsound(src.loc, 'sound/machines/click.ogg', 25, 1)
	var/mob/living/carbon/C = user
	if(istype(C) && !C.throw_mode)
		C.toggle_throw_mode(THROW_MODE_NORMAL)
	to_chat(user, SPAN_NOTICE("You activate the M17 Satchel Charge, it will now arm itself after a short time once thrown."))
	activated = TRUE
	addtimer(CALLBACK(src, .proc/un_activate), 10 SECONDS, TIMER_UNIQUE)

/obj/item/explosive/satchel_charge/attackby(obj/item/W, mob/user)
	. = ..()
	beep(TRUE)
	if(armed)
		to_chat(user, SPAN_WARNING("This charge is armed, its linking cannot be altered unless disarmed."))
		return
	if(!istype(W, /obj/item/satchel_charge_detonator))
		return
	var/obj/item/satchel_charge_detonator/D = W
	if(linked_detonator == D)
		D.linked_charges -= src
		linked_detonator == null
		to_chat(user, SPAN_NOTICE("You unlink the charge from the detonator."))
		icon_state = "satchel"
	else
		D.linked_charges |= src
		linked_detonator = D
		to_chat(user, SPAN_NOTICE("The detonator indicates a new charge has been linked."))
		icon_state = "satchel_linked"

/obj/item/explosive/satchel_charge/proc/un_activate()
	if(activated)
		activated = FALSE
		if(linked_detonator)
			icon_state = "satchel_linked"
		else
			icon_state = "satchel"

/obj/item/explosive/satchel_charge/throw_atom(atom/target, range, speed, atom/thrower, spin, launch_type, pass_flags)
	. = ..()
	dir = get_dir(src, thrower)
	if(activated && linked_detonator)
		icon_state = "satchel_primed"
		prime_timer  = addtimer(CALLBACK(src, .proc/arm), prime_time , TIMER_UNIQUE)
		beep()

/obj/item/explosive/satchel_charge/proc/beep(var/beep_once)
	//playsound(src.loc, 'sound/effects/beepo.ogg', 10, 1)
	to_chat(world, "BEEP")
	if(!armed && beep_once != TRUE)
		addtimer(CALLBACK(src, .proc/beep), 1 SECONDS, TIMER_UNIQUE)


/obj/item/explosive/satchel_charge/proc/arm()
	activated = FALSE
	if(!linked_detonator || armed)
		return
	icon_state = "satchel_armed"
	armed = TRUE

/obj/item/explosive/satchel_charge/pickup(mob/user)
	if(armed || prime_timer )
		if(prime_timer )
			//stop the timer somehow -_-
		do_after(user, prime_time , INTERRUPT_MOVED, TRUE)
		if(linked_detonator)
			icon_state = "satchel_linked"
		else
			icon_state = "satchel"
		armed = FALSE
		. = ..()
	else
		. = ..()

/obj/item/explosive/satchel_charge/proc/detonate(triggerer)
	if(!armed || linked_detonator != triggerer)
		return
	linked_detonator.linked_charges -= src
	message_admins("BOOM!")
	qdel(src)



