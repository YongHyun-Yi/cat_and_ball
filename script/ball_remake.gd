extends RigidBody2D

onready var manager = get_node("/root/ingame")
#onready var camera = get_node("/root/ingame/camera")
#onready var player = get_node("/root/ingame/player/player_body")
var ball_spawner = null

export var ball_spawn_complete = false

var move_direction = Vector2()
var power = 2000

var attackable = false
var transformed = false
var t_length = 10
var save_speed : Vector2
var dead = false

signal hit_pause

export (String, "idle", "slide", "scroll") var movement_state = "idle"

var slide_acl = 20
var slide_max = 700

var scroll_acl = 0

var grabed = false
var pulled = false
var pulled_speed = Vector2()

var out_of_caemra = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$anim.play("spawn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	indicator_range_check()
	move_dir_update()
	attackable_check()
	floor_check()
	
	
	
	applied_force = Vector2((pulled_speed.x + scroll_acl), pulled_speed.y)
	
	if out_of_caemra == true:
		screen_indicator_check()
	
	if grabed == true:
		global_position = manager.player.get_node("grabed_ball_point").global_position
		linear_velocity = Vector2.ZERO
	
	if transformed == true:
		linear_velocity = Vector2.ZERO
	
	if attackable == true:
		
		$trail.global_position = Vector2.ZERO
		$trail.rotation_degrees = 0
		var point = global_position
		$trail.add_point(point)
		if $trail.get_point_count() > t_length:
			$trail.remove_point(0)
		
		var a = linear_velocity.normalized()
		if a.x < 0:
			$sprite.scale.x = -1
		else:
			$sprite.scale.x = 1
		
		$sprite.look_at(global_position + a)
	
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
				scroll_acl = 0
				friction = 1
			movement_state = "on_air"

func _integrate_forces(state):
	rotation_degrees = 0
	
	#if grabed == true:
	#	global_position = manager.player.get_node("grabed_ball_point").global_position
	#	linear_velocity = Vector2.ZERO
	
	if pulled == true:
		pulled_speed = Vector2(2000, 0).rotated(manager.player.global_position.angle_to_point(global_position))
	
	#if dead == true:
	#	set_linear_velocity(Vector2(0, 0))
	#set_angular_velocity(0)

func attackable_check():
	#print(str(rotation_degrees))
	#set_angular_velocity(0)

	if abs(linear_velocity.x)/1000 > 1 or abs(linear_velocity.y)/1000 > 1:
		if attackable != true:
			attackable = true
			$sprite.animation = "speed1"
			#if abs(linear_velocity.x) > abs(linear_velocity.y):
			#	$sprite.animation = "speed1"
			#elif abs(linear_velocity.x) < abs(linear_velocity.y):
			#	$sprite.animation = "speed2"
			
			set_collision_mask_bit(5, true)
			#$sprite.self_modulate = "ffffff"

	else:
		if attackable != false:
			attackable = false
			#$sprite.self_modulate = "ff0000"
			set_collision_mask_bit(5, false)
			$sprite.animation = "idle"
			$sprite.rotation_degrees = 0
			$trail.clear_points()

func move_dir_arrow_toggle(a):
	if a == "show":
		$Line2D.show()
	else:
		$Line2D.hide()

func indicator_range_check():
	var a = Vector2(100, 0).rotated(manager.player.global_position.angle_to_point(global_position))
	$indicator_range.cast_to = a
	if $indicator_range.collide_with_bodies:
		if $indicator_range.get_collider() == manager.player:
			if $Line2D.visible == false:
				$Line2D.visible = true
		else:
			if $Line2D.visible == true:
				$Line2D.visible = false

func screen_indicator_check():
	var border_size = Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height"))
	var indicator_size = 40
	
	$screen_indicator.global_position.x = manager.camera.global_position.x + clamp((global_position.x - manager.camera.global_position.x) , -border_size.x/2 + indicator_size, border_size.x/2 - indicator_size)
	$screen_indicator.global_position.y = manager.camera.global_position.y + clamp((global_position.y - manager.camera.global_position.y) , -border_size.y/2 + indicator_size, border_size.y/2 - indicator_size)
	pass

func move_dir_update():
	move_direction = global_position.direction_to(get_global_mouse_position())
	move_direction.x = stepify(move_direction.x, 0.1)
	move_direction.y = stepify(move_direction.y, 0.1)
	$Line2D.points[1] =  move_direction * 100

func ball_attacked(kick_power):
	
	#attackable = true
	#$sprite.self_modulate = "ffffff"
	
	set_linear_velocity(Vector2(0, 0))
	print(str(get_linear_velocity()))
	apply_impulse(Vector2(0, 0), move_direction * kick_power)
	print(str(get_linear_velocity()))
	
	if friction != 1:
		friction = 1
	if applied_force.x != 0:
		applied_force.x = 0
	pass

func ball_pulled_event():
	if ball_spawn_complete == true:
		pulled = true
		linear_velocity = Vector2.ZERO
		gravity_scale = 1

func ball_pulled_finish():
	if ball_spawn_complete == true:
		pulled = false
		pulled_speed = Vector2.ZERO
		gravity_scale = 8

func ball_grabed():
	if ball_spawn_complete == true:
		manager.player.ball_grab = true
		manager.player.ball_pull = false
		grabed = true
		
		$CollisionShape2D.disabled = true
		$hit_zone/CollisionShape2D2.disabled = true
		$hurt_zone/CollisionShape2D2.disabled = true
		
		mode = RigidBody2D.MODE_CHARACTER
		
		ball_pulled_finish()

func ball_throw():
	manager.player.ball_grab = false
	grabed = false
	
	$CollisionShape2D.disabled = false
	$hit_zone/CollisionShape2D2.disabled = false
	$hurt_zone/CollisionShape2D2.disabled = false
	
	mode = RigidBody2D.MODE_RIGID
	
	#global_position = manager.player.global_position
	#print(str(manager.player.global_position))
	#print(str(global_position))
	
	set_linear_velocity(Vector2(0, 0))
	apply_impulse(Vector2(0, 0), move_direction * 3000) # 임시로 move_direction 삽임
	pass

func hit_zone_in(area):
	var a = area.get_parent()
	print(a.name)
	
	if attackable == true:
		"""
		if a.has_method("ball_hit"): # 적에게 맞을경우
			$effect2.show()
			$effect2.rotation_degrees = rad2deg(global_position.angle_to_point(a.global_position)-180) # 스프라이트 방향이 반대라서 -180도 해줬음
			#$hit_zone/CollisionShape2D2.set_deferred("disabled", true) # 버그인가? disabled를 해도 계속 시그널이 방출되서 사용
			#linear_velocity.x *= -1
			a.ball_hit()
			camera.camera_shake(.2, 20, .2)
		"""
		#$effect2.show()
		$effect2.rotation_degrees = rad2deg(global_position.angle_to_point(a.global_position)-180) # 스프라이트 방향이 반대라서 -180도 해줬음
		a.hurt_check(1, self)
	pass # Replace with function body.

func hit_valid():
	print("ball hit valid")
	manager.camera.camera_shake(0.2, 20, 0.2)
	#manager.hit_pause(0.2)
	#$effect2.hide()
	pass

func hurt_check(kick_power, attacker):
	#print("ball hurt check start")
	hurt_valid(kick_power)
	pass

func hurt_valid(kick_power):
	#print("ball hurt valid")
	set_linear_velocity(Vector2(0, 0))
	apply_impulse(Vector2(0, 0), move_direction * kick_power)
	
	if friction != 1:
		friction = 1
	if applied_force.x != 0:
		applied_force.x = 0
	pass

func hit_zone_body_entered(body):
	linear_velocity *= -1
	body.get_parent().damaged()
	pass # Replace with function body.

func ball_dead():
	dead = true
	$dead_timer.start()
	$CollisionShape2D.disabled = true
	$hurt_zone/CollisionShape2D2.disabled = true
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


func screen_entered():
	if out_of_caemra == true:
		out_of_caemra = false
		$screen_indicator.hide()
	pass # Replace with function body.


func screen_exited():
	if out_of_caemra == false:
		print("out")
		out_of_caemra = true
		$screen_indicator.show()
	pass # Replace with function body.


func sprite_animation_finished():
	if $sprite.animation == "spawn":
		$sprite.animation = "idle"
		$sprite.playing = false
		$CollisionShape2D.disabled = false
		$hit_zone/CollisionShape2D2.disabled = false
		$hurt_zone/CollisionShape2D2.disabled = false
		mode = RigidBody2D.MODE_RIGID
		apply_impulse(Vector2.ZERO, Vector2.UP*100)
	pass # Replace with function body.


func body_entered(body):
	print("충돌")
	print(str((body.global_position - global_position).normalized()))
	
	if attackable == true:
		save_speed = linear_velocity
		transformed = true
		if $sprite.animation == "speed1":
			$anim.play("bounce1")
		else:
			$sprite.animation = "speed1"
	
	pass # Replace with function body.


func body_exited(body):
	pass # Replace with function body.


func sprite_anim_finished(anim_name):
	if transformed == true:
		transformed = false
		if anim_name == "bounce1":
			$sprite.animation = "speed1"
			linear_velocity = save_speed
			save_speed = Vector2()
		else:
			$sprite.animation = "speed2"
	pass # Replace with function body.
