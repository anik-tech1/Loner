extends Node3D

@export var speed: float = 8.0
@export var bob_amount: float = 2.0
@export var bob_speed: float = 5.0
@export var lifetime: float = 20.0 # Deletes the bird after 20 seconds

var time_alive: float = 0.0
var start_y: float = 0.0

func _ready() -> void:
	start_y = position.y
	
	# Randomize the bird's speed slightly so flocks don't look robotic
	speed = randf_range(speed * 0.8, speed * 1.2)

func _process(delta: float) -> void:
	time_alive += delta
	
	# 1. Fly forward (In Godot, -Z is the forward direction)
	# We use global_transform.basis to ensure it flies in the direction it's rotated!
	position += global_transform.basis.z * -speed * delta
	
	# 2. Bob up and down using a sine wave
	position.y = start_y + (sin(time_alive * bob_speed) * bob_amount)
	
	# 3. Delete the bird when it flies too far away
	if time_alive >= lifetime:
		queue_free()
