class_name World

extends Node2D

@export var zombie_scene : PackedScene
@onready var zombie_timer := $ZombieTimer
@onready var player := $ActorsContainer/Player
# The message in the center of the screen
@onready var splash_text := $SplashText

@onready var experience_gauge := $ExperienceGauge

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zombie_timer.timeout.connect(on_mob_timeout_spawn)
	player.gained_experience_signal.connect(on_player_experience_gained)
	player.leveled_up_signal.connect(on_player_level_up)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Vanishing text
	splash_text.modulate.a -= delta / 5
	pass


func on_mob_timeout_spawn():
	# Create a new instance of the Mob scene.
	var mob = zombie_scene.instantiate()
	
	mob.connect('on_death_signal', player.increase_experience)

	# Choose a random location on Path2D.
	var mob_spawn_location = $SpawnPath/SpawnPathLocation
	mob_spawn_location.progress_ratio = randf()
	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func on_player_experience_gained(amount: int) -> void:
	experience_gauge.value = amount
	
func on_player_level_up() -> void:
	print("LEVELED UP - WORLD")
