class_name BaseAOE

extends Useable


@export var sprite: Sprite2D
@export var area: Area2D

func _unhandled_input(event: InputEvent) -> void:
	if not using: return
	
	if event.is_action_pressed('apply_potion'):
		var affected: Array[CollisionObject2D] = []
		
		if area.has_overlapping_areas():
			affected.append_array(area.get_overlapping_areas())
			
		if area.has_overlapping_bodies():
			affected.append_array(area.get_overlapping_bodies())
		
		_affect(affected)
	
	elif event.is_action_pressed('cancel_potion'):
		_cancel()
	
	elif event is InputEventMouseMotion:
		sprite.global_position = get_global_mouse_position()
		area.global_position = get_global_mouse_position()


func set_using(using: bool) -> void:
	sprite.visible = using
	super(using)


func _affect(affected: Array[CollisionObject2D]):
	pass
