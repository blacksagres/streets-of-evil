extends RayCast2D

@export var cast_speed := 7000.0
@export var max_length := 1400.0

@onready var laser_line := $LaserLine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	target_position.x = move_toward(
		target_position.x, 
		max_length, 
		cast_speed * delta
	)
	
	var laser_end_position := target_position
	
	# Apparently this is important to make sure we 
	# get accurate collision information
	force_raycast_update()
	
	if is_colliding():
		laser_end_position = to_local(get_collision_point())
	
	laser_line.points = [Vector2.ZERO, laser_end_position]
	
