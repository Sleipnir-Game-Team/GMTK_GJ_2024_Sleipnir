extends Control

var is_open: bool:
	get:
		return visible
	set(value):
		visible = value


func _ready() -> void:
	close()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("toggle_inventory"):
		toggle()

func toggle():
	is_open = not is_open

func open():
	is_open = true

func close():
	is_open = false
