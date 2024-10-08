extends Event

class_name LightsOut

const TorchScene = preload('res://Prefabs/RoomEvents/torch.tscn')

var snuffed_torches := 0
var lit_torches := 0
var timed_out := false

var torches := {}

@export var points_worth := 5

@onready var end_timer = $Duration
@onready var torch_timer = $LightTorch

@onready var locations = [$TopLeft, $TopRight, $BottomRight, $BottomLeft]

func _ready() -> void:
	print('Event Ready: ' + name)
	
	var room = get_parent()
	room.activate.connect(end_timer.start)
	room.deactivate.connect(end_timer.stop)
	
	torches = {
		locations[0].name: false,
		locations[1].name: false,
		locations[2].name: false,
		locations[3].name: false,
	}
	
	end_timer.timeout.connect(func (): timed_out = true)
	torch_timer.timeout.connect(light_torch)
	
	super()

func _process(delta: float) -> void:
	super(delta)


func light_torch():
	if lit_torches >= 4: return
	
	var location = locations.pick_random()
	
	while torches[location.name]:
		location = locations.pick_random()
	
	torches[location.name] = true
	lit_torches += 1
	
	var torch = TorchScene.instantiate()
	torch.position = location.position
	torch.clicked.connect(snuff_torch.bind(torch, location.name))
	
	if location.name.ends_with('Left'):
		torch.scale = Vector2(-1, 1)
	
	# TODO PLAY ONLY IF VISIBLE
	AudioManager.play_sfx($Acender)
	add_child(torch)

func snuff_torch(torch: Torch, location_name: String):
	AudioManager.play_sfx($Apagar)
	torches[location_name] = false
	lit_torches -= 1
	snuffed_torches += 1
	remove_child(torch)
	torch.queue_free()

func cleanup():
	for child in get_children():
		if child.is_in_group("Torch"):
			child.queue_free()


func add_adventurer(adventurer: Adventurer):
	adventurer.is_sleeping = true
	adventurer.animation_handler.play(adventurer.character_type_name+' sleep')
	super(adventurer)

func _on_finish(affected: Array[Adventurer]):
	for adventurer in affected:
		adventurer.is_sleeping = false
		adventurer.animation_handler.play(adventurer.character_type_name+' walk')

## +5 Score for successfully beating the event
## Deal 10 damage to each affected Adventurer
func _on_success(affected: Array[Adventurer]):
	Globals.score += points_worth
	
	for adventurer in affected:
		adventurer.damage.emit(10)

func _on_failure(affected: Array[Adventurer]):
	for adventurer in affected:
		adventurer.heal.emit(10)
		print(adventurer.current_life)

func _win_condition():
	return snuffed_torches >= 5

func _loss_condition():
	return timed_out

func _activate_events():
	return [torch_timer.start]

func _deactivate_events():
	return [torch_timer.stop, cleanup]


func get_dangerous():
	pass
