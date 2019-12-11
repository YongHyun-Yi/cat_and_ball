extends RigidBody2D

var ghost_effect_position = [global_position,global_position,global_position,global_position,global_position]
var g_color = "blue"

# Called when the node enters the scene tree for the first time.
func _ready():
	#apply_impulse(Vector2(0, 0), Vector2(0, -1000))#8
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	"""if global_position.x > get_viewport().size.x or global_position.x < 0:
		speed.x *= -1
	if global_position.y > get_viewport().size.y or global_position.y < 0:
		speed.y *= -1
	global_position += speed"""
	get_node("../Label").text = str(rad2deg(global_position.angle_to_point(get_node("../../enemys/target").global_position)))#("linear_velocity : "+str(get_linear_velocity ()))
	ghost_effects()
	#print(str(rotation_degrees))
	pass


func _on_ball_body_body_entered(body):
	if body.get_parent().name == "player":
		#var cha = get_node("../../player/player_body")
		set_linear_velocity(Vector2(linear_velocity.x/2, 0))
		apply_impulse(Vector2(0, 0), Vector2(0, -800))#(global_position-cha.global_position)*800)
		if g_color != "blue":
			ghost_blue()
			g_color = "blue"
		#print("player")
		var a = get_linear_velocity()
		#if a.y > 300:
		#	set_axis_velocity ( Vector2(0, -300) )"""
	pass # Replace with function body.

func hitted():
	print("ball")
	#print("attack point : "+str(a))
	#set_linear_velocity(a)
	
	var power = Vector2(0, -2000)
	
	#rotation_degrees = 0
	#var aa = rad2deg(global_position.angle_to(get_node("../../enemys/target").global_position))#-90
	
	var angle = global_position.angle_to_point(get_node("../../enemys/target").global_position) # 목표와의 각도 구하기
	angle -= deg2rad(90) 
	# 이유는 모르겠으나 0도일때 바라보는 방향과 힘이 작용하는 방향이 다름 오른쪽을 볼때 위로 힘이 작용함
	#즉 바라보는 방향으로 힘이 작용하길 바란다면 현재 바라보는 각도 - 90 (보는 방향과 작용한느 방향의 각도 차)를 해야함
	
	#var angle = rad2deg((get_node("../../enemys/target").global_position).angle_to_point(global_position))
	#look_at(get_node("../../enemys/target").global_position)
	#print(str(get_node("../../enemys/target").global_position))
	#print(str(global_position))
	#rotation_degrees = angle
	#rotation_degrees = 0.0
	#set_linear_velocity(Vector2(0, 0))
	#look_at(get_node("../../enemys/target").global_position)
	#print("angle is : "+str(angle))
	#apply_impulse(Vector2(0, 0), power.rotated(rotation_degrees-90))
	
	set_linear_velocity(Vector2(0, 0))
	apply_impulse(Vector2(0, 0), power.rotated(angle))
	
	#print("power is : "+str(power))

func ghost_effects():
	var a = 4
	for i in range(4):
		ghost_effect_position[a] = ghost_effect_position[a-1]
		a -= 1
	ghost_effect_position[0] = global_position
	for i in range(1,6):
		var ghost = "../../ball_ghost/ghost"
		get_node(ghost+str(i)).global_position = ghost_effect_position[i-1]

func ghost_blue():
	get_node("../../ball_ghost/ghost"+"1").self_modulate = "00dbff"
	get_node("../../ball_ghost/ghost"+"2").self_modulate = "00bdff"
	get_node("../../ball_ghost/ghost"+"3").self_modulate = "0093ff"
	get_node("../../ball_ghost/ghost"+"4").self_modulate = "006aff"
	get_node("../../ball_ghost/ghost"+"5").self_modulate = "003aff"

func ghost_red():
	get_node("../../ball_ghost/ghost"+"1").self_modulate = "ff9b00"
	get_node("../../ball_ghost/ghost"+"2").self_modulate = "ff6c00"
	get_node("../../ball_ghost/ghost"+"3").self_modulate = "ff4e00"
	get_node("../../ball_ghost/ghost"+"4").self_modulate = "ff3000"
	get_node("../../ball_ghost/ghost"+"5").self_modulate = "ff0000"