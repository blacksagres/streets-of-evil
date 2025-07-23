class_name Shotgun

extends Node2D

const SPEED := 500
const DAMAGE = 10

@export var shotgun_bullet: PackedScene

@onready var barrel := $Barrel

## Shoots projectiles from the weapon. 
##
## [param damage_modifier] a multiplier based on the player's level
## [param direction] a Vector2 pointing where to shoot at 
func shoot(damage_modifier: float, direction: Vector2) -> void:
	## Single bullet
	#var handgun_bullet = shotgun_bullet.instantiate() as ShotgunBullet
	#handgun_bullet.speed = SPEED
	#handgun_bullet.direction = direction
	#handgun_bullet.damage = DAMAGE * damage_modifier
	#handgun_bullet.global_position = barrel.global_position
	#handgun_bullet.rotation = barrel.global_rotation
	#get_tree().root.add_child(handgun_bullet)
	#
	#return

	
	## SHOTGUN
	
	const MAXIMUM_SPREAD = deg_to_rad(15)
	const BULLET_COUNT = 3
	
	for i in range(BULLET_COUNT):
		var bullet = shotgun_bullet.instantiate() as ShotgunBullet
		#print("shooting ze bullet - ", bullet)
		
		bullet.speed = SPEED
		bullet.damage = DAMAGE * damage_modifier
		
		var interpolation_variation = float(i)/(BULLET_COUNT-1)
		var angle_offset = lerp(-MAXIMUM_SPREAD, MAXIMUM_SPREAD, interpolation_variation)
		# this "straightens up" the bullet
		bullet.rotation = barrel.global_rotation
		
		bullet.direction = direction.rotated(angle_offset)
		
		bullet.global_position = barrel.global_position
		
		# We always add the bullet in the world, 
		# otherwise the bullet will remain "attached" to the player and rotates
		# with the scene.
		get_tree().root.add_child(bullet)
	
