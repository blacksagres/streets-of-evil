# Has static function `show_damage` so any scene can use this to display damage taken.
# This scene already includes animation for the number to transition.
# Possibly this can also become something for healing as well.
class_name DamageDisplay

extends Node2D

@onready var animation_player := $AnimationPlayer
@onready var damage_display_text := $DamageDisplayText

static var damage_display_scene := preload("res://characters/effects/damage_display/DamageDisplay.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.animation_finished.connect(
		func(anim_name: String):
			if anim_name == "display-damage":
				queue_free()
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func display_damage(amount: int) -> void:
	damage_display_text.text = str(amount)
	animation_player.play("display-damage")
	
static func show_damage(scene_to_contain_damage_text: Node, position: Vector2, damage_amount: int) -> void:
	var damage_display_instance := damage_display_scene.instantiate()
	scene_to_contain_damage_text.add_child(damage_display_instance)
	
	damage_display_instance.global_position = position
	damage_display_instance.display_damage(damage_amount)
	
	
