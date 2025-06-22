class_name Bullet

extends Area2D

const SPEED := 200
const DAMAGE = 10

signal on_handgun_bullet_hit(area: Area2D)

func _ready() -> void:
	connect('area_entered', on_hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * SPEED * delta
	
func on_hit(area: Area2D) ->void:   	
	on_handgun_bullet_hit.emit(area)
	print("BANG BANG")
	queue_free()
