extends Spatial



export (bool) var use_raycast= false

const turret_damage_bullet=20
const turret_damage_raycast=5

var flash_timer=0
const flash_time=0.1


const fire_time=0.8
var fire_timer=0

var node_turret_head:Spatial=null
var node_raycast:RayCast=null
var node_flash_one:MeshInstance=null
var node_flash_two:MeshInstance=null

const ammo_in_full_turret=20
var ammo_in_turret=ammo_in_full_turret

const ammo_reload_time=4
var ammo_reload_timer=ammo_reload_time

var current_target=null

var is_active=false

const player_height=3


var smoke_particles
const max_turret_health=300.0
var turret_health=max_turret_health


const destroyed_time=5
var destroyed_timer=destroyed_time
var bullet_scene=preload("res://Bullet.tscn")

func _ready():
	$Vision_Area.connect("body_entered", self, "body_entered_vision")
	$Vision_Area.connect("body_exited", self, "body_entered_vision")

	node_turret_head=$Head
	node_raycast=$Head/Ray_Cast
	node_flash_one= $Head/Flash
	node_flash_two= $Head/Flash_2

	node_raycast.add_exception($Base/Static_Body)
	node_raycast.add_exception($Head/Static_Body)
	node_raycast.add_exception($Vision_Area)

	node_flash_one.visible=false
	node_flash_two.visible=false

	smoke_particles=$Smoke
	smoke_particles.emitting=false

	turret_health=max_turret_health

func _physics_process(delta):

	if is_active==true:
		$Head/HP_col.scale=(Vector3(turret_health/max_turret_health, 1, 1))
		if flash_timer>=0:
			flash_timer-=delta
			if flash_timer<=0:
				node_flash_one.visible=false
				node_flash_two.visible=false
		if current_target!=null:
			if $Head/HP_col.scale.x<=0:
				$Head/HP_col.visible=false
			
			if turret_health>0:
				
				node_turret_head.look_at(current_target.global_transform.origin+Vector3(0, player_height, 0), Vector3(0, 1, 0))
				if ammo_in_turret>0:
					if fire_timer>0:
						fire_timer-=delta
					else:
						fire_bullet()
				else:
					if ammo_reload_timer>0:
						ammo_reload_timer-=delta
					else:
						ammo_in_turret= ammo_in_full_turret
						ammo_reload_timer=ammo_reload_time
	if turret_health<=0:
		if destroyed_timer>=0:
			destroyed_timer-=delta
			smoke_particles.emitting=true
		else:
			turret_health=max_turret_health
			smoke_particles.emitting=false
			destroyed_timer=destroyed_time
			$Head/HP_col.visible=true


func fire_bullet():
	if !use_raycast:
		var clone= bullet_scene.instance()
		var scene_root= get_tree().root.get_children()[0]
		scene_root.add_child(clone)
		clone.global_transform= $Head/Barrel_End.global_transform
		clone.scale=Vector3(8, 8, 8)
		clone.bulletDamage=60
		clone.sender=self
		ammo_in_turret-=1
			
	else:
#		node_raycast.look_at(current_target.global_transform+player_height, Vector3(0, 1, 0))
		node_raycast.force_raycast_update()
		if node_raycast.is_colliding():
			var body=node_raycast.get_collider()
			if body.has_method("bullet_hit"):
				body.bullet_hit(turret_damage_raycast, node_raycast.get_collision_point())
		ammo_in_turret-=1

	node_flash_one.visible=true
	node_flash_two.visible=true

	flash_timer=flash_time
	fire_timer=fire_time


func body_entered_vision(body):
	if current_target==null:
		if body is KinematicBody:
			current_target=body
			is_active=true

func bullet_hit(damage, bullet_hit_pos):
	if is_active:
		
		if turret_health>0:
			turret_health-=damage


func _on_Vision_Area_body_exited(body):
	if current_target!=null:
		if body== current_target:
			current_target=null
			is_active=false
			flash_timer=0
			fire_timer=0
			node_flash_one.visible=false
			node_flash_two.visible=false
