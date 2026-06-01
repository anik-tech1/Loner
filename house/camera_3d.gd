extends Camera3D

@export var mouse_sensitivity: float = 0.003

@export_group("Vertical Limits")
@export var max_look_up: float = 80.0
@export var max_look_down: float = -80.0

@export_group("Horizontal Limits")
# In Godot, turning LEFT is positive, turning RIGHT is negative
@export var max_look_left: float = 45.0  
@export var max_look_right: float = -45.0

var pitch: float = 0.0
var yaw: float = 0.0
var start_yaw: float = 0.0 # Stores the direction the camera faces when the game starts

func _ready() -> void:
	# Hide the mouse cursor and lock it to the game window
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Grab the camera's starting rotations
	yaw = rotation.y
	pitch = rotation.x
	
	# Save the initial Y rotation so we can calculate our left/right limits from it
	start_yaw = rotation.y

func _input(event: InputEvent) -> void:
	# Only rotate if the mouse is currently captured
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		
		# 1. Clamp the pitch (up/down)
		pitch = clamp(pitch, deg_to_rad(max_look_down), deg_to_rad(max_look_up))
		
		# 2. Clamp the yaw (left/right) RELATIVE to the starting angle
		# We put right (negative) first, and left (positive) second for the min/max 
		yaw = clamp(yaw, start_yaw + deg_to_rad(max_look_right), start_yaw + deg_to_rad(max_look_left))
		
		# Apply the new rotations to the camera
		rotation.y = yaw
		rotation.x = pitch

func _process(delta: float) -> void:
	# Pressing 'Escape' frees the mouse
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
