extends KinematicBody2D

onready var ball = get_node("/root/ingame/ball/ball_body")

var velocity = Vector2()
var gravity = 2000
var jump = -900
var dubble_jump = -800
var can_dubble_jump = true
var speed = 400

var kick_power = 2000
var attack_power = 1

var flipped = false

var attack_angle = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if get_slide_count():
	#	for i in get_slide_count():
	#		var collision = get_slide_collision(i)
	#		print("Collided with: ", collision.collider.name)
	
	flip_check()
	arrowkey_move_input()
	jump_and_gravity(delta)
	move_and_slide(velocity, Vector2(0, -1))
	
	#$attack.look_at(get_global_mouse_position())
	
	pass

func flip_check(): # 마우스 위치에 따라서 좌우반전, 회전도 넣어줄 예정
	
	var mouse_pos = get_global_mouse_position()
	
	if mouse_pos.x < global_position.x:
		if flipped == false:
			flipped = true
			scale.x *= -1
	else:
		velocity.x = speed
		if flipped == true:
			flipped = false
			scale.x *= -1

func arrowkey_move_input():
	if Input.is_action_pressed("move_left"):
		
		velocity.x = -speed
		
	elif Input.is_action_pressed("move_right"):
		
		velocity.x = speed
		
	else:
		velocity.x = 0

func jump_and_gravity(delta):
	
	if is_on_floor():
		if velocity.y > 0:
			velocity.y = 0
			$sprite.animation = "idle"
			can_dubble_jump = true
		
		if Input.is_action_just_pressed("move_jump"):
			velocity.y += jump
			$sprite.animation = "jump"
			print(str(can_dubble_jump))
	else:
		if Input.is_action_just_pressed("move_jump") and can_dubble_jump == true:
			can_dubble_jump = false
			velocity.y = 0
			velocity.y += dubble_jump
			$sprite.animation = "jump"
			print(str(can_dubble_jump))
		
		if velocity.y < gravity:
			velocity.y += gravity * delta
	
	pass

func _unhandled_input(event):
	if Input.is_action_just_pressed("move_attack"):
		#print("attack")
		
		"""
		var b = $attack.get_overlapping_bodies() # 공 공격
		
		if b.size() > 0:
			for i in b:
				
				var bs = $attack.global_position.direction_to(get_global_mouse_position())
				bs.x = stepify(bs.x, 0.1)
				bs.y = stepify(bs.y, 0.1)
				print(str(bs))
				
				i.attacked(bs)
		"""
		
		var b = $attack.get_overlapping_areas() # 적 공격 공도 공격 - area 체크로 모두 통일하기로 했음
		if b.size() > 0:
			for i in b:
				
				var a = i.get_parent()
				if a.has_method("ball_attacked"):
					a.ball_attacked(kick_power)
				elif a.has_method("enemy_attacked"):
					a.enemy_attacked(attack_power)
		
		get_tree().is_input_handled()


func attack_zone_in(area): # 공이 공격존 안에 들어오면 공격방향을 표시하도록
	#print("area in")
	var a = area.get_parent()
	if a.has_method("move_dir_arrow_toggle"):
		a.move_dir_arrow_toggle("show")
	pass # Replace with function body.


func attack_zone_out(area):
	#print("area in")
	var a = area.get_parent()
	if a.has_method("move_dir_arrow_toggle"):
		a.move_dir_arrow_toggle("hide")
	pass # Replace with function body.
