extends Spatial
const name_weapon = "pistol"
const damage = 15
const idle_ani = "Pistol_idle"
const fire_ani = "Pistol_fire"

var ammo_in_weapon = 3
var spare_ammo = 6
var ammo_in_mag = 3
var can_reload = true
var is_reloading = false
var can_refill= true


const RELOADING_ANI = "Pistol_reload"

var isWeaponEnabled = false

var bullet = load("Bullet.tscn")

var playerNode = null

func _ready():
	pass
func fireWeapon():
	playerNode.create_sound("pistol_shot", self.global_transform.origin)

	var clone = bullet.instance()
	ammo_in_weapon -= 1
	var root = get_tree().root.get_children()[0]
	root.add_child(clone)
	
	clone.global_transform = self.global_transform
	clone.scale = Vector3(1, 1, 1)
	clone.bulletDamage = damage
	
func equipWeapon():
	if playerNode.animation_manager.current_state == idle_ani:
		return false
	if playerNode.animation_manager.current_state == "Idle_unarmed":
		isWeaponEnabled = true
		playerNode.animation_manager.set_animation("Pistol_equip")
		return true
func unequipWeapon():
	if playerNode.animation_manager.current_state == idle_ani:
		playerNode.animation_manager.set_animation("Pistol_unequip")
	
	if playerNode.animation_manager.current_state == "Idle_unarmed":
		isWeaponEnabled = false
		return true
	return false
	
func reload_weapon():
	
	can_reload = false

	if playerNode.animation_manager.current_state == idle_ani:
		can_reload = true

	if spare_ammo <= 0 or ammo_in_weapon == ammo_in_mag:
		can_reload = false
	if can_reload == true:
		playerNode.create_sound("pistol_reload", self.global_transform.origin)

		var ammo_needed = ammo_in_mag - ammo_in_weapon

		if spare_ammo >= ammo_needed:
			spare_ammo -= ammo_needed
			ammo_in_weapon = ammo_in_mag
		else:
			ammo_in_weapon += spare_ammo
			spare_ammo = 0
			
		playerNode.animation_manager.set_animation(RELOADING_ANI)

		return true

	can_reload = true
	return false
	
func reset_weapon():
	ammo_in_weapon=10
	spare_ammo=20
