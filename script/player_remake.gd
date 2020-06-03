extends KinematicBody2D

onready var ball = get_node("/root/ingame/ball/ball_body")

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

var kick_power = 2000
var attack_power = 1
var invincible = false

var flipped = false

var attack_angle = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	flip_check()
	arrowkey_move_input()
	jump_and_gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP) # 계산해서 반환받은 값으로 velocity값을 갱신시켜준다 → 원하는 이동값 에서 시뮬레이트된 값으로
	
	#$attack.look_at(get_global_mouse_position())
	
	pass

func flip_check(): # 마우스 위치에 따라서 좌우반전, 회전도 넣어줄 예정
	
	var mouse_pos = get_global_mouse_position()
	
	if mouse_pos.x < global_position.x:
		if flipped == false:
			flipped = true
			scale.x *= -1
			#$sprite.flip_h = true
	else:
		#velocity.x = speed
		if flipped == true:
			flipped = false
			scale.x *= -1
			#$sprite.flip_h = false

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
	
	#if sprite_state_machine.get_current_node() == "idle" and attacking == true:
	#	attacking = false
	#	print("finish")

func arrowkey_move_input():
	
	if Input.is_action_pressed("move_left"): # / idle - 땅 / slide - 얼음판 / scroll - 스크롤벨트 / on_air - 공중움직임 /
		movement_state_check(-1)

	elif Input.is_action_pressed("move_right"):
		movement_state_check(1)

	else:
		movement_state_check(0)

func jump_and_gravity(delta):
	
	if movement_state == "on_air":
		if velocity.y > 0 and $sprite.animation != "receive":
			$sprite.animation = "receive"
			$sprite.frame = 1
		
		if velocity.y > 0:
			sprite_state_machine.travel("fall")
		elif velocity.y < 0:
			sprite_state_machine.travel("jump")
	
	if Input.is_action_just_pressed("move_jump"):
		if movement_state == "on_air":
			if can_dubble_jump == true:
				can_dubble_jump = false
				velocity.y = dubble_jump
				$sprite.animation = "jump"
				$sprite_anim.play("jump")
		elif attacking == false:
			velocity.y += jump
			$sprite.animation = "jump"
			$sprite_anim.play("jump")

	velocity.y += gravity * delta # 중력값은 계속 적용
	pass

func _unhandled_input(event):
	if Input.is_action_just_pressed("move_attack"):
		if attacking == true and chain_attack == true:
			match sprite_state_machine.get_current_node():
				"attack1":
					sprite_state_machine.travel("attack2")
				"attack2":
					sprite_state_machine.travel("attack3")
		else:
			if is_on_floor():
				sprite_state_machine.travel("attack1")
				attacking = true
			else:
				if jump_attack == false:
					jump_attack = true
					sprite_state_machine.travel("jump_attack")
					print("jump attack")
		
		var b = $attack_zone.get_overlapping_areas() # 적 공격 공도 공격 - area 체크로 모두 통일하기로 했음
		if b.size() > 0:
			for i in b:
				var a = i.get_parent()
				if a.has_method("ball_attacked"):
					a.ball_attacked(kick_power)
		b = $attack_zone.get_overlapping_bodies()
		if b.size() > 0:
			for i in b:
				var a = i.get_parent()
				if a.has_method("enemy_attacked"):
					a.enemy_attacked(attack_power)
				
		get_tree().is_input_handled()

func attack_zone_in(a): # 공이 공격존 안에 들어오면 공격방향을 표시하도록
	a = a.get_parent()
	if a.has_method("move_dir_arrow_toggle"):
		a.move_dir_arrow_toggle("show")
	pass # Replace with function body.


func attack_zone_out(a):
	a = a.get_parent()
	if a.has_method("move_dir_arrow_toggle"):
		a.move_dir_arrow_toggle("hide")
	pass # Replace with function body.


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
