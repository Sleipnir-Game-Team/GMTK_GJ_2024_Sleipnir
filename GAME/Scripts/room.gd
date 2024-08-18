extends Area2D

enum Type {BOTTOM, BOTTOM_L, BOTTOM_R};

const path_instance := preload("res://Prefabs/paths.tscn")
const Adventurer := preload("res://Actors/adventurer.tscn")

signal activate
signal deactivate

var paths_dict := {"right" = false, "down" = false}

var _active_event: Event
@export var _long_lasting_event: Event
@export var _event_queue: Array[Event] = []

@onready var collision_shape := $CollisionShape2D

@onready var down_detector := $down_path_detector as RayCast2D
@onready var right_detector := $right_path_detector as RayCast2D

@onready var down_spawn := $down_path_spawn as Marker2D
@onready var right_spawn := $right_path_spawn as Marker2D

func _ready() -> void:
	print('Room Ready: ' + name)
	
	if len(_event_queue) > 0:
		_swap_active_event(_event_queue.pop_front())
	elif _long_lasting_event:
		_swap_active_event(_long_lasting_event)
	
	print()

func _process(delta: float) -> void:
	# Se não tem evento fodase
	if not _active_event: return
	
	# Se tem eventos na pilha:
	if len(_event_queue) > 0:
		# Se esse evento é o evento duradouro
		if _active_event == _long_lasting_event:
			# Troca pelo primeiro evento da pilha
			var new_event = _event_queue.pop_front()
			new_event.finished.connect(_start_long_lasting_event)
			_swap_active_event(new_event)
			
		# Se não fodase
	# Senão, tem evento duradouro?:
	elif _long_lasting_event:
		# Troca pelo duradouro
		_start_long_lasting_event()


func _on_body_entered(body):
	print('Adventurer entered room %s' % name)
	
	if _active_event:
		print('Active event: ', self._active_event)
		activate.emit()
	else:
		print('Room has no active event.')

	if body:
		body.last_room = self
		body.entered_room.emit()

func _on_body_left(body):
	if body:
		body.left_room.emit()

func set_long_lasting_event(event: Event):
	_long_lasting_event = event

func add_temporary_event(event: Event):
	_event_queue.push_back(event)

## Checks if there are adjacent rooms and spawns corresponding paths
func update_paths():
	_detect_adjacent_rooms()
	_spawn_paths()

func _start_long_lasting_event():
	if _long_lasting_event != _active_event:
		_swap_active_event(_long_lasting_event)
	

func _swap_active_event(event: Event):
	if _active_event:
		remove_child(_active_event)
	
	_active_event = event
	_active_event.set_process(true)
	_active_event.set_physics_process(true)
	_active_event.finish.connect(deactivate.emit)
	
	if not is_ancestor_of(_active_event):
		add_child(_active_event)


func _detect_adjacent_rooms():
	paths_dict["down"] = down_detector.is_colliding()
	paths_dict["right"] = right_detector.is_colliding()

func _spawn_paths():
	if paths_dict["down"]:
		var path = path_instance.instantiate()
		path.position = down_spawn.position
		path.rotate(PI/2)
		add_child(path)
		
	if paths_dict["right"]:
		var path = path_instance.instantiate()
		path.position = right_spawn.position
		add_child(path)
