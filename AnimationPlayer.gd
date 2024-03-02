extends AnimationPlayer

#
var states = {
    "Idle_unarmed":["Knife_equip", "Pistol_equip", "Rifle_equip", "Idle_unarmed"],

    "Pistol_equip":["Pistol_idle"],
    "Pistol_fire":["Pistol_idle"],
    "Pistol_idle":["Pistol_fire", "Pistol_reload", "Pistol_unequip", "Pistol_idle"],
    "Pistol_reload":["Pistol_idle"],
    "Pistol_unequip":["Idle_unarmed"],

    "Rifle_equip":["Rifle_idle"],
    "Rifle_fire":["Rifle_idle"],
    "Rifle_idle":["Rifle_fire", "Rifle_reload", "Rifle_unequip", "Rifle_idle"],
    "Rifle_reload":["Rifle_idle"],
    "Rifle_unequip":["Idle_unarmed"],

    "Knife_equip":["Knife_idle"],
    "Knife_fire":["Knife_idle"],
    "Knife_idle":["Knife_fire", "Knife_unequip", "Knife_idle"],
    "Knife_unequip":["Idle_unarmed"],
}

var animation_speeds = {
    "Idle_unarmed":1,

    "Pistol_equip":1.4,
    "Pistol_fire":1.8,
    "Pistol_idle":1,
    "Pistol_reload":1,
    "Pistol_unequip":1.4,

    "Rifle_equip":2,
    "Rifle_fire":6,
    "Rifle_idle":1,
    "Rifle_reload":1.45,
    "Rifle_unequip":2,

    "Knife_equip":1,
    "Knife_fire":1.35,
    "Knife_idle":1,
    "Knife_unequip":1,
}
var current_state = null
var callbackFunc = null
func _ready():
#	set_animation("Idle_unarmed")
	set_animation("Idle_unarmed")
	connect("animation_finished", self, "animation_ended")
	pass

func set_animation(name):
	if name == current_state:
		print("ALready have")
		return true
	if has_animation(name):
		if current_state!=null:
			var possibleAni = states[current_state]
			if name in possibleAni:
				current_state = name
				play(name, -1, animation_speeds[name])
				return true
			else: 
				return false
		else:
			current_state=name
			play(name, -1, animation_speeds[name])
			return true
	return false

func animation_ended(anim_name):
	if current_state == "Idle_unarmed":
		pass
	# KNIFE transitions
	elif current_state == "Knife_equip":
		set_animation("Knife_idle")
	elif current_state == "Knife_idle":
		pass
	elif current_state == "Knife_fire":
		set_animation("Knife_idle")
	elif current_state == "Knife_unequip":
		set_animation("Idle_unarmed")
	# PISTOL transitions
	elif current_state == "Pistol_equip":
		set_animation("Pistol_idle")
	elif current_state == "Pistol_idle":
		pass
	elif current_state == "Pistol_fire":
		set_animation("Pistol_idle")
	elif current_state == "Pistol_unequip":
		set_animation("Idle_unarmed")
	elif current_state == "Pistol_reload":
		set_animation("Pistol_idle")
	# RIFLE transitions
	elif current_state == "Rifle_equip":
		set_animation("Rifle_idle")
	elif current_state == "Rifle_idle":
		pass;
	elif current_state == "Rifle_fire":
		set_animation("Rifle_idle")
	elif current_state == "Rifle_unequip":
		set_animation("Idle_unarmed")
	elif current_state == "Rifle_reload":
		set_animation("Rifle_idle")

func callback():
	if callbackFunc== null:
		print("No callback")
	else:
		callbackFunc.call_func()
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
