extends Resource

class_name Inventory

@export var items: Array[Item] = []

func add_item(item: Item):
	if items.size() < 4:
		items.append(item)
		changed.emit(items, items.size())

func get_item(position: int):
	return items.pop_at(position)
