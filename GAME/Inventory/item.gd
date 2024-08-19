extends Resource

class_name Item

@export var name := ''
@export var texture: Texture2D
@export var useable: PackedScene

func _to_string() -> String:
	return name
