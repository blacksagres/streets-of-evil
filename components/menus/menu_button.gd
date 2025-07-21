extends Node2D


@onready var button := $Button
@onready var animation_player := $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.pause()
	button.connect('mouse_entered', on_button_focus_entered)
	button.connect('mouse_exited', on_button_focus_exited)


func on_button_focus_entered() -> void:
	animation_player.play("pulse")

func on_button_focus_exited() -> void:
	animation_player.pause()
