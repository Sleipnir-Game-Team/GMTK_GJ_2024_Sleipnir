extends Event

func _ready() -> void:
	print(get_parent())
	super()

func _deactivate_events():
	return []

func _activate_events():
	return [UI_Controller.gameOver]

func _win_condition():
	pass

func _loss_condition():
	pass
