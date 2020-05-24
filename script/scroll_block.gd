extends "res://script/wall.gd"

export var speed = 300
export (String, "left", "right") var scroll_way


# Called when the node enters the scene tree for the first time.
func _ready():
	state = "scroll"
	if scroll_way == "left":
		speed *= -1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func state_update(a):
	a.movement_state = state
	
	if a.scroll_acl != speed:
		a.scroll_acl = speed