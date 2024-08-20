class_name InfoEvent
extends Event

@export var title: String
@export var info_text: String

@onready var TitleLabel := $TitleLabel as Label
@onready var BodyLabel := $BodyLabel as Label
@onready var InfoPanel := $ColorRect as ColorRect


func _ready() -> void:
	TitleLabel.text = title
	BodyLabel.text = info_text


func _on_area_2d_mouse_entered() -> void:
	TitleLabel.visible = true
	BodyLabel.visible = true
	InfoPanel.visible = true

func _on_area_2d_mouse_exited() -> void:
	TitleLabel.visible = false
	BodyLabel.visible = false
	InfoPanel.visible = false
