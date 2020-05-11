extends RigidBody2D


signal attack_pause


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func attacked(direction):
	set_linear_velocity(Vector2(0, 0))
	apply_impulse(Vector2(0, 0), direction*1000)
	$hit_zone/CollisionShape2D2.disabled = false
	pass

func _unhandled_key_input(event):
	#if Input.is_action_just_pressed("ui_select"):
	#	print(str(get_linear_velocity()))
	if Input.is_action_just_pressed("ui_cancel"):
		$hit_zone/CollisionShape2D2.disabled = false

func hit_zone_area_entered(area):
	#area.get_parent().damaged()
	pass # Replace with function body.


func hit_zone_body_entered(body):
	body.get_parent().damaged()
	pass # Replace with function body.
