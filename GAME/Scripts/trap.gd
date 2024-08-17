extends Node2D

class_name Trap

signal success
signal failure

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _win_condition():
		success.emit()
	elif _loss_condition():
		failure.emit()


func _win_condition():
	printerr('Must override "_win_condition" in Trap Subclasses')
	
func _loss_condition():
	printerr('Must override "_loss_condition" in Trap Subclasses')
