extends Control


export var chat_on : bool = false
onready var player = get_node("/root/ingame/player/player_body")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _unhandled_key_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		if chat_on == false:
			start_chat()
		else:
			if $LineEdit.text.length() > 0:
				chat_output()
			end_chat()
	
	elif Input.is_action_just_pressed("ui_cancel"):
		if chat_on == true:
			end_chat()
	
	#else:
	#	if chat_on == true:
	#		if event is InputEventKey and chat_init == false:
				#chat_init()
	#			pass
	#		get_tree().set_input_as_handled()
	
	#print(event.scancode)

func start_chat():
	chat_on = true
	show()
	$LineEdit.grab_focus()

func end_chat():
	chat_on = false
	#chat_init = false
	hide()
	$LineEdit.clear()
	$LineEdit.release_focus()

#func chat_init():
#	$LineEdit.clear()
#	chat_init = true

func chat_output():
	print($LineEdit.text)
	player.display_chat($LineEdit.text)


#func text_changed(new_text):
#	print("change")
#	if chat_init == false:
#		chat_init()


func text_entered(new_text):
	print("entered")
	pass # Replace with function body.
