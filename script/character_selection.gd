extends Node2D

onready var selected_character : Object
onready var character_detail = $Control/Control/character_detail


# Called when the node enters the scene tree for the first time.
func _ready():
	menu_tween()
	selected_character = $Control/Control/Panel2/grid.get_child(GlobalData.last_selected_character_index)
	character_detail_update(selected_character)
	$Control/Control/Panel2/grid.get_child(GlobalData.last_selected_character_index).pressed = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func menu_tween():
	$Control/Control/screen_tween.interpolate_property($Control/Control, "rect_position:x", 90, 0, .4, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Control/Control/screen_tween.start()

func _input(event):
	if FadeEffect.transitioning == false:
		if Input.is_action_just_pressed("ui_left"):
			if GlobalData.last_selected_character_index > 0:
				$Control/Control/Panel2/grid.get_child(GlobalData.last_selected_character_index).pressed = false
				GlobalData.last_selected_character_index -= 1
				selected_character = $Control/Control/Panel2/grid.get_child(GlobalData.last_selected_character_index)
				character_detail_update(selected_character)
				$Control/Control/Panel2/grid.get_child(GlobalData.last_selected_character_index).pressed = true
			pass
		elif Input.is_action_just_pressed("ui_right"):
			if GlobalData.last_selected_character_index < $Control/Control/Panel2/grid.get_child_count()-1:
				$Control/Control/Panel2/grid.get_child(GlobalData.last_selected_character_index).pressed = false
				GlobalData.last_selected_character_index += 1
				selected_character = $Control/Control/Panel2/grid.get_child(GlobalData.last_selected_character_index)
				character_detail_update(selected_character)
				$Control/Control/Panel2/grid.get_child(GlobalData.last_selected_character_index).pressed = true
			pass
		
		if Input.is_action_just_pressed("ui_accept"):
			FadeEffect.change_scene(2.0, "res://scene/ingame.tscn")
			#get_tree().change_scene("res://scene/ingame.tscn")
		elif Input.is_action_just_pressed("ui_cancel"):
			get_tree().change_scene("res://scene/main_screen.tscn")

func button_event(button_object, keyboard_input):
	if Rect2(Vector2.ZERO, button_object.rect_size).has_point(button_object.get_local_mouse_position()) or keyboard_input == true:
		
		match button_object.name:
			"confirm":
				FadeEffect.change_scene(2.0, "res://scene/ingame.tscn")
				#get_tree().change_scene("res://scene/ingame.tscn")
			"cancel":
				get_tree().change_scene("res://scene/main_screen.tscn")


func character_detail_init():
	character_detail.get_node("image/sprite").texture = null
	character_detail.get_node("name/Label").text = ""
	character_detail.get_node("caption/Label").text = ""
	
	character_detail.get_node("stats/stats_tween").remove_all()
	character_detail.get_node("stats/stats_tween").interpolate_property(character_detail.get_node("stats/stats_power"), "value", character_detail.get_node("stats/stats_power").value, 0, 0.2, Tween.TRANS_EXPO, Tween.EASE_OUT)
	character_detail.get_node("stats/stats_tween").start()
	character_detail.get_node("stats/stats_tween").interpolate_property(character_detail.get_node("stats/stats_speed"), "value", character_detail.get_node("stats/stats_speed").value, 0, 0.2, Tween.TRANS_EXPO, Tween.EASE_OUT)
	character_detail.get_node("stats/stats_tween").start()
	character_detail.get_node("stats/stats_tween").interpolate_property(character_detail.get_node("stats/stats_health"), "value", character_detail.get_node("stats/stats_health").value, 0, 0.2, Tween.TRANS_EXPO, Tween.EASE_OUT)
	character_detail.get_node("stats/stats_tween").start()

func character_detail_update(char_object):
	character_detail.get_node("image/sprite").texture = char_object.char_sprite
	character_detail.get_node("name/Label").text = char_object.char_name
	character_detail.get_node("caption/Label").text = char_object.char_caption
	
	character_detail.get_node("stats/stats_tween").interpolate_property(character_detail.get_node("stats/stats_power"), "value", character_detail.get_node("stats/stats_power").value, char_object.char_power, 0.6, Tween.TRANS_EXPO, Tween.EASE_OUT)
	character_detail.get_node("stats/stats_tween").start()
	character_detail.get_node("stats/stats_tween").interpolate_property(character_detail.get_node("stats/stats_speed"), "value", character_detail.get_node("stats/stats_speed").value, char_object.char_speed, 0.6, Tween.TRANS_EXPO, Tween.EASE_OUT)
	character_detail.get_node("stats/stats_tween").start()
	character_detail.get_node("stats/stats_tween").interpolate_property(character_detail.get_node("stats/stats_health"), "value", character_detail.get_node("stats/stats_health").value, char_object.char_health, 0.6, Tween.TRANS_EXPO, Tween.EASE_OUT)
	character_detail.get_node("stats/stats_tween").start()

func character_sprite_resized():
	var init_pos = Vector2(170, 131)
	var init_size = Vector2(40, 40)
	
	var a = $Control/Control/character_detail/image/sprite.texture.get_size()
	a /= 2
	$Control/Control/character_detail/image.rect_position = init_pos - a
	
	pass # Replace with function body.

func name_Label_resized():
	var init_pos_x = 158
	var init_size_x = 0
	
	var a = $Control/Control/character_detail/name/Label.rect_size.x - init_size_x
	a /= 2
	$Control/Control/character_detail/name.rect_position.x = init_pos_x - a
	
	pass # Replace with function body.
