extends Event

class_name AcidPool

@onready var pool_sprite := $pool_sprite as Sprite2D

func _ready() -> void:
	print('Event Ready: ' + name)
	super()

func _process(delta: float) -> void:
	super(delta)
	
	
## Overwrites superclass to check if adventurer fall on the acip trap, killing him instantly
func add_adventurer(adventurer: Adventurer):
	if randf() < 0.2:
		adventurer.die()
	else:
		call_deferred('_end')

func _end():
	finish.emit([])
