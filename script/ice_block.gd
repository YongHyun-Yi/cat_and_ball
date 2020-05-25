extends "res://script/wall.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	state = "slide"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func ball_state_update(a):
	a.friction = 0.4
