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
	character_detail.get_node("image/sprite").texture = null
	character_detail.get_node("name/Label").text = ""
	character_detail.get_node("caption/Label").text = ""
	
	character_detail.get_node("stats/stats_tween").remove_all()
	character_detail.get_node("stats/stats_tween").interpolate_property(character_detail.get_node("stats/stats_power"), "value", character_detail.get_node("stats/stats_power").value, 0, 0.2, Tween.TRANS_EXPO, Tween.EASE_OUT)
	character_detail.get_node("stats/stats_tween").start()
	character_detail.get_node("stats/stats_tween").interpolate_property(character_detail.get_node("stats/stats_speed"), "value", character_detail.get_node("stats/stats_speed").value, 0, 0.2, Tween.TRANS_EXPO, Tween.EASE_OUT)
	character_detail.get_node("stats/stats_tween").start()
	character_detail.get_node("stats/stats_tween").interpolate_property(character_detail.get_node("stats/stats_health"), "value", character_detail.get_node("stats/stats_health").value, 0, 0.2, Tween.TRANS_EXPO, Tween.EASE_OUT)
	character_detail.get_node("stats/stats_tween").start()

func character_detail_update(char_object):
	character_detail.get_node("image/sprite").texture = char_object.char_sprite
	character_detail.get_node("name/Label").text = char_object.char_name
	character_detail.get_node("caption/Label").text = char_object.char_caption
	
	character_detail.get_node("stats/stats_tween").interpolate_property(character_detail.get_node("stats/stats_power"), "value", character_detail.get_node("stats/stats_power").value, char_object.char_power, 0.6, Tween.TRANS_EXPO, Tween.EASE_OUT)
	character_detail.get_node("stats/stats_tween").start()
	character_detail.get_node("stats/stats_tween").interpolate_property(character_detail.get_node("stats/stats_speed"), "value", character_detail.get_node("stats/stats_speed").value, char_object.char_speed, 0.6, Tween.TRANS_EXPO, Tween.EASE_OUT)
	character_detail.get_node("stats/stats_tween").start()
	character_detail.get_node("stats/stats_tween").interpolate_property(character_detail.get_node("stats/stats_health"), "value", character_detail.get_node("stats/stats_health").value, char_object.char_health, 0.6, Tween.TRANS_EXPO, Tween.EASE_OUT)
	character_detail.get_node("stats/stats_tween").start()

func character_sprite_resized():
	var init_pos = Vector2(139, 107)
	var init_size = Vector2(40, 40)
	
	var a = $Control/HSeparator/character_detail/image/sprite.rect_size - init_size
	a.x /= 2
	$Control/HSeparator/character_detail/image.rect_position = init_pos - a
	
	pass # Replace with function body.

func name_Label_resized():
	var init_pos_x = 158
	var init_size_x = 0
	
	var a = $Control/HSeparator/character_detail/name/Label.rect_size.x - init_size_x
	a /= 2
	$Control/HSeparator/character_detail/name.rect_position.x = init_pos_x - a
	
	pass # Replace with function body.
