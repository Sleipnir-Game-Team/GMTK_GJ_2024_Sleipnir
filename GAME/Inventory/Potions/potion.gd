class_name Potion

extends Useable

var using := false

@export var area: Area2D

func _ready() -> void:
	super()

func _input(event: InputEvent) -> void:
	print('[POTION] INPUT HAPPENED')
	if not using: return
	
	print('[POTION] CERTAINLY USING')
	
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var affected: Array[CollisionObject2D] = []
			
			if area.has_overlapping_areas():
				affected.append_array(area.get_overlapping_areas())
			if area.has_overlapping_bodies():
				affected.append_array(area.get_overlapping_bodies())
			_affect(affected)
			
	elif event is InputEventMouseMotion:
		area.position = event.position

func _affect(affected: Array[CollisionObject2D]):
	pass

func _trigger() -> void:
	print('[POTION] TRIGGER')
	using = true
