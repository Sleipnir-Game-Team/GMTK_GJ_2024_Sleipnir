extends CharacterBody2D

var total_life := 10
var current_life := 10

var resting := false
var moving := false
var minimum_rest_chance := 1
var rng_rest := RandomNumberGenerator.new()
var rng_paths := RandomNumberGenerator.new()

var last_room: Node
var target_room: Node
var time := 0.0 # Time used in movement interpolation

signal entered_room
signal left_room

@onready var right_detector = $right_path_detector
@onready var down_detector = $down_path_detector

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving: return
	
	var possible_moves = []
	
	if right_detector.is_colliding():
		possible_moves.append(right_detector.get_collider())
	
	if down_detector.is_colliding():
		possible_moves.append(down_detector.get_collider())
	
	if len(possible_moves) > 0:
		target_room = possible_moves.pick_random()
		moving = true

	
func _physics_process(delta):
	if not moving: return
	
	velocity = target_room.position - position
	move_and_slide()
	 

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
	
<<<<<<< HEAD
	if area.name == "core_room":
		has_arrived_to_the_core = true
		next_path = null
		print("Game-Over")
	
	if adventurer_life > 0 and has_arrived_to_the_core == false:
		if area.paths_dict["right"] == true:
			possible_paths.append("right")
		if area.paths_dict["down"] == true:
			possible_paths.append("down")
			
		var path_choise := rng_paths.randi_range(1, possible_paths.size())
		print(path_choise)
		print(possible_paths)
		next_path = possible_paths[path_choise-1]
	elif adventurer_life <= 0:
		queue_free()
=======
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
>>>>>>> b5b0dded4279b3c0fce335217cd22563d758f1ee
			
