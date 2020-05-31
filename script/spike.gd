extends "res://script/interact_object.gd"


onready var player = get_node("/root/ingame/player/player_body")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Area2D.get_overlapping_areas().size() > 0 or $Area2D.get_overlapping_bodies().size() > 0:
		hit_check()
	pass

func hit_check():
	for i in $Area2D.get_overlapping_areas():
		if i.get_parent().has_method("interact_spike"):
			i.get_parent().interact_spike()
	
	for i in $Area2D.get_overlapping_bodies():
		if i.has_method("interact_spike"):
			i.interact_spike()
		
		elif i.get_parent().has_method("interact_spike"):
			i.get_parent().interact_spike()
