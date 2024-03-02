extends KinematicBody

const gravity=  30
var vel = Vector3(0, 0,0 )
const maxSpeed= 30
const jumpSpeed= 42
const accel= 4.5
var dir=Vector3()
const deaccel= 16
const maxSlopeAngle= 40
onready var camera= $Rotation_Helper/Camera
onready var rotationHelper= $Rotation_Helper

var animation_manager
var current_weapon_name= "unarmed"
var weapons ={"unarmed": null, "knife": null, "pistol": null, "rifle": null}
const weapon_number_to_name = {0:"unarmed", 1: "knife", 2: "pistol", 3: 'rifle'}
const weapon_name_to_number = {"unarmed": 0, "knife": 1, "pistol": 2, "rifle": 3}

var isVisible= true
var changing_weapon=false
var changing_weapon_name="unarmed"
var health=100
var UI_status_label
var jumping=false
var reloading_weapon= false

var fire= false



onready var flash_light= $Rotation_Helper/FlashLight

var sensitivity=0.1
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	animation_manager= $Rotation_Helper/Model/AnimationPlayer
	animation_manager.callbackFunc= funcref(self, "fire_bullet")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	weapons["knife"] = $Rotation_Helper/Gun_Fire_Points/Knife_Point
	weapons["pistol"] = $Rotation_Helper/Gun_Fire_Points/Pistol_Point
	weapons["rifle"]= $Rotation_Helper/Gun_Fire_Points/Rifle_Point
	
	var gun_aim_point_pos= $Rotation_Helper/Gun_Aim_Point.global_transform.origin
	for weapon in weapons:
		var weapon_node = weapons[weapon]
		if weapon_node !=null:
			weapon_node.playerNode=self
			weapon_node.look_at(gun_aim_point_pos, Vector3(0, 1, 0))
			weapon_node.rotate_object_local(Vector3(0, 1, 0), deg2rad(180))
	current_weapon_name ="unarmed"
	changing_weapon_name="unarmed"
	UI_status_label = $HUD/Panel/Gun_label
	
	pass

	

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	process_changing_weapon(delta)
	process_reloading(delta)
	processUI()

func process_input(delta):
	var weapon_change_number =weapon_name_to_number[current_weapon_name]
	if Input.is_key_pressed(KEY_1):
		weapon_change_number=0
	if Input.is_key_pressed(KEY_2):
		weapon_change_number=1
	if Input.is_key_pressed(KEY_3):
		weapon_change_number=2
	if Input.is_key_pressed(KEY_4):
		weapon_change_number=3
	
	weapon_change_number = clamp(weapon_change_number, 0, weapon_number_to_name.size()-1)

	if changing_weapon==false:
		if reloading_weapon == false:
			if weapon_number_to_name[weapon_change_number]!=current_weapon_name:
				changing_weapon_name= weapon_number_to_name[weapon_change_number]
				changing_weapon=true
				pass
	if Input.is_action_pressed("fire"):
		if changing_weapon==false:
			if reloading_weapon==false:
				var current_weapon= weapons[current_weapon_name]
				if current_weapon!=null:
					if current_weapon.ammo_in_weapon>0:
						if animation_manager.current_state== current_weapon.idle_ani:
							animation_manager.set_animation(current_weapon.fire_ani)
							fire_bullet()
					else:
						reloading_weapon=true
	if !reloading_weapon:
		if changing_weapon ==false:
			if Input.is_action_just_pressed("reload"):
				var current_weapon= weapons[current_weapon_name]
				print("Before: ", current_weapon.can_reload)
				if current_weapon!=null:
					if current_weapon.can_reload== true:
						var current_ani_state= animation_manager.current_state
						var is_reloading= false
						for weapon in weapons:
							var weapon_node= weapons[weapon]
							if weapon_node!=null:
								if current_ani_state== weapon_node.RELOADING_ANI:
									is_reloading=true
						if is_reloading==false:
							print("reload! R")
							reloading_weapon=true





	dir = Vector3()
	var cam_xform= camera.get_global_transform()
	var movement= Vector2()
	if Input.is_action_pressed("ui_up"):
		movement.y-=1
	if Input.is_action_pressed("ui_down"):
		movement.y+=1
	if Input.is_action_pressed("ui_left"):
		movement.x-=1
	if Input.is_action_pressed("ui_right"):
		movement.x+=1
	movement = movement.normalized()
	dir +=cam_xform.basis.z * movement.y
	dir += cam_xform.basis.x * movement.x
	dir.y-=1
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			vel.y= jumpSpeed
			jumping= true
		else: 
			jumping = false
		if Input.is_action_just_pressed("ui_cancel"):
			if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				
func process_movement(delta):
	dir.y=0
	dir = dir.normalized()
	if jumping:

		vel.y-=1.5
	else:
		vel.y=-gravity
	var hvel= vel
	hvel.y=0
	var target = dir
	target *= maxSpeed
	var acc
	if dir.dot(hvel)>0:
		acc=accel
	else:
		acc = deaccel
	hvel  = hvel.linear_interpolate(target, acc*delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), false, 4, deg2rad(maxSlopeAngle))
	
func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE:
			get_tree().quit()
		if event.scancode == KEY_Z:
			if isVisible:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				isVisible=false
		if event.scancode == KEY_X:
			if !isVisible:
				isVisible=true
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

			
	if event is InputEventMouseMotion and Input.get_mouse_mode()== Input.MOUSE_MODE_CAPTURED:
		rotationHelper.rotate_x(deg2rad(event.relative.y*sensitivity))
		self.rotate_y(deg2rad(-event.relative.x*sensitivity))
		
		var cameraRot= rotationHelper.rotation_degrees
		cameraRot.x= clamp(cameraRot.x, -70, 70)
		rotationHelper.rotation_degrees = cameraRot
		
func process_changing_weapon(delta):
	if changing_weapon ==true:
		var weapon_unequipped= false
		var current_weapon =weapons[current_weapon_name]
		if current_weapon==null:
			current_weapon= weapons[changing_weapon_name]
		if true:
			if current_weapon.isWeaponEnabled== true:
				weapon_unequipped =current_weapon.unequipWeapon()
			else:
				weapon_unequipped =true
			if weapon_unequipped==true:
				var weapon_equipped= false
				var weapon_to_equip =weapons[changing_weapon_name]

				if weapon_to_equip == null:
					weapon_equipped = true
				else:
					if weapon_to_equip.isWeaponEnabled==false:
						weapon_equipped = weapon_to_equip.equipWeapon()
					else:
						weapon_equipped= true
				if weapon_equipped == true:
					changing_weapon =false
					current_weapon_name= changing_weapon_name
					changing_weapon_name= ""


func fire_bullet():
	if changing_weapon == true:
		return 
	weapons[current_weapon_name].fireWeapon()

func processUI():
	if current_weapon_name=="unarmed" or current_weapon_name=="knife":
		UI_status_label.text="Heath: "+ str(health)
	else:
		var current_weapon= weapons[current_weapon_name]
		UI_status_label.text= "Heath: "+ str(health)
		UI_status_label.text+= "\n Ammo: "+ str(current_weapon.ammo_in_weapon)
		UI_status_label.text+="\n Spare ammo: "+ str(current_weapon.spare_ammo)


func process_reloading(delta):
	if reloading_weapon == true:
		var current_weapon = weapons[current_weapon_name]
		if current_weapon != null:
			current_weapon.reload_weapon()
		reloading_weapon = false

