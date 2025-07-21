extends Node

enum GameState {
	START_MENU,
	PLAYING,
	PAUSED,
	GAME_OVER
}

signal game_state_changed(new_state: GameState)

var state := GameState.START_MENU

func pause() -> void:
	state = GameState.PAUSED
	
func resume() -> void: 
	state = GameState.PLAYING

func start() -> void:
	state = GameState.PLAYING
