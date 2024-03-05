extends Spatial


var bulletSpeed= 70
var bulletDamage=15

const killTimer=4
var timer =0
var hitSomething= false
func _ready():
	$Area.connect("body_entered", self, "collided")
	
func _physics_process(delta):
	var forward_dir= global_transform.basis.z.normalized()
	global_translate(forward_dir*bulletSpeed* delta)
	timer += delta
	if timer >= killTimer:
		pass
#		queue_free()
func collided(body):
	if hitSomething==false:
		if body.has_method("bullet_hit"):
			body.bullet_hit(bulletDamage, global_transform)
	
