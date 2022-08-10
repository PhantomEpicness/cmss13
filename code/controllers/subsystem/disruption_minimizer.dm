/*
The disruption monitor

	This Subsystem monitors the server for mass disconnection type events.
	It checks every time period defined by DISRUPTION_CHECK, comparing the player count between the last count and the current one.area
	If the count is below a percentage defined by DISRUPTION_THRESHOLD, then a major server disruption is declared.

	This also features a lowpop cutoff, meaning that if population goes below the amount, it will disable the checks until pop is good.

	Note that this system is not foolproof is only intended to check for major disruptions where a large percentage of the server's pop suddenly
	disconnects.

	In DDOS attack situations, this subsystem needs to be turned off as mass disconnects are common during one and this would only further disrupt play.area

	In addition, it is also theoretically possible for a potential attacker to flood the server with fake accounts, then have them leave in order
	to cause a "false alarm" and disrupt gameplay, technically creating a DDOS attack situation. (though if they could create botted BYOND accounts, they could simply have them mass join the server instead.)



*/
#define DISRUPTION_CHECK 				10 SECONDS		//10 minutes in ticks (approx.)
#define CLIENT_SLEEP_TIME 				1 MINUTES		// how long clients should be aslept in a disruption event
#define DISRUPTION_THRESHOLD_FACTOR 	4  				// What fraction of the server's clients need to be disrupted before a major disruption is called.
#define DISRUPTION_POP_CUTOFF			30				// minimum pop to disable this system
#define DISRUPTION_POP_CUTOFF_TIMER		5 MINUTES		// how long we should start checking again after the pop cutoff was triggered

SUBSYSTEM_DEF(disruption_moniter)
	name = "Disruption Moniter"
	wait = DISRUPTION_CHECK
	flags = SS_NO_INIT | SS_BACKGROUND | SS_DISABLE_FOR_TESTING
	priority = SS_PRIORITY_INACTIVITY
	runlevels = RUNLEVEL_GAME
	var/last_count = 0
	var/disable_check = FALSE

/datum/controller/subsystem/disruption_moniter/fire(resumed = FALSE)
	var/cur_count = 0
	for(var/i in GLOB.clients) // if it hasn't changed, then recount
		cur_count++
	if((last_count / DISRUPTION_THRESHOLD_FACTOR) < (last_count - cur_count))


	if(last_count <  DISRUPTION_POP_CUTOFF && cur_count <  DISRUPTION_POP_CUTOFF && disable_check = FALSE)
		disable_check == TRUE
		log_game("Disruption monitor pop threshold too low! Postponing next check for [(DISRUPTION_POP_CUTOFF_TIMER * 10)/60] minutes")
	else
		last_count = cur_count
	var/client/C = i
			if(C.admin_holder && C.admin_holder.rights & R_ADMIN) //Skip admins.
				to_chat_forced(C, SPAN_HIGH_WARNING("Mass server disconnection detected! All clients have been slept for [CLIENT_SLEEP_TIME * 10] seconds in order to allow sufficient time to reconnect."))
			if (C.is_afk(INACTIVITY_KICK))
				if (!istype(C.mob, /mob/dead))
					log_access("AFK: [key_name(C)]")
					to_chat_immediate(world, SPAN_HIGH_WARNING("Mass server disconnection detected! In order to maintain minimum disruption for the game, all players have been slept for [CLIENT_SLEEP_TIME * 10] seconds in order to allow sufficient time to reconnect! Admins have been notified and may resume the game if needed. Please contact them if you were stuck in an unfortunate position (ea: fire) and were killed due to this."))
					qdel(C)
