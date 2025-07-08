class_name Player
extends CharacterBody2D

signal gained_experience_signal(amount: int)
signal leveled_up_signal()

@onready var animation_player := $AnimationPlayer
@onready var character_sprite := $PlayerSprites

@onready var laser_sight := $LaserSight
@onready var attack_speed := $AttackSpeedTimer

# External dependencies, weapons, equipment, etc

@export var BULLET : PackedScene

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

enum PlayerParameterNames {
	FIRE_RATE,
	DAMAGE_MODIFIER,
	SPEED,
	LEVEL,
	CURRENT_EXPERIENCE
}

var PlayerParameters := {
	PlayerParameterNames.DAMAGE_MODIFIER: 1,
	PlayerParameterNames.FIRE_RATE: 0.5,
	PlayerParameterNames.SPEED: 100,
	PlayerParameterNames.LEVEL: 1,
	PlayerParameterNames.CURRENT_EXPERIENCE: 0
}

func _ready() -> void:
	attack_speed.wait_time = PlayerParameters[PlayerParameterNames.FIRE_RATE]
	attack_speed.timeout.connect(attack)

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_movement_input()
	handle_laser_sight()
	handle_command_input()

	handle_animation(current_state)
	
	handle_attack_speed()
	
	# Process movement and execute it in game
	move_and_slide()

func get_player_parameters() -> Dictionary:
	return {
		"LEVEL": PlayerParameters[PlayerParameterNames.LEVEL],
		"DAMAGE_MODIFIER": PlayerParameters[PlayerParameterNames.DAMAGE_MODIFIER],
		"FIRE_RATE": PlayerParameters[PlayerParameterNames.FIRE_RATE]
	}

func handle_attack_speed() -> void:
	if attack_speed.wait_time == PlayerParameters[PlayerParameterNames.FIRE_RATE]:
		pass
		
	attack_speed.wait_time = PlayerParameters[PlayerParameterNames.FIRE_RATE]

func increase_experience(amount: int) -> void:
	PlayerParameters[PlayerParameterNames.CURRENT_EXPERIENCE] += 10

	if PlayerParameters[PlayerParameterNames.CURRENT_EXPERIENCE] == 100:
		PlayerParameters[PlayerParameterNames.CURRENT_EXPERIENCE] = 0
		PlayerParameters[PlayerParameterNames.LEVEL] += 1
		leveled_up_signal.emit()

	gained_experience_signal.emit(PlayerParameters[PlayerParameterNames.CURRENT_EXPERIENCE])

func attack() -> void:
	var new_bullet = BULLET.instantiate()
	new_bullet.damage_modifier += PlayerParameters[PlayerParameterNames.DAMAGE_MODIFIER]
	get_tree().root.add_child(new_bullet)

	# this makes a new origin point from the bullet to shoot from
	# ideally we want a Marker2D as a spawn point but the character itself
	# will do.
	new_bullet.transform = self.transform

	# have to have this state in a function somewhere
	#if character_sprite.flip_h:
		#new_bullet.scale.x = 1
	#else:
		#new_bullet.scale.x = -1

func handle_laser_sight() -> void:
	# Rotates the laser together with the character, make it stretch "infinitely"
	laser_sight.points = [Vector2.ZERO, Vector2.RIGHT * 10000]

# COMMAND INPUTS
# Reference: https://github.com/Unchained112/SimpleTopDownShooterTemplate2D/tree/main
func handle_command_input() -> void:
	if Input.is_action_just_pressed("shoot"):

		## SHOTGUN

		#const MAXIMUM_SPREAD = deg_to_rad(5)
		#const BULLET_COUNT = 7
		#
		#for i in range(BULLET_COUNT):
			#var bullet = BULLET.instantiate()
#
			#var angle_offset = lerp(-MAXIMUM_SPREAD, MAXIMUM_SPREAD, float(i)/BULLET_COUNT)
			#bullet.rotation = angle_offset
			#bullet.position = position
			#get_tree().root.add_child(bullet)
			##add_sibling(bullet)
		#
		#return
		var new_bullet = BULLET.instantiate()
		new_bullet.damage_modifier = PlayerParameters[PlayerParameterNames.DAMAGE_MODIFIER]
		get_tree().root.add_child(new_bullet)

		# this makes a new origin point from the bullet to shoot from
		# ideally we want a Marker2D as a spawn point but the character itself
		# will do.
		new_bullet.transform = self.transform

		# have to have this state in a function somewhere
		if character_sprite.flip_h:
			new_bullet.scale.x = 1
		else:
			new_bullet.scale.x = -1

# STATE

func set_state(new_state: PlayerState) -> void:
	current_state = new_state

#
#	The idea is to pass a percentage to the parameter, so:
#	after leveling up you can inrease one of these parameters by 10%, for example
func increase_parameter(parameter: PlayerParameterNames, amount: float) -> void:
	if parameter == PlayerParameterNames.FIRE_RATE:
		PlayerParameters[parameter] = amount
		return
	
	PlayerParameters[parameter] += amount
	print(PlayerParameters)

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
	velocity = direction * PlayerParameters[PlayerParameterNames.SPEED]

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
