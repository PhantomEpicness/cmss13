/datum/action/xeno_action/onclick/toggle_long_range/boiler
	should_delay = TRUE
	delay = 20
	ability_primacy = XENO_PRIMARY_ACTION_4
	movement_buffer = 7

/datum/action/xeno_action/activable/acid_lance
	name = "Acid Lance"
	ability_name = "acid lance"
	action_icon_state = "acid_lance"
	plasma_cost = 50
	macro_path = /datum/action/xeno_action/verb/verb_acid_lance
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 190

	// Config
	var/stack_time = 10
	var/base_range = 6
	var/range_per_stack = 1
	var/base_damage = 35
	var/damage_per_stack = 15
	var/movespeed_per_stack = 1.25

	var/time_after_max_before_end = 25

	// State
	var/stacks = 0
	var/max_stacks = 5
	var/movespeed_nerf_applied = 0
	var/activated_once = FALSE

/datum/action/xeno_action/onclick/dump_acid
	name = "Dump Acid"
	ability_name = "dump acid"
	action_icon_state = "dump_acid"
	plasma_cost = 10
	macro_path = /datum/action/xeno_action/verb/verb_dump_acid
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 340

	var/buffs_duration = 60
	var/cooldown_duration = 350

	var/speed_buff_amount = 0.5
	var/movespeed_buff_applied = FALSE

	// List of types of actions to place on 20-second CD
	// if you ever want to subtype this for a strain or whatever, just change this var on the subtype
	var/action_types_to_cd = list(/datum/action/xeno_action/activable/bombard, /datum/action/xeno_action/activable/acid_lance)

//////////////////////////// Trapper boiler abilities

/datum/action/xeno_action/activable/boiler_trap
	name = "Deploy Trap"
	ability_name = "deploy trap"
	action_icon_state = "resin_pit"
	plasma_cost = 60
	macro_path = /datum/action/xeno_action/verb/verb_boiler_trap
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 205

	/// Config
	var/trap_ttl = 100
	var/empowered = FALSE
	var/empowering_charge_counter = 0
	var/empower_charge_max = 10

/datum/action/xeno_action/activable/acid_mine
	name = "Acid Mine"
	ability_name = "acid mine"
	action_icon_state = "acid_mine"
	plasma_cost = 40
	macro_path = /datum/action/xeno_action/verb/verb_acid_mine
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 55

	var/empowered = FALSE

	var/damage = 45
	var/delay = 13.5

/datum/action/xeno_action/activable/acid_shotgun
	name = "Acid Shotgun"
	ability_name = "acid shotgun"
	action_icon_state = "acid_shotgun"
	plasma_cost = 60
	macro_path = /datum/action/xeno_action/verb/verb_acid_shotgun
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 130

	var/ammo_type = /datum/ammo/xeno/acid_shotgun

/datum/action/xeno_action/onclick/toggle_long_range/trapper
	handles_movement = FALSE
	should_delay = FALSE
	ability_primacy = XENO_PRIMARY_ACTION_4


//////////////////////////// acid grenadier abilities

/datum/action/xeno_action/onclick/shift_chemicals
	name = "Switch Chemicals"
	action_icon_state = "shift_spit_neurotoxin"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/verb_toggle_spit_type
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 5 SECONDS
	var/action_types_to_cd = list(  	// copypasted from dump acid
		/datum/action/xeno_action/activable/grenadier_lob,
		/datum/action/xeno_action/onclick/shift_chemicals,
		/datum/action/xeno_action/activable/spray_acid/grenadier)

	var/cooldown_duration = 5 SECONDS

/datum/action/xeno_action/onclick/shift_chemicals/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated())
		return TRUE


/datum/action/xeno_action/activable/grenadier_lob
	name = "Acid Glob"
	action_icon_state = "prae_acid_ball"
	ability_name = "acid glob"
	macro_path = /datum/action/xeno_action/verb/verb_acid_ball
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 20 SECONDS
	plasma_cost = 120
	// activation delay is warmup
	var/activation_delay = 5 SECONDS
	var/prime_delay = 1 SECONDS
	// throw range in tiles
	var/throw_range = 10
	var/globtype = /obj/item/explosive/grenade/grenadier_acid_nade //placeholder

/datum/action/xeno_action/activable/spray_acid/grenadier
	name = "Spray"
	action_icon_state = "spray_acid"
	ability_name = "spray acid"
	macro_path = /datum/action/xeno_action/verb/verb_spray_acid
	action_type = XENO_ACTION_CLICK

	plasma_cost = 40
	xeno_cooldown = 10 SECONDS


	// Configurable options

	spray_type = ACID_SPRAY_CONE	// Enum for the shape of spray to do
	spray_distance = 3 				// Distance to spray
	spray_effect_type = /obj/effect/xenomorph/spray

	activation_delay = FALSE		// These are placeholders
	activation_delay_length = 0		// These are placeholders

/datum/action/xeno_action/activable/spray_acid/grenadier/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	var/datum/behavior_delegate/boiler_grenadier/BD = X.behavior_delegate
	switch(BD.curr_chem)
		if("acid")
			spray_effect_type = /obj/effect/xenomorph/spray
			activation_delay = TRUE
		if("slime")
			spray_effect_type = /obj/effect/xenomorph/spray/slime
			activation_delay = FALSE
		else
			CRASH("Invalid grenadier chemical")
	..()

