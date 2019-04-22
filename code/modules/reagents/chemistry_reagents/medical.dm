
// All reagents related to medicine



/datum/reagent/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	description = "Inaprovaline is a synaptic stimulant and cardiostimulant. Commonly used to stabilize patients."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE*2
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL*2

	scannable = 1

/datum/reagent/inaprovaline/on_mob_life(mob/living/M, alien)
	. = ..()
	if(!.) return

	M.reagent_shock_modifier += PAIN_REDUCTION_LIGHT

	if(M.losebreath >= 10)
		M.losebreath = max(10, M.losebreath-5)

	holder.remove_reagent(src.id, 0.5 * REAGENTS_METABOLISM)

/datum/reagent/inaprovaline/on_overdose(mob/living/M, alien)
	if(alien == IS_YAUTJA) return
	M.make_jittery(5) //Overdose causes a spasm
	M.knocked_out = max(M.knocked_out, 20)

/datum/reagent/inaprovaline/on_overdose_critical(mob/living/M, alien)
	if(alien == IS_YAUTJA) return
	M.drowsyness = max(M.drowsyness, 20)
	if(ishuman(M)) //Critical overdose causes total blackout and heart damage. Too much stimulant
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
		E.damage += 0.5
		if(prob(10))
			M.emote(pick("twitch","blink_r","shiver"))

/datum/reagent/ryetalyn
	name = "Ryetalyn"
	id = "ryetalyn"
	description = "Ryetalyn can cure all genetic abnomalities via a catalytic process."
	reagent_state = SOLID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL

