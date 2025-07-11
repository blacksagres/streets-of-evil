# PlayerStatus.gd
extends Resource
class_name PlayerStatus

@export var damage_modifier: float = 1.0
@export var fire_rate: float = 0.5
@export var speed: int = 100
@export var level: int = 1
@export var current_experience: int = 0

func level_up(parameter: String) -> void:
	match parameter:
		"damage_modifier": damage_modifier *= 1.20
		"fire_rate": fire_rate  -= 1.15
		"move_speed": speed *= 1.15
		_:
			push_error("Unknown parameter: " + parameter)

func get_status() -> Dictionary: 
	return {
		"damage_modifier": damage_modifier,
		"fire_rate": fire_rate,
		"move_speed": speed,
		"level": level,
		"current_experience": current_experience
	}
