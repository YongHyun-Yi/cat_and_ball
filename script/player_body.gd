extends KinematicBody2D

var velocity = Vector2()
var speed = 250
var gravity = 2000
var jump = -700
var d_jump = -550
var double_jump = true
var attack_point = Vector2()
var move_button_press = false
var move_button_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_on_floor():
		if velocity.y < gravity:
			velocity.y += gravity * delta
	else:
		if double_jump == false:
			double_jump = true
	if is_on_wall():
		var a = get_slide_collision(1)
		if a.collider.is_in_group("wall"):
			print("wall")
			speed *= -1
	get_input()
	velocity.x = speed
	move_and_slide(velocity, Vector2(0, -1))
	get_node("../Label").text = str(attack_point)
	
	if move_button_press == true:
		if move_button_timer < 20:
			move_button_timer += 1
		elif move_button_timer == 20:
			move_button_timer += 1
			speed *= 2
	pass

func get_input():
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
	elif Input.is_action_pressed("ui_right"):
		velocity.x = speed
	else:
		velocity.x = 0
	if Input.is_action_just_pressed("ui_attack"):
		$anim.play("attack")
		pass
	if Input.is_action_just_pressed("ui_jump"):
		if self.is_on_floor():
			velocity.y = jump
			print("jump!")
		elif double_jump == true:
			velocity.y = d_jump
			double_jump = false
			print("double jump!")

func touch_botton_action_press(a):
	Input.action_press(a)
	get_node("../../"+a).self_modulate = "832f2f2f"
	pass

func touch_botton_action_release(a):
	Input.action_release(a)
	get_node("../../"+a).self_modulate = "83ffffff"
	pass

func attack_hitted(body):
	if body.get_parent().name == "ball":
		body.hitted(attack_point)

func wall_detect(body):
	#if body.name == "wall_left":
	#	print(body.name)
	pass

func move_button(a):
	if a == "press":
		#speed *= 2
		move_button_timer = 0
		move_button_press = true
	elif a == "release":
		move_button_press = false
		if move_button_timer > 20:
			speed /= 2
		else:
			speed *= -1