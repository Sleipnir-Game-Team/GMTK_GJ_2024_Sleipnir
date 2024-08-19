extends Control

signal buyItem

func _ready():
	currencyEditor("100")

func _on_button_buy_item_1_pressed():
	buyItem.emit("1")


func _on_button_buy_item_2_pressed():
	buyItem.emit("2")


func _on_button_buy_item_3_pressed():
	buyItem.emit("3")


func _on_button_buy_item_4_pressed():
	buyItem.emit("4")


func _on_button_buy_item_5_pressed():
	buyItem.emit("5")


func _on_button_buy_item_6_pressed():
	buyItem.emit("6")


func currencyEditor(points):
	$CanvasLayer/Player_Points/Player_Points.text = points
