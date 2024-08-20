extends Resource

class_name Item

@export var name := ''
@export var texture: Texture2D
@export var useable: PackedScene
@export var price := 1

func _to_string() -> String:
	return name
