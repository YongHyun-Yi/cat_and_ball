extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func button_press(b_name):
	var button = get_node("Control/main_menus/"+b_name)
	
	button.self_modulate = Color(0.35, 0.35, 0.35, 1)
	
	pass

func button_event(b_name):
	var button = get_node("Control/main_menus/"+b_name)
	
	button.self_modulate = Color(1, 1, 1, 1)
	
	if Rect2(Vector2.ZERO, button.rect_size).has_point(button.get_local_mouse_position()):
		if b_name == "game_start":
			get_tree().change_scene("res://scene/character_selection.tscn")
		elif b_name == "game_end":
			get_tree().quit()
		pass
	pass
