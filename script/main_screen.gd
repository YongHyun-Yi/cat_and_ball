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
	var button = get_node(b_name)
	
	button.self_modulate = Color(0.71, 0.99, 0.73, 1)
	
	pass

func button_event(b_name):
	var button = get_node(b_name)
	
	button.self_modulate = Color(2, 2.78, 2.07, 1)
	
	if Rect2(button.rect_global_position,button.rect_size).has_point(get_global_mouse_position()):
		if b_name == "game_start":
			get_tree().change_scene("res://scene/ingame.tscn")
		elif b_name == "game_end":
			get_tree().quit()
		pass
	pass
