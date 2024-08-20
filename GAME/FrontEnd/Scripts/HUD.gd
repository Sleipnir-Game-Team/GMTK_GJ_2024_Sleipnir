extends CanvasLayer

@onready var hotBar = $Control/HotBar 

func _ready():
	UI_Controller.show_HUD.connect(showHUD)
	UI_Controller.occult_HUD.connect(occultHUD)
	UI_Controller.syncSouls($Control/Player_Points/Label)

func updateHotBar(itens):
	var cont = 0
	for item in itens:
		if item != null:
			hotBar.get_child(cont).texture = item.texture
		else:
			hotBar.get_child(cont).texture = null

func showHUD():
	self.visible = true


func occultHUD():
	self.visible = false
