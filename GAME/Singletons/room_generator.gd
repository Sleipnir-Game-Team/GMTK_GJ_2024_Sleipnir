extends Node

const EmptyRoom := preload('res://Prefabs/room.tscn')
static var TrapRooms = []

const TRAP_ROOM_PATH := 'res://Prefabs/TrapRooms/'
static var trap_directory := DirAccess.open(TRAP_ROOM_PATH)

func _ready() -> void:
	var traps = trap_directory.get_files()
	
	for trap in traps:
		var prefab = load(TRAP_ROOM_PATH + trap)
		TrapRooms.append(prefab)

static func get_random_room():
	var room_type = randf()
	
	if room_type < 1.0/3.0:
		return get_random_trap_room()
	else:
		return get_empty_room()


static func get_random_trap_room():
	return TrapRooms.pick_random()

static func get_empty_room():
	return EmptyRoom
