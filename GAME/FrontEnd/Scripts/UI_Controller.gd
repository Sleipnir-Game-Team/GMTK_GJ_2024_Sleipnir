extends Node


func manageScreen(screen_path, parent, action):
	var newScreen = UI_Displayer.displayScreen(screen_path)
	match action:
		"open":
			UI_Displayer.openScreen(newScreen, parent)
		"change":
			UI_Displayer.freeScreen()
			UI_Displayer.openScreen(newScreen, parent)
		"free":
			UI_Displayer.freeScreen()
	
