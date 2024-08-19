class_name Useable

extends Node2D


var using := false:
	get = get_using,
	set = set_using

signal used


func use():
	used.emit()

	
func get_using() -> bool:
	return using

func set_using(new_using: bool) -> void:
	using = new_using


func _trigger() -> void:
	using = true

func _cancel() -> void:
	using = false
