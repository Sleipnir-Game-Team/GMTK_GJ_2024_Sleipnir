extends Control


func _on_button_play_pressed():
	pass # Replace with function body.


func _on_button_options_pressed():
	pass
	#UI_Controller.manageScreen("res://FrontEnd/Prefabs/Screen_OptionsMenu.tscn", get_tree().root, "open")


func _on_button_back_pressed():
	UI_Controller.manageScreen(null, null, "free")
