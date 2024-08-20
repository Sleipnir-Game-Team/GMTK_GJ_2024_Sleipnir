extends BaseTargeted


var query := PhysicsPointQueryParameters2D.new()

func _ready():
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = 0b100010 # 6 - Clickable Adventurers and 2 - Rooms

func _handle_selection(selected: Array[Dictionary]):
	if len(selected) > 0:
		for entry in selected:
			print('[PRINTPOWER] CLICKOU NESSE BAGULHO: ', entry.collider)
	else:
		print('[PRINTPOWER] CLICOU FORA MANÉ')
	
	finish()


func _get_query() -> PhysicsPointQueryParameters2D:
	query.position = get_global_mouse_position()
	return query
