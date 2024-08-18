extends Control

func _ready():
	UI_Displayer.oldScreen = self

func _on_button_play_pressed():
	UI_Controller.manageScreen("res://Levels/test.tscn", get_tree().root, "change")


func _on_button_options_pressed():
	UI_Controller.manageScreen("res://FrontEnd/Prefabs/Screen_OptionsMenu.tscn", get_tree().root, "open")


func _on_button_quit_pressed():
	get_tree().quit()
