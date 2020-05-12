extends RigidBody2D

onready var manager = get_node("/root/ingame")
signal hit_pause


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("hit_pause", manager,"hit_pause")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$hit_zone.position = Vector2(0, 0)
	pass

func attacked(direction):
	set_linear_velocity(Vector2(0, 0))
	apply_impulse(Vector2(0, 0), direction*1000)
	$hit_zone/CollisionShape2D2.disabled = false
	pass

func _unhandled_key_input(event):
	#if Input.is_action_just_pressed("ui_select"):
	#	print(str(get_linear_velocity()))
	if Input.is_action_just_pressed("ui_cancel"):
		#$hit_zone/CollisionShape2D2.call_deferred("set_disabled", true)
		#$hit_zone/CollisionShape2D2.set_deferred("disabled", true)
		pass

func hit_zone_area_entered(area):
	#area.get_parent().damaged()
	print(str($hit_zone/CollisionShape2D2.disabled))
	emit_signal("hit_pause")
	$effect2.show()
	$effect2.rotation_degrees = rad2deg(global_position.angle_to_point(area.get_parent().global_position)-180) # 스프라이트 방향이 반대라서 -180도 해줬음
	#$hit_zone/CollisionShape2D2.disabled = true
	$hit_zone/CollisionShape2D2.set_deferred("disabled", true) # 버그인가? disabled를 해도 계속 시그널이 방출되서 사용
	linear_velocity *= -1
	area.get_parent().damaged()
	pass # Replace with function body.


func hit_zone_body_entered(body):
	#$CollisionShape2D.disabled = true
	linear_velocity *= -1
	body.get_parent().damaged()
	pass # Replace with function body.
