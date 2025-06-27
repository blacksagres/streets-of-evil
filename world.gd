class_name World

extends Node2D

@export var zombie_scene : PackedScene
@onready var zombie_timer := $ZombieTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zombie_timer.timeout.connect(_on_mob_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = zombie_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $SpawnPath/SpawnPathLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
