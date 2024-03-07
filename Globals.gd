extends Node
var canvas_layer=null
const debug_scene= preload("res://Debug_Display.tscn")
var debug_display=null
var mouse_sensitivity= 0.08
var respawn_points=null



var audio_clips= {
	"knife_shot":load("res://audio/knife_shot.wav") if ResourceLoader.exists("res://audio/knife_shot.wav") else null,

	"pistol_shot":load("res://audio/pistol_shot.wav"),
	"pistol_reload":load("res://audio/pistol_reload.wav") if ResourceLoader.exists("res://audio/pistol_reload.wav") else null,

	"rifle_shot": load("res://audio/rifle_shot.wav") if ResourceLoader.exists("res://audio/rifle_shot.wav") else null,
	"rifle_reload" :load("res://audio/rifle_reload.wav") if ResourceLoader.exists("res://audio/rifle_reload.wav") else null,

	"bomb" :load("res://audio/bomb.wav"),
}

const audio_scene= preload("res://Audio.tscn")
var create_audio= []






func _ready():
	randomize()
	canvas_layer= CanvasLayer.new()
	add_child(canvas_layer)
	pass
func load_new_scene(path):
	respawn_points=null
	for sound in create_audio:
		if (sound!=null):
			sound.queue_free()
	create_audio.clear()

	get_tree().change_scene(path)
	

func set_debug_display(on):
	if on==false:
		if debug_display!=null:
			debug_display.queue_free()
			debug_display=null
	else:
		if debug_display==null:
			debug_display= debug_scene.instance()
			canvas_layer.add_child(debug_display)


const main_menu ="res://Main_Menu.tscn"
const popup_scene = preload("res://Pause_Popup.tscn")
var popup=null

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if popup==null:
			popup= popup_scene.instance()

			popup.get_node("Button_quit").connect("pressed", self, "popup_quit")
			popup.connect("popup_hide", self, "popup_closed")
			popup.get_node("Button_resume").connect("pressed", self, "popup_closed")

			canvas_layer.add_child(popup)
			popup.popup_centered()

			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

			get_tree().paused=true



func popup_closed():
	get_tree().paused=false


	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if popup!=null:
		popup.queue_free()
		popup=null

func popup_quit():
	get_tree().paused=false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if popup!=null:
		popup.queue_free()
		popup=null

	load_new_scene(main_menu)
func get_respawn_position():
	if respawn_points==null:
		return Vector3(0, 0, 0)
	else:
		var respawn_index=randi()%respawn_points.size()
		return respawn_points[respawn_index].global_transform.origin

func play_sound(name, loop_sound=false, position=null):
	if audio_clips.has(name):
		var new_audio= audio_scene.instance()
		new_audio.should_loop=loop_sound

		add_child(new_audio)
		create_audio.append(new_audio)
		new_audio.play_sound(audio_clips[name], position)
	else:
		printerr("Cannot play sound that does not exists")
