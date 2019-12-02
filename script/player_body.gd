extends RigidBody2D

var velocity = Vector2()
var speed = 300
var gravity = 1000
var jump = -700
var d_jump = -550
var double_jump = true
var controller = false
var move_point = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if double_jump == false:
		double_jump = true
	get_input()
	if controller == true:
		$Line2D.clear_points()
		$Line2D.add_point(Vector2(0, 0))
		move_point = get_local_mouse_position().clamped(200)
		$Line2D.add_point(move_point)
		$move_point.position = move_point
	pass

func get_input():
	"""if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
	elif Input.is_action_pressed("ui_right"):
		velocity.x = speed
	else:
		velocity.x = 0
	if Input.is_action_just_pressed("ui_kick"):
		
		pass"""
	"""if Input.is_action_just_pressed("ui_jump"):
		if self.is_on_floor():
			velocity.y = jump
			print("jump!")
		elif double_jump == true:
			velocity.y = d_jump
			double_jump = false
			print("double jump!")"""
	if Input.is_action_just_pressed("controller"):
		if controller == false:
			controller = true
			$move_point.show()
	elif Input.is_action_just_released("controller"):
		if controller == true:
			$Line2D.clear_points()
			controller = false
			$move_point.hide()
			apply_central_impulse(move_point*3)
			#$Tween.interpolate_property(self, "position", position, move_point, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			#$Tween.start()