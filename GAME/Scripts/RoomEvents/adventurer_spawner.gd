extends Event

const AdventurerScene = preload('res://Actors/adventurer.tscn')

var spawn_rate_minimum := 100
var c := 1.1
var rng_adventurer_spawn_rate := RandomNumberGenerator.new()
var is_waiting := false

func spawn_adventurer():
	var adventure_spawn_chance := rng_adventurer_spawn_rate.randi_range(0, 99)
	
	if adventure_spawn_chance <= spawn_rate_minimum:
		spawn_rate_minimum = 10
		is_waiting = true
		var adventurer = AdventurerScene.instantiate()
		get_parent().get_parent().call_deferred("add_child", adventurer)
		adventurer.position = get_parent().position
		adventurer.entered_room.connect(moved)
	else:
		spawn_rate_minimum *= spawn_rate_minimum
		print("New Spawn Rate: ", spawn_rate_minimum)

func _win_condition() -> bool:
	# Never win or lose event, such that it runs forever
	return false
	
func _loss_condition() -> bool:
	# Never win or lose event, such that it runs forever
	return false

func moved(adventurer, room):
	if room != get_parent():
		adventurer.entered_room.disconnect(moved)
		is_waiting = false

func _on_spawn_timer_timeout() -> void:
	if !is_waiting:
		spawn_adventurer()
