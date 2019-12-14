extends KinematicBody2D

var velocity = Vector2()
var speed = 350
var gravity = 5000
var jump = -700
var d_jump = -550
var double_jump = true
var move_button_first = Vector2()
var move_button_press = false
var state = "idle"
var first = Vector2()
var last = Vector2()
var in_area = []
var in_area_actioned = []
var power = 0
var pre_pressed = false
var pre_pressed_way = ""
var attack_pause = false
onready var dir_sp = $sprite/jump_direction

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("../Label").text = state
	
	if !is_on_floor():
		if velocity.y < gravity:
			velocity.y += gravity * delta
		if velocity.x != 0:
			velocity.x = lerp(velocity.x, 0, .1)
		#if state != "jump":
		#	state = "jump"
	else:
		if double_jump == false:
			double_jump = true
		if state == "jump":
			velocity.x = 0
			velocity.y = 0
			power = 0
			state = "idle"
			$sprite.animation = "idle"
			$sprite.flip_h = false
			if pre_pressed == true:
				move_button_press(pre_pressed_way)
				pre_pressed = false
				pre_pressed_way = ""
	
	if is_on_wall():
		pass
	
	move_and_slide(velocity, Vector2(0, -1))
	
	if state == "ready":
		"""
		last = get_global_mouse_position()
		var a = clamp((last.x - first.x)/2, -70, 70)
		dir_sp.rotation_degrees = a
		"""
		if power < 9:
			power += .4
			$power_gauge.value = (power * 100) + 700
		pass
	
	if attack_pause == false and Engine.get_time_scale() != 1.0:
		Engine.set_time_scale(lerp(Engine.get_time_scale(), 1.0, .1))
	pass

func attack_in(body):
	if body.name == "ball_body":
		if state == "jump":
			body.hitted(power)
			get_node("../../camera").camera_shake(.05, 5)
			Engine.set_time_scale(.01)
			$attack/timer.wait_time = 2 * Engine.get_time_scale()
			$attack/timer.start()
			attack_pause = true
			print("느려짐 시작")
		elif state == "idle":
			$sprite.animation = "receive"
	pass # Replace with function body.

func hit_pause_timer():
	$attack/timer.stop()
	attack_pause = false
	get_node("../../ball/ball_body/sprite").texture = load("res://sprite/ball.png")
	get_node("../../ball/ball_body/effect2").hide()
	print("느려짐 끝")
	pass # Replace with function body.

func _on_sprite_animation_finished():
	if $sprite.animation == "receive":
		$sprite/timer.start()
		get_node("../../ball/ball_body").receive()
	pass # Replace with function body.

func _on_timer_timeout():
	$sprite.animation = "idle"
	$sprite/timer.stop()
	pass # Replace with function body.


func move_button_press(way):
	
	get_node("../../"+way).texture_normal = load("res://sprite/button_pressed.png")
	get_node("../../"+way+"/arrow").position.y += 3
	
	if state == "idle":
		state = "ready"
		$sprite.animation = "ready"
		$power_gauge.show()
	else:
		pre_pressed = true
		pre_pressed_way = way
	pass

func move_button_release(way):
	
	get_node("../../"+way).texture_normal = load("res://sprite/button.png")
	get_node("../../"+way+"/arrow").position.y -= 3
	
	if pre_pressed == true:
		pre_pressed = false
		pre_pressed_way = ""
	
	if state == "ready":
		state = "jump"
		$sprite.animation = "jump"
		if way == "right":
			$sprite.flip_h = true
		velocity.x = (power * 200) + 200
		if way == "left":
			velocity *= -1
		velocity.y = -((power * 50) + 700)
		move_and_slide(velocity, Vector2(0, -1))
		
		$power_gauge.hide()
	pass

func self_shake(t,p):
	print("self shake start")
	var s = $sprite
	var initial_offset = s.position
	
	var time = 0
	var time_limit = t
	var power = p
	
	while time < time_limit:
		time += get_process_delta_time()
		time = min(time, time_limit)
		
		var offset = Vector2()
		offset.x = rand_range(-power, power)
		offset.y = rand_range(-power, power)
		s.position = offset
		
		yield(get_tree(), "idle_frame")
	
	s.position = initial_offset
	print("camera shake end")
