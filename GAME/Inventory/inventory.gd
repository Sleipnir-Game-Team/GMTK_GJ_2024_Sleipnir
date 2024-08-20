extends Resource

class_name Inventory

@export var max_size := 9
@export var items: Array[Item] = []


func _init() -> void:
	items.resize(max_size)


func add_item(item: Item) -> void:
	var position = items.find(null)
	if position != -1:
		items[position] = item
		changed.emit(items)

func remove_item(position: int):
	items[position] = null
	changed.emit(items)

func get_item(position: int):
	return items[position]


func has_space():
	return items.has(null)
