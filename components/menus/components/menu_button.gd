extends Node2D
class_name NewGameButton


@onready var button := $Button
@onready var animation_player := $AnimationPlayer

@export var on_click : Callable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.pause()
	button.connect('mouse_entered', _on_button_focus_entered)
	button.connect('mouse_exited', _on_button_focus_exited)
	button.connect('pressed', _on_click)


func _on_button_focus_entered() -> void:
	animation_player.play("pulse")

func _on_button_focus_exited() -> void:
	animation_player.pause()
	
func _on_click() -> void:
	if not on_click.is_valid():
		return
		
	on_click.call()
