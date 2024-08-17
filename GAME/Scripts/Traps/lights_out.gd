extends Trap

var Torch := preload('res://Prefabs/Traps/torch.tscn')

var snuffed_lights := 0
var timed_out := false

@onready var end_timer = $Duration
@onready var torch_timer = $LightTorch

@onready var locations = [$TopLeft, $TopRight, $BottomRight, $BottomLeft]

func _ready() -> void:
	end_timer.timeout.connect(func (): timed_out = true)
	torch_timer.timeout.connect(spawn_torch)

func spawn_torch():
	print('spawning torch')
	var torch = Torch.instantiate()
	torch.position = locations.pick_random().position
	torch.clicked.connect(snuff_torch.bind(torch))
	add_child(torch)

func snuff_torch(torch: Node):
	snuffed_lights += 1
	remove_child(torch)

func _win_condition():
	return snuffed_lights >= 5
	
func _loss_condition():
	return timed_out
	
