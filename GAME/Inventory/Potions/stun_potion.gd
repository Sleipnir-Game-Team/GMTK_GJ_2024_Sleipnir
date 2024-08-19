extends Potion

func _affect(affected: Array[CollisionObject2D]):
	for target in affected:
		target.stun()
	queue_free()
		
