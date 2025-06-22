extends Node2D

@onready var hurtbox := %Hurtbox
@onready var healthbar := $Healthbar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurtbox.hit_taken_signal.connect(on_received_damage)
	healthbar.current_health_changed_signal.connect(on_current_health_changed)
	
	# setup
	
	healthbar.set_initial_health(100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Signal responses

func on_received_damage(hit_box: Hitbox) -> void:
	print('"Oh no!" - Enemy says... ', hit_box.damage, ' damage!')
	#healthbar.current_health_changed_signal.
	# better to have function that deals damage?
	healthbar.update_current_health(-hit_box.damage)

# make signal trigger animation?
func on_current_health_changed(amount: float) -> void:
	print('Enemy health changed! - change state, play animation, etc')
