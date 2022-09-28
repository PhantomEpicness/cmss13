/*
Acid grenadier

Projectile based, use the prae acid ball grenade

todo:  [✓] = done [-] = in prog  [%] = todo
- port over prae acid ball						[✓]
	-
	-TESTED[✓]

- make new acid ball nade for grenadier			[✓]
	-
	-TESTED[✓]


======================NEW OBJECTIVE=======================
Steal shit from the twebs 'acid grenade'
for spread and propogation + niceness 			[✓]
	-
	-TESTED[✓]


- make dot cades only or acid effect cades only	[]


- make a slimeball variant 						[✓]
	-lower range, slowdown if caught in it, minimal damage
	-TESTED[✓]

- attempt to make le acid pool					[]


balance convo


https://discord.com/channels/150315577943130112/745447048261795890/939419932406456331

BASICALLY
- make dot cades only or acid effect cades only	[]

-???
	- kill trapper

====== notes=======

-- test every major change

//strain not appearing on purchas strain		[✓]

*/
/datum/xeno_mutator/grenadier
	name = "STRAIN: Boiler - Acid Grenadier"
	description = "You trade your acid gas cloud, some speed and acid lance into a neuro gas cloud that immobilizes your opponents, gain a long range acid artillery glob and can support your fellow sisters with acid pools"
	flavor_description = "I love the smell of meltin' tallhosts in the Mornin'."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_BOILER) //Only boiler.
	mutator_actions_to_remove = list( ////// todo: remove actions
		/datum/action/xeno_action/activable/bombard,
		/datum/action/xeno_action/activable/acid_lance,
		/datum/action/xeno_action/onclick/dump_acid,
	) /////////////// todo: put the actions you want here
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/grenadier_lob,
		/datum/action/xeno_action/onclick/shift_chemicals,
		/datum/action/xeno_action/activable/spray_acid/grenadier
	)
	keystone = TRUE

	behavior_delegate_type = /datum/behavior_delegate/boiler_grenadier

/datum/xeno_mutator/grenadier/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if(. == 0)
		return

	var/mob/living/carbon/Xenomorph/Boiler/B = MS.xeno
	if(B.is_zoomed)
		B.zoom_out()

	B.mutation_type = BOILER_GRENADIER
	B.plasma_types -= PLASMA_NEUROTOXIN

	//B.speed_modifier += XENO_SPEED_SLOWMOD_TIER_1
	B.recalculate_everything()

	apply_behavior_holder(B)

	mutator_update_actions(B)
	MS.recalculate_actions(description, flavor_description)


/datum/behavior_delegate/boiler_grenadier
	name = "Boiler Grenadier Behavior Delegate"
	var/curr_chem = "acid"
	var/list/chems = list("acid","slime")
	//var/list/sprays = list(/obj/effect/xenomorph/spray,/obj/effect/xenomorph/spray/slime)
	//var/list/nades = list(/obj/item/explosive/grenade/grenadier_acid_nade,/obj/item/explosive/grenade/grenadier_slime_nade)
	// Config
	var/temp_movespeed_amount = 1.25
	var/temp_movespeed_duration = 50
	var/temp_movespeed_cooldown = 200
	var/bonus_damage_shotgun_trapped = 7.5

	// State
	var/temp_movespeed_time_used = 0
	var/temp_movespeed_usable = FALSE
	var/temp_movespeed_messaged = FALSE
