extends KinematicBody2D

var velocity = Vector2()
var speed = 350
var gravity = 5000
var jump = -700
var d_jump = -550
var double_jump = true
var move_button_first = Vector2()
var move_button_press = false
var state = "idle"
var first = Vector2()
var last = Vector2()
var in_area = []
var in_area_actioned = []
var power = 0
onready var dir_sp = $sprite/jump_direction

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("../Label").text = state
	
	if !is_on_floor():
		if velocity.y < gravity:
			velocity.y += gravity * delta
		if velocity.x != 0:
			velocity.x = lerp(velocity.x, 0, .1)
		if state != "jump":
			state = "jump"
	else:
		if double_jump == false:
			double_jump = true
		if state == "jump":
			velocity.x = 0
			velocity.y = 0
			power = 0
			state = "idle"
	
	if is_on_wall():
		pass
	
	move_and_slide(velocity, Vector2(0, -1))
	
	if state == "ready":
		last = get_global_mouse_position()
		var a = clamp((last.x - first.x)/2, -70, 70)
		dir_sp.rotation_degrees = a
		if power < 9:
			power += .4
			$power_gauge.value = (power * 100) + 700
		pass
	
	pass

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			if state == "idle":
				first = event.position
				#print("first is : "+str(first))
				#print("global mouse is : "+str(get_global_mouse_position()))
				$power_gauge.show()
				dir_sp.show()
				state = "ready"
		else:
			if state == "ready":
				velocity = Vector2(0,-((power * 100) + 700))
				velocity = velocity.rotated(deg2rad(dir_sp.rotation_degrees))
				velocity.x += (velocity.x * 25)/100 # x값 속력은 부족한것 같아서 추가 보정
				
				if abs(dir_sp.rotation_degrees) <= 15:
					print("위쪽")
				elif abs(dir_sp.rotation_degrees) <= 55:
					print("대각선")
				elif abs(dir_sp.rotation_degrees) <= 70:
					print("옆쪽")
				
				first = Vector2()
				last = Vector2()
				$power_gauge.hide()
				dir_sp.hide()
				dir_sp.rotation_degrees = 0
	pass

func attack_in(body):
	if body.name == "ball_body":
		if state == "jump":
			body.hitted(power)
		elif state == "idle":
			body.receive()
	pass # Replace with function body.
