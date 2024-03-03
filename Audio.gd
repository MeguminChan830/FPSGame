extends Spatial

var knife_shot = load("res://audio/knife_shot.wav") if ResourceLoader.exists("res://audio/knife_shot.wav") else null

var pistol_shot= load("res://audio/pistol_shot.wav")
var pistol_reload = load("res://audio/pistol_reload.wav") if ResourceLoader.exists("res://audio/pistol_reload.wav") else null

var rifle_shot = load("res://audio/rifle_shot.wav") if ResourceLoader.exists("res://audio/rifle_shot.wav") else null
var rifle_reload = load("res://audio/rifle_reload.wav") if ResourceLoader.exists("res://audio/rifle_reload.wav") else null

var audio_node = null

func _ready():
    audio_node=$AudioStreamPlayer
    audio_node.connect("finished", self, "destroy_self")
    audio_node.stop()

func play_sound(name, pisition=null):
    if pistol_shot== null or rifle_shot==null or knife_shot==null or pistol_reload==null or rifle_reload==null:
        print("Audio not Set")
        queue_free()
        return 
    if name=="pistol_shot":
        audio_node.stream=pistol_shot
    elif name=="pistol_reload":
        audio_node.stream=pistol_reload
    elif name=="rifle_shot":
        audio_node.stream=rifle_shot
    elif name=="rifle_reload":
        audio_node.stream=rifle_reload
    elif name=="knife_shot":
        audio_node.stream=knife_shot
    else:
        print("Unknow stream!")
        queue_free()
        return 
    audio_node.play()

func destroy_self():
    audio_node.stop()
    queue_free()

