extends Area2D

class_name Torch

signal clicked

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int	):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		clicked.emit()
