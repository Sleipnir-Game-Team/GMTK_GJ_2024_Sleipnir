extends Event

@export var expand_sfx: SoundQueue

@onready var risk_range := $risk_range as Area2D
@onready var alarm_range := $alarm_range as Area2D

func _enter_tree() -> void:
	SfxGlobals.play_global('AmbienciaDungeon')
	
	if not SleipnirMaestro.current_song == 'MusicaDungeon':
		SleipnirMaestro.stop()
		SleipnirMaestro.change_song("MusicaDungeon")
		SleipnirMaestro.play()

func _ready() -> void:
	super()


func _activate_events():
	return [UI_Controller.gameOver]


func _on_expand_clicked():
	AudioManager.play_sfx(expand_sfx)
	
	RoomGenerator.expand()
	
	if SleipnirMaestro.current_song == 'MusicaDungeon':
		SleipnirMaestro.toggle_layer_off(2)


func _on_risk_range_body_entered(body: Node2D) -> void:
	SleipnirMaestro.toggle_layer_on(2)

func _on_risk_range_body_exited(body: Node2D) -> void:
	if SleipnirMaestro.current_song == 'MusicaDungeon':
		SleipnirMaestro.toggle_layer_off(2)


func _on_alarm_range_body_entered(body: Node2D) -> void:
	if not Globals.alarm_is_active:
		Globals.alarm_is_active = true
		SleipnirMaestro.trigger("Alarme")
		SleipnirMaestro.toggle_layer_on(2)

func _on_alarm_range_body_exited(body: Node2D) -> void:
	if Globals.alarm_is_active and not alarm_range.has_overlapping_bodies():
		Globals.alarm_is_active = false

func get_dangerous():
	pass


func _on_disable_expasion():
	Logger.debug("Expansion disabled")
	$ExpandButton/CollisionShape2D.disabled = true
	$ExpandButton/expand_sprite.modulate = Color.hex(0xfffffff51)
	$Cooldown.timeout.connect(get_parent().enable_expasion.emit)
	$Cooldown.start()
	


func _on_enable_expasion():
	Logger.debug("Expansion disabled")
	$ExpandButton/CollisionShape2D.disabled = false
	$ExpandButton/expand_sprite.modulate = Color.hex(0xffffffff)
