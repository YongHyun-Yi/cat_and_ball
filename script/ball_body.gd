extends RigidBody2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	"""if global_position.x > get_viewport().size.x or global_position.x < 0:
		speed.x *= -1
	if global_position.y > get_viewport().size.y or global_position.y < 0:
		speed.y *= -1
	global_position += speed"""
	
	pass


func _on_ball_body_body_entered(body):
	if body.name == "player_body":
		var cha = get_node("../../player/player_body")
		apply_impulse(Vector2(0, 0), Vector2(0, -500))#(global_position-cha.global_position)*800)
		print("ball touch")
	pass # Replace with function body.
