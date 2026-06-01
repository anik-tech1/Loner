extends Node3D

@export var bird_scene: PackedScene
@export var min_spawn_time: float = 3.0
@export var max_spawn_time: float = 8.0
@export var spawn_radius: float = 20.0 # How wide the flock can be

var spawn_timer: float = 0.0

func _ready() -> void:
	# Set the first timer
	spawn_timer = randf_range(min_spawn_time, max_spawn_time)

func _process(delta: float) -> void:
	spawn_timer -= delta
	
	if spawn_timer <= 0.0:
		spawn_bird()
		# Reset the timer for the next bird
		spawn_timer = randf_range(min_spawn_time, max_spawn_time)

func spawn_bird() -> void:
	if not bird_scene: 
		return
		
	var new_bird = bird_scene.instantiate()
	
	# Add the bird to the main scene tree, NOT as a child of the spawner, 
	# so it moves independently
	get_tree().current_scene.add_child(new_bird)
	
	# Move the bird to the spawner's location
	new_bird.global_position = global_position
	
	# Randomize the start position slightly so they don't spawn in a perfect single-file line
	new_bird.global_position.x += randf_range(-spawn_radius, spawn_radius)
	new_bird.global_position.y += randf_range(-spawn_radius/2, spawn_radius/2)
	
	# Match the spawner's rotation so the bird flies in the right direction
	new_bird.rotation = rotation
