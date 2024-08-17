extends Area2D


enum Type {BOTTOM, BOTTOM_L, BOTTOM_R};

const possible_traps := ["acid", "spikes", "lava"]
const path_instance := preload("res://Prefabs/paths.tscn")

var active := false
var has_trap := false
var rng_trap := RandomNumberGenerator.new()
var paths_dict := {"right" = false, "down" = false}

var trap_kind

@onready var collision_shape := $CollisionShape2D

@onready var down_detector := $down_path_detector as RayCast2D
@onready var right_detector := $right_path_detector as RayCast2D

@onready var down_spawn := $down_path_spawn as Marker2D
@onready var right_spawn := $right_path_spawn as Marker2D

# Called when the node enters the scene tree for the first time.
func _ready():
	set_trap()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_area_entered(area):
	pass
	
func trigger():
	active = true
	
	# Called to start minigame in this room

# SETUP FUNCTIONS
func set_trap():
	var is_trap_number := rng_trap.randf_range(0, 10.0)
	if is_trap_number >= 5:
		has_trap = true
		trap_kind = possible_traps.pick_random()

## Checks if there are adjacent rooms and spawns corresponding paths
func update_paths():
	_detect_adjacent_rooms()
	_spawn_paths()


func _detect_adjacent_rooms():
	paths_dict["down"] = down_detector.is_colliding()
	paths_dict["right"] = right_detector.is_colliding()
		
func _spawn_paths():
	if paths_dict["down"]:
		var path = path_instance.instantiate()
		path.position = down_spawn.position
		path.rotate(PI/2)
		add_child(path)
		
	if paths_dict["right"]:
		var path = path_instance.instantiate()
		path.position = right_spawn.position
		add_child(path)
