extends CanvasLayer

@onready var hotBar = $Control/HotBar 

func _ready():
	UI_Controller.show_HUD.connect(showHUD)
	UI_Controller.occult_HUD.connect(occultHUD)
	UI_Controller.update_HotBar.connect(updateHotBar)
	UI_Controller.syncSouls($Control/Player_Points/Label)

func updateHotBar(items):
	var slots = hotBar.get_children()
	for index in range(len(items)):
		slots[index].texture = items[index].texture if items[index] else null

func showHUD():
	self.visible = true


func occultHUD():
	self.visible = false
