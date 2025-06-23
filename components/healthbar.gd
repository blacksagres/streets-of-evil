class_name Healthbar
extends ProgressBar

signal current_health_changed_signal(amount: float)

func set_initial_health(amount: float) -> void:
	self.value = amount

func update_current_health(amount: float) -> void:
	print('updating health: amount', amount, ', value: :', self.value)
	
	
	if(amount > self.value): 
		self.value = 0
	else:
		self.value += amount
		
	current_health_changed_signal.emit(amount)

func get_current_health() -> float:
	return self.value
