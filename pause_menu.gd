extends Node2D
class_name PauseMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.z_index = -GameConstants.MENU_Z_INDEX
	self.visible = false
	$ColorRect.color = GameConstants.BLOOD_RED
	$ResumeGameButton.on_click = _on_resume_game_click


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_pause_input()
			
func handle_pause_input() -> void:
	if not Input.is_action_just_pressed("pause"):
		return
			
	if GameStateManager.isPausable():
		_show()
		return
		
	if GameStateManager.isPaused():
		_hide()
		return


func _hide() -> void:
	self.z_index = -GameConstants.MENU_Z_INDEX
	self.visible = false
	GameStateManager.resume()
	
func _show() -> void:
	self.z_index = GameConstants.MENU_Z_INDEX
	self.visible = true
	GameStateManager.pause()
	
func _on_resume_game_click() -> void:
	_hide()
