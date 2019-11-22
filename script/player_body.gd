extends KinematicBody2D

var velocity = Vector2()
var speed = 300
var gravity = 2000
var jump = -700
var double_jump = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !self.is_on_floor():
		if velocity.y < gravity:
			velocity.y += gravity * delta
	else:
		if double_jump == false:
			double_jump = true
	get_input()
	move_and_slide(velocity, Vector2(0, -1))
	pass

func get_input():
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
	elif Input.is_action_pressed("ui_right"):
		velocity.x = speed
	else:
		velocity.x = 0
	if Input.is_action_just_pressed("ui_kick"):
		
		pass
	if Input.is_action_just_pressed("ui_jump"):
		if self.is_on_floor():
			velocity.y = jump
			print("jump!")
		elif double_jump == true:
			velocity.y = jump
			double_jump = false
			print("double jump!")