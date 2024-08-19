class_name BaseTargeted

extends Useable

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed('apply_potion'):
		var space_state = get_world_2d().direct_space_state
		var query = _get_query()
		var result = space_state.intersect_point(query)
		
		_handle_selection(result)


## SHOULD BE OVERRIDEN
func _handle_selection(selected: Array[Dictionary]):
	pass


## SHOULD BE OVERRIDEN
func _get_query() -> PhysicsPointQueryParameters2D:
	return
