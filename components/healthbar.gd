## Not a scene yet but it could be
class_name Healthbar

extends ProgressBar

signal current_health_changed_signal(amount: float)

## Sets the intial health value and the max value to the same amount.
func set_initial_health(amount: float) -> void:
	self.value = amount
	self.max_value = amount

func update_current_health(amount: float) -> void:
	print('updating health: amount', amount, ', value: :', self.value)


	if(amount > self.value):
		self.value = 0
	else:
		self.value += amount

	current_health_changed_signal.emit(amount)

func get_current_health() -> float:
	return self.value
