extends KinematicBody2D

onready var ball = get_node("/root/ingame/ball/ball_body")
onready var camera = get_node("/root/ingame/camera")

var velocity = Vector2()
var gravity = 2000
var jump = -900
var speed = 400

var invincible = false

export var hp = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	$hp_bar.max_value = hp
	$hp_bar.value = $hp_bar.max_value
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

func enemy_attacked(attack_power, attack_camera_time, attack_camera_power):
	camera.camera_shake(attack_camera_time, attack_camera_power)
	hp_update(-attack_power)
	print("damaged!")

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
