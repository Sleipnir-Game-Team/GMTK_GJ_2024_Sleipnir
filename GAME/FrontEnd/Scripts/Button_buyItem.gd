extends TextureButton

@export var item : Item

func _on_pressed():
	UI_Controller.buyItem(item)
