extends BaseAOE

func _affect(affected: Array[CollisionObject2D]):
	for target in affected:
		target.stun()
	finish()
