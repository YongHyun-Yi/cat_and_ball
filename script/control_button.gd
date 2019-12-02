extends TextureButton

var drag = false
var line_start = Vector2()
onready var player = get_node("../player/player_body")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_drag_data(position):
	line_start = position
	drag = true