extends RigidBody2D

var ghost_effect_position = [global_position,global_position,global_position,global_position,global_position]
var g_color = "blue"
var state = "idle"
onready var manager = get_node("../..")
onready var player = get_node("../../player/player_body")

# Called when the node enters the scene tree for the first time.
func _ready():
	#apply_impulse(Vector2(0, 0), Vector2(0, -1000))#8
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vel = get_linear_velocity()
	vel.x = floor(vel.x)
	vel.y = floor(vel.y)
	get_node("../Label").text = "선형가속도 : "+str(vel)#("linear_velocity : "+str(get_linear_velocity ()))
	ghost_effects()
	#print(str(rotation_degrees))
	pass

func hitted(a, b):
	
	print("a is : "+str(a))
	var power = Vector2(0, -((a*100)+1100))
	print("power is : "+str(power))
	
	set_linear_velocity(Vector2(0, 0))
	
	if get_node("../../enemys").get_child_count() > 0:
		var angle = global_position.angle_to_point(player.target.global_position) # 목표와의 각도 구하기
		angle -= deg2rad(90)
	# 이유는 모르겠으나 0도일때 바라보는 방향과 힘이 작용하는 방향이 다름 오른쪽을 볼때 위로 힘이 작용함
	#즉 바라보는 방향으로 힘이 작용하길 바란다면 현재 바라보는 각도 - 90 (보는 방향과 작용한느 방향의 각도 차)를 해야함
		
		apply_impulse(Vector2(0, 0), power.rotated(angle))
	
	else:
		#b는 x의 가속도 - 값이면 왼쪽 + 값이면 오른쪽
		randomize()
		var angle = deg2rad(rand_range(0, 60))
		if b < 0:
			angle *= -1
		apply_impulse(Vector2(0, 0), power.rotated(angle))
	
	$sprite.texture = load("res://sprite/ball_punch.png")
	look_at(player.global_position)
	
	$effect2.position = (player.global_position-global_position)/2
	$effect2.look_at(player.global_position)
	$effect2.show()
	
	var effect_scene = load("res://scene/attack_effect.tscn")
	var effect = effect_scene.instance()
	effect.global_position = global_position
	effect.look_at(player.global_position)
	get_node("../..").add_child(effect)
	
	state = "hit"
	
	#$sprite/timer.wait_time = 2 * Engine.get_time_scale()
	#$sprite/timer.start()
	
	#print("power is : "+str(power))

func receive(): # 리시브 시작, 선형가속도 tween해서 0으로 자연스럽게, 시간은 player 애니메이션 끝나는 정도 쯤
	$receive_tween.interpolate_property(self, "linear_velocity", get_linear_velocity(), Vector2(0, 0), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$receive_tween.start()
	state = "receive"
	pass

func _on_receive_tween_tween_completed(object, key): # 리시브 tween 후 자연스럽게 impulse로 위로 띄우기
	apply_impulse(Vector2(0, 0), Vector2(0, -700))
	pass # Replace with function body.

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

func attack_pause_timer():
	$sprite/timer.stop()
	$sprite.texture = load("res://sprite/ball.png")
	pass # Replace with function body.


func _on_ball_body_body_entered(body):
	if body.name == "floor":
		manager.combo = 0
		state = "idle"
	pass # Replace with function body.
