extends Control


func _on_button_retry_pressed():
	UI_Controller.manageScreen("res://Levels/test.tscn", get_tree().root, "change")


func _on_button_main_menu_pressed():
	UI_Controller.manageScreen("res://FrontEnd/Prefabs/Screen_MainMenu.tscn", get_tree().root, "change")


func _on_button_quit_pressed():
	get_tree().quit()
