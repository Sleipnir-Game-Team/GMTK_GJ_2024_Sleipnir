extends Node2D

const Room := preload("res://Prefabs/room.tscn")
const INITIAL_SIZE = Vector2i(3, 3)

# Called when the node enters the scene tree for the first time.
func _ready():
	_create_grid(INITIAL_SIZE.x, INITIAL_SIZE.y)
	_fill_paths()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _create_grid(rows: int, columns: int):
	# Create a room to calculate the distance between each room
	var distance = null
	
	# Variable to keep next room's position
	var room_position = Vector2(0,0)
	for row in rows:
		for column in columns:
			var room = Room.instantiate()
			room.global_position = room_position
			add_child(room)
			
			# Calculate the distance between each room
			if not distance:
				distance = (room.right_spawn.position.x - room.position.x) * 2 
			
			room_position.x += distance # Step over a column
		room_position.y += distance # Step over a row
		room_position.x = 0 # Reset back to first column

func _fill_paths():
	for child in get_children():
		child.call_deferred("update_paths")
