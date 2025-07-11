# PlayerStatus.gd
extends Resource
class_name PlayerStatus

@export var damage_modifier: float = 1.0
@export var fire_rate: float = 0.5
@export var speed: int = 100
@export var level: int = 1
@export var current_experience: int = 0

signal leveled_up()
signal gained_experience(current_amount: int)

signal increased_status(status: Dictionary)

func increase_experience(experience_amount: int) -> void: 
	current_experience += experience_amount
	
	if current_experience > 100:
		current_experience = current_experience - 100
		level += 1
		leveled_up.emit()
		
	gained_experience.emit(current_experience)

func level_up(parameter: String) -> void:
	match parameter:
		"damage_modifier": damage_modifier += 10
		"fire_rate": fire_rate  *= 0.85
		"move_speed": speed *= 1.15
		_:
			push_error("Unknown parameter: " + parameter)
	
	increased_status.emit(get_status())
	

func get_status() -> Dictionary: 
	return {
		"damage_modifier": damage_modifier,
		"fire_rate": fire_rate,
		"move_speed": speed,
		"level": level,
		"current_experience": current_experience
	}
