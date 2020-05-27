extends "res://script/interact_object.gd"


onready var player = get_node("/root/ingame/player/player_body")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Area2D.get_overlapping_areas().size() > 0:
		hit_check()
	pass

func interact(area):
	var a = area.get_parent()
	
	pass # Replace with function body.

func hit_check():
	#var a = $Area2D.overlaps_area()
	#"""
	if $Area2D.overlaps_area(player.get_node("hit_zone")):
		if player.invincible == false:
			player.invincible = true
			player.get_node("hitted_anim").play("hitted")
			player.get_node("hitted_anim/Timer").start()
			print("spike!")
	#"""
	for i in $Area2D.get_overlapping_areas(): # 적에게도 적용하기위한 확장성을 위해 player에서 overlapped area로 변경
		var a = i.get_parent()
		if a is KinematicBody2D and a.invincible == false:
			a.invincible = true
			a.get_node("hitted_anim").play("hitted")
			a.get_node("hitted_anim/Timer").start()
			print("spike!")
		elif a is RigidBody2D and a.name == "ball_body":
			if a.dead == false:
				print("dead is : "+str(a.dead))
				a.dead = true
				print("dead is : "+str(a.dead))
				a.ball_dead()
				
	#"""
