extends Control

func _ready():
	UI_Displayer.screens.append(self)
	get_viewport().size = DisplayServer.screen_get_size()
	$CanvasLayer/AnimationPlayer.play("Flickering")
	#SleipnirMaestro.change_song("menu")
	#SleipnirMaestro.play()

func _on_button_play_pressed():
	UI_Controller.manageScreen("res://FrontEnd/Prefabs/Screen_Cutscene.tscn", get_tree().root, "change")


func _on_button_options_pressed():
	UI_Controller.manageScreen("res://FrontEnd/Prefabs/Screen_OptionsMenu.tscn", get_tree().root, "open")


func _on_button_quit_pressed():
	get_tree().quit()


func _on_button_options_mouse_entered():
	get_tree().get_nodes_in_group("Ilumination")[1].modulate.a = 1


func _on_button_options_mouse_exited():
	get_tree().get_nodes_in_group("Ilumination")[1].modulate.a = 0.5


func _on_button_play_mouse_entered():
	get_tree().get_nodes_in_group("Ilumination")[0].modulate.a = 1


func _on_button_play_mouse_exited():
	get_tree().get_nodes_in_group("Ilumination")[0].modulate.a = 0.5


func _on_button_quit_mouse_entered():
	get_tree().get_nodes_in_group("Ilumination")[2].modulate.a = 1


func _on_button_quit_mouse_exited():
	get_tree().get_nodes_in_group("Ilumination")[2].modulate.a = 0.5
