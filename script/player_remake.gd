extends KinematicBody2D

onready var ball = get_node("/root/ingame/ball/ball_body")

var velocity = Vector2()
var gravity = 2000
var jump = -900
var dubble_jump = -800
var can_dubble_jump = true
var speed = 400

var flipped = false

var attack_angle = Vector2()


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
	
	$attack.look_at(get_global_mouse_position())
	
	pass

func arrowkey_move_input():
	if Input.is_action_pressed("move_left"):
		
		velocity.x = -speed
		if flipped == false:
			flipped = true
			scale.x *= -1
		
	elif Input.is_action_pressed("move_right"):
		
		velocity.x = speed
		if flipped == true:
			flipped = false
			scale.x *= -1
		
	else:
		velocity.x = 0

func jump_and_gravity(delta):
	
	if is_on_floor():
		if velocity.y > 0:
			velocity.y = 0
			$sprite.animation = "idle"
			can_dubble_jump = true
		
		if Input.is_action_just_pressed("move_jump"):
			velocity.y += jump
			$sprite.animation = "jump"
			print(str(can_dubble_jump))
	else:
		if Input.is_action_just_pressed("move_jump") and can_dubble_jump == true:
			can_dubble_jump = false
			velocity.y = 0
			velocity.y += dubble_jump
			$sprite.animation = "jump"
			print(str(can_dubble_jump))
		
		if velocity.y < gravity:
			velocity.y += gravity * delta
	
	pass

func _input(event):
	if Input.is_action_just_pressed("move_attack"):
		
		var b = $attack.get_overlapping_bodies() # 공 공격
		#print(str(b))
		if b.size() > 0:
			for i in b:
				
				#var bs = (i.global_position - $attack/CollisionShape2D.global_position).normalized()
				#bs.x = stepify(bs.x, 0.1)
				#bs.y = stepify(bs.y, 0.1)
				#print(str(bs))
				
				#bs = $attack/CollisionShape2D.global_position.angle_to_point(i.global_position)
				#bs = Vector2.RIGHT.rotated(bs)
				var bs = $attack.global_position.direction_to(get_global_mouse_position())
				bs.x = stepify(bs.x, 0.1)
				bs.y = stepify(bs.y, 0.1)
				print(str(bs))
				
				i.attacked(bs)
		
		b = $attack.get_overlapping_areas() # 적 공격
		if b.size() > 0:
			for i in b:
				
				var bs = $attack.global_position.direction_to(get_global_mouse_position())
				bs.x = stepify(bs.x, 0.1)
				bs.y = stepify(bs.y, 0.1)
				print(str(bs))
				
				i.get_parent().attacked(bs)
