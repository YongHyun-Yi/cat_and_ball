extends Node2D

var press_key = false

func _ready():
	pass


func title_anim_finished(anim_name):
	press_key = true
	pass # Replace with function body.

func _unhandled_key_input(event):
	if press_key == true and FadeEffect.transitioning == false:
		FadeEffect.change_scene(1.0, "res://scene/main_screen.tscn")
