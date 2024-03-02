extends Spatial
const name_weapon="knife"
const damage = 400

const idle_ani = "Knife_idle"
const fire_ani = "Knife_fire"

var ammo_in_weapon = 1
var spare_ammo = 1
const AMMO_IN_MAG = 1

const can_reload= false
const can_refill= false

const RELOADING_ANI="Knife_reload"


var isWeaponEnabled=false
var playerNode=null

func _ready() -> void:
	pass # Replace with function body.
	
func fireWeapon():
	var area=$Area
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body ==playerNode:
			continue
		if body.has_method("bullet_hit"):
			body.bullet_hit(damage, area.global_transform)



func equipWeapon():
	if playerNode.animation_manager.current_state==idle_ani:
		return false
	if playerNode.animation_manager.current_state=="Idle_unarmed":
		isWeaponEnabled=true
		playerNode.animation_manager.set_animation("Knife_equip")
		return true


func unequipWeapon():
	if playerNode.animation_manager.current_state ==idle_ani:
		playerNode.animation_manager.set_animation("Knife_unequip")

	if playerNode.animation_manager.current_state=="Idle_unarmed":
		isWeaponEnabled= false
		return true
	return false
	

func reload_weapon():
	return false




