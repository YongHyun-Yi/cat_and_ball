extends Node2D

var menu_count : int = 0
onready var menu_count_max = $Control/Control/main_menus.get_child_count()-1

onready var menu_name_label = $Control/Control/menu_name/Label
onready var menu_caption_label = $Control/Control/menu_caption

onready var main_menus = $Control/Control/main_menus

# Called when the node enters the scene tree for the first time.
func _ready():
	menu_info_update()
	$Control/Control/menu_cursor2/AnimationPlayer.seek(0.2)
	menu_tween()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func menu_tween():
	$Control/Control/screen_tween.interpolate_property($Control/Control, "rect_position:x", 90, 0, .4, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Control/Control/screen_tween.start()
	pass

func _input(event):
	
	if Input.is_action_just_pressed("ui_left"):
		menu_move_event("prev")
	elif Input.is_action_just_pressed("ui_right"):
		menu_move_event("next")
	elif Input.is_action_just_pressed("ui_accept"):
		main_menus.get_child(menu_count).emit_signal("button_event", main_menus.get_child(menu_count), true)


func button_event(button_object, keyboard_input):
	if Rect2(Vector2.ZERO, button_object.rect_size).has_point(button_object.get_local_mouse_position()) or keyboard_input == true:
		
		match button_object.name:
			"game_start":
				get_tree().change_scene("res://scene/character_selection.tscn")
			"collect":
				pass
			"option":
				get_tree().change_scene("res://scene/main_option.tscn")
			"game_end":
				get_tree().quit()

func menu_move_event(ward):
	var step = 330
	
	if ward == "next" and menu_count < menu_count_max-1:
		main_menus.get_child(menu_count).disabled = true
		main_menus.get_node("menus_tween").interpolate_property(main_menus, "rect_position:x", main_menus.rect_position.x, 480 - (step * (menu_count+1)), 0.7, Tween.TRANS_EXPO, Tween.EASE_OUT)
		main_menus.get_node("menus_tween").start()
		menu_count += 1
		main_menus.get_child(menu_count).disabled = false
		menu_info_update()
	
	elif ward == "prev" and menu_count > 0:
		main_menus.get_child(menu_count).disabled = true
		main_menus.get_node("menus_tween").interpolate_property(main_menus, "rect_position:x", main_menus.rect_position.x, 480 - (step * (menu_count-1)), 0.7, Tween.TRANS_EXPO, Tween.EASE_OUT)
		main_menus.get_node("menus_tween").start()
		menu_count -= 1
		main_menus.get_child(menu_count).disabled = false
		menu_info_update()

func menu_go_to():
	var step = 330
	
	main_menus.get_child(menu_count).disabled = true
	main_menus.get_node("menus_tween").interpolate_property(main_menus, "rect_position:x", main_menus.rect_position.x, 480 - (step * menu_count), 0.7, Tween.TRANS_EXPO, Tween.EASE_OUT)
	main_menus.get_node("menus_tween").start()
	menu_info_update()

func menu_info_update():
	menu_name_label.text = main_menus.get_child(menu_count).text
	menu_caption_label.text = main_menus.get_child(menu_count).caption


func _on_custom_button_button_event():
	print("야호")
	pass # Replace with function body.
