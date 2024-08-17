extends Node2D

signal success
signal failure

@export var teste = 10

var damage := 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if _win_condition():
		success.emit(damage)


func _win_condition():
	# TODO
	return false
