extends KinematicBody2D

var hp = 3
var hp_max = 3

var velocity = Vector2()
var gravity = 5000
var jump = -700
var d_jump = -550

var on_floor = true
var jump_ready = false
var double_jump = true
var w_grab = false

var w_detect = false
var w_stuck_check = false

var move_button_press = false

var state = "idle"

var power = 0

var pre_pressed = false
var pre_pressed_way = ""

var w_grab_able = false
var w_grab_way = ""

onready var manager = get_node("../..")
onready var ball = get_node("../../ball/ball_body")
onready var controls = get_node("../../controls")

var target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("../Label").text = "상태 : "+state+"\n 체력 : "+str(hp)
	
	# 버튼을 눌렀을 떄-------------------------
	
	if Input.is_action_just_pressed("ui_left"):
		if w_grab_able == true and w_grab_way == "left":
			wall_grab_button_press("left")
		else:
			move_button_press("left")
	
	elif Input.is_action_just_pressed("ui_right"):
		if w_grab_able == true and w_grab_way == "right":
			wall_grab_button_press("right")
		else:
			move_button_press("right")
	
	elif Input.is_action_just_pressed("target_prev"):
		target_button_press("prev")
	
	elif Input.is_action_just_pressed("target_next"):
		target_button_press("next")
	
	# 버튼을 뗏을때 ---------------------
	
	if Input.is_action_just_released("ui_left"):
		if w_grab_able == true and w_grab_way == "left":
			wall_grab_button_release("left")
		else:
			move_button_release("left")
	
	elif Input.is_action_just_released("ui_right"):
		if w_grab_able == true and w_grab_way == "right":
			wall_grab_button_release("right")
		else:
			move_button_release("right")
	
	elif Input.is_action_just_released("target_prev"):
		target_button_release("prev")
	
	elif Input.is_action_just_released("target_next"):
		target_button_release("next")
	
	if !is_on_floor(): # 공중에 있을 때----------------------------
		if w_grab == false:
			if velocity.y < gravity:
				velocity.y += gravity * delta
			if velocity.x != 0:
				velocity.x = lerp(velocity.x, 0, Engine.get_time_scale()/10) # 기본값이 0.1이니 타임스케일이 1.0일떄 0.1이 나오도록 설정
		#if state != "jump":
		#	state = "jump"
		
	else: # 땅에 있을 때---------------------------
		if double_jump == false:
			double_jump = true
		if on_floor == false:
			on_floor = true
			velocity.x = 0
			velocity.y = 0
			$sprite.animation = "idle"
			$attack/CollisionShape2D.disabled = true
			$receive/CollisionShape2D.disabled = false
			if pre_pressed == true:
				move_button_press(pre_pressed_way)
				pre_pressed = false
				pre_pressed_way = ""
			
		if w_grab_able == true:
			print("벽 잡을수 없음")
			w_grab_able = false
			controls.get_node(w_grab_way).show()
			controls.get_node("w_" + w_grab_way).hide()
			w_grab_way = ""
	
	if hp <= 0: # 체력이 0이하일떄 player dead 로 씬 전환
		player_dead()
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
	
	if is_on_wall(): # 벽에 닿았을 때
		if w_grab_able == false and velocity.y != 0:
			print("벽 잡을수 있음")
			w_grab_able = true
			if $sprite.flip_h == true: # 오른쪽으로 이동중
				w_grab_way = "right"
				print("오른쪽 그랩버튼")
			else:
				w_grab_way = "left"
				print("왼쪽 그랩버튼")
			controls.get_node(w_grab_way).hide()
			controls.get_node("w_" + w_grab_way).show()
	
	# 벽과 움직이는 벽 사이에 끼었을떄 플레이어가 죽도록
	var collision = get_slide_collision(0) # 충돌체를 구한다
	
	if collision != null: # 충돌체가 null 이 아닌경우
		var collider = collision.collider
		if collider.is_in_group("wall") and w_stuck_check == true: # 충돌체가 wall 그룹에 속하고 플레이어가 움직이는 벽의 area안에 들어있는경우
			player_dead()
			pass

	move_and_slide(velocity, Vector2(0, -1))
	
	if jump_ready == true:
		if power < 9:
			power += .4
			$power_gauge.value = (power * 100) + 700
		pass

	if manager.hit_pause == false and Engine.get_time_scale() != 1.0:
		Engine.set_time_scale(lerp(Engine.get_time_scale(), 1.0, .1))
	pass

