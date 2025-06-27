extends Node2D

@onready var hurtbox := %Hurtbox
@onready var healthbar := $Healthbar
@onready var death_cry_audio := $DeathCry
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurtbox.hit_taken_signal.connect(on_received_damage)
	healthbar.current_health_changed_signal.connect(on_current_health_changed)
	
	# setup
	
	healthbar.set_initial_health(100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_death(delta)
	
# Time related effects

func handle_death(delta: float) -> void:
	if healthbar.get_current_health() <= 0:
		# decreases the alpha, creating a phase out effect
		modulate.a -= delta / 2.0
	
# Signal responses

func on_received_damage(hit_box: Area2D) -> void:
		
	if hit_box.has_method('get_hit_info'):
		var hit_info = hit_box.get_hit_info()
		#healthbar.current_health_changed_signal.
		# better to have function that deals damage?
		healthbar.update_current_health(-hit_info.damage)
		print('"Oh no!" - Enemy says... ', hit_info.damage, ' damage!')
		
	
	if hit_box.has_method('destroy_projectile'):
		hit_box.destroy_projectile()
		
	if healthbar.get_current_health() <= 0:
		queue_free()
		return
		death_cry_audio.play()
		death_cry_audio.finished.connect(queue_free)
	
	

# make signal trigger animation?
func on_current_health_changed(amount: float) -> void:
	print('Enemy health changed! - change state, play animation, etc')
