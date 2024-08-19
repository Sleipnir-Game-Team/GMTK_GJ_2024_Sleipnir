extends Event

class_name Spikes

var trigger_chance := 0.8

@export var damage := 5

@onready var spikes_sprite := $sprite as Sprite2D
@onready var danger_time := $danger_time as Timer

func _ready() -> void:
	print('Event Ready: ' + name)
	super()

func _process(delta: float) -> void:
	super(delta)
	
## Overwrites superclass to check if adventurer touches the spikes, damaging him
func add_adventurer(adventurer: Adventurer):
	if randf() < trigger_chance:
		adventurer.damage.emit(damage)
		# Finish only if adventurer has enough health to tank a hit, to avoid moving while on the dying animation
		if damage < adventurer.current_life:
			finish.emit.call_deferred([])
	else:
		finish.emit.call_deferred([])
	
	finish.emit([])

func get_dangerous():
	trigger_chance = 1
	damage = 8
	spikes_sprite.texture = load("res://Assets/Level/Enviroment/Arte/Enviroment V1/Armadilhas espinhos alt.png")
	danger_time.start()
	
func get_safe():
	trigger_chance = 0.2
	damage = 5
	spikes_sprite.texture = load("res://Assets/Level/Enviroment/Arte/Enviroment V1/Armadilhas espinhos.png")

func _on_danger_time_timeout() -> void:
	get_safe()
