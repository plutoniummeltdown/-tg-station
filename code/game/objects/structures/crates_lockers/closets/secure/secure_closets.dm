/obj/structure/closet/secure_closet
	name = "secure locker"
	desc = "It's a card-locked storage unit."
	icon = 'icons/obj/closet.dmi'
	icon_state = "secure1"
	density = 1
	opened = 0
	locked = 1
	icon_closed = "secure"
	var/icon_locked = "secure1"
	icon_opened = "secureopen"
	var/icon_broken = "securebroken"
	var/icon_off = "secureoff"
	var/panel = 0
	wall_mounted = 0 //never solid (You can always pass over it)
	health = 200

/obj/structure/closet/secure_closet/can_open()
	if(src.locked || src.welded)
		return 0
	return 1

/obj/structure/closet/secure_closet/close()
	..()
	if(broken)
		icon_state = src.icon_off
	return 1

/obj/structure/closet/secure_closet/emp_act(severity)
	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken)
		if(prob(50/severity))
			src.locked = !src.locked
			src.update_icon()
		if(prob(20/severity) && !opened)
			if(!locked)
				open()
			else
				src.req_access = list()
				src.req_access += pick(get_all_accesses())
	..()

/obj/structure/closet/secure_closet/proc/togglelock(mob/user as mob)
	if(src.allowed(user))
		src.locked = !src.locked
		add_fingerprint(user)
		for(var/mob/O in viewers(user, 3))
			if((O.client && !( O.blinded )))
				O << "<span class='notice'>The locker has been [locked ? null : "un"]locked by [user].</span>"
		if(src.locked)
			src.icon_state = src.icon_locked
		else
			src.icon_state = src.icon_closed
	else
		user << "<span class='notice'>Access Denied</span>"

/obj/structure/closet/secure_closet/place(var/mob/user, var/obj/item/I)
	if(!src.opened)
		togglelock(user)
		return 1
	return 0

/obj/structure/closet/secure_closet/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/screwdriver))
		if(welded == 1)
			user << "<span class='warning'>It's welded shut!</span>"
			return
		else
			src.add_fingerprint(user)
			panel = !panel
			// this part is super sloppy but idk
			if(!panel) // if the panel is now closed
				if(!broken)
					overlays -= "hacking"
				else
					overlays -= "hackingsparks"
				user << "<span class='notice'>You close the locking mechanism's panel on the locker.</span>"
			else
				if(!broken)
					overlays += "hacking"
				else
					overlays += "hackingsparks"
				user << "<span class='notice'>You open the locking mechanism's panel on the locker.</span>"
			return
	else if(src.panel && istype(W, /obj/item/device/multitool))
		src.add_fingerprint(user)
		playsound(src.loc, 'sound/machines/twobeep.ogg', 150, 1)
		if(!broken)
			user << "<span class='danger'>You begin hacking the locker open. (This action will take 20 seconds to complete.)</span>"
			if(do_after(user,200) && panel) // makes sure that the user stays in place and does not close the panel
				overlays -= "hacking"
				overlays += "hackingsparks"
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(5, 1, src)
				s.start()
				broken = 1
				locked = 0
				desc = "It appears to be broken."
				for(var/mob/O in viewers(user, 3))
					O.show_message("<span class='warning'>The locker has been broken by [user] with a multitool!</span>", 1, "You hear a faint electrical spark.", 2)
				icon_state = icon_off
		else
			user << "<span class='danger'>You begin repairing the broken locker. (This action will take 30 seconds to complete.)</span>"
			if(do_after(user,300) && panel) // longer than hacking it open for reasons
				overlays -= "hackingsparks"
				overlays += "hacking"
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(5, 1, src)
				s.start()
				broken = 0
				locked = 0	// the locker stays unlocked after it's been fixed, which should be noticable to anyone who's paying attention (read: nobody at all)
				desc = "It's a card-locked storage unit."
				for(var/mob/O in viewers(user, 3))
					O.show_message("<span class='warning'>The locker has been repaired by [user] with a multitool!</span>", 1, "You hear a faint electrical spark.", 2)
				icon_state = icon_closed
		return
	else if(src.panel)
		user << "<span class='notice'>You cannot do that while the locker's panel is open!</span>"
		return
	else if(!src.opened && src.broken)
		user << "<span class='notice'>The locker appears to be broken.</span>"
		return
	else if((istype(W, /obj/item/weapon/card/emag)||istype(W, /obj/item/weapon/melee/energy/blade)) && !src.broken)
		broken = 1
		locked = 0
		desc = "It appears to be broken."
		icon_state = icon_off
		flick(icon_broken, src)
		if(istype(W, /obj/item/weapon/melee/energy/blade))
			var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
			spark_system.set_up(5, 0, src.loc)
			spark_system.start()
			playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
			playsound(src.loc, "sparks", 50, 1)
			for(var/mob/O in viewers(user, 3))
				O.show_message("<span class='warning'>The locker has been sliced open by [user] with an energy blade!</span>", 1, "You hear metal being sliced and sparks flying.", 2)
		else
			for(var/mob/O in viewers(user, 3))
				O.show_message("<span class='warning'>The locker has been broken by [user] with an electromagnetic card!</span>", 1, "You hear a faint electrical spark.", 2)
	else
		..(W, user)

/obj/structure/closet/secure_closet/relaymove(mob/user as mob)
	if(user.stat || !isturf(src.loc))
		return

	if(!(src.locked))
		open()
	else
		user << "<span class='notice'>The locker is locked!</span>"
		if(world.time > lastbang+5)
			lastbang = world.time
			for(var/mob/M in get_hearers_in_view(src, null))
				M.show_message("<FONT size=[max(0, 5 - get_dist(src, M))]>BANG, bang!</FONT>", 2)
	return

/obj/structure/closet/secure_closet/attack_hand(mob/user as mob)
	src.add_fingerprint(user)

	if(panel)
		user << "<span class='notice'>You cannot do that while the locker's panel is open!</span>"
		return
	if(!src.toggle())
		return src.attackby(null, user)

/obj/structure/closet/secure_closet/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/closet/secure_closet/verb/verb_togglelock()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Toggle Lock"

	if(!usr.canmove || usr.stat || usr.restrained()) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return

	if(get_dist(usr, src) != 1)
		return

	if(src.broken)
		return

	if (ishuman(usr))
		if (!opened)
			togglelock(usr)
	else
		usr << "<span class='warning'>This mob type can't use this verb.</span>"

/obj/structure/closet/secure_closet/update_icon()//Putting the welded stuff in updateicon() so it's easy to overwrite for special cases (Fridges, cabinets, and whatnot)
	overlays.Cut()
	if(!opened)
		if(locked)
			icon_state = icon_locked
		else
			icon_state = icon_closed
		if(welded)
			overlays += "welded"
		if(panel)
			if(broken)
				overlays += "hackingsparks"
			else
				overlays += "hacking"
	else
		icon_state = icon_opened