extends Node2D

var combo = 0
var targets = []
var hit_pause = false

onready var player = get_node("player/player_body")
onready var ball = get_node("ball/ball_body")
onready var camera = get_node("camera")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$background/combo.text = "COMBO\n"+str(combo)
	pass

func restart():
	get_tree().reload_current_scene()
	pass

func go_to_main_screen():
	get_tree().change_scene("res://scene/main_screen.tscn")
	pass

func hit_pause():
	get_tree().paused = true
	#Engine.set_time_scale(.01)
	#$hit_pause_timer.wait_time = 1.8 * Engine.get_time_scale()
	$hit_pause_timer.start()
	hit_pause = true
	print("느려짐 시작")

func hit_pause_timer_timeout():
	get_tree().paused = false
	$hit_pause_timer.stop()
	#Engine.set_time_scale(1.0)
	hit_pause = false
	ball.get_node("sprite").texture = load("res://sprite/ball.png")
	ball.get_node("effect2").hide()
	print("느려짐 끝")
	pass # Replace with function body.

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		camera.camera_shake(1, 30)
