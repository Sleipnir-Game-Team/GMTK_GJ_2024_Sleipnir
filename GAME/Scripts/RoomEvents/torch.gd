extends Area2D

class_name Torch

signal clicked

func _ready()->void:
	AudioManager.play_sfx($Acender)

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		AudioManager.play_sfx($Apagar)
		clicked.emit()
