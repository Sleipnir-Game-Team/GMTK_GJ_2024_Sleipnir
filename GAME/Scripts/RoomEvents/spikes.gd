extends Event

class_name Spikes

@export var damage := 5

@onready var spikes_sprite := $sprite as Sprite2D

func _ready() -> void:
	print('Event Ready: ' + name)
	super()

func _process(delta: float) -> void:
	super(delta)
	
## Overwrites superclass to check if adventurer touches the spikes, damaging him
func add_adventurer(adventurer: Adventurer):
	if randf() < 0.8:
		adventurer.damage.emit(damage)
		# Finish only if adventurer has enough health to tank a hit, to avoid moving while on the dying animation
		if damage < adventurer.current_life:
			finish.emit.call_deferred([])
	else:
		finish.emit.call_deferred([])

	finish.emit([])