/datum/reagent/ryetalyn/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return

	var/needs_update = M.mutations.len > 0

	M.mutations = list()
	M.disabilities = 0
	M.sdisabilities = 0

	// Might need to update appearance for hulk etc.
	if(needs_update && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_mutations()

/datum/reagent/ryetalyn/on_overdose(mob/living/M)
	M.confused = max(M.confused, 20) //Confusion and some toxins
	M.apply_damage(1, TOX)

/datum/reagent/ryetalyn/on_overdose_critical(mob/living/M)
	M.knocked_out = max(M.knocked_out, 20) //Total DNA collapse
	M.apply_damage(1, TOX)
	M.apply_damage(3, CLONE)

/datum/reagent/paracetamol
	name = "Paracetamol"
	id = "paracetamol"
	description = "Most probably know this as Tylenol, but this chemical is a mild, simple painkiller."
	reagent_state = LIQUID
	color = "#C855DC"
	scannable = 1
	custom_metabolism = 0.025 // Lasts 10 minutes for 15 units
	overdose = REAGENTS_OVERDOSE*2
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL*2

/datum/reagent/paracetamol/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.reagent_pain_modifier += PAIN_REDUCTION_HEAVY

/datum/reagent/paracetamol/on_overdose(mob/living/M)
	M.hallucination = max(M.hallucination, 2) //Hallucinations and tox damage
	M.apply_damage(1, TOX)

/datum/reagent/paracetamol/on_overdose_critical(mob/living/M)
	M.apply_damage(4, TOX) //Massive liver damage


/datum/reagent/tramadol
	name = "Tramadol"
	id = "tramadol"
	description = "A simple, yet effective painkiller."
	reagent_state = LIQUID
	color = "#C8A5DC"
	scannable = 1
	custom_metabolism = 0.1 // Lasts 10 minutes for 15 units
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL

/datum/reagent/tramadol/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.reagent_pain_modifier += PAIN_REDUCTION_VERY_HEAVY


/datum/reagent/tramadol/on_overdose(mob/living/M)
	M.apply_damage(1, OXY)
	M.apply_damage(1, TOX)

/datum/reagent/tramadol/on_overdose_critical(mob/living/M)
	M.apply_damage(3, OXY)
	M.apply_damage(2, TOX)
	M.adjustBrainLoss(1)


/datum/reagent/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	description = "An effective and very addictive painkiller."
	reagent_state = LIQUID
	color = "#C805DC"
	custom_metabolism = 0.2 // Lasts 5 minutes for 15 units
	overdose = REAGENTS_OVERDOSE * 0.66
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL * 0.66

/datum/reagent/oxycodone/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.reagent_pain_modifier += PAIN_REDUCTION_VERY_HEAVY

/datum/reagent/oxycodone/on_overdose(mob/living/M)
	M.apply_damage(1, OXY)
	M.apply_damage(1, TOX)

/datum/reagent/oxycodone/on_overdose_critical(mob/living/M)
	M.apply_damage(3, OXY)
	M.apply_damage(2, TOX)
	M.adjustBrainLoss(1)

/datum/reagent/oxycodone/on_overdose(mob/living/M)
	M.apply_damage(1, OXY)
	M.apply_damage(1, TOX)

/datum/reagent/oxycodone/on_overdose_critical(mob/living/M)
	M.apply_damage(3, OXY)
	M.apply_damage(2, TOX)
	M.adjustBrainLoss(1)

/datum/reagent/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	description = "Sterilizes wounds in preparation for surgery."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220

	//makes you squeaky clean
/datum/reagent/sterilizine/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
	if(method == TOUCH)
		M.germ_level -= min(volume*20, M.germ_level)

/datum/reagent/sterilizine/reaction_obj(var/obj/O, var/volume)
	O.germ_level -= min(volume*20, O.germ_level)

/datum/reagent/sterilizine/reaction_turf(var/turf/T, var/volume)
	T.germ_level -= min(volume*20, T.germ_level)

/datum/reagent/leporazine
	name = "Leporazine"
	id = "leporazine"
	description = "Leporazine can be use to stabilize an individuals body temperature."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL

/datum/reagent/leporazine/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	else if(M.bodytemperature < 311)
		M.bodytemperature = min(310, M.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/leporazine/on_overdose(mob/living/M, alien)
	if(alien == IS_YAUTJA) return
	M.knocked_out = max(M.knocked_out, 20)

/datum/reagent/leporazine/on_overdose_critical(mob/living/M, alien)
	if(alien == IS_YAUTJA) return
	M.drowsyness  = max(M.drowsyness, 30)

/datum/reagent/kelotane
	name = "Kelotane"
	id = "kelotane"
	description = "Kelotane is a drug used to treat burns."
	reagent_state = LIQUID
	color = "#D8C58C"
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL

/datum/reagent/kelotane/on_mob_life(var/mob/living/M)
	. = ..()
	if(!.) return
	if(M.stat == DEAD)
		return
	M.heal_limb_damage(0, 2 * REM)

/datum/reagent/kelotane/on_overdose(mob/living/M)
	M.apply_damages(1, 0, 1) //Mixed brute/tox damage

/datum/reagent/kelotane/on_overdose_critical(mob/living/M)
	M.apply_damages(4, 0, 4) //Massive brute/tox damage

/datum/reagent/dermaline
	name = "Dermaline"
	id = "dermaline"
	description = "Dermaline is the next step in burn medication. Works twice as good as kelotane and enables the body to restore even the direst heat-damaged tissue."
	reagent_state = LIQUID
	color = "#F8C57C"
	overdose = REAGENTS_OVERDOSE/2
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL/2
	scannable = 1

/datum/reagent/dermaline/on_mob_life(mob/living/M, alien)
	. = ..()
	if(!.) return
	if(M.stat == DEAD) //THE GUY IS **DEAD**! BEREFT OF ALL LIFE HE RESTS IN PEACE etc etc. He does NOT metabolise shit anymore, god DAMN
		return
	if(!alien)
		M.heal_limb_damage(0, 3 * REM)

/datum/reagent/dermaline/on_overdose(mob/living/M)
	M.apply_damages(1, 0, 1) //Mixed brute/tox damage

/datum/reagent/dermaline/on_overdose_critical(mob/living/M)
	M.apply_damages(4, 0, 4) //Massive brute/tox damage

/datum/reagent/dexalin
	name = "Dexalin"
	id = "dexalin"
	description = "Dexalin is used in the treatment of oxygen deprivation."
	reagent_state = LIQUID
	color = "#C865FC"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	scannable = 1

/datum/reagent/dexalin/on_mob_life(mob/living/M,alien)
	. = ..()
	if(!.) return
	if(M.stat == DEAD)
		return  //See above, down and around. --Agouri

	if(!alien)
		M.adjustOxyLoss(-2*REM)

	holder.remove_reagent("lexorin", 2 * REM)

/datum/reagent/dexalin/on_overdose(mob/living/M)
	M.apply_damage(1, TOX) //Mixed brute/tox damage

/datum/reagent/dexalin/on_overdose_critical(mob/living/M)
	M.apply_damages(2, 0, 4) //Massive brute/tox damage

/datum/reagent/dexalinp
	name = "Dexalin Plus"
	id = "dexalinp"
	description = "Dexalin Plus is used in the treatment of oxygen deprivation. It is highly effective."
	reagent_state = LIQUID
	color = "#C8A5FC"
	overdose = REAGENTS_OVERDOSE/2
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL/2
	scannable = 1

/datum/reagent/dexalinp/on_mob_life(mob/living/M,alien)
	. = ..()
	if(!.) return
	if(M.stat == DEAD)
		return

	if(!alien)
		M.adjustOxyLoss(-M.getOxyLoss())

	holder.remove_reagent("lexorin", 2*REM)

/datum/reagent/dexalinp/on_overdose(mob/living/M)
	M.apply_damage(1, TOX) //Mixed brute/tox damage

/datum/reagent/dexalinp/on_overdose_critical(mob/living/M)
	M.apply_damages(2, 0, 4) //Massive brute/tox damage

/datum/reagent/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
	reagent_state = LIQUID
	color = "#B865CC"
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL

/datum/reagent/tricordrazine/on_mob_life(mob/living/M, alien)
	. = ..()
	if(!.) return
	if(M.stat == DEAD)
		return
	if(!alien)
		if(M.getOxyLoss()) M.adjustOxyLoss(-REM)
		if(M.getBruteLoss() && prob(80)) M.heal_limb_damage(REM, 0)
		if(M.getFireLoss() && prob(80)) M.heal_limb_damage(0, REM)
		if(M.getToxLoss() && prob(80)) M.adjustToxLoss(-REM)

/datum/reagent/tricordrazine/on_overdose(mob/living/M)
	M.make_jittery(5)
	M.adjustBrainLoss(1)

/datum/reagent/tricordrazine/on_overdose_critical(mob/living/M)
	M.apply_damages(5, 5, 5) //Massive damage bounceback if abused
	M.adjustBrainLoss(1)

/datum/reagent/anti_toxin
	name = "Dylovene"
	id = "anti_toxin"
	description = "Dylovene is a broad-spectrum antitoxin."
	reagent_state = LIQUID
	color = "#A8F59C"
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL

/datum/reagent/anti_toxin/on_mob_life(mob/living/M,alien)
	. = ..()
	if(!.) return
	if(!alien)
		M.reagents.remove_all_type(/datum/reagent/toxin, REM, 0, 1)
		M.drowsyness = max(M.drowsyness- 2 * REM, 0)
		M.hallucination = max(0, M.hallucination -  5 * REM)
		M.adjustToxLoss(-2 * REM)

/datum/reagent/anti_toxin/on_overdose(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
		if(E)
			E.damage += 0.41 //blurry after slightly more than 10u of overdose, blindness after ~15 or so

/datum/reagent/anti_toxin/on_overdose_critical(mob/living/M)
	M.apply_damages(3, 3) //Starts detoxing, hard
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
		if(E)
			E.damage += 0.82

/datum/reagent/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	id = "adminordrazine"
	description = "It's magic. We don't have to explain it."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220

/datum/reagent/adminordrazine/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(!.) return
	M.reagents.remove_all_type(/datum/reagent/toxin, 5*REM, 0, 1)
	M.setCloneLoss(0)
	M.setOxyLoss(0)
	M.radiation = 0
	M.heal_limb_damage(5,5)
	M.adjustToxLoss(-5)
	M.hallucination = 0
	M.setBrainLoss(0)
	M.disabilities = 0
	M.sdisabilities = 0
	M.eye_blurry = 0
	M.eye_blind = 0
	M.SetKnockeddown(0)
	M.SetStunned(0)
	M.SetKnockedout(0)
	M.silent = 0
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.confused = 0
	M.sleeping = 0
	M.jitteriness = 0
	for(var/datum/disease/D in M.viruses)
		D.spread = "Remissive"
		D.stage--
		if(D.stage < 1)
			D.cure()

/datum/reagent/thwei //OP yautja chem
	name = "thwei"
	id = "thwei"
	description = "A strange, alien liquid."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220

/datum/reagent/thwei/on_mob_life(mob/living/carbon/M,alien)
	. = ..()
	if(!.) return
	if(!isYautja(M)) return
	var/mob/living/carbon/human/Y = M
	for(var/datum/limb/L in Y.limbs)
		if(L.time_to_knit && (L.status & LIMB_BROKEN))
			if(L.knitting_time) break // only one knits at a time
			if((L.status & LIMB_SPLINTED) && L.knitting_time == -1)
				L.knitting_time = L.time_to_knit + world.time
				L.start_processing()
				to_chat(Y, SPAN_NOTICE("You feel the bones in your [L.display_name] start to knit together."))
				break

	if(M.getBruteLoss() && prob(80)) M.heal_limb_damage(1*REM,0)
	if(M.getFireLoss() && prob(80)) M.heal_limb_damage(0,1*REM)
	if(M.getToxLoss() && prob(80)) M.adjustToxLoss(-1*REM)
	M.reagents.remove_all_type(/datum/reagent/toxin, 5*REM, 0, 1)
	M.setCloneLoss(0)
	M.setOxyLoss(0)
	M.radiation = 0
	M.adjustToxLoss(-5)
	M.hallucination = 0
	M.setBrainLoss(0)
	M.disabilities = 0
	M.sdisabilities = 0
	M.eye_blurry = 0
	M.eye_blind = 0
	M.silent = 0
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.confused = 0
	M.jitteriness = 0
	for(var/datum/internal_organ/I in M.internal_organs)
		if(I.damage > 0)
			I.damage = max(I.damage - 1, 0)
	for(var/datum/disease/D in M.viruses)
		D.spread = "Remissive"
		D.stage--
		if(D.stage < 1)
			D.cure()

/datum/reagent/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	description = "Synaptizine is used to treat various diseases."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.1
	overdose = REAGENTS_OVERDOSE/5
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL/5
	scannable = 1

/datum/reagent/synaptizine/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.reagent_shock_modifier += PAIN_REDUCTION_MEDIUM
	M.drowsyness = max(M.drowsyness-5, 0)
	M.AdjustKnockedout(-1)
	M.AdjustStunned(-1)
	M.AdjustKnockeddown(-1)
	holder.remove_reagent("mindbreaker", 5)
	M.hallucination = max(0, M.hallucination - 10)
	if(prob(80))	M.adjustToxLoss(1)

/datum/reagent/synaptizine/on_overdose(mob/living/M)
	M.apply_damage(2, TOX)

/datum/reagent/synaptizine/on_overdose_critical(mob/living/M)
	M.apply_damages(1, 1, 3)

/datum/reagent/neuraline //injected by neurostimulator implant
	name = "Neuraline"
	id = "neuraline"
	description = "A chemical cocktail tailored to enhance or dampen specific neural processes."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.4
	overdose = 2
	overdose_critical = 3
	scannable = 0

/datum/reagent/neuraline/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.reagent_shock_modifier += PAIN_REDUCTION_FULL
	M.drowsyness = max(M.drowsyness-5, 0)
	M.dizziness = max(M.dizziness-5, 0)
	M.stuttering = max(M.stuttering-5, 0)
	M.confused = max(M.confused-5, 0)
	M.eye_blurry = max(M.eye_blurry-5, 0)
	M.AdjustKnockedout(-2)
	M.AdjustStunned(-2)
	M.AdjustKnockeddown(-1)

/datum/reagent/hyronalin
	name = "Hyronalin"
	id = "hyronalin"
	description = "Hyronalin is a medicinal drug used to counter the effect of radiation poisoning."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	scannable = 1

/datum/reagent/hyronalin/on_mob_life(var/mob/living/M as mob)
	. = ..()
	if(!.) return
	M.radiation = max(M.radiation-3*REM,0)

/datum/reagent/hyronalin/on_overdose(mob/living/M)
	M.apply_damage(2, TOX)

/datum/reagent/hyronalin/on_overdose_critical(mob/living/M)
	M.apply_damages(1, 1, 3)

/datum/reagent/arithrazine
	name = "Arithrazine"
	id = "arithrazine"
	description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE/2
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL/2

/datum/reagent/arithrazine/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(M.stat == DEAD)
		return  //See above, down and around. --Agouri
	M.radiation = max(M.radiation-7*REM,0)
	M.adjustToxLoss(-1*REM)
	if(prob(15))
		M.take_limb_damage(1, 0)

/datum/reagent/arithrazine/on_overdose(mob/living/M)
		M.apply_damage(2, TOX)

/datum/reagent/arithrazine/on_overdose_critical(mob/living/M)
		M.apply_damages(1, 1, 3)

/datum/reagent/russianred
	name = "Russian Red"
	id = "russianred"
	description = "An emergency radiation treatment, however it has extreme side effects."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 1
	overdose = REAGENTS_OVERDOSE/3
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL/3
	scannable = 1

/datum/reagent/russianred/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.radiation = max(M.radiation - 10 * REM, 0)
	M.adjustToxLoss(-1*REM)
	if(prob(50))
		M.take_limb_damage(3, 0)

/datum/reagent/russianred/on_overdose(mob/living/M)
	M.apply_damages(1, 0, 0)

/datum/reagent/russianred/on_overdose_critical(mob/living/M)
	M.apply_damages(1, 2, 2)

/datum/reagent/alkysine
	name = "Alkysine"
	id = "alkysine"
	description = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
	reagent_state = LIQUID
	color = "#E89599"
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	scannable = 1

/datum/reagent/alkysine/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.reagent_shock_modifier += PAIN_REDUCTION_VERY_LIGHT
	M.adjustBrainLoss(-3 * REM)

/datum/reagent/alkysine/on_overdose(mob/living/M)
	M.apply_damage(2, TOX)

/datum/reagent/alkysine/on_overdose_critical(mob/living/M)
	M.apply_damages(1, 1, 3)

/datum/reagent/imidazoline
	name = "Imidazoline"
	id = "imidazoline"
	description = "Heals eye damage"
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	scannable = 1

/datum/reagent/imidazoline/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.eye_blurry = max(M.eye_blurry-5 , 0)
	M.eye_blind = max(M.eye_blind-5 , 0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
		if(E && istype(E))
			if(E.damage > 0)
				E.damage = max(E.damage - 1, 0)

/datum/reagent/imidazoline/on_overdose(mob/living/M)
		M.apply_damage(2, TOX)

/datum/reagent/imidazoline/on_overdose_critical(mob/living/M)
		M.apply_damages(1, 1, 3)

/datum/reagent/peridaxon
	name = "Peridaxon"
	id = "peridaxon"
	description = "Used to stabilize internal organs while waiting for surgery. Medicate cautiously."
	reagent_state = LIQUID
	color = "#C845DC"
	overdose = REAGENTS_OVERDOSE/2
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL/2
	custom_metabolism = 0.05
	scannable = 1

/datum/reagent/peridaxon/on_overdose(mob/living/M)
	M.apply_damage(2, BRUTE)

/datum/reagent/peridaxon/on_overdose_critical(mob/living/M)
	M.apply_damages(3, 3, 3)

/datum/reagent/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma."
	reagent_state = LIQUID
	color = "#E8756C"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	scannable = 1

/datum/reagent/bicaridine/on_mob_life(mob/living/M, alien)
	. = ..()
	if(!.) return
	if(M.stat == DEAD)
		return
	M.heal_limb_damage(2*REM,0)

/datum/reagent/bicaridine/on_overdose(mob/living/M) // yes it cures IB, it's located in some other part of wound code for whatever reason
	M.apply_damage(1, BURN)

/datum/reagent/bicaridine/on_overdose_critical(mob/living/M)
	M.apply_damages(0, 4, 2)

/datum/reagent/quickclot
	name = "Quick Clot"
	id = "quickclot"
	description = "A chemical designed to quickly stop all sorts of bleeding by encouraging coagulation."
	reagent_state = LIQUID
	color = "#CC00FF"
	overdose = REAGENTS_OVERDOSE/2 //Was 4, now 6 //Now 15
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL/2
	scannable = 1 //scannable now.  HUZZAH.
	custom_metabolism = 0.05

/datum/reagent/quickclot/on_overdose(mob/living/M)
	M.apply_damage(3, BRUTE)

/datum/reagent/quickclot/on_overdose_critical(mob/living/M)
	M.apply_damages(2, 3, 3)

/datum/reagent/adrenaline
	name = "Epinephrine"
	id = "adrenaline"
	description = "A natural muscle and heart stimulant. Useful for restarting the heart."
	reagent_state = LIQUID
	ingestible = FALSE
	color = "FFE703" // Yellow-ish
	overdose = REAGENTS_OVERDOSE/2.95 // slightly more than 10, so 10u doesn't OD you
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL/2.5 //20
	scannable = 1
	custom_metabolism = 0.4

/datum/reagent/adrenaline/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return

	M.reagent_move_delay_modifier -= 0.2
	M.reagent_shock_modifier += PAIN_REDUCTION_MEDIUM // half of tramadol

/datum/reagent/adrenaline/on_overdose(mob/living/M)
	var/mob/living/carbon/human/H = M
	var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
	if(E)
		E.damage += 0.25

/datum/reagent/adrenaline/on_overdose_critical(mob/living/M, alien)
	var/mob/living/carbon/human/H = M
	var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
	if(E)
		E.damage += 1
		
/datum/reagent/hyperzine
	name = "Hyperzine"
	id = "hyperzine"
	description = "Hyperzine is a highly effective, long lasting, muscle stimulant.  May cause heart damage"
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.2
	overdose = REAGENTS_OVERDOSE/5
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL/5

/datum/reagent/hyperzine/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return

	M.reagent_move_delay_modifier -= 0.5

	if(prob(1))
		M.emote(pick("twitch","blink_r","shiver"))
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/datum/internal_organ/heart/F = H.internal_organs_by_name["heart"]
			F.damage += 1
			M.emote(pick("twitch","blink_r","shiver"))

/datum/reagent/hyperzine/on_overdose(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
		if(E)
			E.damage += 0.5
		if(prob(10))
			M.emote(pick("twitch", "blink_r", "shiver"))

/datum/reagent/hyperzine/on_overdose_critical(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
		if(E)
			E.damage += 2
		if(prob(25))
			M.emote(pick("twitch", "blink_r", "shiver"))

/datum/reagent/ultrazine
	name = "Ultrazine"
	id = "ultrazine"
	description = "A highly-potent, long-lasting combination CNS and muscle stimulant. Extremely addictive."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.0167 //5 units will last approximately 10 minutes
	overdose = 10
	overdose_critical = 20

/datum/reagent/ultrazine/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return

	M.reagent_move_delay_modifier -= 10

	var/has_addiction = 0

	for(var/datum/disease/ultrazine_addiction/D in M.viruses)
		has_addiction = 1

		if(D.stage < D.max_stages)
			D.addiction_progression++
			if(D.addiction_progression > D.progression_threshold)
				D.addiction_progression = 0
				D.stage++
		else
			D.addiction_progression = min(D.addiction_progression+1, D.progression_threshold) //withdrawal buffer

		switch(D.stage)
			if(2)
				if(prob(1))
					M.hallucination = max(50, M.hallucination)
			if(3)
				if(prob(1))
					M.hallucination = max(75, M.hallucination)
			if(4)
				if(prob(2))
					M.hallucination = max(75, M.hallucination)
				if(prob(0.5) && ishuman(M))
					var/mob/living/carbon/human/H = M
					var/affected_organ = pick("heart","lungs","liver","kidneys")
					var/datum/internal_organ/I =  H.internal_organs_by_name[affected_organ]
					I.damage += 5

		break

	if(!has_addiction)
		M.contract_disease(new /datum/disease/ultrazine_addiction, 1)

	if(prob(2))
		M.emote(pick("twitch","blink_r","shiver"))


/datum/reagent/ultrazine/on_overdose(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
		if(E)
			E.damage += 0.5
		if(prob(10))
			M.emote(pick("twitch", "blink_r", "shiver"))

/datum/reagent/ultrazine/on_overdose_critical(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
		if(E)
			E.damage += 2
		if(prob(25))
			M.emote(pick("twitch", "blink_r", "shiver"))

/datum/reagent/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	scannable = 1

/datum/reagent/cryoxadone/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(M.bodytemperature < 170)
		M.adjustCloneLoss(-1)
		M.adjustOxyLoss(-1)
		M.heal_limb_damage(1,1)
		M.adjustToxLoss(-1)

/datum/reagent/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	description = "A liquid compound similar to that used in the cloning process. Can be used to 'finish' the cloning process when used in conjunction with a cryo tube."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	scannable = 1

/datum/reagent/clonexadone/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(M.bodytemperature < 170)
		M.adjustCloneLoss(-3)
		M.adjustOxyLoss(-3)
		M.heal_limb_damage(3,3)
		M.adjustToxLoss(-3)

/datum/reagent/rezadone
	name = "Rezadone"
	id = "rezadone"
	description = "A powder derived from fish toxin, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	scannable = 1

/datum/reagent/rezadone/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(!data) data = 1
	data++
	switch(data)
		if(1 to 15)
			M.adjustCloneLoss(-1)
			M.heal_limb_damage(1,1)
		if(15 to 35)
			M.adjustCloneLoss(-2)
			M.heal_limb_damage(2,1)
			M.status_flags &= ~DISFIGURED
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				H.name = H.get_visible_name()
		if(35 to INFINITY)
			M.adjustToxLoss(1)
			M.make_dizzy(5)
			M.make_jittery(5)

/datum/reagent/rezadone/on_overdose(mob/living/M)
		M.apply_damage(2, TOX)

/datum/reagent/rezadone/on_overdose_critical(mob/living/M)
		M.apply_damage(3, TOX)

/datum/reagent/spaceacillin
	name = "Spaceacillin"
	id = "spaceacillin"
	description = "An all-purpose antiviral agent."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.01
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	scannable = 1

/datum/reagent/spaceacillin/on_overdose(mob/living/M)
	M.apply_damage(1, TOX)

/datum/reagent/spaceacillin/on_overdose_critical(mob/living/M)
	M.apply_damage(4, TOX)

/datum/reagent/ethylredoxrazine	// FUCK YOU, ALCOHOL
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	description = "A powerful oxidizer that reacts with ethanol."
	reagent_state = SOLID
	color = "#605048" // rgb: 96, 80, 72
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL

/datum/reagent/ethylredoxrazine/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.confused = 0
	M.reagents.remove_all_type(/datum/reagent/ethanol, REM, 0, 1)

/datum/reagent/ethylredoxrazine/on_overdose(mob/living/M)
	M.apply_damage(1, TOX)

/datum/reagent/ethylredoxrazine/on_overdose_critical(mob/living/M)
	M.apply_damage(4, TOX)

///////ANTIDEPRESSANTS///////

#define ANTIDEPRESSANT_MESSAGE_DELAY 5*60*10

/datum/reagent/antidepressant/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	description = "Improves the ability to concentrate."
	reagent_state = LIQUID
	color = "#C8A5DC"
	custom_metabolism = 0.01
	data = 0

/datum/reagent/antidepressant/methylphenidate/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(src.volume <= 0.1) if(data != -1)
		data = -1
		to_chat(M, "<span class='warning'>You lose focus.</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, SPAN_NOTICE("Your mind feels focused and undivided."))

/datum/reagent/antidepressant/citalopram
	name = "Citalopram"
	id = "citalopram"
	description = "Stabilizes the mind a little."
	reagent_state = LIQUID
	color = "#C8A5DC"
	custom_metabolism = 0.01
	data = 0

/datum/reagent/antidepressant/citalopram/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(volume <= 0.1) if(data != -1)
		data = -1
		to_chat(M, "<span class='warning'>Your mind feels a little less stable...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, SPAN_NOTICE("Your mind feels stable.. a little stable."))


/datum/reagent/antidepressant/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	description = "Stabilizes the mind greatly, but has a chance of adverse effects."
	reagent_state = LIQUID
	color = "#C8A5DC"
	custom_metabolism = 0.01
	data = 0

/datum/reagent/antidepressant/paroxetine/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(volume <= 0.1) if(data != -1)
		data = -1
		to_chat(M, "<span class='warning'>Your mind feels much less stable...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			if(prob(90))
				to_chat(M, SPAN_NOTICE("Your mind feels much more stable."))
			else
				to_chat(M, "<span class='warning'>Your mind breaks apart...</span>")
				M.hallucination += 200

/datum/reagent/antized
	name = "Anti-Zed"
	id = "antiZed"
	description = "Destroy the zombie virus in living humans and prevents regeneration for those who have already turned."
	reagent_state = LIQUID
	color = "#C8A5DC"
	custom_metabolism = 0.01
	data = 0

/datum/reagent/antized/on_mob_life(mob/living/carbon/human/M)
	M.regenZ = 0
	. = ..()
