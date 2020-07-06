extends Popup

func _ready():
	key_info_update()
	pass

func key_info_update():
	$Control/move/action_info/action_name.text = "왼쪽 이동"
	$Control/move/action_info/binding_button.text = InputMap.get_action_list("move_left")[0].as_text()
