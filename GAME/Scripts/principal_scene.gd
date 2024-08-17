extends Node2D

@onready var action_timer := $action_timer as Timer
@onready var adventurer := $adventurer as Area2D

var minimun_adventurer_spawn_rate := 10
var adventurer_spawn_incrementention := 1.1
var rng_adventurer_spawn_rate := RandomNumberGenerator.new()
var is_waiting := false

var present_position

func _ready():
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("expand"):
		is_waiting = true
	if Input.is_action_just_released("expand"):
		is_waiting = false
	
func adventurer_moviment():
	if adventurer.next_path == "left":
		present_position = adventurer.get_global_position()
		adventurer.set_global_position(Vector2(present_position.x - 224, present_position.y))
	elif adventurer.next_path == "down":
		present_position = adventurer.get_global_position()
		adventurer.set_global_position(Vector2(present_position.x, present_position.y + 224))
	elif adventurer.next_path == "right":
		present_position = adventurer.get_global_position()
		adventurer.set_global_position(Vector2(present_position.x + 224, present_position.y))
	elif adventurer.next_path == "up":
		present_position = adventurer.get_global_position()
		adventurer.set_global_position(Vector2(present_position.x, present_position.y - 224))
	
func expand_dungeon():
	pass
	
func spawn_adventurer():
	var adventure_spawn_chance := rng_adventurer_spawn_rate.randi_range(0, 99)
	if adventure_spawn_chance <= minimun_adventurer_spawn_rate:
		print("Entrou na Dungeon")
		minimun_adventurer_spawn_rate = 10
	else:
		minimun_adventurer_spawn_rate *= adventurer_spawn_incrementention
		print(minimun_adventurer_spawn_rate)

func _on_action_timer_timeout():
	pass
	#adventurer_moviment()
	
func _on_spawn_timer_timeout():
	if !is_waiting:
		spawn_adventurer()
