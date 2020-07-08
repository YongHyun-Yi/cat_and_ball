extends KinematicBody2D

onready var manager = get_node("/root/ingame")

onready var sprite_state_machine = $sprite_anim_tree.get("parameters/playback")

var velocity = Vector2()
var gravity = 2000
var jump = -900
var speed = 200

var h_flip = false

var pre_jump = false
var pre_jump_func_value : int = 0
var jump_func_value : int = 0
var landing_check = false

export (String, "idle_stop", "idle_move") var idle_mode = "idle_stop"
export var idle_stop_time : int = 5
export var idle_move_time : int = 10

export var chasing_mode = false
var attacking = false
var attack_ray = 0

var guard_mode = false

var invincible = false

export var hp = 5

signal hurt_valid
signal hit_guard

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	$idle_mode_timer.wait_time = rand_range(3, 7)
	$idle_mode_timer.start()
	
	$hp_bar.max_value = hp
	$hp_bar.value = $hp_bar.max_value
	display_chat("핫하 죽어라!")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	#h_flip_check()
	
	if is_on_floor() and velocity.x == 0:
		velocity_x_update()
	anim_state_update()
	chasing_ai()
	
	attack_ray = manager.player.global_position - global_position
	attack_ray = attack_ray.clamped(100.0)
	$RayCast2D.cast_to = attack_ray
	
	if $RayCast2D.is_colliding() and $RayCast2D.get_collider() == manager.player:
		attacking = true
	else:
		attacking = false
	
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
	pass

"""
func ball_hit():
	hp_update(-1)
	print("ball hit!")
"""

func h_flip_check():
	if manager.player.global_position.x > global_position.x:
		if h_flip == true:
			h_flip = false
			scale.x *= -1
			$chat.rect_scale.x *= -1
			#velocity.x = speed
	
	elif manager.player.global_position.x < global_position.x:
		if h_flip == false:
			h_flip = true
			scale.x *= -1
			$chat.rect_scale.x *= -1
			#velocity.x = -speed

func h_flip_func():
	if h_flip == true:
			h_flip = false
			scale.x *= -1
			$chat.rect_scale.x *= -1
	else:
		h_flip = true
		scale.x *= -1
		$chat.rect_scale.x *= -1

func velocity_x_update():
	if manager.player.global_position.x > global_position.x:
		velocity.x = speed
	elif manager.player.global_position.x < global_position.x:
		velocity.x = -speed

func anim_state_update():
	if is_on_floor():
		if velocity.x != 0:
			if sprite_state_machine.get_current_node() != "walk":
				sprite_state_machine.travel("walk")
		else:
			if sprite_state_machine.get_current_node() != "idle":
				sprite_state_machine.travel("idle")
	else:
		if velocity.y > 0:
			if sprite_state_machine.get_current_node() != "fall":
				sprite_state_machine.travel("fall")
		else:
			if sprite_state_machine.get_current_node() != "jump":
				sprite_state_machine.travel("jump")
	pass

func pre_jump_func():
	print("pre!")
	velocity.y = pre_jump_func_value
	pre_jump_func_value = 0
	pre_jump = false
	print(str(pre_jump))
	landing_check = true
	
func jump_func():
	velocity.x = jump_func_value
	jump_func_value = 0

