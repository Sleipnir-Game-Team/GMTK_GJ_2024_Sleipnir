extends CanvasLayer

@onready var hotBar = $Control/HotBar 

func _ready():
	UI_Controller.show_HUD.connect(showHUD)
	UI_Controller.occult_HUD.connect(occultHUD)
	UI_Controller.update_HotBar.connect(updateHotBar)
	Globals.score_changed.connect(updateScore)
	updateScore(Globals.score)
	UI_Controller.syncSouls($Control/Player_Points/Label)

func updateHotBar(items):
	var slots = hotBar.get_children()
	for index in range(len(items)):
		slots[index].texture = items[index].texture if items[index] else null

func updateScore(score):
	$Control/player_Score.text = str(score)

func showHUD():
	self.visible = true
	UI_Controller.syncSouls($Control/Player_Points/Label)


func occultHUD():
	self.visible = false
