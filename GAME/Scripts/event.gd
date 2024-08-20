extends Node2D

class_name Event

signal finish(adventurers: Array[Adventurer])
signal success(adventurers: Array[Adventurer])
signal failure(adventurers: Array[Adventurer])

var adventurers: Array[Adventurer] = []

var _enabled := false

# TODO FUNCIONAR ISSO AQUI PRO SOL BOTAR MÚSICA FODA
@export var interactive := false


func _ready() -> void:
	var room = get_parent()
	
	room.activate.connect(set_enabled.bind(true))
	
	print('Binding event activation callbacks:')
	for event in _activate_events():
		print('> On activate: %s %s' % [event.get_object().get_class(), event.get_method()])
		room.activate.connect(event)
	
	if interactive:
		room.activate.connect(_on_interactive_event_activated)
		finish.connect(remove_from_group.bind('running_interactive_events'))
	
	for event in _deactivate_events():
		room.deactivate.connect(event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not _enabled: return
	
	if _win_condition():
		success.emit(adventurers)
		finish.emit(adventurers)
		clear_adventurers()
		set_enabled(false)
	elif _loss_condition():
		failure.emit(adventurers)
		finish.emit(adventurers)
		clear_adventurers()
		set_enabled(false)

func _force_win():
	success.emit(adventurers)
	finish.emit(adventurers)
	clear_adventurers()
	set_enabled(false)

func _force_loss():
	failure.emit(adventurers)
	finish.emit(adventurers)
	clear_adventurers()
	set_enabled(false)
		
func set_enabled(enable):
	if enable == _enabled:
		print('Trying to %s already %s event' % ['enable' if enable else 'disable', 'enabled' if enable else 'disabled'])
	print('Event %s: %s' % ['enabled' if enable else 'disabled', name])
	_enabled = enable


func _on_interactive_event_activated():
	add_to_group('running_interactive_events')


func add_adventurer(adventurer: Adventurer):
	adventurers.append(adventurer)

func clear_adventurers():
	adventurers = []


func _activate_events() -> Array[Callable]:
	return []

func _deactivate_events() -> Array[Callable]:
	return []


func _win_condition() -> bool:
	return false

func _loss_condition() -> bool:
	return false
