extends "res://script/interact_object.gd"


export var spring_power = -1500


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func interact(body):
	print("spring_in")
	body.velocity.y = spring_power
	body.velocity = body.move_and_slide(body.velocity, Vector2.UP)
	body.get_node("sprite").animation = "jump"
	pass # Replace with function body.
