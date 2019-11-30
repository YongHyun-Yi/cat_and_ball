extends RigidBody2D

var ghost_effect_position = [global_position,global_position,global_position,global_position,global_position]

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
	get_node("../Label").text = ("linear_velocity : "+str(get_linear_velocity ()))
	ghost_effects()
	pass


func _on_ball_body_body_entered(body):
	if body.name == "player_body":
		#var cha = get_node("../../player/player_body")
		#apply_impulse(Vector2(0, 0), Vector2(0, -500))#(global_position-cha.global_position)*800)
		var a = get_linear_velocity()
		if a.y > 300:
			set_axis_velocity ( Vector2(0, -300) )
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