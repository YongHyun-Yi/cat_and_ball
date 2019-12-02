extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	"""var a = OS.get_screen_size()
	$Camera2D.offset_h = a.x
	$Camera2D.offset_v = a.y
	$Camera2D.offset = Vector2(a.x/2, a.y/2)"""
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func restart():
	get_tree().reload_current_scene()
	pass