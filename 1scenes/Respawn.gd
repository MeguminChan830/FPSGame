extends Spatial


func _ready():
	var globals= get_node("/root/Globals")
	globals.respawn_points= []
	for child in get_children():
		if child is WorldEnvironment:
			globals.respawn_points.append(get_node("Player"))
		else:
			globals.respawn_points.append(child)
