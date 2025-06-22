class_name Hitbox
extends Area2D

@export var damage:int = 1

func get_hit_info() -> Dictionary:
	return {
		damage = damage
	}
