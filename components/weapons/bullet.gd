class_name Bullet

extends Area2D

const SPEED := 500
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
