extends BaseAOE

func _affect(affected: Array[CollisionObject2D]):
	for target in affected:
		print('[PRINTPOTION] ATINGIU ESSA PORRA AQUI OLHA: ', target)
	# After applying the effect, delete self
	queue_free()
