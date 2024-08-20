extends Node

const EmptyRoom := preload('res://Prefabs/room.tscn')
const CoreRoom := preload('res://Prefabs/core_room.tscn')
var TrapRooms = []

const TRAP_ROOM_PATH := 'res://Prefabs/TrapRooms/'
var trap_directory := DirAccess.open(TRAP_ROOM_PATH)


func _ready() -> void:
	var traps = trap_directory.get_files()
	
	for trap in traps:
		var prefab = load(TRAP_ROOM_PATH + trap)
		TrapRooms.append(prefab)


func get_random_room():
	var room_type = randf()
	
	if room_type < 1.0/3.0:
		return get_random_trap_room()
	else:
		return get_empty_room()

func get_random_trap_room():
	return TrapRooms.pick_random()

func get_empty_room():
	return EmptyRoom

func get_core_room():
	return CoreRoom

func _fill_paths():
	get_tree().call_group_flags(SceneTree.GROUP_CALL_DEFERRED, 'Room', 'update_paths')

func expand():
	get_tree().get_first_node_in_group("Camera").get_child(0).expand(273)
	get_tree().call_group_flags(0, 'Last_Rooms', '_add_adjacent_rooms')
	_fill_paths()
