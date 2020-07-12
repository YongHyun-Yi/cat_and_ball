extends CanvasLayer

signal fade_in # 밝아지는 것
signal fade_in_finish
signal fade_out # 어두워지는 것
signal fade_out_finish

export var go_to_scene : NodePath
var scene_changing = false
var transitioning : bool = false

func _ready():
	pass

func anim_finished(anim_name):
	if anim_name == "fade_in":
		emit_signal("fade_in_finish")
	elif anim_name == "fade_out":
		emit_signal("fade_out_finish")
		$fade_wait_timer.start()
	pass # Replace with function body.


func anim_started(anim_name):
	if anim_name == "fade_in":
		emit_signal("fade_in")
	elif anim_name == "fade_out":
		emit_signal("fade_out")
	pass # Replace with function body.

func fade_in():
	$anim.play("fade_in")

func fade_out(time):
	$anim.play("fade_out")
	transitioning = true
	$fade_wait_timer.wait_time = time

#func timer_start(a):
#	$Timer.wait_time = a
#	$Timer.start()

func fade_wait_timeout():
	fade_in()
	
	if scene_changing == true:
		if go_to_scene != "":
			get_tree().change_scene(go_to_scene)
			go_to_scene = ""
		$fade_wait_timer.stop()
	transitioning = false
	
	pass # Replace with function body.

func change_scene(time, scene):
	fade_out(time)
	scene_changing = true
	go_to_scene = scene
