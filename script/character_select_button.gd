extends Button

onready var manager = get_node("/root/character_selection")

export (Resource) var char_sprite
export var char_name = "이름"
export var char_caption = "설명이에오"

export var char_power = 3
export var char_speed = 5
export var char_health = 7
onready var char_stats = [char_power, char_speed, char_health]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func mouse_entered():
	manager.character_detail_update(self)


func mouse_exited():
	if manager.selected_character != self:
		if manager.selected_character != null:
			manager.character_detail_update(manager.selected_character)
		else:
			manager.character_detail_init()


func button_down():
	if manager.selected_character != self:
		if manager.selected_character != null:
			manager.selected_character.mouse_filter = 0
			manager.selected_character.pressed = false
		manager.selected_character = self
	else:
		mouse_filter = 2
		pass
