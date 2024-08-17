extends Area2D

enum Type {BOTTOM, BOTTOM_L, BOTTOM_R};

const path_instance := preload("res://Prefabs/paths.tscn")
const Adventurer := preload("res://Actors/adventurer.tscn")

signal activate
signal deactivate

var paths_dict := {"right" = false, "down" = false}

@export var _trap: Trap

@onready var collision_shape := $CollisionShape2D

@onready var down_detector := $down_path_detector as RayCast2D
@onready var right_detector := $right_path_detector as RayCast2D

@onready var down_spawn := $down_path_spawn as Marker2D
@onready var right_spawn := $right_path_spawn as Marker2D

func _ready() -> void:
	print('Ready ' + name)
	if _trap:
		print('Deactivate trap')
		deactivate.emit()
		
	print()


func _on_body_entered(body):
	print('ROOM ENTERED BY ADVENTURER')
	if _trap:
		activate.emit()
	if body:
		body.last_room = self
	
## Add trap to room
func set_trap(trap: Trap):
	_trap = trap
	deactivate.emit() # start disabled
	add_child(_trap)

## Checks if there are adjacent rooms and spawns corresponding paths
func update_paths():
	_detect_adjacent_rooms()
	_spawn_paths()

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
