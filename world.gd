class_name World

extends Node2D

@export var zombie_scene : PackedScene
@onready var zombie_timer := $ZombieTimer
@onready var player := $ActorsContainer/Player
# The message in the center of the screen
@onready var splash_text := $SplashText
@onready var debug_label := $Debug/Label
@onready var experience_gauge := $ExperienceGauge

# MENUS

@onready var level_up_menu := $Menus/LevelUpMenu

@onready var fire_rate_boon := $Menus/LevelUpMenu/FireRateBoon
@onready var damage_boon := $Menus/LevelUpMenu/DamageBoon
@onready var movement_speed_boon := $Menus/LevelUpMenu/MovementSpeedBoon

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		print("Mouse clicked at", event.position)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zombie_timer.timeout.connect(on_mob_timeout_spawn)
	player.gained_experience_signal.connect(on_player_experience_gained)
	player.leveled_up_signal.connect(on_player_level_up)
	
	# Hidden by default
	level_up_menu.visible = false
	#level_up_menu.z_index = 1000
	
	fire_rate_boon.process_mode = Node.PROCESS_MODE_ALWAYS
	damage_boon.process_mode = Node.PROCESS_MODE_ALWAYS
	movement_speed_boon.process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Boons callback setup
	fire_rate_boon.connect("pressed", on_fire_rate_boon_clicked)
	damage_boon.connect("pressed", on_damage_boon_clicked)
	movement_speed_boon.connect("pressed", on_movement_speed_boon_clicked)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Vanishing text
	debug_label.text = JSON.stringify(player.get_player_parameters(), "\t")
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
	get_tree().paused = true
	level_up_menu.visible = true

func on_fire_rate_boon_clicked() -> void:
	print('attack speed incrased')
	player.increase_parameter(player.PlayerParameterNames.FIRE_RATE, player.PlayerParameters[player.PlayerParameterNames.FIRE_RATE] / 1.2)
	get_tree().paused = false
	level_up_menu.visible = false
	
func on_damage_boon_clicked() -> void:
	print('damage incrased')
	player.increase_parameter(player.PlayerParameterNames.DAMAGE_MODIFIER, player.PlayerParameters[player.PlayerParameterNames.DAMAGE_MODIFIER] * 1.2)
	get_tree().paused = false
	level_up_menu.visible = false
	
func on_movement_speed_boon_clicked() -> void:
	print('movement speed incrased')
	player.increase_parameter(player.PlayerParameterNames.SPEED, 0.2)
	player.increase_parameter(player.PlayerParameterNames.SPEED, player.PlayerParameters[player.PlayerParameterNames.SPEED] * 1.2)
	get_tree().paused = false
	level_up_menu.visible = false
