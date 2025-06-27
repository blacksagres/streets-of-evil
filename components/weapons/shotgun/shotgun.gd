class_name Shotgun

extends Area2D

const SPEED := 200
const DAMAGE = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * SPEED * delta
	
func get_hit_info() -> Dictionary:   	
	return {
		damage = DAMAGE
	}
	
func destroy_projectile() -> void: 
	queue_free()
	
#func shoot(window: Window, bullet_point:Transform2D) -> void:
	
