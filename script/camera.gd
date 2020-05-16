extends Camera2D

onready var player = get_node("/root/ingame/player/player_body")
onready var ball = get_node("/root/ingame/ball/ball_body")

var current_shake = 0
var distance = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#global_position = Vector2(640, 360)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	distance = player.global_position.distance_to(ball.global_position) # 거리 구하기
	distance *= 0.001 # 단위 낮추기
	distance += 1 # 가장 가까이 있을때 1배수가 나오도록
	#print(str(distance))
	
	if distance < 1.6 and distance > 1.1:
		set_zoom(Vector2(1, 1) * distance) # 거리에 따른 줌 설정
	
	global_position = (player.global_position + ball.global_position) * 0.5 # 두 오브젝트 사이에 카메라 위치 설정
	pass

func camera_shake(t,p):
	if p >= current_shake:
		current_shake = p
		print("camera shake start")
		var initial_offset = get_offset()
		
		var time = 0
		var time_limit = t
		var power = p
		
		while time < time_limit:
			#print("time is : "+str(time))
			#print("time_limit is : "+str(time_limit))
			time += get_process_delta_time()
			time = min(time, time_limit)
			
			var offset = Vector2()
			offset.x = rand_range(-power, power)
			offset.y = rand_range(-power, power)
			set_offset(offset)
			
			yield(get_tree(), "idle_frame")
	
		set_offset(initial_offset)
		current_shake = 0
		print("camera shake end")
