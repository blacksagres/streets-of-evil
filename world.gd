class_name World

extends Node2D

@export var zombie_scene : PackedScene
@onready var zombie_timer := $ZombieTimer
@export var player : Player
# The message in the center of the screen
@onready var splash_text := $SplashText
@onready var debug_label := $Debug/Label
@onready var experience_gauge := $ExperienceGauge

# MENUS

@onready var level_up_menu := $Menus/LevelUpMenu



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# WORLD IS PAUSED BY DEFAULT!
	get_tree().paused = true
	
	zombie_timer.timeout.connect(on_mob_timeout_spawn)
	player.status.gained_experience.connect(on_player_experience_gained)
	# Enables the game to give options on what to increase
	player.status.leveled_up.connect(on_player_level_up)
	
	# The actual status increase after leveling up, too granular?
	player.status.increased_status.connect(on_player_status_increased)
	
	# Hidden by default
	level_up_menu.visible = false
	level_up_menu.z_index = -GameConstants.MENU_Z_INDEX
	
	# Boons callback setup
	level_up_menu.increased_damage_boon_button.on_click = on_damage_boon_clicked
	level_up_menu.increased_fire_rate_boon_button.on_click = on_fire_rate_boon_clicked
	level_up_menu.increased_movement_speed_boon_button.on_click = on_movement_speed_boon_clicked
	
	GameStateManager.game_state_changed.connect(_on_game_state_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Vanishing text
	debug_label.text = JSON.stringify(player.get_player_parameters(), "\t")
	splash_text.modulate.a -= delta / 5
	pass
	

func _on_game_state_changed(new_state: GameStateManager.GameState) -> void:
	print('STATE CHANGED ', - new_state)
	get_tree().paused = [
	GameStateManager.GameState.PAUSED, 
	GameStateManager.GameState.START_MENU
	].has(new_state)


func on_mob_timeout_spawn():
	# Create a new instance of the Mob scene.
	var mob = zombie_scene.instantiate()
	
	mob.connect('on_death_signal', player.status.increase_experience)

	# Choose a random location on Path2D.
	var mob_spawn_location = $SpawnPath/SpawnPathLocation
	mob_spawn_location.progress_ratio = randf() 
	print({ "rand": mob_spawn_location.progress_ratio })
	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func on_player_experience_gained(amount: int) -> void:
	experience_gauge.value = amount
	
func on_player_level_up() -> void:
	get_tree().paused = true
	level_up_menu.z_index = GameConstants.MENU_Z_INDEX
	level_up_menu.visible = true

func on_player_status_increased(_status: Dictionary) -> void:
	print('zombies will spawn faster!')
	zombie_timer.wait_time *= 0.9

func on_fire_rate_boon_clicked() -> void:
	print('attack speed incrased')
	player.status.level_up("fire_rate")
	get_tree().paused = false
	level_up_menu.visible = false
	
func on_damage_boon_clicked() -> void:
	print('damage incrased')
	player.status.level_up("damage_modifier")
	get_tree().paused = false
	level_up_menu.visible = false
	
func on_movement_speed_boon_clicked() -> void:
	print('movement speed incrased')
	player.status.level_up("speed")
	get_tree().paused = false
	level_up_menu.visible = false
