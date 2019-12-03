extends TextureButton

var origin = Vector2()
var start_point = Vector2()
var move_point = Vector2()
var stick_range = 50
var clicked = false
var drag = false
onready var player = get_node("../../player/player_body")

# Called when the node enters the scene tree for the first time.
func _ready():
	origin = rect_position
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if clicked == true and start_point.distance_to(get_global_mouse_position()) > 2 and drag == false:
		drag = true
	
	if drag == true:
		move_point = (get_global_mouse_position()-rect_pivot_offset-origin).clamped(stick_range)#start_point-get_global_mouse_position()
		player.move_and_slide(Vector2(player.speed/stick_range*move_point.x, 0), Vector2(0, -1))
		rect_position = move_point+origin#(get_global_mouse_position()-rect_pivot_offset-origin).clamped(stick_range)+origin
	
	player.attack_point = move_point
	pass


func stick_clicked():
	start_point = get_global_mouse_position()
	clicked = true
	print("click stick")
	pass # Replace with function body.


func stick_relaese():
	print(str(move_point))
	clicked = false
	drag = false
	start_point = Vector2()
	move_point = Vector2()
	rect_position = origin
	print("relase stick")
	pass # Replace with function body.
