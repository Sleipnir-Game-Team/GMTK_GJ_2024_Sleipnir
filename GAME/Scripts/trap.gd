extends Node2D

class_name Trap

signal success
signal failure

var _enabled := false

func _ready() -> void:
	get_parent().activate.connect(_set_enabled.bind(true))
	get_parent().deactivate.connect(_set_enabled.bind(false))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not _enabled: return
	
	if _win_condition():
		success.emit()
	elif _loss_condition():
		failure.emit()

func _set_enabled(enable):
	_enabled = enable
	

func _win_condition():
	printerr('Must override "_win_condition" in Trap Subclasses')
	
func _loss_condition():
	printerr('Must override "_loss_condition" in Trap Subclasses')