func chasing_ai(): # 가로점프 350 세로점프 190
	if chasing_mode == true:
		if attacking == false:
			
			if pre_jump == false:
				if h_flip == false:
					velocity.x = speed
				else:
					velocity.x = -speed
			else:
				velocity.x = 0
			
			if abs(manager.player.global_position.y - global_position.y) <= 190:
				
				if is_on_floor():
					h_flip_check()
				
				if manager.player.global_position.y <= global_position.y and is_on_floor():
					
					for i in get_slide_count():
						var collision = get_slide_collision(i)
						if collision.get_normal() == Vector2.LEFT or collision.get_normal() == Vector2.RIGHT: # 벽에 좌우로 충돌시
							if collision.collider.get_parent().rect_size.y <= 190: # 바닥을 원점으로 190
								pre_jump_func_value = (jump/2) + (jump/2 * (collision.collider.get_parent().rect_size.y)/190) # 점프력 900값을 모두 비례로 잡으면 작은벽도 못 넘길래 기본점프값 + 비례값으로 설정 500정도 해야 다른 크기의 벽도 넘는것으로 보임
								sprite_state_machine.travel("pre_jump")
					
					if $up_wall_check.is_colliding() and $up_wall_check.get_collider().get_parent().one_way == true and sprite_state_machine.get_current_node() != "pre_jump": # 통과가능한 벽 + 지상에 있을 떄
						if global_position.y - $up_wall_check.get_collider().global_position.y <= 129: # 맨바닥에서 세운 벽은 사이즈가 190이라면 공중에 뜬 벽은 사이즈보단 시작점으로 좌표계산 대충 129가 위와 동일한 높이
							pre_jump_func_value = (- 600) + (- 300 * (global_position.y - $up_wall_check.get_collider().global_position.y)/129) # 얘는 기본점프가 600이여야함 ㄱ-;
							pre_jump = true
							print("pree true")
							sprite_state_machine.travel("pre_jump")
							
			
			else:
				
				if manager.player.global_position.y < global_position.y and is_on_floor():
					
					for i in get_slide_count():
						var collision = get_slide_collision(i)
						if collision.get_normal() == Vector2.LEFT or collision.get_normal() == Vector2.RIGHT: # 벽에 좌우로 충돌시
							if collision.collider.get_parent().rect_size.y <= 190: # 바닥을 원점으로 190
								pre_jump_func_value = (jump/2) + (jump/2 * (collision.collider.get_parent().rect_size.y)/190) # 점프력 900값을 모두 비례로 잡으면 작은벽도 못 넘길래 기본점프값 + 비례값으로 설정 500정도 해야 다른 크기의 벽도 넘는것으로 보임
								sprite_state_machine.travel("pre_jump")
							else:
								h_flip_func()
								
					
					if $up_wall_check.is_colliding() and $up_wall_check.get_collider().get_parent().one_way == true and sprite_state_machine.get_current_node() != "pre_jump": # 통과가능한 벽 + 지상에 있을 떄
						if global_position.y - $up_wall_check.get_collider().global_position.y <= 129: # 맨바닥에서 세운 벽은 사이즈가 190이라면 공중에 뜬 벽은 사이즈보단 시작점으로 좌표계산 대충 129가 위와 동일한 높이
							pre_jump_func_value = (- 600) + (- 300 * (global_position.y - $up_wall_check.get_collider().global_position.y)/129) # 얘는 기본점프가 600이여야함 ㄱ-;
							pre_jump = true
							sprite_state_machine.travel("pre_jump")

func attack_event(): # 공격범위 안에 들어왔을경우 이동을 멈추고 공격 + 레이캐스트
	pass

func hit_valid():
	print("enemy hit valid")
	manager.camera.camera_shake(0.2, 20, 0.2)
	#manager.hit_pause(0.2)
	pass

func hurt_check(attack_power, attacker):
	print("enemy hurt check")
	if guard_mode == false:
		hurt_valid(attack_power)
		connect("hurt_valid", attacker, "hit_valid")
		emit_signal("hurt_valid")
		disconnect("hurt_valid", attacker, "hit_valid")

func hurt_valid(attack_power):
	hp_update(-attack_power)
	hit_shake()
	print("enemy hurt valid")

"""
func enemy_attacked(attack_power, attack_camera_time, attack_camera_power, attack_camera_pause):
	
	hp_update(-attack_power)
	hit_shake()
	manager.camera.camera_shake(attack_camera_time, attack_camera_power, attack_camera_pause)
	print("damaged!")
"""

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
	hp += a
	$hp_bar.value = hp
	if hp <= 0:
		queue_free()

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
	var chat_box_pos = Vector2(-11, -112)
	
	if $chat/chat_box/Label.text.length() > 19:
		$chat/chat_box/Label.rect_min_size.x = 380
		$chat/chat_box/Label.autowrap = true
	else:
		$chat/chat_box/Label.autowrap = false
		$chat/chat_box/Label.rect_min_size.x = chat_box_min.x
	
	var a = $chat/chat_box/Label.rect_size - chat_box_min
	a.x /= 2
	$chat/chat_box.rect_position = chat_box_pos - a

func interact_spike():
	if invincible == false:
		invincible = true
		$hitted_anim.play("hitted")
		$hitted_anim/Timer.start()


func idle_mode_timeout():
	$idle_mode_timer.stop()
	if idle_mode == "idle_stop":
		idle_mode = "idle_move"
		$idle_mode_timer.wait_time = idle_move_time
		$idle_mode_timer.start()
	else:
		idle_mode = "idle_stop"
		$idle_mode_timer.wait_time = idle_stop_time
		$idle_mode_timer.start()
	pass # Replace with function body.
