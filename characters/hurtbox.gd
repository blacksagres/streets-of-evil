class_name Hurtbox
extends Area2D

signal hit_taken_signal(hit_box: Hitbox)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered", hit_taken)

func hit_taken(hit_box: Area2D) -> void:
	if hit_box == null:
		print('Unexpected collision in hurtbox, hitbox is null.' )
		return;
	
	hit_taken_signal.emit(hit_box)
	
