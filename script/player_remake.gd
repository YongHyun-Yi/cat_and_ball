extends KinematicBody2D

onready var manager = get_node("/root/ingame")
onready var hp_bar = get_node("/root/ingame/uis/ingame_infos/hp_bar")
onready var ball_bar = get_node("/root/ingame/uis/ingame_infos/ball_bar")

var ball = null
var ball_scene = load("res://scene/ball.tscn")
onready var chat_sys = get_node("/root/ingame/uis/chat_system")

export (String, "idle", "slide", "scroll", "on_air", "wall") var movement_state = "idle"

onready var sprite_state_machine = $sprite_anim_tree.get("parameters/playback")

export var hp : int
export var hp_max : int = 10

signal bar_update

var velocity = Vector2()
var gravity = 2000
var jump = -900
var dubble_jump = -800
var can_dubble_jump = true
var can_move = true

var speed = 400

var slide_acl = 20
var slide_max = 700

var scroll_acl = 0

var attacking = false
var jump_attack = false
export var chain_attack = false

export var kick_power = 2000
export var attack_power = 1
export var attack_camera = Vector2()
export var attack_pause = 0.0
signal attacked

var ball_spawn_point = 0
var ball_spawn_point_max = 100
var ball_spawnable = false
var ball_spawned = false

# 공 잡음 상태 추가
var ball_grab = false
var ball_pull = false

var invincible = false

var flipped = false

var attack_angle = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	
	hp = hp_max
	hp_bar.max_value = hp_max
	hp_bar.value = hp
	
	ball_bar.value = ball_spawn_point
	ball_bar.max_value = ball_spawn_point_max
	
	manager.get_node("uis/chat_system").connect("chat_mode", self, "chat_mode")
	
	get_ball_spawn_point(100)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	flip_check()
	
	arrowkey_move_input()
	jump_input()
	
	attack_events()
	
	ball_grab_event()
	ball_grab_check()
	#used_ball_spwan_point()
	
	velocity.y += gravity * delta # 중력값은 계속 적용
	velocity = move_and_slide(velocity, Vector2.UP) # 계산해서 반환받은 값으로 velocity값을 갱신시켜준다 → 원하는 이동값 에서 시뮬레이트된 값으로
	
	#$attack.look_at(get_global_mouse_position())
	
	pass

func flip_check(): # 마우스 위치에 따라서 좌우반전, 회전도 넣어줄 예정
	
	var mouse_pos = get_global_mouse_position()
	
	if attacking == false and jump_attack == false:
		if mouse_pos.x < global_position.x:
			if flipped == false:
				flipped = true
				scale.x *= -1
				$chat.rect_scale.x *= -1
		else:
			if flipped == true:
				flipped = false
				scale.x *= -1
				$chat.rect_scale.x *= -1

func movement_state_check(a):
	if attacking == false: # 공격중이 아닐때
		match movement_state:
			"idle":
				velocity.x = (speed*a)
			"slide":
				if a > 0: # 우측입력
					velocity.x = min(velocity.x + slide_acl, slide_max)
				elif a < 0: # 좌측입력
					velocity.x = max(velocity.x - slide_acl, -slide_max)
				elif a == 0: # 입력없음
					if velocity.x != 0:
						velocity.x = lerp(velocity.x, 0, 0.04) 
			"scroll":
				velocity.x = (speed*a) + scroll_acl
		if jump_attack == false:
			if a != 0:
				sprite_state_machine.travel("walk")
			else:
				sprite_state_machine.travel("idle")
	
	else: # 공격중 일 때
		match movement_state:
			"idle":
				velocity.x = 0
			"slide":
					if velocity.x != 0:
						velocity.x = lerp(velocity.x, 0, 0.04) 
			"scroll":
				velocity.x = scroll_acl
	
	if movement_state == "on_air": # 공중은 공격에 상관없이 같은 스피드
		if a > 0:
			if velocity.x > speed:
				velocity.x = velocity.x
			else:
				velocity.x = lerp(velocity.x, speed, 0.15)
		elif a < 0:
			if velocity.x < -speed:
				velocity.x = velocity.x
			else:
				velocity.x = lerp(velocity.x, -speed, 0.15)
		elif a == 0:
			velocity.x = lerp(velocity.x, speed, 0.001)

