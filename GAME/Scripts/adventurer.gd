extends CharacterBody2D

const LightsOutEvent = preload('res://Prefabs/RoomEvents/lights_out.tscn')

var total_life := 10
var current_life := 10

var last_room: Node
var target_room: Node

signal entered_room(adventurer, room)
signal left_room(adventurer, room)

@export var speed := 45

@onready var right_detector = $right_path_detector
@onready var down_detector = $down_path_detector

# Called when the node enters the scene tree for the first time.
func _ready():
	entered_room.connect(_handle_enter_event)
	left_room.connect(_handle_leave_event)

func _physics_process(delta):
	if target_room and position.distance_to(target_room.position) < 1:
		stop_moving()
		
	move_and_slide()
	 
#region
#func _on_area_entered(area):
	#possible_paths.clear()
	## If the adventurer has encountered a new room
	#if area.name == "room":
		#area.trigger();
		
		# If room has a trap, damage adventurer
		#if area.has_trap == true:
			#adventurer_life -= 1
			#print("adventurer life points: ", adventurer_life)
			#minimum_rest_chance += 10
		# If it doesn't have a trap, test if the adventurer will rest
		#else:
			#var rest_chance := rng_rest.randi_range(minimum_rest_chance, 100)
			#print("rest chance: ", rest_chance)
			#if rest_chance == 100 or minimum_rest_chance >= 100:
				#minimum_rest_chance = 1
				#adventurer_life = total_life
				#print("Descansados")
			#else:
				#minimum_rest_chance += 5
	
	#if area.name == "core_room":
		#has_arrived_to_the_core = true
		#next_path = null
		#print("Game-Over")
	#
	#if adventurer_life > 0 and has_arrived_to_the_core == false:
		#if area.paths_dict["right"] == true:
			#possible_paths.append("right")
		#if area.paths_dict["down"] == true:
			#possible_paths.append("down")
			#
		#var path_choise := rng_paths.randi_range(1, possible_paths.size())
		#next_path = possible_paths[path_choise - 1]
	#elif adventurer_life <= 0:
		#queue_free()
#endregion

func move_in_direction(direction: Vector2):
	velocity = direction * speed

func stop_moving():
	velocity = Vector2(0,0)

func _find_possible_moves():
	var possible_moves = []
	
	if right_detector.is_colliding():
		possible_moves.append(right_detector.get_collider())
	
	if down_detector.is_colliding():
		possible_moves.append(down_detector.get_collider())
	
	target_room = possible_moves.pick_random()
	var target_direction = (target_room.position - position).normalized()
	
	move_in_direction(target_direction)

func _handle_enter_event(adventurer, room):
	# If last_room is not defined, the Adventurer has just been created and is in spawn
	if not last_room:
		last_room = room
		# Since this is spawn, we can immediatly look for a new target room to move towards
		_find_possible_moves()
	# This is not the spawn room, and it has an event
	elif room._active_event:
		# Wait till the event is over and then find a new target!
		room._active_event.finish.connect(_find_possible_moves)
	# This is an empty room
	else:
		# Add a temporary rest event to the room
		var event = LightsOutEvent.instantiate()
		event.finish.connect(_find_possible_moves) # Trigger movement once it's over
		room.add_temporary_event(event)
		room.activate.emit() # Trigger event activation!

func _handle_leave_event(adventurer, room):
	last_room = room
