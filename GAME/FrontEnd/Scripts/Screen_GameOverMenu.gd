extends Control

func _ready():
	SleipnirMaestro.stop()
	SleipnirMaestro.change_song("GameOver")
	SleipnirMaestro.play()
	$player_Score.text = str(Globals.score)
	$player_highScore.text = str(Globals.high_score)


func _on_button_retry_pressed():
	UI_Controller.manageScreen("res://Levels/dungeon.tscn", get_tree().root, "change")


func _on_button_main_menu_pressed():
	SfxGlobals.play_global('ButtonClick')
	UI_Controller.manageScreen("res://FrontEnd/Prefabs/Screen_MainMenu.tscn", get_tree().root, "change")


func _on_button_quit_pressed():
	SfxGlobals.play_global('ButtonClick')
	get_tree().quit()


func _on_button_retry_mouse_entered() -> void:
	SfxGlobals.play_global('ButtonHover')


func _on_button_main_menu_mouse_entered() -> void:
	SfxGlobals.play_global('ButtonHover')
