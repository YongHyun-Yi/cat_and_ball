extends RigidBody2D

onready var manager = get_node("/root/ingame")
onready var camera = get_node("/root/ingame/camera")

var move_direction = Vector2()
var power = 2000

var attackable = false

signal hit_pause


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("hit_pause", manager,"hit_pause")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_dir_update()
	attackable_check()
	pass

func _integrate_forces(state):
	rotation_degrees = 0

func attackable_check():
	#print(str(rotation_degrees))
	set_angular_velocity(0)
	if abs(linear_velocity.x)/1000 > 1 or abs(linear_velocity.y)/1000 > 1:
		if attackable != true:
			attackable = true
			print("attackable")
			$sprite.self_modulate = "ffffff"
	else:
		if attackable != false:
			attackable = false
			print("dis attackable")
			$sprite.self_modulate = "ff0000"

func move_dir_arrow_toggle(a):
	if a == "show":
		$Line2D.show()
	else:
		$Line2D.hide()

func move_dir_update():
	move_direction = global_position.direction_to(get_global_mouse_position())
	move_direction.x = stepify(move_direction.x, 0.1)
	move_direction.y = stepify(move_direction.y, 0.1)
	$Line2D.points[1] =  move_direction * 100

func ball_attacked(kick_power):
	print(str(linear_velocity))
	attackable = true
	print("attackable")
	$sprite.self_modulate = "ffffff"
	set_linear_velocity(Vector2(0, 0))
	apply_impulse(Vector2(0, 0), move_direction * kick_power)
	pass

func hit_zone_area_entered(area):
	var a = area.get_parent()
	
	if attackable == true:
		if a.has_method("ball_hit"): # 적에게 맞을경우
			emit_signal("hit_pause")
			$effect2.show()
			$effect2.rotation_degrees = rad2deg(global_position.angle_to_point(area.get_parent().global_position)-180) # 스프라이트 방향이 반대라서 -180도 해줬음
			#$hit_zone/CollisionShape2D2.set_deferred("disabled", true) # 버그인가? disabled를 해도 계속 시그널이 방출되서 사용
			linear_velocity.x *= -1
			area.get_parent().ball_hit()
			camera.camera_shake(.2, 20)
	pass # Replace with function body.


func hit_zone_body_entered(body):
	linear_velocity *= -1
	body.get_parent().damaged()
	pass # Replace with function body.
