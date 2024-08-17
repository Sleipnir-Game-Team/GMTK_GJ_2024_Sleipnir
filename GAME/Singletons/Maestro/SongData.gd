@tool
class_name SongData
extends Resource

@export var default_first_section : String = "ambient"
@export_enum("Immediate", "Next Beat", "Next Bar", "End")\
 var default_track_transition: int = 0
@export var fade_beats : int = 0
@export var fade_mode : int = 0
@export var BPM : int
@export var MainClips : Resource
@export var TriggerClips : Array[Resource]:
	get:
		return TriggerClips
	set(value):
		TriggerClips = value
		if value != null:
			has_trigger_clips = true
		else:
			has_trigger_clips = false


var has_trigger_clips : bool = false

func get_main_clips():
	return MainClips

func get_trigger_clips():
	return TriggerClips

func get_first_section():
	return default_first_section

func get_track_transition():
	return default_track_transition

func get_fade_mode():
	return fade_mode

func get_fade_beats():
	return fade_beats
