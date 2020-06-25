extends KinematicBody2D

onready var manager = get_node("/root/ingame")
onready var camera = get_node("/root/ingame/camera")
onready var ball = get_node("/root/ingame/ball/ball_body")
onready var chat_sys = get_node("/root/ingame/buttons/chat_system")

export (String, "idle", "slide", "scroll", "on_air", "wall") var movement_state = "idle"

onready var sprite_state_machine = $sprite_anim_tree.get("parameters/playback")

var velocity = Vector2()
var gravity = 2000
var jump = -900
var dubble_jump = -800
var can_dubble_jump = true

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

# 공 잡음 상태 추가
var ball_grab = false
var ball_pull = false

var invincible = false

var flipped = false

var attack_angle = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	flip_check()
	ball_grab_check()
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
	
	if Input.is_action_pressed("move_left"): # / idle - 땅 / slide - 얼음판 / scroll - 스크롤벨트 / on_air - 공중움직임 /
		movement_state_check(-1)

	elif Input.is_action_pressed("move_right"):
		movement_state_check(1)

	else:
		movement_state_check(0)

func jump_input():
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
			velocity.y += jump

func _unhandled_input(event):
	
	arrowkey_move_input()
	jump_input()
	attack_events()

	if Input.is_action_just_pressed("ball_grab"):
		if ball_grab == false: # 끌어당기기
			if ball_pull == false:
				ball_pull = true
				ball.pulled = true
				ball.linear_velocity = Vector2.ZERO
				ball.gravity_scale = 1
			#else:
				#ball.pulled_speed = Vector2(2000, 0).rotated(global_position.angle_to_point(ball.global_position))
		pass
	if Input.is_action_just_released("ball_grab"): # 끌어당기기 취소
		if ball_grab == false:
			ball_pull = false
			ball.pulled = false
			ball.pulled_speed = Vector2.ZERO
			ball.gravity_scale = 8
		#get_tree().is_input_handled()

func attack_events():
	if Input.is_action_just_pressed("move_attack"):
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
			ball.ball_throw()

func hit_zone_in(a): # 공격범위 안에 적이 있으면 공격 메소드를 실행
	a = a.get_parent()
	#print(a.name)
	if a.has_method("enemy_attacked"):
		a.enemy_attacked(attack_power, attack_camera.x, attack_camera.y, attack_pause)
	elif a.has_method("ball_attacked"):
		a.ball_attacked(kick_power)



func ball_grab_check():
	if ball_pull == true:
		var a = $hurt_zone.get_overlapping_bodies()
		if a.size() > 0:
			print(str(a))
			for i in a:
				if not i.has_method("ball_grabed"):
					continue
				
				i.ball_grabed()


func floor_check_in(body): # 바닥에 착지 / 착지후 애니메이션 여기서 설정?
	var a = body.get_parent()
	
	if not a.get("state") == null:
		a.state_update(self)
		$sprite.animation = "idle"
		$sprite.frame = 1
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
	print("finish")

func display_chat(chat):
	$chat/HBoxContainer/VBoxContainer/Label.text = chat
	$chat/Timer.start()
	$chat.show()
	print(str(chat.length()))

func chat_timeout():
	$chat/Timer.stop()
	$chat/HBoxContainer/VBoxContainer/Label.text = ""
	$chat.hide()

func chat_Label_resized():
	
	var chat_box_min = Vector2(20, 24)
	#var chat_box_pos = Vector2(-9, -188)
	var chat_box_pos = Vector2(-9, -43)
	
	if $chat/HBoxContainer/VBoxContainer/Label.text.length() > 19:
		$chat/HBoxContainer/VBoxContainer/Label.rect_min_size.x = 380
		$chat/HBoxContainer/VBoxContainer/Label.autowrap = true
	else:
		$chat/HBoxContainer/VBoxContainer/Label.autowrap = false
		$chat/HBoxContainer/VBoxContainer/Label.rect_min_size.x = chat_box_min.x
	
	var a = $chat/HBoxContainer/VBoxContainer/Label.rect_size - chat_box_min
	a.x /= 2
	$chat/HBoxContainer.rect_position = chat_box_pos - a
