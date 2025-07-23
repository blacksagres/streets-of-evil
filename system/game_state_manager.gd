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
	game_state_changed.emit(state)
	
func resume() -> void: 
	state = GameState.PLAYING
	game_state_changed.emit(state)

func start() -> void:
	state = GameState.PLAYING
	game_state_changed.emit(state)

# Utility state functions

func isPausable() -> bool:
	return state == GameState.PLAYING

func isPaused() -> bool:
	return state == GameState.PAUSED
