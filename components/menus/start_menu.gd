extends Node2D

@onready var new_game_button := $NewGameButton
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = true
	new_game_button.on_click = _on_new_game_click

func _on_new_game_click() -> void:
	self.z_index = -GameConstants.MENU_Z_INDEX
	self.visible = false
	GameStateManager.start()
