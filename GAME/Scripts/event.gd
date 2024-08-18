extends Node2D

class_name Event

signal finish(adventurers: Array[Adventurer])
signal success(adventurers: Array[Adventurer])
signal failure(adventurers: Array[Adventurer])

var adventurers := []

var _enabled := false

@onready var end_timer = $Duration

func _ready() -> void:
	var room = get_parent()
	var activate_signal = room.activate
	var deactivate_signal = room.deactivate
	
	activate_signal.connect(_set_enabled.bind(true))
	
	activate_signal.connect(end_timer.start)
	deactivate_signal.connect(end_timer.stop)
	
	print('Binding event activation callbacks:')
	for event in _activate_events():
		print('> On activate: %s %s' % [event.get_object().get_class(), event.get_method()])
		activate_signal.connect(event)
	
	for event in _deactivate_events():
		deactivate_signal.connect(event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not _enabled: return
	
	if _win_condition():
		success.emit(adventurers)
		finish.emit(adventurers)
		clear_adventurers()
		_set_enabled(false)
	elif _loss_condition():
		failure.emit(adventurers)
		finish.emit(adventurers)
		clear_adventurers()
		_set_enabled(false)
		


func add_adventurer(adventurer: Adventurer):
	adventurers.append(adventurer)

func clear_adventurers():
	adventurers = []

func _set_enabled(enable):
	if enable == _enabled:
		print('Trying to %s already %s event' % ['enable' if enable else 'disable', 'enabled' if enable else 'disabled'])
	print('Event %s: %s' % ['enabled' if enable else 'disabled', name])
	_enabled = enable

func _activate_events() -> Array[Callable]:
	printerr('Must override "_activate_events" in Trap Subclasses')
	return []
	
func _deactivate_events() -> Array[Callable]:
	printerr('Must override "_deactivate_events" in Trap Subclasses')
	return []

func _win_condition() -> bool:
	printerr('Must override "_win_condition" in Trap Subclasses')
	return false
	
func _loss_condition() -> bool:
	printerr('Must override "_loss_condition" in Trap Subclasses')
	return false
