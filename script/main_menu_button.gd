extends Button


signal button_event
export var caption : String


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func button_up():
	emit_signal("button_event", self, false)
	pass # Replace with function body.
