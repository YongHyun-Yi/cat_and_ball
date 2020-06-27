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


func cancel_button():
	get_tree().change_scene("res://scene/main_screen.tscn")
	pass # Replace with function body.

func button_event(b_name):
	var button = get_node("Control/HSeparator/hbox/"+b_name)
	
	if Rect2(Vector2.ZERO, button.rect_size).has_point(button.get_local_mouse_position()):
		if b_name == "confirm":
			get_tree().change_scene("res://scene/ingame.tscn")
		elif b_name == "cancel":
			get_tree().change_scene("res://scene/main_screen.tscn")
		pass
