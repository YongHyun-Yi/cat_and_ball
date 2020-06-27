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
	#$background/combo.text = "COMBO\n"+str(combo)
	#$uis/Label.text = "state : "+ball.movement_state+"\n applied force.x : "+str(ball.applied_force.x)
	#$uis/Label.text = "velocity : "+str(ball.get_linear_velocity())
	#$uis/Label.text = "state : "+str(player.can_dubble_jump)
	#$uis/Label.text = "state : "+player.movement_state
	$uis/Label.text = "vector2 : "+str(player.velocity)
	pass

func _unhandled_key_input(event):
	if Input.is_action_just_pressed("ui_menu"):
		if $uis/ingame_menus.visible == false:
			open_menu()
		else:
			close_menu()

func open_menu():
	get_tree().paused = true
	$uis/ingame_menus.show()

func close_menu():
	$uis/ingame_menus.hide()
	get_tree().paused = false

func button_event(b_name):
	var button = get_node("uis/ingame_menus/hbox/"+b_name)
	
	if Rect2(Vector2.ZERO, button.rect_size).has_point(button.get_local_mouse_position()):
		print("in there")
		if b_name == "restart":
			get_tree().reload_current_scene()
			get_tree().paused = false
		elif b_name == "go_to_main":
			get_tree().change_scene("res://scene/main_screen.tscn")
			get_tree().paused = false
		elif b_name == "close":
			close_menu()

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
