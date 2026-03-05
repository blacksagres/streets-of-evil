class_name Player
extends CharacterBody2D

@onready var animated_sprite := $AnimatedPlayerSprite
@onready var weapon_anchor := $AnimatedPlayerSprite/WeaponAnchor
@onready var laser_sight := $AnimatedPlayerSprite/LaserSight
@onready var attack_speed := $AttackSpeedTimer
@onready var healthbar :Healthbar = $Healthbar


@onready var hurtbox := $Hurtbox
# External dependencies, weapons, equipment, etc
@onready var shotgun := $AnimatedPlayerSprite/WeaponAnchor/Shotgun

@export var status: PlayerStatus

# Specific variables

@onready var knockback := $KnockbackComponent

const JUMP_VELOCITY = -400.0

enum PlayerState {
	IDLE_UP,
	IDLE_DOWN,
	IDLE_SIDE,
	
	WALK_SIDE,
	WALK_DOWN,
	WALK_UP,
}

var AnimationDictionary := {
	PlayerState.IDLE_UP: 'idle-up',
	PlayerState.IDLE_DOWN: 'idle-down',
	PlayerState.IDLE_SIDE: 'idle-side',
	
	PlayerState.WALK_SIDE: 'side-walk',
	PlayerState.WALK_DOWN: 'down-walk',
	PlayerState.WALK_UP: 'up-walk'
}

var current_state : PlayerState

func _ready() -> void:
	# attack_speed.wait_time = status.fire_rate
	# attack_speed.timeout.connect(attack)
	healthbar.set_initial_health(30)
	status.increased_status.connect(on_status_increase)
	hurtbox.area_entered.connect(on_damage_taken)
	

func _physics_process(delta: float) -> void:
	# in knockback status
	var knockback_velocity = knockback.update(delta)
	
	if knockback.is_active:
		velocity = knockback_velocity
		# if we're being knocked back, do not register movement
		move_and_slide()
		return

	if velocity.length() > 0:
		velocity = Vector2.ZERO
	
	handle_movement_input()

	handle_animation(current_state)
	handle_shoot_command()
	
	# Process movement and execute it in game
	move_and_slide()
	
func on_damage_taken(_area: Area2D) -> void:
	# start knockback for opposite direction 
	var knockback_direction = global_position.direction_to(_area.global_position) * -1
	knockback.apply_knockback(knockback_direction)
	
	# Damage blink animation
	var damage_tween = create_tween().set_trans(Tween.TRANS_SINE)
	# Flash red and fade out quickly
	damage_tween.parallel().tween_property(animated_sprite, "modulate", Color.RED, 0.1)
	damage_tween.parallel().tween_property(animated_sprite, "modulate:a", 0.5, 0.1)
	# Return to normal color and full opacity
	damage_tween.tween_property(animated_sprite, "modulate", Color.WHITE, 0.3)
	damage_tween.tween_property(animated_sprite, "modulate:a", 1.0, 0.3)
	
	healthbar.update_current_health(-10)
	
	if(healthbar.get_current_health() == 0):
		GameStateManager.game_over()
	
func handle_shoot_command() -> void:
	if Input.is_action_just_pressed('shoot') or Input.is_action_pressed('shoot'):
		attack()
	
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

# STATE

func set_state(new_state: PlayerState) -> void:
	current_state = new_state

func flip_sprites() -> void:
	pass
	# moving forward
	if velocity.x > 0:
		animated_sprite.flip_h = true
		#damage_emitter.scale.x = 1
	# moving back
	elif velocity.x < 0:
		animated_sprite.flip_h = false
		#damage_emitter.scale.x = -1

# PHYSICS

func handle_movement_input() -> void:
	weapon_anchor.look_at(get_global_mouse_position())
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction:Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = direction * status.speed
	var last_non_zero_velocity = Vector2.RIGHT

	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			# horizontal moviment priority
			set_state(PlayerState.WALK_SIDE)
			animated_sprite.flip_h = velocity.x < 0
		else:
			# vertical movement priority
			if velocity.y < 0: 
				set_state(PlayerState.WALK_UP)
			else:
				set_state(PlayerState.WALK_DOWN)
		# for the idleness
		last_non_zero_velocity = velocity

	else:
		if last_non_zero_velocity.y < 0:
			set_state(PlayerState.IDLE_DOWN)
		elif last_non_zero_velocity.y > 0:
			set_state(PlayerState.IDLE_UP)
		else:
			set_state(PlayerState.IDLE_SIDE)


# Should I have an animation module?

func handle_animation(state: PlayerState) -> void:
	var animation_to_play = AnimationDictionary[state]

	print("VELOCITY", velocity, ", ANIMATION ---> ", animation_to_play)

	if animated_sprite.sprite_frames.has_animation(animation_to_play):
		animated_sprite.play(animation_to_play)
	else:
		print('Unexpected animation key - ', animation_to_play)
		return
