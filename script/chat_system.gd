extends Control


export var chat_on : bool = false
onready var player = get_node("/root/ingame/player/player_body")

signal chat_mode

var char_id : String = "캐릭터"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	"""
	if Input.is_action_just_pressed("ui_chat"):
		if chat_on == false:
			start_chat()
		else:
			if $chat_input_edit.text.length() > 0:
				chat_output()
			end_chat()
	
	elif Input.is_action_just_pressed("ui_cancel"):
		if chat_on == true:
			end_chat()
			get_tree().set_input_as_handled()
	"""
	#else:
	#	if chat_on == true:
	#		if event is InputEventKey and chat_init == false:
				#chat_init()
	#			pass
	#		get_tree().set_input_as_handled()
	
	#print(event.scancode)
	pass

func start_chat():
	chat_on = true
	player.can_move = false
	#$chat_input_rect.show()
	$chat_input_edit.grab_focus()
	emit_signal("chat_mode", "on")

func end_chat():
	chat_on = false
	player.can_move = true
	#chat_init = false
	#$chat_input_rect.hide()
	$chat_input_edit.clear()
	$chat_input_edit.release_focus()
	emit_signal("chat_mode", "off")

#func chat_init():
#	$LineEdit.clear()
#	chat_init = true

func chat_output():
	player.display_chat($chat_input_edit.text)
	var a = char_id + " : " + $chat_input_edit.text + "\n"
	$chat_output_display.bbcode_text += a


#func text_changed(new_text):
#	print("change")
#	if chat_init == false:
#		chat_init()


func text_entered(new_text):
	print("entered")
	pass # Replace with function body.
