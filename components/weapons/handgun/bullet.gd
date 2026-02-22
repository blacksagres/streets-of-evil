class_name Bullet

extends Area2D

const SPEED := 500
const DAMAGE = 10

# any modifiers to this bullet

var damage_modifier: float = 1:
	get:
		return damage_modifier
	set(new_damage_modifier):
		damage_modifier = new_damage_modifier

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * SPEED * delta

func get_hit_info() -> Dictionary:
	return {
		damage = DAMAGE * damage_modifier
	}

func destroy_projectile() -> void:
	queue_free()
