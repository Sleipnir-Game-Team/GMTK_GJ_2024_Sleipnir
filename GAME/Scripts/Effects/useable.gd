class_name Useable

extends Node2D


var using := false:
	get = get_using,
	set = set_using

signal used
signal finished


func use():
	used.emit()

	
func get_using() -> bool:
	return using

func set_using(new_using: bool) -> void:
	using = new_using


func _trigger() -> void:
	using = true

func finish() -> void:
	finished.emit()
	queue_free()
