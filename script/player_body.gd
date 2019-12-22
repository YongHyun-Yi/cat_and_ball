extends KinematicBody2D

var hp = 3
var hp_max = 3
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
onready var dir_sp = $sprite/jump_direction
onready var manager = get_node("../..")
onready var ball = get_node("../../ball/ball_body")
var target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("../Label").text = "상태 : "+state+"\n 체력 : "+str(hp)
	
	if Input.is_action_just_pressed("ui_left"):
		move_button_press("left")
	elif Input.is_action_just_pressed("ui_right"):
		move_button_press("right")
	elif Input.is_action_just_pressed("target_prev"):
		target_button_press("prev")
	elif Input.is_action_just_pressed("target_next"):
		target_button_press("next")
	
	if Input.is_action_just_released("ui_left"):
		move_button_release("left")
	elif Input.is_action_just_released("ui_right"):
		move_button_release("right")
	elif Input.is_action_just_released("target_prev"):
		target_button_release("prev")
	elif Input.is_action_just_released("target_next"):
		target_button_release("next")
	
	if !is_on_floor():
		if velocity.y < gravity:
			velocity.y += gravity * delta
		if velocity.x != 0:
			velocity.x = lerp(velocity.x, 0, Engine.get_time_scale()/10) # 기본값이 0.1이니 타임스케일이 1.0일떄 0.1이 나오도록 설정
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
			$attack/CollisionShape2D.disabled = true
			$receive/CollisionShape2D.disabled = false
	
	if hp <= 0: # 체력이 0이하일떄 player dead 로 씬 전환
		var dead_body_scene = load("res://scene/player_dead.tscn")
		var dead_body = dead_body_scene.instance()
		dead_body.global_position = global_position
		dead_body.get_node("player_dead").velocity = velocity
		get_node("..").add_child(dead_body)
		queue_free()
		pass
	
	if target == null:
		if manager.targets.size() > 0:
			target = manager.targets[0]
			get_node("../aim").show()
			get_node("../aim").global_position = target.global_position
			#print("target is : "+target.name)
			pass
		else:
			get_node("../aim").hide()
			#print("there no target")
		pass
	
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
	
	if manager.hit_pause == false and Engine.get_time_scale() != 1.0:
		Engine.set_time_scale(lerp(Engine.get_time_scale(), 1.0, .1))
	pass

func attack_in(body):
	if body.name == "ball_body":
		if state == "jump":
			body.hitted(power, velocity.x)
			get_node("../../camera").camera_shake(.05, 5)
			manager.combo += 1
			manager.hit_pause()
	pass # Replace with function body.

func receive_in(body):
	if body.name == "ball_body":
		if state == "idle":
			$sprite.animation = "receive"
			ball.receive()
	pass

func _on_sprite_animation_finished():
	if $sprite.animation == "receive":
		$sprite.animation = "idle"
	pass # Replace with function body.

func _on_timer_timeout():
	#$sprite.animation = "idle"
	$sprite/timer.stop()
	pass # Replace with function body.


func move_button_press(way):
	
	var button = get_node("../../controls/"+way)
	
	if state == "idle":
		state = "ready"
		$sprite.animation = "ready"
		$power_gauge.show()
	else:
		pre_pressed = true
		pre_pressed_way = way
	$receive/CollisionShape2D.disabled = true
	pass

func move_button_release(way):
	
	var button = get_node("../../controls/"+way)
	
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
		$attack/CollisionShape2D.disabled = false
	"""
	if way == "left":
		hp_update(-1)
	elif way == "right":
		hp_update(1)
	"""
	pass

func target_button_press(way):
	
	var button = get_node("../../controls/target_"+way)
	

	if target != null:
		if manager.targets.size() > 1:
			var a = manager.targets.find(target)
			
			if way == "prev":
				if a == 0:
					target = manager.targets[manager.targets.size()-1]
				else:
					target = manager.targets[a-1]
			else:
				if a == manager.targets.size()-1:
					target = manager.targets[0]
				else:
					target = manager.targets[a+1]
			
			get_node("../aim").global_position = target.global_position
	pass

	
	pass

func target_button_release(way):
	
	var button = get_node("../../controls/target_"+way)
	"""
	if way == "prev":
		hp_max -= 1
	elif way == "next":
		hp_max += 1
	print(str(hp_max))
	"""
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

func hp_update(a):

	if hp + a > hp_max and a > 0:
		if hp < hp_max:
			hp = hp_max
	elif hp + a < 0:
		hp = 0
	else:
		hp += a
	
	get_node("../hp_bar").value = hp