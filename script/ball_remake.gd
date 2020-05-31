extends RigidBody2D

onready var manager = get_node("/root/ingame")
onready var camera = get_node("/root/ingame/camera")
var ball_spawner = null

var move_direction = Vector2()
var power = 2000

var attackable = false
var dead = false

signal hit_pause

export (String, "idle", "slide", "scroll") var movement_state = "idle"

var slide_acl = 20
var slide_max = 700

var scroll_acl = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("hit_pause", manager,"hit_pause")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_dir_update()
	attackable_check()
	floor_check()
	pass

func floor_check():
	"""
	var a = Physics2DTestMotionResult.new()
	var b = test_motion(Vector2.ZERO, true, 0.08, a) # 여기에 주어진 벡터는 해당값으로 이동시키기만 하는것
	if b:
		var collision_pos : Vector2 = (a.collision_point - global_position).normalized() # 충돌지점은 위치좌표로 뜸
		#print(str(ceil(collision_pos.y))) # 정상화해줘도 불분명해서 반올림
		
		if a.collision_point.y >= global_position.y :
			if movement_state != a.collider.get_parent().state:
				a.collider.get_parent().ball_state_update(self)
				#print("update")
	"""
	if $floor_ray.is_colliding(): # 위 코드를 레이캐스트로 대체 / 마찰계수는 안건드는게 더 자연스럽게 나옴
		var a = $floor_ray.get_collider()
		if movement_state != a.get_parent().state:
			a.get_parent().ball_state_update(self)
	else:
		if movement_state != "on_air":
			if movement_state == "scroll":
				applied_force.x = 0
				#friction = 1
			movement_state = "on_air"

func _integrate_forces(state):
	rotation_degrees = 0
	#if dead == true:
	#	set_linear_velocity(Vector2(0, 0))
	#set_angular_velocity(0)

func attackable_check():
	#print(str(rotation_degrees))
	#set_angular_velocity(0)
	if abs(linear_velocity.x)/1000 > 1 or abs(linear_velocity.y)/1000 > 1:
		if attackable != true:
			attackable = true
			$sprite.self_modulate = "ffffff"
	else:
		if attackable != false:
			attackable = false
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
	
	attackable = true
	$sprite.self_modulate = "ffffff"
	set_linear_velocity(Vector2(0, 0))
	apply_impulse(Vector2(0, 0), move_direction * kick_power)
	
	if friction != 1:
		friction = 1
	if applied_force.x != 0:
		applied_force.x = 0
	pass

func hit_zone_in(a):
	a = a.get_parent()
	
	if attackable == true:
		if a.has_method("ball_hit"): # 적에게 맞을경우
			emit_signal("hit_pause")
			$effect2.show()
			$effect2.rotation_degrees = rad2deg(global_position.angle_to_point(a.global_position)-180) # 스프라이트 방향이 반대라서 -180도 해줬음
			#$hit_zone/CollisionShape2D2.set_deferred("disabled", true) # 버그인가? disabled를 해도 계속 시그널이 방출되서 사용
			#linear_velocity.x *= -1
			a.ball_hit()
			camera.camera_shake(.2, 20)
	pass # Replace with function body.


func hit_zone_body_entered(body):
	linear_velocity *= -1
	body.get_parent().damaged()
	pass # Replace with function body.

func ball_dead():
	dead = true
	$dead_timer.start()
	$CollisionShape2D.disabled = true
	$hit_zone/CollisionShape2D2.disabled = true
	set_linear_velocity(Vector2(0, 0))
	mode = 3
	hide()
	pass

func dead_timer_timeout():
	print("timeout")
	$dead_timer.stop()
	ball_spawner.ball_spawn()
	pass # Replace with function body.

func interact_spike():
	if dead == false:
		dead = true
		ball_dead()
