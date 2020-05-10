extends KinematicBody2D


var velocity = Vector2()
var gravity = 2000
var jump = -900
var speed = 400


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	arrowkey_move_input()
	jump_and_gravity(delta)
	move_and_slide(velocity, Vector2(0, -1))
	pass

func arrowkey_move_input():
	if Input.is_action_pressed("ui_left"):
		
		velocity.x = -speed
		
	elif Input.is_action_pressed("ui_right"):
		
		velocity.x = speed
		
	else:
		velocity.x = 0

func jump_and_gravity(delta):
	if is_on_floor():
		if velocity.y > 0:
			velocity.y = 0
		
		if Input.is_action_pressed("ui_up"):
			velocity.y += jump
	else:
		if velocity.y < gravity:
			velocity.y += gravity * delta
	pass
