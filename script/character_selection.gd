extends Node2D


var selected_character : Object = null

onready var character_detail = $Control/HSeparator/character_detail


# Called when the node enters the scene tree for the first time.
func _ready():
	#$Control/HSeparator/Panel2/grid/Button.connect("button_up", self,)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func cancel_button():
	get_tree().change_scene("res://scene/main_screen.tscn")
	pass # Replace with function body.

func button_event(b_name):
	var button = get_node("Control/HSeparator/hbox/"+b_name)
	
	if Rect2(Vector2.ZERO, button.rect_size).has_point(button.get_local_mouse_position()):
		if b_name == "confirm":
			get_tree().change_scene("res://scene/ingame.tscn")
		elif b_name == "cancel":
			get_tree().change_scene("res://scene/main_screen.tscn")
		pass

func character_detail_init():
	character_detail.get_node("sprite").texture = null
	character_detail.get_node("caption/Label").text = ""

func character_detail_update(char_object):
	character_detail.get_node("sprite").texture = char_object.char_sprite
	character_detail.get_node("caption/Label").text = char_object.char_caption
