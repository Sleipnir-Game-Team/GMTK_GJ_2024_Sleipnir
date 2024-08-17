extends Area2D

var adventurer_life := 10
var adventurer_is_resing := false 
var minimum_rest_chance := 1
var rng_rest := RandomNumberGenerator.new()
var rng_paths := RandomNumberGenerator.new()
var possible_paths := []
var has_arrived_to_the_core := false

var next_path

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_entered(area):
	possible_paths.clear()
	if area.name == "room":
		if area.has_trap == true:
			adventurer_life -= 1
		else:
			var rest_chance := rng_rest.randf_range(minimum_rest_chance, 100)
			if rest_chance == 100 or minimum_rest_chance >= 100:
				minimum_rest_chance = 1
			else:
				minimum_rest_chance += 5
	
	if area.name == "core_room":
		has_arrived_to_the_core = true
		next_path = null
		print("Game-Over")
	
	if adventurer_life > 0 and has_arrived_to_the_core == false:
		if area.paths_dict["left"] == true:
			possible_paths.append("left")
		if area.paths_dict["right"] == true:
			possible_paths.append("right")
		if area.paths_dict["up"] == true:
			possible_paths.append("up")
		if area.paths_dict["down"] == true:
			possible_paths.append("down")
			
		var path_choise := rng_paths.randi_range(1, possible_paths.size())
		next_path = possible_paths[path_choise - 1]
			
