extends Node2D

# Signals for health status changes
signal health_status_changed(new_status: String)

# Health thresholds (percentages)
const HEALTHY_THRESHOLD := 0.70
const CAUTION_THRESHOLD := 0.40

@onready var sprite := $Sprite2D
@onready var animation_player := $AnimationPlayer

var current_status := "healthy"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize with healthy status
	update_health_status(1.0)  # Start at 100% health
	play_animation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Update the HUD based on current health percentage (0.0 to 1.0)
func update_health_status(health_percentage: float) -> void:
	var new_status := get_status_for_percentage(health_percentage)
	
	if new_status != current_status:
		current_status = new_status
		update_sprite_for_status(new_status)
		health_status_changed.emit(new_status)

# Get the status string for a given health percentage
func get_status_for_percentage(health_percentage: float) -> String:
	if health_percentage > HEALTHY_THRESHOLD:
		return "healthy"
	elif health_percentage > CAUTION_THRESHOLD:
		return "caution"
	else:
		return "danger"

# Update the sprite texture based on health status
func update_sprite_for_status(status: String) -> void:
	match status:
		"healthy":
			sprite.texture = load("res://assets/hud/streets-of-evil-condition-healthy.png")
		"caution":
			sprite.texture = load("res://assets/hud/streets-of-evil-condition-caution.png")
		"danger":
			sprite.texture = load("res://assets/hud/streets-of-evil-condition-danger.png")
		_:
			push_error("Unknown health status: " + status)
	
	play_animation()

func play_animation():
	if animation_player.has_animation("condition-status"):
		animation_player.play("condition-status")
