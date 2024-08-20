extends Area2D

class_name ExpandButton

signal clicked

const hover_texture   := preload('res://Assets/Menu/UI/V4/menu_buttons/expansion/Expansion Hover@8x.png')
const default_texture := preload('res://Assets/Menu/UI/V4/menu_buttons/expansion/Expansion Normal@8x.png')
const clicked_texture := preload('res://Assets/Menu/UI/V4/menu_buttons/expansion/Expansion Clicked@8x.png')

@onready var sprite := $expand_sprite

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		sprite.texture = clicked_texture
		clicked.emit()

func get_dangerous():
	pass


func _on_mouse_entered() -> void:
	sprite.texture = hover_texture
	


func _on_mouse_exited() -> void:
	sprite.texture = default_texture
