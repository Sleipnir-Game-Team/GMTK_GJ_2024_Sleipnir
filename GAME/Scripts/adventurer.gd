extends CharacterBody2D

class_name Adventurer

const LightsOutScene = preload('res://Prefabs/RoomEvents/lights_out.tscn')

var current_life := 10

var last_room: Node
var target_room: Node
var target_position: Vector2

var rng_event := RandomNumberGenerator.new()
var minimum_event_chance := 50

signal entered_room(adventurer, room)
signal left_room(adventurer, room)

signal damage(amount)
signal heal(amount)


@export var total_life := 10
@export var speed := 45
@export var points_worth := 15

@onready var animation_handler := $AnimatedSprite2D as AnimatedSprite2D

@onready var right_detector := $right_path_detector as RayCast2D
@onready var down_detector := $down_path_detector as RayCast2D


# Called when the node enters the scene tree for the first time.
func _ready():
	entered_room.connect(_handle_enter_event)
	left_room.connect(_handle_leave_event)

func _physics_process(_delta):
	if target_room and position.distance_to(target_position) < 1:
		stop_moving()
	
	move_and_slide()


func move_in_direction(direction: Vector2):
	velocity = direction * speed

func stop_moving():
	velocity = Vector2(0,0)

func _find_possible_moves():
	var possible_moves = []
	
	if right_detector.is_colliding():
		possible_moves.append(right_detector.get_collider())
			
	if down_detector.is_colliding():
		possible_moves.append(down_detector.get_collider())
		#if down_detector.get_collider().is_end == true and !Globals.alarm_is_active:
			#Globals.alarm_is_active = true
			#AudioManager.play_sfx(sfx_proximity)
		#else:
			#AudioManager.stop_sfx(sfx_proximity)
	
	if len(possible_moves) > 0:
		target_room = possible_moves.pick_random()
		target_position = target_room.position
		Logger.debug("Se movendo para a %s (%s)" % [target_room.name, target_position])
		var target_direction = (target_position - position).normalized()
		
		move_in_direction(target_direction)
	else:
		# TODO teoricamente (tudo dando certo) isso daqui significa que chegou na última sala
		pass

## Play death animation, add to score and delete node
func die():
	stop_moving()
	
	animation_handler.play('death')
	animation_handler.animation_finished.connect(queue_free)
	
	Globals.alarm_is_active = false
	Globals.score += points_worth

func _on_damage(amount: Variant) -> void:
	current_life -= amount
	print('[DAMAGING] Adventurer health: %s/%s' % [current_life, total_life])
	if current_life <= 0:
		call_deferred('die')

func _on_heal(amount: Variant) -> void:
	current_life = min(current_life + amount, total_life)
	print('[HEALING] Adventurer health: %s/%s' % [current_life, total_life])


func _handle_enter_event(_adventurer, room):
	# If last_room is not defined, the Adventurer has just been created and is in spawn
	if not last_room:
		last_room = room
		# Since this is spawn, we can immediatly look for a new target room to move towards
		_find_possible_moves()
	# This is not the spawn room, and it has an event
	elif room._active_event:
		# Wait till the event is over and then find a new target!
		room._active_event.finish.connect(_find_possible_moves.unbind(1), ConnectFlags.CONNECT_ONE_SHOT)
	# This is an empty room
	else:
		var event_chance := rng_event.randi_range(0, 99)
		
		if event_chance <= minimum_event_chance:
			# Add a temporary rest event to the room
			var event = LightsOutScene.instantiate()
			event.add_adventurer(self)
			event.finish.connect(_find_possible_moves.unbind(1), ConnectFlags.CONNECT_ONE_SHOT) # Trigger movement once it's over
			room.add_temporary_event(event)
		else:
			Logger.debug("Vai DESGRAÇA")
			_find_possible_moves()

func _handle_leave_event(_adventurer, room):
	last_room = room
