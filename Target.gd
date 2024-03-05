extends Spatial


const target_health=40
var current_health=40

var broken_target_holder 

onready var target_collision_shape= $Collision_Shape

const target_respawn_time= 14
var target_respawn_timer =0

export (PackedScene ) var destroyed_target 
func _ready():
	broken_target_holder = get_parent().get_node("Broken_Target_Holder")
	
func _physics_process(delta):
	if target_respawn_timer>0:
		target_respawn_timer-=delta
		if target_respawn_timer<=0:
			for child in broken_target_holder.get_children():
				child.queue_free()
			target_collision_shape.disabled= false
			visible=true
			current_health= target_health
func bullet_hit(damage, bullet_transform):
	destroyed_target= load("res://Broken_Target.tscn")
	current_health-=damage
	if current_health<=0:
		var clone = destroyed_target.instance()
		broken_target_holder.add_child(clone)
		for rigid in clone.get_children():
			if rigid is RigidBody:
				var direction = (rigid.transform.origin).normalized()
				rigid.apply_impulse(Vector3(0, 0,0), direction * 120 * damage)
			target_respawn_timer= target_respawn_time
			target_collision_shape.disabled=true
			visible=false
