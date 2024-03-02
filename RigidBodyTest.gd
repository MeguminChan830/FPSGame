extends RigidBody

const base_bullet_boost =3

func _ready() -> void:
	pass # Replace with function body.

func bullet_hit(damage, bullet_global_trans):
	var dir = bullet_global_trans.basis.z.normalized()*base_bullet_boost
	apply_impulse((bullet_global_trans.origin-global_transform.origin).normalized(), dir*damage)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
