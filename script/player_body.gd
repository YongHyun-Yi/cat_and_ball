extends KinematicBody2D

var velocity = Vector2()
var speed = 350#250
var gravity = 2000
var jump = -700
var d_jump = -550
var double_jump = true
var attack_point = Vector2()
var move_button_first = Vector2()
var move_button_press = false
var move_swipe = false
var move_way = "center"
var move_button_timer = 0
var attack_power = 0
var mns

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/ingame/SwipeDetector").connect("swiped", self, "get_swipe")
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
		"""var a = get_slide_collision(1)
		if a.collider.is_in_group("wall"):
			print("wall")
			speed *= -1"""
		pass
	#get_input()
	#velocity.x = speed
	mns = move_and_slide(velocity, Vector2(0, -1))
	get_node("../Label").text = str(attack_point)
	"""
	if move_button_press == true and move_swipe == false:
		if move_button_timer < 17:
			move_button_timer += 1
			#print("timer is : "+str(move_button_timer))
			if abs(move_button_first.x - get_global_mouse_position().x) >= 23 :
				move_swipe = true
				print("move swipe")
				var a = get_node("../../button2")
				#포지션 /110/312/230/
				if move_button_first.x > get_global_mouse_position().x:
					if move_way != "left":
						
						if move_way == "center":
							a.global_position.x = 312-60
							velocity.x = -speed
							move_way = "left"
						elif move_way == "right":
							a.global_position.x = 312
							velocity.x = 0
							move_way = "center"
							
						a.global_position.x = 312-60
						velocity.x = -speed
						move_way = "left"
						move_button_first = get_global_mouse_position()
				elif move_button_first.x < get_global_mouse_position().x:
					if move_way != "right":
						
						if move_way == "center":
							a.global_position.x = 312+60
							velocity.x = speed
							move_way = "right"
						if move_way == "left":
							a.global_position.x = 312
							velocity.x = 0
							move_way = "center"
							
						a.global_position.x = 312+60
						velocity.x = speed
						move_way = "right"
						move_button_first = get_global_mouse_position()
		elif move_button_timer == 17:
			if attack_power < 29:
				attack_power += 1
				$sprite.self_modulate = "fff500"
			elif attack_power == 29:
				attack_power += 1
				$sprite.self_modulate = "ff0000"
			#print("power is : "+str(attack_power))
			#speed *= 2
	
	elif move_button_press == true and move_swipe == true:
		if abs(move_button_first.x - get_global_mouse_position().x) >= 23 :
				var a = get_node("../../button2")
				#포지션 /110/170/230/
				if move_button_first.x > get_global_mouse_position().x:
					if move_way != "left":
						if move_way == "center":
							a.global_position.x = 312-60
							velocity.x = -speed
							move_way = "left"
						elif move_way == "right":
							a.global_position.x = 312
							velocity.x = 0
							move_way = "center"
						move_button_first = get_global_mouse_position()
				elif move_button_first.x < get_global_mouse_position().x:
					if move_way != "right":
						if move_way == "center":
							a.global_position.x = 312+60
							velocity.x = speed
							move_way = "right"
						if move_way == "left":
							a.global_position.x = 312
							velocity.x = 0
							move_way = "center"
						move_button_first = get_global_mouse_position()
						
	"""
	# 버튼 없이 화면으로만 조작
	# 스와이프 양방향으로 이동
	# 터치 더블터치로 점프
	# 공격버튼은 하단에 따로 만들것 / 리듬게임처럼 타이밍 맞춰서 누르기?
	# 양끝을 더블터치하면 다이빙
	# 벽에 부딫혔을때 점프상태가 아니면 가만히 서있기
	
	pass

func get_swipe(a):
	if a.x > 0:
		velocity.x = -speed
	elif a.x < 0:
		velocity.x = speed
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
	if body.name == "ball_body":
		body.hitted()

func wall_detect(body):
	#if body.name == "wall_left":
	#	print(body.name)
	pass

func move_button(a):
	"""
	if a == "press":
		move_button_timer = 0
		attack_power = 0
		move_button_press = true
		move_button_first = get_global_mouse_position()
	elif a == "release":
		if move_button_timer < 17 and move_swipe == false:
			#speed /= 2
			if is_on_floor():
				velocity.y = jump
				print("jump!")
			elif double_jump == true:
				velocity.y = d_jump
				double_jump = false
				print("double jump!")
		elif attack_power > 0:
			$sprite.self_modulate = "ffffff"
			$anim.play("attack")
		move_button_first = Vector2()
		print("attack power is : "+str(attack_power))
		#else:
			#speed *= -1
		move_button_press = false
		move_swipe = false
		"""
	pass