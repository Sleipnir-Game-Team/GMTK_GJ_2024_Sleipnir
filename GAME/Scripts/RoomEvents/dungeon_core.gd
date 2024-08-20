extends Event

@onready var risk_range := $risk_range as Area2D
@onready var alarm_range := $alarm_range as Area2D
@onready var sfx_proximity := $sfx as SoundQueue

func _enter_tree() -> void:
	if not SleipnirMaestro.current_song == 'MusicaDungeon':
		SleipnirMaestro.change_song("MusicaDungeon")
		SleipnirMaestro.play()

func _ready() -> void:
	super()


func _activate_events():
	return [UI_Controller.gameOver]


func _on_expand_clicked():
	RoomGenerator.expand()
	SleipnirMaestro.toggle_layer_off(2)


func _on_risk_range_body_entered(body: Node2D) -> void:
	SleipnirMaestro.toggle_layer_on(2)

func _on_risk_range_body_exited(body: Node2D) -> void:
	SleipnirMaestro.toggle_layer_off(2)


func _on_alarm_range_body_entered(body: Node2D) -> void:
	if not Globals.alarm_is_active:
		Globals.alarm_is_active = true
		SleipnirMaestro.trigger("alarme placeholder")
		SleipnirMaestro.toggle_layer_on(2)

func _on_alarm_range_body_exited(body: Node2D) -> void:
	if Globals.alarm_is_active and not alarm_range.has_overlapping_bodies():
		Globals.alarm_is_active = false

func get_dangerous():
	pass
