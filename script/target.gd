extends Area2D

onready var camera = get_node("/root/ingame/camera")
var hp = 5
onready var manager = get_node("../..")
onready var player = get_node("../../player/player_body")

# Called when the node enters the scene tree for the first time.
func _ready():
	$hp_bar.max_value = hp
	manager.targets.append(self)
	print(str(manager.targets))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$hp_bar.value = hp
	if hp <= 0:
		if player.target == self:
			player.target = null
			print("목록 초기화")
		var a = manager.targets.find(self)
		manager.targets.remove(a)
		print(str(manager.targets))
		queue_free()
	pass

# 필요한것
# 카메라 흔들기
# 공 리바운드
# 피격모션

func _on_target_body_entered(body):
	if body.name == "ball_body" and body.state == "hit":
		print("hit target")
		#camera.camera_shake(.3 ,5)
		self_shake(.3, 9)
		hp -= 1
		
		body.state = "hitted"
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