func arrowkey_move_input():
	
	if can_move == true and sprite_state_machine.get_current_node() != "pre_jump":
	
		if Input.is_action_pressed("move_left"): # / idle - 땅 / slide - 얼음판 / scroll - 스크롤벨트 / on_air - 공중움직임 /
			movement_state_check(-1)
	
		elif Input.is_action_pressed("move_right"):
			movement_state_check(1)
	
		else:
			movement_state_check(0)
	
	else:
		movement_state_check(0)

func jump_input():
	if can_move == true:
	
		if movement_state == "on_air":
			if jump_attack == false:
				if velocity.y > 0:
					sprite_state_machine.travel("fall")
				elif velocity.y < 0:
					sprite_state_machine.travel("jump")
		
		if Input.is_action_just_pressed("move_jump"):
			if movement_state == "on_air":
				if can_dubble_jump == true:
					can_dubble_jump = false
					velocity.y = dubble_jump
			elif attacking == false:
				sprite_state_machine.travel("pre_jump")
				#velocity.y += jump

func jump_func():
	print("jump!")
	velocity.y += jump

func _unhandled_input(event):

	#attack_events()
	#ball_grab_event()
	if Input.is_action_just_pressed("target_next"):
		hp_update(1)
	elif Input.is_action_just_pressed("target_prev"):
		hp_update(-1)

func attack_events():
	if Input.is_action_just_pressed("normal_attack"):
		if ball_grab == false:
			if is_on_floor(): # 지상공격
				if attacking == true and chain_attack == true:
					match sprite_state_machine.get_current_node():
						"attack1":
							sprite_state_machine.travel("attack2")
						"attack2":
							sprite_state_machine.travel("attack3")
				else:
					sprite_state_machine.travel("attack1")
					attacking = true
			else: # 공중공격
				if jump_attack == false:
					jump_attack = true
					sprite_state_machine.travel("jump_attack")
					print("jump attack")
		elif ball_grab == true: # 공던지기
			manager.ball.ball_throw()

func ball_grab_event():
	if ball_spawned == true: # 공이 이미 존재할때
		if Input.is_action_just_pressed("ball_event"):
			if ball_grab == false: # 공을 잡고있지 않은경우 끌어당기기
				if ball_pull == false:
					ball_pull = true
					manager.ball.ball_pulled_event()
					print("pulling start")
			pass
		elif Input.is_action_just_released("ball_event"): # 끌어당기기 취소
			if ball_grab == false:
				ball_pull = false
				manager.ball.ball_pulled_finish()
				print("pulling finish")
	
	else: # 공이없다면 조건확인후 생성
		if Input.is_action_just_pressed("ball_event"):
			ball_spawn_event()
	pass

func ball_spawn_event(): # 공 생성
	if ball_spawnable == true:
		ball_spawned = true
		manager.ball = ball_scene.instance()
		manager.get_node("ball").add_child(manager.ball)
		manager.ball.global_position = global_position
		ball_bar.get_node("../ball_info_effect").show()
		ball_bar.get_node("../ball_info_effect").playing = true
		get_tree().set_input_as_handled()
	pass

func hit_zone_in(a): # 공격범위 안에 적이 있으면 공격 메소드를 실행
	print("start check")
	a = a.get_parent()
	var b
	if a.name == "ball_body":
		b = kick_power
	else:
		b = attack_power
	
	a.hurt_check(b, self)
	"""
	if a.has_method("enemy_attacked"):
		a.enemy_attacked(attack_power, attack_camera.x, attack_camera.y, attack_pause)
	elif a.has_method("ball_attacked"):
		a.ball_attacked(kick_power)
	"""

func hit_valid():
	print("player hit valid")
	manager.camera.camera_shake(attack_camera.x, attack_camera.y, attack_pause)
	#manager.hit_pause(attack_pause)
	get_ball_spawn_point(40)

func get_ball_spawn_point(a):
	if ball_spawn_point + a > ball_spawn_point_max:
		ball_spawn_point = ball_spawn_point_max
	else:
		ball_spawn_point += a
	
	#ball_bar.value = ball_spawn_point
	emit_signal("bar_update", "ball_bar", a)
	
	if ball_spawnable == false and ball_spawn_point == ball_spawn_point_max:
		ball_spawnable = true
		ball_bar.get_node("anim").play("spwanable")
		pass

