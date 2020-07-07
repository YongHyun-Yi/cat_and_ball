extends KinematicBody2D

onready var manager = get_node("/root/ingame")

var velocity = Vector2()
var gravity = 2000
var jump = -900
var speed = 200

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
	$hp_bar.max_value = hp
	$hp_bar.value = $hp_bar.max_value
	display_chat("핫하 죽어라!")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
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

func chasing_ai(): # 타입이 두개 - 일정범위를 랜덤하게 돌아다니다가 사거리 안에 들어오면 추격 / 그냥 무작정 추격
	if chasing_mode == true:
		if attacking == false:
			if manager.player.global_position.x > global_position.x:
				velocity.x = speed
			else:
				velocity.x = -speed
			
			if manager.player.global_position.y < global_position.y - 150 and is_on_floor():
				velocity.y = jump
		else:
			velocity.x = 0

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
