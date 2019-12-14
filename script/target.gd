extends Area2D

onready var camera = get_node("/root/ingame/camera")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# 필요한것
# 카메라 흔들기
# 공 리바운드
# 피격모션

func _on_target_body_entered(body):
	if body.name == "ball_body":
		print("hit target")
		#camera.camera_shake(.3 ,5)
		self_shake(.3, 9)
	pass # Replace with function body.

func self_shake(t,p):
	print("self shake start")
	var s = $sprite
	var initial_offset = s.position
	
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
		s.position = offset
		
		yield(get_tree(), "idle_frame")
	
	s.position = initial_offset
	print("camera shake end")