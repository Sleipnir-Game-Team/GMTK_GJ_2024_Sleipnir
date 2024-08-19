extends Node

var room_sprite_value := 0
var sprite
var rotation_value

func room_sprites_management(detectors):
	if detectors["up"]:
		room_sprite_value += 1
	if detectors["left"]:
		room_sprite_value += 2
	if detectors["down"]:
		room_sprite_value += 4
	if detectors["right"]:
		room_sprite_value += 8
	
	match room_sprite_value:
		1:
			sprite = "res://Assets/Level/Enviroment/Arte/Enviroment V1/Sala 3.jpg"
			rotation_value = 0.0
		2:
			sprite = "res://Assets/Level/Enviroment/Arte/Enviroment V1/Sala 3.jpg"
			rotation_value = -90.0
		3:
			sprite = "res://Assets/Level/Enviroment/Arte/Enviroment V1/Sala 2.jpg"
			rotation_value = -90.0
		4:
			sprite = "res://Assets/Level/Enviroment/Arte/Enviroment V1/Sala 3.jpg"
			rotation_value = 180.0
		5:
			sprite = "res://Assets/Level/Enviroment/Arte/Enviroment V1/Sala 1.jpg"
			rotation_value = 0.0
		6:
			sprite = "res://Assets/Level/Enviroment/Arte/Enviroment V1/Sala 2.jpg"
			rotation_value = 180.0
		7:
			sprite = "res://Assets/Level/Enviroment/Arte/Enviroment V1/Sala 5.jpg"
			rotation_value = 90.0
		8:
			sprite = "res://Assets/Level/Enviroment/Arte/Enviroment V1/Sala 3.jpg"
			rotation_value = 90.0
		9:
			sprite = "res://Assets/Level/Enviroment/Arte/Enviroment V1/Sala 2.jpg"
			rotation_value = 0.0
		10:
			sprite = "res://Assets/Level/Enviroment/Arte/Enviroment V1/Sala 1.jpg"
			rotation_value = 90.0
		11:
			sprite = "res://Assets/Level/Enviroment/Arte/Enviroment V1/Sala 5.jpg"
			rotation_value = 180.0
		12:
			sprite = "res://Assets/Level/Enviroment/Arte/Enviroment V1/Sala 2.jpg"
			rotation_value = 90.0
		13:
			sprite = "res://Assets/Level/Enviroment/Arte/Enviroment V1/Sala 5.jpg"
			rotation_value = -90.0
		14:
			sprite = "res://Assets/Level/Enviroment/Arte/Enviroment V1/Sala 5.jpg"
			rotation_value = 0.0
		15:
			sprite = "res://Assets/Level/Enviroment/Arte/Enviroment V1/Sala 4.jpg"
			rotation_value = 0.0
