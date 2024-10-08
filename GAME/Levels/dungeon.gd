extends Node2D

const RoomScene = preload('res://Prefabs/room.tscn')

const INITIAL_SIZE = Vector2i(3, 3)

var item_being_used: Useable

@export var inventory: Inventory

@onready var BuffPotionSFX := $BuffPotion as SoundQueue
@onready var StunPotionSFX := $StunPotion

func _ready():
	Globals.souls = 0
	Globals.score = 0
	UI_Controller.buy_Item.connect(_on_buy_item)
	
	inventory.changed.connect(UI_Controller.updateHotbar)
	
	_create_grid(INITIAL_SIZE.x, INITIAL_SIZE.y)
	RoomGenerator._fill_paths()

func _unhandled_input(event: InputEvent) -> void:
	if item_being_used != null or not (event is InputEventKey and event.pressed): return
	
	var position: int
	
	match event.keycode:
		KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9:
			position = event.keycode - KEY_1
		_:
			return
	
	var my_item = inventory.get_item(position)
	if not my_item: return
	
	item_being_used = my_item.useable.instantiate() as Useable
	item_being_used.finished.connect(inventory.remove_item.bind(position), CONNECT_ONE_SHOT)
	print('ITEM NAME ', item_being_used.name)
	
	match my_item.name:
		'BuffPotion':
			item_being_used.finished.connect(AudioManager.play_sfx.bind(BuffPotionSFX), CONNECT_ONE_SHOT)
		'StunPotion':
			item_being_used.finished.connect(AudioManager.play_sfx.bind(StunPotionSFX), CONNECT_ONE_SHOT)
	item_being_used.use()
	add_sibling(item_being_used)


## Check if item can be bought, remove souls and add it to inventory
func _on_buy_item(item: Item):
	if Globals.souls >= item.price and inventory.has_space():
		SfxGlobals.play_global('LojaCompra')
		Globals.souls -= item.price
		inventory.add_item(item)
	else:
		SfxGlobals.play_global('LojaReject')

## Gain 20 points every 10 seconds of being alive
func _on_score_timer() -> void:
	Globals.score += 20


## Create initial playing grid
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
