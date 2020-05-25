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

func ball_state_update(a):
	a.movement_state = state
	
	#var b = a.get_applied_force() 
	if a.applied_force.x != speed*3:
		#a.friction = 0
		a.applied_force.x = speed*3
	pass
