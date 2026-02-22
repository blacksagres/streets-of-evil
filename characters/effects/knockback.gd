class_name KnockbackComponent
extends Node

var velocity = Vector2.ZERO
var duration = 0.2 #in seconds
var strength = 400.0
var timer = 0.0 
var is_active = false

"""
When called, applies the knockback status to this component based
on the configured parameters (velocity, strength and duration) but
won't apply it yet. 

The `update` method needs to be called in the `_physics_process` 
with the delta to make the game see its effects.
"""
func apply_knockback(direction: Vector2):
	velocity = direction * strength
	timer = duration
	is_active = true
	
func update(delta: float):
	if not is_active:
		return
	
	# We calculate for how long the knockback lasts
	timer -= delta
	
	if timer > 0:
		return velocity
	else:
		# If the duration is up, stop moving
		reset()
	
	return Vector2.ZERO
	

func reset():
	velocity = Vector2.ZERO
	timer = 0.0
	is_active = false
