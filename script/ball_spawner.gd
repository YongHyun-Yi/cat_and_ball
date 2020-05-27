extends Node2D


onready var ball = get_node("/root/ingame/ball/ball_body")


# Called when the node enters the scene tree for the first time.

func _ready():
	ball.ball_spawner = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func ball_spawn():
	print("ball spawn!")
	ball.get_node("CollisionShape2D").disabled = false
	ball.get_node("hit_zone/CollisionShape2D2").disabled = false
	ball.mode = 0
	ball.global_position = $spawn_point.global_position
	ball.dead = false
	ball.show()
	pass
