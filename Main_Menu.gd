extends Control


var start_menu:Control
var level_select_menu:Control
var options_menu:Control

export (String, FILE) var test_scene
export (String, FILE) var space_scene
export (String, FILE) var ruin_scene

func _ready():
	start_menu=$start_menu
	level_select_menu=$level_select_menu
	options_menu= $options_menu

	$start_menu/start.connect("pressed", self, "start_menu_button_pressed", ["start"])
	$start_menu/open_godot.connect("pressed", self, 'start_menu_button_pressed', ['open_godot'])
	$start_menu/options.connect("pressed",self, "start_menu_button_pressed", ['options'])
	$start_menu/quit.connect("pressed", self , "start_menu_button_pressed", ['quit'])

	$level_select_menu/back.connect("pressed", self, 'level_select_menu_pressed', ['back'])
	$level_select_menu/test.connect("pressed", self, 'level_select_menu_pressed', ['testing_scene'])
	$level_select_menu/space.connect('pressed', self, 'level_select_menu_pressed', ['space_level'])
	$level_select_menu/ruin.connect("pressed", self, 'level_select_menu_pressed', ['ruins_level'])

	$options_menu/back.connect('pressed', self, 'options_menu_button_pressed', ['back'])
	$options_menu/full_screen.connect("pressed", self, "options_menu_button_pressed", ['fullscreen'])
	$options_menu/vsync.connect("pressed", self, 'options_menu_button_pressed', ['vsync'])
	$options_menu/debug.connect("pressed", self, 'options_menu_button_pressed', ['debug'])

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var globals= get_node("/root/Globals")
	$options_menu/sensitivity.value= globals.mouse_sensitivity

func start_menu_button_pressed(name):
	if name=="start":
		level_select_menu.visible=true
		start_menu.visible=false
	elif name=='open_godot':
		OS.shell_open("https://google.com")
	elif name== 'options':
		options_menu.visible=true
		start_menu.visible=false
	elif name=='quit':
		get_tree().quit()

func level_select_menu_pressed(name):
	if name =='back':
		start_menu.visible=true
		level_select_menu.visible=false
	elif name== 'testing_scene':
		print("Hello")
		set_mouse_sensitivity()
		get_node('/root/Globals').load_new_scene(test_scene)
	elif name== "space_level":
		set_mouse_sensitivity()
		get_node('/root/Globals').load_new_scene(space_scene)
	elif name=='ruins_level':
		set_mouse_sensitivity()
		get_node("/root/Globals").load_new_scene(ruin_scene)

func options_menu_button_pressed(name):
	if name=="back":
		start_menu.visible=true
		options_menu.visible=false
	elif name=='fullscreen':
		OS.window_fullscreen= !OS.window_fullscreen
	elif name=='vsync':
		OS.vsync_enabled=$options_menu/vsync.pressed
	elif name=='debug':
		get_node("/root/Globals").set_debug_display($options_menu/debug.pressed)



func set_mouse_sensitivity()->void:
	var globals = get_node('/root/Globals')
	globals.mouse_sensitivity=$options_menu/sensitivity.value

