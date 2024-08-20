extends Control


func _ready():
	get_tree().get_first_node_in_group("Camera").get_child(0).set_dragging(false)
	UI_Controller.syncSouls($CanvasLayer/Player_Points/Label)
	

func _on_button_back_pressed():
	get_tree().get_first_node_in_group("Camera").get_child(0).set_dragging(true)
	UI_Controller.desyncSouls()
	UI_Controller.manageScreen(null, null, "free")
	UI_Controller.showHUD()
	
