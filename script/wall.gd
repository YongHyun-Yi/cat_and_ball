extends ColorRect


export var state = "idle"
export var one_way = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var shape = RectangleShape2D.new()
	shape.set_extents(rect_size/2)
	$Staticbody2D/CollisionShape2D.set_shape(shape)
	$Staticbody2D/CollisionShape2D.position = $Staticbody2D/CollisionShape2D.shape.get_extents()
	if one_way == true:
		$Staticbody2D/CollisionShape2D.one_way_collision = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func state_update(a):
	a.movement_state = state

func ball_state_update(a):
	a.movement_state = state
	#a.applied_force = Vector2.ZERO
	a.friction = 1
	pass
