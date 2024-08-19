extends Node

var alarm_is_active := false

signal souls_changed(new_value)
signal high_score_changed(new_value)
signal score_changed(new_value)

var souls := 0:
	set(value):
		souls = max(value, 0) 
		souls_changed.emit(souls)

var high_score := 0 :
	set(value):
		high_score = value
		print('New High Score: %s' % high_score)
		high_score_changed.emit(high_score)

var score := 0:
	set(value):
		score = max(value, 0)
		high_score = max(score, high_score)
		score_changed.emit(score)
