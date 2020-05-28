extends "res://script/wall.gd"


export var blink_time = 0.0
export var blink = true


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = blink_time
	$Timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func blink_toggle():
	if blink == true:
		blink = false
		$Staticbody2D/CollisionShape2D.disabled = true
		self_modulate.a = .5
		#print("blink false")
	
	elif blink == false:
		blink = true
		$Staticbody2D/CollisionShape2D.disabled = false
		self_modulate.a = 1
		#print("blink true")
	
	pass
