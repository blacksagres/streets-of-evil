class_name Player
extends CharacterBody2D

@onready var animation_player := $AnimationPlayer
@onready var character_sprite := $PlayerSprites

@onready var laser_sight := $LaserSight
@onready var attack_speed := $AttackSpeedTimer

@export var status: PlayerStatus

# External dependencies, weapons, equipment, etc
@onready var shotgun := $Shotgun

const JUMP_VELOCITY = -400.0

enum PlayerState {
	IDLE,
	WALK
}

var AnimationDictionary := {
	PlayerState.IDLE: 'idle',
	PlayerState.WALK: 'walk'
}

var current_state : PlayerState

func _ready() -> void:
	attack_speed.wait_time = status.fire_rate
	attack_speed.timeout.connect(attack)
	
	status.increased_status.connect(on_status_increase)
	

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_movement_input()
	handle_laser_sight()

	handle_animation(current_state)
	
	# Process movement and execute it in game
	move_and_slide()
	
func on_status_increase(new_status: Dictionary) -> void:
	attack_speed.wait_time = new_status.fire_rate

func get_player_parameters() -> Dictionary:
	return {
		"LEVEL": status.level,
		"DAMAGE_MODIFIER": status.damage_modifier,
		"FIRE_RATE": status.fire_rate
	}

func attack() -> void:
	if shotgun and shotgun.has_method("shoot"):
		var aim_direction := global_position.direction_to(get_global_mouse_position())
		shotgun.shoot(status.damage_modifier, aim_direction)
		

func handle_laser_sight() -> void:
	# Rotates the laser together with the character, make it stretch "infinitely"
	laser_sight.points = [Vector2.ZERO, Vector2.RIGHT * 10000]

# STATE

func set_state(new_state: PlayerState) -> void:
	current_state = new_state

func is_walking() -> void:
	current_state = PlayerState.WALK

func is_idle() -> void:
	current_state = PlayerState.IDLE

func flip_sprites() -> void:
	# moving forward
	if velocity.x > 0:
		character_sprite.flip_h = true
		#damage_emitter.scale.x = 1
	# moving back
	elif velocity.x < 0:
		character_sprite.flip_h = false
		#damage_emitter.scale.x = -1

# PHYSICS

func handle_gravity(delta: float) -> void:
	return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func handle_movement_input() -> void:
	look_at(get_global_mouse_position())
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * status.speed

	flip_sprites()

	if velocity.x == 0:
		is_idle()

# Should I have an animation module?

func handle_animation(state: PlayerState) -> void:
	var animation_to_play = AnimationDictionary[state]

	if animation_player.has_animation(animation_to_play):
		animation_player.play(animation_to_play)
	else:
		print('Unexpected animation key - ', animation_to_play)
		return
