class_name ShotgunBullet
extends Area2D

## These variables are assigned by the weapon

## The vector through each the bullet will travel.
## Think about the straight line it will go. PEW!
var direction = Vector2(1, 0)

## To be assigned by the weapon.
var speed := 0

## To be assinged by the weapon.
var damage := 0

func destroy_projectile() -> void:
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += direction * speed * delta

func get_hit_info() -> Dictionary:
	return {
		damage = damage
	}
