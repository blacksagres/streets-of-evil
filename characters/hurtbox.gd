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
	
	if hit_box.has_method('get_hit_info'):
		var hit_info = hit_box.get_hit_info()
		print('Hurtbox was dealt ', hit_info.damage, ' damage!')
	
	print('new damage type!')
	
	hit_taken_signal.emit(hit_box)
	
