extends RigidBody2D

var ghost_effect_position = [global_position,global_position,global_position,global_position,global_position]
var g_color = "blue"

# Called when the node enters the scene tree for the first time.
func _ready():
	#apply_impulse(Vector2(0, 0), Vector2(0, -1000))#8
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("../Label").text = str(rad2deg(global_position.angle_to_point(get_node("../../enemys/target").global_position)))#("linear_velocity : "+str(get_linear_velocity ()))
	ghost_effects()
	#print(str(rotation_degrees))
	pass

func hitted(a):
	
	print("a is : "+str(a))
	var power = Vector2(0, -((a*100)+1100))
	print("power is : "+str(power))
	
	var angle = global_position.angle_to_point(get_node("../../enemys/target").global_position) # 목표와의 각도 구하기
	angle -= deg2rad(90) 
	# 이유는 모르겠으나 0도일때 바라보는 방향과 힘이 작용하는 방향이 다름 오른쪽을 볼때 위로 힘이 작용함
	#즉 바라보는 방향으로 힘이 작용하길 바란다면 현재 바라보는 각도 - 90 (보는 방향과 작용한느 방향의 각도 차)를 해야함
	
	set_linear_velocity(Vector2(0, 0))
	apply_impulse(Vector2(0, 0), power.rotated(angle))
	
	#print("power is : "+str(power))

func receive():
	set_linear_velocity(Vector2(0, 0))
	apply_impulse(Vector2(0, 0), Vector2(0, -700))
	pass

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