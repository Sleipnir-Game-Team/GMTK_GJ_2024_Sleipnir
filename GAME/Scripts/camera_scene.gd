extends CharacterBody2D

var dragging = false

var limit_left = 450
var limit_right = 700
var limit_up = 450
var limit_down = 700

var move_limit_x = 0.2
var move_limit_y = 0.2

func _ready() -> void:
	set_process_input(true)
	
func _process(delta: float) -> void:
	var mousePositionX = get_viewport().get_mouse_position().x/get_viewport().size.x
	var mousePositionY = get_viewport().get_mouse_position().y/get_viewport().size.y
	
	var movement = Vector2.ZERO
	if mousePositionX < move_limit_x:
		movement.x = (mousePositionX - move_limit_x) * 100
	elif mousePositionX > 1 - move_limit_x:

		movement.x = (mousePositionX -  (1 - move_limit_x)) *100
	if mousePositionY < move_limit_y:
		movement.y = (mousePositionY - move_limit_y) * 100
	elif mousePositionY > 1 - move_limit_y:
		movement.y = (mousePositionY - (1 - move_limit_x)) *100
	
	var predict = movement + position

	if predict.x < limit_left or predict.x > limit_right:
		if position.x < limit_left:
			predict.x = limit_left
		elif position.x > limit_right:
			predict.x = limit_right
		else:
			predict.x = position.x
	if predict.y < limit_up or predict.y > limit_right:
		if position.y < limit_left:
			predict.y = limit_left
		elif position.y > limit_right:
			predict.y = limit_right
		else:
			predict.y = position.y
	position = predict

func expand(size):
	limit_right += size
	limit_down += size
#func _input(event):
	#if event is InputEventMouseMotion:
		
		
		#if event.is_pressed():
			#dragging = true
		#else:
			#dragging = false
	
	#if event is InputEventMouseMotion:
		#var movement = position + event.relative
		#print(movement)
		#if movement.x < limit_left or movement.x > limit_right:
			#movement.x = position.x
		#if movement.y < limit_up or movement.y > limit_right:
			#movement.y = position.y
		#position = movement
