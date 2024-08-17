extends Area2D

var paths_dict := {"right" = false, "left" = false, "up" = false, "down" = false}

@onready var down_detector := $down_path_detector as RayCast2D
@onready var right_detector := $right_path_detector as RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func detect_path():
	if down_detector.is_colliding():
		paths_dict["down"] = true
	if right_detector.is_colliding():
		paths_dict["right"] = true

func _on_area_entered(area):
	detect_path()
