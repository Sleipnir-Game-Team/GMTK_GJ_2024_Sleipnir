extends Potion

func _affect(affected: Array[CollisionObject2D]):
	Logger.debug("Dano Aumentado")
	for target in affected:
		if target._long_lasting_event != null:
			target._long_lasting_event.get_dangerous()
	queue_free()
