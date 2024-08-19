extends Event

@onready var alarm_range := $alarm_range as Area2D
@onready var sfx_proximity := $sfx as SoundQueue

func _ready() -> void:
	SleipnirMaestro.change_song("MusicaDungeon")
	SleipnirMaestro.play()
	super()

func _activate_events():
	return [UI_Controller.gameOver]

func _on_expand_clicked():
	RoomGenerator.expand()

func _on_alarm_range_body_entered(body: Node2D) -> void:
	if not Globals.alarm_is_active:
		print('inside')
		Globals.alarm_is_active = true
		SleipnirMaestro.trigger("alarme placeholder")
		SleipnirMaestro.toggle_layer(2)

func _on_alarm_range_body_exited(body: Node2D) -> void:
	if Globals.alarm_is_active and not alarm_range.has_overlapping_bodies():
		Globals.alarm_is_active = false
		SleipnirMaestro.toggle_layer(2)
