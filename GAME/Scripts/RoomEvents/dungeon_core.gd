extends Event

func _ready() -> void:
	super()
	
func _activate_events():
	return [UI_Controller.gameOver]


func _on_expand_clicked():
	RoomGenerator.expand()
