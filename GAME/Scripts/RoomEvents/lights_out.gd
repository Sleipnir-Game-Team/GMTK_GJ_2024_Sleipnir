extends Event

var Torch := preload('res://Prefabs/RoomEvents/torch.tscn')

var snuffed_lights := 0
var timed_out := false

@onready var torch_timer = $LightTorch

@onready var locations = [$TopLeft, $TopRight, $BottomRight, $BottomLeft]

func _ready() -> void:
	print('Event Ready: ' + name)
	end_timer.timeout.connect(func (): timed_out = true)
	torch_timer.timeout.connect(light_torch)
	super()

func _process(delta: float) -> void:
	super(delta)

func light_torch():
	print('Spawning torch')
	var torch = Torch.instantiate()
	torch.position = locations.pick_random().position
	torch.clicked.connect(snuff_torch.bind(torch))
	add_child(torch)

func snuff_torch(torch: Node):
	snuffed_lights += 1
	remove_child(torch)

func cleanup():
	for child in get_children():
		if child.is_in_group("Torch"):
			child.queue_free()

func _win_condition():
	return snuffed_lights >= 5

func _loss_condition():
	return timed_out

func _activate_events():
	return [torch_timer.start]

func _deactivate_events():
	return [torch_timer.stop, cleanup]
