extends Control

func _ready():
	print(str($ball_bar.get_tint_under()))
	pass

func bar_update(bar, value):
	#$bars_tween.resume_all()
	bar = get_node(bar)
	$bars_tween.interpolate_property(bar, "value", bar.value, bar.value + value, 0.2, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$bars_tween.start()