func used_ball_spwan_point():
	if ball_spawned == true:
		var a = -1
		ball_spawn_point += a
		#emit_signal("bar_update", "ball_bar", a)
		ball_bar.value = ball_spawn_point
		
		if ball_spawn_point <= 0:
			ball_delete()
			ball_bar.get_node("anim").play("reset")
			ball_bar.get_node("../ball_info_effect").hide()
			ball_bar.get_node("../ball_info_effect").playing = false
			ball_bar.get_node("../ball_info_effect").frame = 0
			#manager.get_node("uis/Panel/ProgressBar").self_modulate = "ffffff"
	pass

func ball_delete():
	ball_grab = false
	ball_pull = false
	ball_spawned = false
	ball_spawnable = false
	ball_spawn_point = 0
	manager.ball.queue_free()
	manager.ball = null

func hurt_check(attack_power):
	pass

func hurt_valid(attack_power):
	pass

func hit_shake(): # 스프라이트 흔들기
	
	var power = 5
	var time = 0
	var time_limit = .2
	
	var initial_offset = $Sprite.get_offset()
	
	while time < time_limit:
		time += get_process_delta_time()
		time = min(time, time_limit)
		
		randomize()
		
		var offset = Vector2()
		offset.x = rand_range(-power, power)
		offset.y = rand_range(-power, power)
		$Sprite.set_offset(offset)
		
		yield(get_tree(), "idle_frame")

	$Sprite.set_offset(initial_offset)

func hp_update(a):
	if hp + a > hp_max:
		hp = hp_max
	else:
		hp += a
	#hp_bar.value = hp
	#hp = hp_bar.value
	emit_signal("bar_update", "hp_bar", a)

func ball_grab_check():
	if ball_pull == true:
		"""
		var a = $hurt_zone.get_overlapping_bodies()
		if a.size() > 0:
			print(str(a))
			for i in a:
				if not i.has_method("ball_grabed"):
					continue
				
				i.ball_grabed()
		"""
		if $hurt_zone.overlaps_body(manager.ball):
			manager.ball.ball_grabed()
			print("get ball!")


func floor_check_in(body): # 바닥에 착지 / 착지후 애니메이션 여기서 설정?
	var a = body.get_parent()
	
	if not a.get("state") == null:
		a.state_update(self)
		#$sprite.animation = "idle"
		#$sprite.frame = 1
		sprite_state_machine.travel("idle")
		can_dubble_jump = true
		jump_attack = false
	pass # Replace with function body.


func floor_check_out(body):
	movement_state = "on_air"
	pass # Replace with function body.


func hitted_timeout():
	$hitted_anim/Timer.stop()
	$hitted_anim.play("reset")
	invincible = false
	pass # Replace with function body.

func interact_spike():
	if invincible == false:
		invincible = true
		$hitted_anim.play("hitted")
		$hitted_anim/Timer.start()

func anim_finish():
	attacking = false
	#print("finish")

func chat_mode(toggle):
	if toggle == "on":
		$chat/anim_icon.play()
		$chat/anim_icon.show()
		can_move = false
	else:
		can_move = true
		$chat/anim_icon.frame = 0
		$chat/anim_icon.stop()
		$chat/anim_icon.hide()

func display_chat(chat):
	$chat/chat_box/Label.text = chat
	$chat/Timer.start()
	$chat/chat_box.show()

func chat_timeout():
	$chat/Timer.stop()
	$chat/chat_box/Label.text = ""
	$chat/chat_box.hide()

func chat_Label_resized():
	
	var chat_box_min = Vector2(20, 24)
	var chat_box_pos = Vector2(-1, -112)
	
	if $chat/chat_box/Label.text.length() > 19:
		$chat/chat_box/Label.rect_min_size.x = 380
		$chat/chat_box/Label.autowrap = true
	else:
		$chat/chat_box/Label.autowrap = false
		$chat/chat_box/Label.rect_min_size.x = chat_box_min.x
	
	var a = $chat/chat_box/Label.rect_size - chat_box_min
	a.x /= 2
	$chat/chat_box.rect_position = chat_box_pos - a
