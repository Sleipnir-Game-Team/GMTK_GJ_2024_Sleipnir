class_name Useable

extends Node2D

signal used

func _ready():
	used.connect(_trigger)

func use():
	used.emit()

func _trigger() -> void:
	pass
