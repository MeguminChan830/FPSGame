extends Spatial

const damage= 4
const idle_ani = "Rifle_idle"
const fire_ani = "Rifle_fire"
const name_weapon="rifle"

var ammo_in_weapon = 50
var spare_ammo = 100
const ammo_in_mag = 50
var can_reload =true


const RELOADING_ANI= "Rifle_reload"


var  isWeaponEnabled =false
var playerNode=null
func _ready():
	pass
func fireWeapon():
	playerNode.create_sound("rifle_shot", self.global_transform.origin)

	var ray = $RayCast
	ammo_in_weapon-=1
	ray.force_raycast_update()
	if ray.is_colliding():
		var body= ray.get_collider()
		if body==playerNode:
			pass
		elif body.has_method("bullet_hit"):
			body.bullet_hit(damage, ray.global_transform)
func equipWeapon():
	if playerNode.animation_manager.current_state== idle_ani:
		isWeaponEnabled =true
		return true
	if playerNode.animation_manager.current_state=="Idle_unarmed":
		playerNode.animation_manager.set_animation("Rifle_equip")
	return false
func unequipWeapon():
	if playerNode.animation_manager.current_state==idle_ani:
		playerNode.animation_manager.set_animation("Rifle_unequip")
	if playerNode.animation_manager.current_state== "Idle_unarmed":
		isWeaponEnabled= false
	return false
func reload_weapon():
	can_reload = false		

	if playerNode.animation_manager.current_state == idle_ani:
		can_reload = true

	if spare_ammo <=0 or ammo_in_weapon == ammo_in_mag:
		can_reload = false
	if can_reload == true:
		playerNode.create_sound("rifle_reload", self.global_transform.origin)
		var ammo_needed = ammo_in_mag - ammo_in_weapon

		if spare_ammo >= ammo_needed:
			spare_ammo -= ammo_needed
			ammo_in_weapon = ammo_in_mag
		else:
			ammo_in_weapon += spare_ammo
			spare_ammo = 0
		playerNode.animation_manager.set_animation(RELOADING_ANI)

		return true
	can_reload= true
	return false



