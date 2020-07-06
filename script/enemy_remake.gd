extends KinematicBody2D

onready var manager = get_node("/root/ingame")
#onready var player = get_node("/root/ingame/player/player_body")
#onready var ball = get_node("/root/ingame/ball/ball_body")
#onready var camera = get_node("/root/ingame/camera")

var velocity = Vector2()
var gravity = 2000
var jump = -900
var speed = 400

var guard_mode = false

var invincible = false

export var hp = 5

signal hurt_valid_by_player
signal hurt_valid_by_ball
signal hit_guard

# Called when the node enters the scene tree for the first time.
func _ready():
	$hp_bar.max_value = hp
	$hp_bar.value = $hp_bar.max_value
	
	#connect("hurt_valid_by_player", player, "hit_valid")
	#connect("hurt_valid_by_ball", ball, "hit_valid")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#arrowkey_move_input()
	jump_and_gravity(delta)
	move_and_slide(velocity, Vector2(0, -1))
	pass

func arrowkey_move_input():
	#if Input.is_action_pressed("ui_left"):
		
	#	velocity.x = -speed
		
	#elif Input.is_action_pressed("ui_right"):
		
	#	velocity.x = speed
		
	#else:
	#	velocity.x = 0
	pass

func jump_and_gravity(delta):
	if is_on_floor():
		if velocity.y > 0:
			velocity.y = 0
			$sprite.animation = "idle"
		
		#if Input.is_action_pressed("ui_up"):
		#	velocity.y += jump
		#	$sprite.animation = "jump"
	else:
		if velocity.y < gravity:
			velocity.y += gravity * delta
	pass

func ball_hit():
	hp_update(-1)
	print("ball hit!")

func hit_valid():
	pass

func hurt_check(attack_power, attacker):
	print("enemy hurt check")
	if guard_mode == false:
		hurt_valid(attack_power)
		
		if attacker.name == "player_body":
			connect("hurt_valid_by_player", attacker, "hit_valid")
			emit_signal("hurt_valid_by_player")
			disconnect("hurt_valid_by_player", attacker, "hit_valid")
		
		elif attacker.name == "ball_body":
			connect("hurt_valid_by_ball", attacker, "hit_valid")
			emit_signal("hurt_valid_by_ball")
			disconnect("hurt_valid_by_ball", attacker, "hit_valid")

func hurt_valid(attack_power):
	hp_update(-attack_power)
	hit_shake()
	print("enemy hurt valid")
	pass

func enemy_attacked(attack_power, attack_camera_time, attack_camera_power, attack_camera_pause):
	
	hp_update(-attack_power)
	hit_shake()
	manager.camera.camera_shake(attack_camera_time, attack_camera_power, attack_camera_pause)
	print("damaged!")

func hit_shake():
	
	var power = 5
	var time = 0
	var time_limit = .2
	
	var initial_offset = $sprite.get_offset()
	#manager.hit_pause(time_limit)
	
	while time < time_limit:
		time += get_process_delta_time()
		time = min(time, time_limit)
		
		randomize()
		
		var offset = Vector2()
		offset.x = rand_range(-power, power)
		offset.y = rand_range(-power, power)
		$sprite.set_offset(offset)
		
		yield(get_tree(), "idle_frame")

	$sprite.set_offset(initial_offset)

func hp_update(a):
	hp += a
	$hp_bar.value = hp
	if hp <= 0:
		queue_free()

func interact_spike():
	if invincible == false:
		invincible = true
		$hitted_anim.play("hitted")
		$hitted_anim/Timer.start()
