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
		camera.camera_shake(.3 ,5)
	pass # Replace with function body.
