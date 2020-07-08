extends Node2D

var combo = 0
var targets = []
var hit_pause = false

onready var player = get_node("player/player_body")
onready var ball = null
onready var camera = get_node("camera")
onready var enemy = get_node("enemys/enemy_body")

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
	#$uis/Label.text = "vector2 : "+str(player.velocity)
	$uis/Label.text = "vector2 : "+str(enemy.velocity)
	pass

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_menu"):
		if $uis/ingame_menus.visible == false:
			open_menu()
		else:
			close_menu()

func open_menu():
	get_tree().paused = true
	$uis/ingame_menus.show()
	$uis/ingame_menus/Tween.interpolate_property($uis/ingame_menus/hbox, "rect_position:y", 230, 190, 0.4, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$uis/ingame_menus/Tween.start()

func close_menu():
	$uis/ingame_menus.hide()
	get_tree().paused = false


func button_event(button_object, keyboard_input):
	if Rect2(Vector2.ZERO, button_object.rect_size).has_point(button_object.get_local_mouse_position()) or keyboard_input == true:
		
		match button_object.name:
			"restart":
				get_tree().reload_current_scene()
				get_tree().paused = false
			"option":
				var a = load("res://scene/main_option.tscn")
				a = a.instance()
				get_node("uis").add_child(a)
				$uis/ingame_menus.hide()
			"go_to_main":
				get_tree().change_scene("res://scene/main_screen.tscn")
				get_tree().paused = false
			"close":
				close_menu()

func hit_pause(time):
	get_tree().paused = true
	$hit_pause_timer.wait_time = time
	$hit_pause_timer.start()
	#hit_pause = true
	print("start")

func hit_pause_timer_timeout():
	get_tree().paused = false
	$hit_pause_timer.stop()
	#hit_pause = false
	#ball.get_node("sprite").texture = load("res://sprite/ball.png")
	#ball.get_node("effect2").hide()
	print("finish")
	pass # Replace with function body.
