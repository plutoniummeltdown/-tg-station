/obj/structure/sign
	icon = 'icons/obj/decals.dmi'
	anchored = 1
	opacity = 0
	density = 0
	layer = 3.5

/obj/structure/sign/attackby(obj/item/I, var/mob/M)
	if(istype(I,/obj/item/weapon/screwdriver) && !M.stat)
		if(do_after(M,10))
			anchored = !anchored
			M << "You [anchored?"secure":"loosen"] \the [src] sign."


/obj/structure/sign/MouseDrop(var/atom/over)
	if(!anchored)
		step_to(src, over)

/obj/structure/sign/Move()
	if(!anchored)
		pixel_x = 0
		pixel_y = 0
	. = ..()

/obj/structure/sign/Bump(atom/A)
	if(istype(A,/turf/simulated/wall))
		switch(get_dir(src,A))
			if(NORTH)
				if(pixel_y != 32)
					pixel_y = 32
				else
					loc = A
					visible_message("\The [src] sign is now prominently affixed to [A].")
					pixel_y = 0
			if(SOUTH)
				if(pixel_y != -32)
					pixel_y = -32
				else
					loc = A
					visible_message("\The [src] sign is now prominently affixed to [A].")
					pixel_y = 0
			if(EAST)
				if(pixel_x != 32)
					pixel_x = 32
				else
					loc = A
					visible_message("\The [src] sign is now prominently affixed to [A].")
					pixel_x = 0
			if(WEST)
				if(pixel_x != -32)
					pixel_x = -32
				else
					loc = A
					visible_message("\The [src] sign is now prominently affixed to [A].")
					pixel_x = 0

/obj/structure/sign/ex_act(severity,specialty)
	qdel(src)

/obj/structure/sign/blob_act()
	qdel(src)
	return


/obj/structure/sign/map
	name = "station map"
	desc = "A framed picture of the station."

/obj/structure/sign/map/left
	icon_state = "map-left"

/obj/structure/sign/map/right
	icon_state = "map-right"

/obj/structure/sign/securearea
	name = "\improper SECURE AREA"
	desc = "A warning sign which reads 'SECURE AREA'."
	icon_state = "securearea"

/obj/structure/sign/biohazard
	name = "\improper BIOHAZARD"
	desc = "A warning sign which reads 'BIOHAZARD'"
	icon_state = "bio"

/obj/structure/sign/electricshock
	name = "\improper HIGH VOLTAGE"
	desc = "A warning sign which reads 'HIGH VOLTAGE'"
	icon_state = "shock"

/obj/structure/sign/examroom
	name = "\improper EXAM ROOM"
	desc = "A guidance sign which reads 'EXAM ROOM'"
	icon_state = "examroom"

/obj/structure/sign/vacuum
	name = "\improper HARD VACUUM AHEAD"
	desc = "A warning sign which reads 'HARD VACUUM AHEAD'"
	icon_state = "space"

/obj/structure/sign/deathsposal
	name = "\improper DISPOSAL: LEADS TO SPACE"
	desc = "A warning sign which reads 'DISPOSAL: LEADS TO SPACE'"
	icon_state = "deathsposal"

/obj/structure/sign/pods
	name = "\improper ESCAPE PODS"
	desc = "A warning sign which reads 'ESCAPE PODS'"
	icon_state = "pods"

/obj/structure/sign/fire
	name = "\improper DANGER: FIRE"
	desc = "A warning sign which reads 'DANGER: FIRE'"
	icon_state = "fire"


/obj/structure/sign/nosmoking_1
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'"
	icon_state = "nosmoking"


/obj/structure/sign/nosmoking_2
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'"
	icon_state = "nosmoking2"

/obj/structure/sign/bluecross
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here.'"
	icon_state = "bluecross"

/obj/structure/sign/bluecross_2
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here.'"
	icon_state = "bluecross2"

/obj/structure/sign/goldenplaque
	name = "The Most Robust Men Award for Robustness"
	desc = "To be Robust is not an action or a way of life, but a mental state. Only those with the force of Will strong enough to act during a crisis, saving friend from foe, are truly Robust. Stay Robust my friends."
	icon_state = "goldenplaque"

/obj/structure/sign/kiddieplaque
	name = "AI developers plaque"
	desc = "Next to the extremely long list of names and job titles, there is a drawing of a little child. The child appears to be retarded. Beneath the image, someone has scratched the word \"PACKETS\""
	icon_state = "kiddieplaque"

/obj/structure/sign/atmosplaque
	name = "\improper FEA Atmospherics Division plaque"
	desc = "This plaque commemorates the fall of the Atmos FEA division. For all the charred, dizzy, and brittle men who have died in its hands."
	icon_state = "atmosplaque"

/obj/structure/sign/maltesefalcon	//The sign is 64x32, so it needs two tiles. ;3
	name = "The Maltese Falcon"
	desc = "The Maltese Falcon, Space Bar and Grill."

/obj/structure/sign/maltesefalcon/left
	icon_state = "maltesefalcon-left"

/obj/structure/sign/maltesefalcon/right
	icon_state = "maltesefalcon-right"

/obj/structure/sign/science			//These 3 have multiple types, just var-edit the icon_state to whatever one you want on the map
	name = "\improper SCIENCE!"
	desc = "A warning sign which reads 'SCIENCE!'"
	icon_state = "science1"

/obj/structure/sign/chemistry
	name = "\improper CHEMISTRY"
	desc = "A warning sign which reads 'CHEMISTRY'"
	icon_state = "chemistry1"

/obj/structure/sign/botany
	name = "\improper HYDROPONICS"
	desc = "A warning sign which reads 'HYDROPONICS'"
	icon_state = "hydro1"