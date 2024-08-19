extends Event

class_name AcidPool

var trigger_chance := 0.2

@onready var pool_sprite := $pool_sprite as Sprite2D
@onready var danger_time := $danger_time as Timer

func _ready() -> void:
	print('Event Ready: ' + name)
	super()

func _process(delta: float) -> void:
	super(delta)
	
	
## Overwrites superclass to check if adventurer fall on the acip trap, killing him instantly
func add_adventurer(adventurer: Adventurer):
	if randf() < trigger_chance:
		adventurer.die()
	else:
		call_deferred('_end')

func _end():
	finish.emit([])
	
func get_dangerous():
	trigger_chance = 0.8
	danger_time.start()
	pool_sprite.texture = load("res://Assets/Level/Enviroment/Arte/Enviroment V1/Armadilha Ácido alt.jpg")
	
func get_safe():
	trigger_chance = 0.2
	pool_sprite.texture = load("res://Assets/Level/Enviroment/Arte/Enviroment V1/Armadilha Ácido .jpg")
	
func _on_danger_time_timeout() -> void:
	get_safe()