func attack_in(body):
	if body.name == "ball_body":
		body.hitted(power, velocity.x)
		get_node("../../camera").camera_shake(.05, 5)
		manager.combo += 1
		manager.hit_pause()
	pass # Replace with function body.

func receive_in(body):
	if body.name == "ball_body":
		$sprite.animation = "receive"
		ball.receive()
		# 공의 상태를 체크하고 공 줍기 추가
		# 공의 선형 가속도를 체크?
	pass

func wall_detect(body,inout):
	pass

func _on_sprite_animation_finished():
	if $sprite.animation == "receive":
		$sprite.animation = "idle"
	pass # Replace with function body.

func move_button_press(way):
	
	var button = controls.get_node(way)
	
	if on_floor == true or w_grab == true:
		if jump_ready == false:
			jump_ready = true
			$sprite.animation = "ready"
			$power_gauge.show()
		pass
	else:
		pre_pressed = true
		pre_pressed_way = way
	$attack/CollisionShape2D.disabled = true
	$receive/CollisionShape2D.disabled = true
	pass

func move_button_release(way):
	
	var button = controls.get_node(way)
	
	if pre_pressed == true:
		pre_pressed = false
		pre_pressed_way = ""
	
	if jump_ready == true:
		on_floor = false
		jump_ready = false
		$sprite.animation = "jump"
		if way == "right":
			$sprite.flip_h = true
		velocity.x = (power * 200) + 200
		if way == "left":
			velocity *= -1
			$sprite.flip_h = false
		velocity.y = -((power * 50) + 700)
		move_and_slide(velocity, Vector2(0, -1))
		
		if w_grab_able == true:
			w_grab = false
			w_grab_able = false
			controls.get_node(w_grab_way).show()
			controls.get_node("w_" + w_grab_way).hide()
			w_grab_way = ""
			$attack/CollisionShape2D.disabled = false
			$receive/CollisionShape2D.disabled = true
		
		power = 0
		$power_gauge.hide()
		$attack/CollisionShape2D.disabled = false
		$receive/CollisionShape2D.disabled = true
	
	"""
	if way == "left":
		hp_update(-1)
	elif way == "right":
		hp_update(1)
	"""
	pass

func target_button_press(way):
	
	var button = controls.get_node("target_"+way)
	

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

func target_button_release(way):
	
	var button = controls.get_node("target_"+way)
	"""
	if way == "prev":
		hp_max -= 1
	elif way == "next":
		hp_max += 1
	print(str(hp_max))
	"""
	pass

func wall_grab_button_press(way):
	
	var button = controls.get_node("w_"+way)
	print(button.name+"is pressed and wall grabbed")
	w_grab = true
	state = "grab"
	w_grab_way = way
	velocity = Vector2(0, 0)
	$attack/CollisionShape2D.disabled = true
	$receive/CollisionShape2D.disabled = false

func wall_grab_button_release(way):
	
	var button = controls.get_node("w_"+way)
	print(button.name+"is released and wall not gragged")
	w_grab = false
	$attack/CollisionShape2D.disabled = false
	$receive/CollisionShape2D.disabled = true
	#w_grab_way = ""

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

func player_dead():
	var dead_body_scene = load("res://scene/player_dead.tscn")
	var dead_body = dead_body_scene.instance()
	dead_body.global_position = global_position
	dead_body.get_node("player_dead").velocity = velocity
	get_node("..").add_child(dead_body)
	queue_free()