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
	#$buttons/Label.text = "state : "+ball.movement_state+"\n applied force.x : "+str(ball.applied_force.x)
	$buttons/Label.text = "velocity : "+str(ball.get_linear_velocity())
	#$buttons/Label.text = "state : "+str(player.can_dubble_jump)
	#$buttons/Label.text = "state : "+player.sprite_state_machine.get_current_node()
	pass

func restart():
	get_tree().reload_current_scene()
	pass

func go_to_main_screen():
	get_tree().change_scene("res://scene/main_screen.tscn")
	pass

func hit_pause(time):
	get_tree().paused = true
	$hit_pause_timer.wait_time = time
	$hit_pause_timer.start()
	hit_pause = true
	#print("start")

func hit_pause_timer_timeout():
	get_tree().paused = false
	$hit_pause_timer.stop()
	hit_pause = false
	#ball.get_node("sprite").texture = load("res://sprite/ball.png")
	ball.get_node("effect2").hide()
	#print("finish")
	pass # Replace with function body.
