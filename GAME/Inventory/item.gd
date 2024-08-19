extends Resource

class_name Item

@export var name := ''
@export var texture: Texture2D


func _to_string() -> String:
	return name
