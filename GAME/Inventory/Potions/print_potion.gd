extends Potion

func _ready() -> void:
	super()

func _process(_delta: float) -> void:
	print('[PRINTPOTION] FUNCIONA FUNCIONA')

func _affect(affected: Array[CollisionObject2D]):
	print('[PRINTPOTION] FOI CHAMADO! FOI CHAMADO!')
	for target in affected:
		print('[PRINTPOTION] ATINGIU ESSA PORRA AQUI OLHA: ', target)
