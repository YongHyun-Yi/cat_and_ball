extends Node2D

var first = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_anim_animation_finished(anim_name):
	if anim_name == "reset":
		$anim.play("fade")
	else:
		if first == false:
			$"godot logo".hide()
			$"yhy logo2".show()
			$anim.play("fade")
			first = true
		else:
			get_tree().change_scene("res://scene/main_screen.tscn")
	pass # Replace with function body.


func _on_Timer_timeout():
	$anim.play("fade")
	pass # Replace with function body.
