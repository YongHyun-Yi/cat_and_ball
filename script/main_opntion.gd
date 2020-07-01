extends Node2D

var first_load = false

onready var screen_size_menu = $Control/Control/option_menus/screen_size
onready var sfx_bar_menu = $Control/Control/option_menus/sfx_bar
onready var bgm_bar_menu = $Control/Control/option_menus/bgm_bar
onready var screen_shake_menu = $Control/Control/option_menus/screen_shake/screen_shake
onready var language_select_menu = $Control/Control/option_menus/language_select/language_select
onready var key_input_menu = $Control/Control/option_menus/key_input
onready var credit_menu = $Control/Control/option_menus/credit
onready var data_reset_menu = $Control/Control/option_menus/data_reset

onready var set_property_funcs = [
	funcref($Control/Control/option_menus/screen_size, "select"),
	funcref($Control/Control/option_menus/sfx_bar/HSlider, "set_value"),
	funcref($Control/Control/option_menus/bgm_bar/HSlider, "set_value"),
	funcref($Control/Control/option_menus/screen_shake/screen_shake, "set_current_tab"),
	funcref($Control/Control/option_menus/language_select/language_select, "set_current_tab")
	]

onready var get_property_funcs = [
	funcref($Control/Control/option_menus/screen_size, "get_selected"),
	funcref($Control/Control/option_menus/sfx_bar/HSlider, "get_value"),
	funcref($Control/Control/option_menus/bgm_bar/HSlider, "get_value"),
	funcref($Control/Control/option_menus/screen_shake/screen_shake, "get_current_tab"),
	funcref($Control/Control/option_menus/language_select/language_select, "get_current_tab")
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(str(OS.get_screen_size()))
	#print(str(OS.get_window_size()))
	screen_shake_menu.add_tab("   0   ")
	screen_shake_menu.add_tab("   1   ")
	screen_shake_menu.add_tab("   2   ")
	screen_shake_menu.add_tab("   3   ")
	screen_shake_menu.add_tab("   4   ")
	screen_shake_menu.current_tab = 2
	
	language_select_menu.add_tab("  한국어  ")
	language_select_menu.add_tab("  ENGLISH  ")
	language_select_menu.set_tab_disabled(1, true)
	
	menu_info_load()
	first_load = true
	menu_tween()
	

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func menu_tween():
	$Control/Control/screen_tween.interpolate_property($Control/Control, "rect_position:x", 90, 0, .4, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Control/Control/screen_tween.start()



func menu_info_load():
	
	for i in GlobalData.data_dictionary["option_setting_keys"].size():
		set_property_funcs[i].call_func(GlobalData.data_dictionary["option_setting"][GlobalData.data_dictionary["option_setting_keys"][i]])

func menu_info_save():
	if first_load == true:
		
		for i in GlobalData.data_dictionary["option_setting_keys"].size():
			GlobalData.data_dictionary["option_setting"][GlobalData.data_dictionary["option_setting_keys"][i]] = get_property_funcs[i].call_func()
		
		#GlobalData.data_save()

func _input(event):
	
	if Input.is_action_just_pressed("ui_cancel"):
		match get_tree().get_current_scene().name:
			"main_option":
				get_tree().change_scene("res://scene/main_screen.tscn")
			"ingame":
				queue_free()
				get_node("/root/ingame").open_menu()
				get_tree().set_input_as_handled()
				

func screen_size_item_selected(id):
	match id:
		0: # 1920 x 1080
			OS.set_window_size(Vector2(1920, 1080))
		1: # 1600 x 900
			OS.set_window_size(Vector2(1600, 900))
		2: # 1280 x 720
			OS.set_window_size(Vector2(1280, 720))
		3: # 640 x 360
			OS.set_window_size(Vector2(640, 360))
	OS.set_window_position((OS.get_screen_size()/2) - (OS.get_window_size()/2))
	menu_info_save()
	pass # Replace with function body.

func sfx_bar_value_changed(value):
	sfx_bar_menu.value = sfx_bar_menu.get_node("HSlider").value
	menu_info_save()
	pass # Replace with function body.

func bgm_bar_value_changed(value):
	bgm_bar_menu.value = bgm_bar_menu.get_node("HSlider").value
	menu_info_save()
	pass # Replace with function body.

func shake_tab_changed(tab):
	menu_info_save()
	pass # Replace with function body.

func select_tab_changed(tab):
	menu_info_save()
	pass # Replace with function body.

func button_event(button_object, keyboard_input):
	if Rect2(Vector2.ZERO, button_object.rect_size).has_point(button_object.get_local_mouse_position()) or keyboard_input == true:
		
		match button_object.name:
			"cancel":
				match get_tree().get_current_scene().name:
					"main_option":
						get_tree().change_scene("res://scene/main_screen.tscn")
					"ingame":
						queue_free()
						#get_node("../ingame_menus").show()
						get_node("/root/ingame").open_menu()
						get_tree().set_input_as_handled()
				#get_tree().get_node("main_screen").menu_count = 2
				#get_tree().get_node("main_screen").menu_go_to()
