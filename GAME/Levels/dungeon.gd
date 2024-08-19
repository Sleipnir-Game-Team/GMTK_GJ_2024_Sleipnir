extends Node2D

const RoomScene = preload('res://Prefabs/room.tscn')

const INITIAL_SIZE = Vector2i(3, 3)

@export var inventory: Inventory

func _init() -> void:
	_create_grid(INITIAL_SIZE.x, INITIAL_SIZE.y)

func _ready():
	RoomGenerator._fill_paths()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# TODO puta merda
	get_tree().call_group_flags(SceneTree.GROUP_CALL_DEFERRED, 'Room', 'update_sprites')


## TODO REMOVER ESSA PORRA AQUI
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_B:
			inventory.add_item(load("res://Inventory/Items/heart.tres"))

## Gain 20 points every 10 seconds of being alive
func _on_score_timer() -> void:
	Globals.score += 20


func _create_grid(rows: int, columns: int):
	# Create a room to calculate the distance between each room
	var distance = null
	
	# Variable to keep next room's position
	var room_position = Vector2(0,0)
	for row in rows:
		for column in columns:
			var room: Room
			
			if column == columns - 1 and row == rows - 1:
				room = RoomGenerator.get_core_room().instantiate()
				room.is_end = true
			else:
				room = RoomGenerator.get_random_room().instantiate()
			
			room.global_position = room_position
			add_child(room)
			
			# Calculate the distance between each room
			if not distance:
				distance = (room.right_spawn.position.x - room.position.x) * 2 
			
			if column == columns-1 or row == rows-1:
				room.add_to_group('Last_Rooms')
			
			room_position.x += distance # Step over a column
		room_position.y += distance # Step over a row
		room_position.x = 0 # Reset back to first column
