extends Camera2D



# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = Vector2(360, 640)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func camera_shake(t,p):
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
	print("camera shake end")