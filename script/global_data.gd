extends Node

var screen_size : int = 2
var sfx_volume : int = 50
var bgm_volume : int = 50
var screen_shake_volume : int = 2
var selected_language : int = 0

var last_selected_character_index : int = 0

var save_path = "user://saved_data.json"

var default_data_dictionary = {
	"option_setting_keys" : ["screen_size", "sfx_volume", "bgm_volume", "screen_shake_volume", "selected_language"],
	"option_setting" :
		{
			"screen_size" : 2,
			"sfx_volume" : 50,
			"bgm_volume" : 50,
			"screen_shake_volume" : 2,
			"selected_language" : 0
		},
	"last_selected_character_index" : 0
}
var data_dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	data_load()
	print(InputMap.get_action_list("ui_accept"))
	#screen_size_setting()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func data_reset():
	data_dictionary = default_data_dictionary.duplicate(true)

func data_load():
	var file = File.new()
	
	if not file.file_exists(save_path):
		data_reset()
		return
	
	file.open(save_path, File.READ)
	var text = file.get_as_text()
	data_dictionary = parse_json(text)
	
	file.close()

func data_save():
	var file = File.new()
	
	file.open(save_path, File.WRITE)
	file.store_line(to_json(data_dictionary))
	
	file.close()

func screen_size_setting():
	match data_dictionary["option_setting"]["screen_size"]:
		0: # 1920 x 1080
			OS.set_window_size(Vector2(1920, 1080))
		1: # 1600 x 900
			OS.set_window_size(Vector2(1600, 900))
		2: # 1280 x 720
			OS.set_window_size(Vector2(1280, 720))
		3: # 640 x 360
			OS.set_window_size(Vector2(640, 360))
	OS.set_window_position((OS.get_screen_size()/2) - (OS.get_window_size()/2))
