extends TextureButton

@export var itemType:int

func _on_pressed():
	UI_Controller.buyItem(itemType)
