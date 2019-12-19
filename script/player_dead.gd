extends KinematicBody2D

var velocity = Vector2()
var gravity = 5000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_on_floor():
		if velocity.y < gravity:
			velocity.y += gravity * delta
		if velocity.x != 0:
			velocity.x = lerp(velocity.x, 0, Engine.get_time_scale()/10)
	else:
		velocity = Vector2(0, 0)
	
	move_and_slide(velocity, Vector2(0, -1))
	pass
