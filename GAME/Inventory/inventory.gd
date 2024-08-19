extends Resource

class_name Inventory

@export var items: Array[Item] = []

func add_item(item: Item) -> void:
	
	if items.size() < 4:
		print('Inventory Appending: %s' % item)
		items.append(item)
		changed.emit(items, items.size())

func get_item(position: int) -> Item:
	return items.pop_at(position)
