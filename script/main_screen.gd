extends Node2D

var menu_count : int = 0
onready var menu_count_max = $Control/main_menus.get_child_count()-1

onready var menu_name_label = $Control/menu_name/Label
onready var menu_caption_label = $Control/menu_caption

# Called when the node enters the scene tree for the first time.
func _ready():
	menu_info_update()
	$Control/menu_cursor2/AnimationPlayer.seek(0.2)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	
	if Input.is_action_just_pressed("ui_left"):
		menu_move_event("prev")
	elif Input.is_action_just_pressed("ui_right"):
		menu_move_event("next")
	elif Input.is_action_just_pressed("ui_accept"):
		$Control/main_menus.get_child(menu_count).emit_signal("button_event", $Control/main_menus.get_child(menu_count), true)


func button_event(button_object, keyboard_input):
	if Rect2(Vector2.ZERO, button_object.rect_size).has_point(button_object.get_local_mouse_position()) or keyboard_input == true:
		
		match button_object.name:
			"game_start":
				get_tree().change_scene("res://scene/character_selection.tscn")
			"collect":
				pass
			"option":
				pass
			"game_end":
				get_tree().quit()

func menu_move_event(ward):
	var step = 330
	
	if ward == "next" and menu_count < menu_count_max-1:
		$Control/main_menus.get_child(menu_count).disabled = true
		$Control/main_menus/menus_tween.interpolate_property($Control/main_menus, "rect_position:x", $Control/main_menus.rect_position.x, 480 - (step * (menu_count+1)), 0.7, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Control/main_menus/menus_tween.start()
		menu_count += 1
		$Control/main_menus.get_child(menu_count).disabled = false
		menu_info_update()
	
	elif ward == "prev" and menu_count > 0:
		$Control/main_menus.get_child(menu_count).disabled = true
		$Control/main_menus/menus_tween.interpolate_property($Control/main_menus, "rect_position:x", $Control/main_menus.rect_position.x, 480 - (step * (menu_count-1)), 0.7, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Control/main_menus/menus_tween.start()
		menu_count -= 1
		$Control/main_menus.get_child(menu_count).disabled = false
		menu_info_update()

func menu_info_update():
	menu_name_label.text = $Control/main_menus.get_child(menu_count).text
	menu_caption_label.text = $Control/main_menus.get_child(menu_count).caption
