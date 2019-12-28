extends KinematicBody2D

var velocity = Vector2()
export var speed_x = 0
export var speed_y = 0

onready var manager = get_node("../..")
onready var player = get_node("../../player/player_body")

# Called when the node enters the scene tree for the first time.
func _ready(): # 속력변수를 속력에 대입
	velocity.x = speed_x
	velocity.y = speed_y
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	move_and_slide(velocity)
	
	var collision = get_slide_collision(0)
	
	if collision != null and is_instance_valid(player): # 충돌체가 null 이 아닌경우
		var collider = collision.collider
		if collider.name == "player_body": # 충돌체가 player라면
			player.velocity.x = velocity.x # 같은 속도로 움직이게 하고
	pass

func _on_w_stuck_detect_body_entered(body):
	if body.name == "player_body":
		if player.w_stuck_check == false: # 벽 낑김 변수가 false라면 true로 한다
			player.w_stuck_check = true
			print("stuck on")
	pass # Replace with function body.


func _on_w_stuck_detect_body_exited(body):
	if body.name == "player_body":
		if player.w_stuck_check == true: # 벽 낑김 변수가 true라면 false로 한다
			player.w_stuck_check = false
			print("stuck off")
	pass # Replace with function body.
