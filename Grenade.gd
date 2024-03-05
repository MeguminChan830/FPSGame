extends RigidBody

const damage= 60

const time= 2
var timer= 0
const explosion_wait_time = 0.48

var explosion_timer= 0

var rigid_shape: CollisionShape
var mesh: MeshInstance
var blast_area: Area
var explosion_particles: CPUParticles

func _ready():
	rigid_shape = $Collision_Shape
	mesh= $Grenade
	blast_area= $Blast_Area
	explosion_particles=$Explosion

	explosion_particles.emitting=false
	explosion_particles.one_shot=true


func _process(delta):
	
	if timer<time:
		timer+=delta
		return 
	else:
		if explosion_timer <=0:
			
			explosion_particles.emitting=true
			mesh.visible=false
			mode= RigidBody.MODE_STATIC
			var bodies= blast_area.get_overlapping_bodies()
			for body in bodies:
				if body.has_method("bullet_hit"):
					body.bullet_hit(damage, global_transform)
		if explosion_timer< explosion_wait_time:
			explosion_timer +=delta
			if explosion_timer >= explosion_wait_time:
				queue_free()
