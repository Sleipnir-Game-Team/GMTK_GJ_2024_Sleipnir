extends Node

var alarm_is_active := false

static var _score := 0
static var _high_score := 0

static var high_score : int:
	get:
		return _high_score
	set(value):
		_high_score = value
		print('New High Score: %s' % _high_score)

static var score: int:
	get:
		return _score
	set(value):
		_score = max(value, 0)
		high_score = max(_score, high_score)
