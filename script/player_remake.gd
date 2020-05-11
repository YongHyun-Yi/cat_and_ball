extends KinematicBody2D

onready var ball = get_node("/root/ingame/ball/ball_body")

var velocity = Vector2()
var gravity = 2000
var jump = -900
var speed = 400


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if get_slide_count():
	#	for i in get_slide_count():
	#		var collision = get_slide_collision(i)
	#		print("Collided with: ", collision.collider.name)
	arrowkey_move_input()
	jump_and_gravity(delta)
	move_and_slide(velocity, Vector2(0, -1))
	pass

func arrowkey_move_input():
	if Input.is_action_pressed("ui_left"):
		
		velocity.x = -speed
		
	elif Input.is_action_pressed("ui_right"):
		
		velocity.x = speed
		
	else:
		velocity.x = 0

func jump_and_gravity(delta):
	if is_on_floor():
		if velocity.y > 0:
			velocity.y = 0
			$sprite.animation = "idle"
		
		if Input.is_action_pressed("ui_up"):
			velocity.y += jump
			$sprite.animation = "jump"
	else:
		if velocity.y < gravity:
			velocity.y += gravity * delta
	pass

func _unhandled_key_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		var b = $attack.get_overlapping_bodies()
		#print(str(b))
		if b.size() > 0:
			for i in b:
				
				var bs = (i.global_position - $attack/CollisionShape2D.global_position).normalized()
				bs.x = stepify(bs.x, 0.1)
				bs.y = stepify(bs.y, 0.1)
				#print(str(bs))
				
				#bs = $attack/CollisionShape2D.global_position.angle_to_point(i.global_position)
				#bs = Vector2.RIGHT.rotated(bs)
				bs = $attack/Position2D.global_position.direction_to(i.global_position)
				bs.x = stepify(bs.x, 0.1)
				bs.y = stepify(bs.y, 0.1)
				#print(str(bs))
				
				i.attacked(bs)
