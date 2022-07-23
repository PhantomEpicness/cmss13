/datum/xeno_mutator/striker
	name = "STRAIN: Boiler - Striker"
	description = "You trade your globs and some health for a long ranged high damage shot, long ranged fragmentation acid, and the spit in quick succession if you manage to hit three hosts in a row. You will also be granted the ability to spray slime."
	flavor_description = "We can do it, yes we can!"
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_BOILER) //Only boiler.
	mutator_actions_to_remove = list( ////// todo: remove actions
		/datum/action/xeno_action/activable/bombard,
		/datum/action/xeno_action/activable/acid_lance,
		/datum/action/xeno_action/onclick/dump_acid,
	) /////////////// todo: put the actions you want here
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/onclick/shift_spits,
		/datum/action/xeno_action/activable/xeno_spit_rapid,
		/datum/action/xeno_action/onclick/toggle_long_range/boiler
	)
	keystone = TRUE
	behavior_delegate_type = /datum/behavior_delegate/boiler_striker
	//zoom(user, 11, 12)
/datum/xeno_mutator/striker/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if(. == 0)
		return
	var/mob/living/carbon/Xenomorph/Boiler/B = MS.xeno
	if(B.is_zoomed)
		B.zoom_out()
	B.spit_types = list(/datum/ammo/xeno/acid/railgun,/datum/ammo/xeno/acid/fragmenting_shot,/datum/ammo/xeno/acid/fragmenting_shot/neuro)
	B.ammo = GLOB.ammo_list[/datum/ammo/xeno/acid/railgun]
	B.spit_delay = 5 SECONDS
	B.spit_windup = 3 SECONDS
	B.mutation_type = BOILER_STRIKER
	B.plasma_types -= PLASMA_NEUROTOXIN

	apply_behavior_holder(B)
	//B.speed_modifier += XENO_SPEED_SLOWMOD_TIER_1
	B.recalculate_everything()


	mutator_update_actions(B)
	MS.recalculate_actions(description, flavor_description)

// find out why its being dumb and making it neuro gas
// save neuro gas for base globber
/datum/behavior_delegate/boiler_striker
	name = "Boiler striker Behavior Delegate"
	// config
	var/row_hits = 0 // Tracks the amount of hits for the Ultimate
	var/hits_threshold = 3 // amount of hits before ultimate is avalible
	// state
	var/empower_active = FALSE

	// Barrage spit config
	var/barrage_used = FALSE
	var/empower_level = 1
	var/barrage_ammo_type = /datum/ammo/xeno/acid/rapidfire
	// These are default values if the empower level is 1, these are crunched in the use_ability proc
	var/spit_barrage_amount = 5
	var/spit_barrage_duration = 3 SECONDS
	var/spit_barrage_windup = 3 SECONDS
