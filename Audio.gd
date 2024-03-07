extends Spatial


# var audio_node = null

# func _ready():
# 	audio_node=$AudioStreamPlayer
# 	audio_node.connect("finished", self, "destroy_self")
# 	audio_node.stop()

# func play_sound(name, pisition=null):
# 	if pistol_shot== null or rifle_shot==null or knife_shot==null or pistol_reload==null or rifle_reload==null:
# 		print("Audio not Set")
# 		queue_free()
# 		return 
# 	if name=="pistol_shot":
# 		audio_node.stream=pistol_shot
# 	elif name=="pistol_reload":
# 		audio_node.stream=pistol_reload
# 	elif name=="rifle_shot":
# 		audio_node.stream=rifle_shot
# 	elif name=="rifle_reload":
# 		audio_node.stream=rifle_reload
# 	elif name=="knife_shot":
# 		audio_node.stream=knife_shot
# 	elif name== "bomb":
# 		audio_node.stream=bomb
# 	else:
# 		print("Unknow stream!")
# 		queue_free()
# 		return 
# 	audio_node.play()

# func destroy_self():
# 	audio_node.stop()
# 	queue_free()


var audio_node=null
var should_loop=false
var globals=null

func _ready():
	audio_node= $AudioStreamPlayer
	audio_node.connect("finished", self, "sound_finished")
	audio_node.stop()

	globals=get_node("/root/Globals")

func play_sound(stream, position=null):
	if stream==null:
		print("No Audio passed")
		globals.create_audio().erase(self)
		queue_free()
		return
	audio_node.stream=stream
	audio_node.play(0.0)

func sound_finished():
	if should_loop:
		audio_node.play(0.0)
	else:
		globals.create_audio.remove(globals.create_audio.find(self))
		AudioStreamPlayer.stop()
		audio_node.stop()
		queue_free()
























