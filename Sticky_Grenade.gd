extends RigidBody





const damage= 40
const time = 2
var timer= 0

const explosion_wait_time=0.48
var explosion_wait_timer= 0
var attached= false
var attach_point= null

var rigid_shape:CollisionShape
var grenade_mesh:MeshInstance

var blast_area:Area
var explosion_particles:CPUParticles
var player_body: KinematicBody

func _ready():
	rigid_shape=$Collision_Shape
	grenade_mesh=$Sticky_Grenade
	blast_area= $Blast_Area
	explosion_particles= $Explosion
	explosion_particles.emitting= false
	explosion_particles.one_shot=true
	$Sticky_Area.connect('body_entered', self, "collied_with_body")
func collied_with_body(body):
	if body==self:
		return 
	if player_body!=null:
		if body==player_body:
			return
	if attached==false:
		attached=true
		attach_point=Spatial.new()
		body.add_child(attach_point)
		attach_point.global_transform.origin=global_transform.origin
		rigid_shape.disabled=true
		mode=RigidBody.MODE_STATIC



func _process(delta):
	if attached:
		if attach_point!=null:
			global_transform.origin= attach_point.global_transform.origin
	if timer< time:
		timer+=delta
		return
	else:
		if explosion_wait_timer<=0:
			explosion_particles.emitting=true
			grenade_mesh.visible=false
			rigid_shape.disabled=true
			mode=RigidBody.MODE_STATIC
			var bodies= blast_area.get_overlapping_bodies()
			for body in bodies:
				if body.has_method("bullet_hit"):
					body.bullet_hit(damage, global_transform)
			explosion_wait_timer+=delta
		if explosion_wait_timer<explosion_wait_time:
			explosion_wait_timer+=delta
		else:
			if attach_point!=null:
				attach_point.queue_free()
			queue_free()
