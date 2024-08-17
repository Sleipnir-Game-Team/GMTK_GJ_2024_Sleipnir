extends Area2D

const possible_traps := ["acid", "spikes", "lava"]
const path_instance := preload("res://Prefabs/paths.tscn")

var has_trap := false
var rng_trap := RandomNumberGenerator.new()
var paths_dict := {"right" = false, "left" = false, "up" = false, "down" = false}

var trap_kind

@onready var up_detector := $up_path_detector as RayCast2D
@onready var down_detector := $down_path_detector as RayCast2D
@onready var left_detector := $left_path_detector as RayCast2D
@onready var right_detector := $right_path_detector as RayCast2D

@onready var up_spawn := $up_path_spawn as Marker2D
@onready var down_spawn := $down_path_spawn as Marker2D
@onready var left_spawn := $left_path_spawn as Marker2D
@onready var right_spawn := $right_path_spawn as Marker2D

# Called when the node enters the scene tree for the first time.
func _ready():
	set_trap()
	add_to_group("rooms")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_trap():
	var is_trap_number := rng_trap.randf_range(0, 10.0)
	if is_trap_number >= 5:
		has_trap = true
		trap_kind = possible_traps.pick_random()
		
func detect_path():
	if up_detector.is_colliding():
		paths_dict["up"] = true
	if down_detector.is_colliding():
		paths_dict["down"] = true
	if left_detector.is_colliding():
		paths_dict["left"] = true
	if right_detector.is_colliding():
		paths_dict["right"] = true

func _on_area_entered(area):
	detect_path()
	
func spawn_path():
	if paths_dict["down"] == false:
		var path = path_instance.instantiate()
		get_parent().call_deferred("add_child", path)
		path.global_position = down_spawn.global_position
	if paths_dict["right"] == false:
		var path = path_instance.instantiate()
		get_parent().call_deferred("add_child", path)
		path.global_position = right_spawn.global_position
