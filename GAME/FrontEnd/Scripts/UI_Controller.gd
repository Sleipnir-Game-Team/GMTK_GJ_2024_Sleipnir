extends Node

func _process(_delta):
	if Input.is_action_just_pressed("Game_Over"):
		gameOver()

func manageScreen(screen_path, parent, action):
	var newScreen
	if screen_path != null:
		newScreen = UI_Displayer.displayScreen(screen_path)
	match action:
		"open":
			UI_Displayer.openScreen(newScreen, parent)
		"change":
			UI_Displayer.freeScreen()
			UI_Displayer.openScreen(newScreen, parent)
		"free":
			UI_Displayer.freeScreen()
	

func gameOver():
	#pause()
	manageScreen("res://FrontEnd/Prefabs/Screen_GameOverMenu.tscn", get_tree().root, "change")
