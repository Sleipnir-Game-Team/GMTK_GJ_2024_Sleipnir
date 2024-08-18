extends Event

func _ready() -> void:
	super()

func _deactivate_events():
	return []

func _activate_events():
	return [UI_Controller.gameOver]

func _win_condition():
	return false

func _loss_condition():
	return false
