extends KinematicBody2D

var velocity = Vector2()
export var speed = 0

enum m_way {left, right, up, down} # 진행방향이자 체크할 방향 즉 그냥 벽이 있는지를 체크하기때문에 일반벽과 같은 순서로
export(m_way) var way

onready var manager = get_node("../..")
onready var player = get_node("../../player/player_body")


# Called when the node enters the scene tree for the first time.
func _ready(): # 속력변수를 속력에 대입
	velocity.x = speed
	match way:
		m_way.right:
			velocity = velocity.rotated(deg2rad(0))
		m_way.down:
			velocity = velocity.rotated(deg2rad(90))
		m_way.left:
			velocity = velocity.rotated(deg2rad(180))
		m_way.up:
			velocity = velocity.rotated(deg2rad(270))
		
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	move_and_slide(Vector2(0,0))
	global_position += velocity*delta
	
	if get_slide_count() != 0 :
		var collision = get_slide_collision(0)
		var obj = collision.collider
		if obj.name == "player_body":
			obj.hp_minus(1)
			pass

	#if collision != null and is_instance_valid(player): # 충돌체가 null 이 아닌경우
	#	var collider = collision.collider
		#if collider.name == "player_body": # 충돌체가 player라면
			#player.velocity += velocity
	pass
