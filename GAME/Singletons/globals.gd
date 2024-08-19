extends Node

var alarm_is_active := false

static var souls := 0:
	set(value):
		souls = max(value, 0) 

static var high_score := 0 :
	set(value):
		high_score = value
		print('New High Score: %s' % high_score)

static var score := 0:
	set(value):
		score = max(value, 0)
		high_score = max(score, high_score)
