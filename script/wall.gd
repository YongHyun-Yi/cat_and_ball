extends ColorRect


export var state = "idle"
export var one_way = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var shape = RectangleShape2D.new()
	shape.set_extents(rect_size/2)
	#shape.position = shape.get_extents()
	$Staticbody2D/CollisionShape2D.set_shape(shape)
	#$Staticbody2D/CollisionShape2D.shape.set_extents(rect_size/2)
	$Staticbody2D/CollisionShape2D.position = $Staticbody2D/CollisionShape2D.shape.get_extents()
	if one_way == true:
		$Staticbody2D/CollisionShape2D.one_way_collision = true
	#$Staticbody2D/CollisionShape2D.set_deferred("one_way_collision", true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func state_update(a):
	a.movement_state = state
