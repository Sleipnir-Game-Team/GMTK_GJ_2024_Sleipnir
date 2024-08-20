extends Node

signal buy_Item
signal show_HUD
signal occult_HUD
signal update_HotBar(items: Array[Item])
signal update_Score

signal cutsceneNext
signal updateCutsceneImg
signal updateCutsceneTxt

func _process(_delta):
	#if Input.is_action_just_pressed("Increase_Souls"):
		#Globals.souls += 1
		#print(Globals.souls)
	#if Input.is_action_just_pressed("Decrease_Souls"):
		#Globals.souls -= 1
		#print(Globals.souls)
	if Input.is_action_just_pressed("Open_Store"):
		manageScreen("res://FrontEnd/Prefabs/Screen_Store.tscn", get_tree().root, "open")
		occultHUD()
	

func manageScreen(screen_path, parent, action):
	var newScreen
	if screen_path != null:
		newScreen = UI_Displayer.displayScreen(screen_path)
	match action:
		"open":
			UI_Displayer.openScreen(newScreen, parent)
		"change":
			while UI_Displayer.screens != []:
				UI_Displayer.freeScreen()
			UI_Displayer.openScreen(newScreen, parent)
		"free":
			UI_Displayer.freeScreen()


func gameOver():
	manageScreen("res://FrontEnd/Prefabs/Screen_GameOverMenu.tscn", get_tree().root, "change")


func buyItem(item):
	buy_Item.emit(item)


func syncSouls(label):
	UI_Displayer.syncSouls(label)

func desyncSouls():
	Globals.souls_changed.disconnect(UI_Displayer.on_souls_changed)


func showHUD():
	show_HUD.emit()

func occultHUD():
	occult_HUD.emit()

func updateHotbar(items: Array[Item]):
	update_HotBar.emit(items)
	
#func updateScore(score):
	#update_Score.emit(score)

func startCutscene():
	cutsceneNext.emit()
	

func processAction(action):
	match action.type:
		"img":
			updateCutsceneImg.emit(action.url)
			cutsceneNext.emit()
		"txt":
			print(action.text)
			updateCutsceneTxt.emit(action.text)
			cutsceneNext.emit()
		"wait":
			pass
		"end":
			manageScreen("res://Levels/Dungeon.tscn", get_tree().root, "change")
