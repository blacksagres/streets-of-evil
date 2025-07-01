class_name DamageDisplay

extends Node2D

@onready var animation_player := $AnimationPlayer
@onready var damage_display_text := $DamageDisplayText
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
	damage_display_text.text = str(amount) + " damage!"
	animation_player.play("display-damage")
