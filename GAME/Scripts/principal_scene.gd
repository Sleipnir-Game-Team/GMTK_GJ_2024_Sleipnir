extends Node2D

@onready var action_timer := $action_timer as Timer
@onready var adventurer := $adventurer as Area2D

var present_position

func _ready():
	pass
	
func _process(delta):
	pass
	
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

func _on_action_timer_timeout():
	pass
	#adventurer_moviment()
	
