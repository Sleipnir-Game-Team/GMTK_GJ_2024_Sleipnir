extends Event

@export var adventurer_instance : PackedScene

var minimun_adventurer_spawn_rate := 100
var adventurer_spawn_incrementention := 1.1
var rng_adventurer_spawn_rate := RandomNumberGenerator.new()
var is_waiting := false

#@onready var spawn_position := $spawn_position as Marker2D

func _ready() -> void:
	pass

func spawn_adventurer():
	var adventure_spawn_chance := rng_adventurer_spawn_rate.randi_range(0, 99)
	if adventure_spawn_chance <= minimun_adventurer_spawn_rate:
		minimun_adventurer_spawn_rate = 10
		is_waiting = true
		var adventurer = adventurer_instance.instantiate()
		get_parent().get_parent().call_deferred("add_child", adventurer)
		adventurer.position = get_parent().position
		adventurer.entered_room.connect(moved)
	else:
		minimun_adventurer_spawn_rate *= adventurer_spawn_incrementention
		print(minimun_adventurer_spawn_rate)

func _win_condition():
	pass
	
func _loss_condition():
	pass

func moved(adventurer, room):
	if room != get_parent():
		adventurer.entered_room.disconnect(moved)
		is_waiting = false

func _on_spawn_timer_timeout() -> void:
	if !is_waiting:
		spawn_adventurer()
