extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func attacked(direction):
	set_linear_velocity(Vector2(0, 0))
	apply_impulse(Vector2(0, 0), direction*1000)
	pass
