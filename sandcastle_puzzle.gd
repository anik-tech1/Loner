extends Node3D

@export_group("Puzzle Mode Setup")
@export var player_camera: Camera3D
@export var puzzle_camera: Camera3D
@export var prompt_ui: Label

@export_group("Puzzle Models")
@export var base_models: Array[Mesh]
@export var mid_models: Array[Mesh]
@export var top_models: Array[Mesh]

var target_combo: Array[int] = [1, 2, 0] 
var current_combo: Array[int] = [0,0,0]

var is_player_near: bool = false
var in_puzzle_mode: bool = false
var is_completed: bool = false

@onready var base_mesh: MeshInstance3D = $BaseMesh
@onready var mid_mesh: MeshInstance3D = $MidMesh
@onready var top_mesh: MeshInstance3D = $TopMesh

func _ready() -> void:
	if prompt_ui: prompt_ui.hide()
	
	if base_models.size() > 0: target_combo[0] = randi() % base_models.size()
	if mid_models.size() > 0: target_combo[1] = randi() % mid_models.size()
	if top_models.size() > 0: target_combo[2] = randi() % top_models.size()
	update_meshes()

func _process(delta: float) -> void:
	# 1. Entering the puzzle
	if is_player_near and not in_puzzle_mode and not is_completed:
		if Input.is_action_just_pressed("interact"):
			enter_puzzle_mode()
			
	# 2. Exiting the puzzle (pressing 'Escape' or 'E' again)
	elif in_puzzle_mode and (Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("interact")):
		exit_puzzle_mode()

# --- CAMERA & MOUSE TRANSITIONS ---

func enter_puzzle_mode() -> void:
	in_puzzle_mode = true
	if prompt_ui: prompt_ui.hide()
	
	# Swap to the cinematic puzzle camera
	if puzzle_camera: puzzle_camera.make_current()
	
	# Free the mouse so they can click the tiers!
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func exit_puzzle_mode() -> void:
	in_puzzle_mode = false
	if prompt_ui and is_player_near and not is_completed: prompt_ui.show()
	
	# Give the camera back to the player
	if player_camera: player_camera.make_current()
	
	# Lock the mouse back to the center of the screen for FPS movement
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# --- PROXIMITY SIGNALS ---

func _on_proximity_trigger_body_entered(body: Node3D) -> void:
	# Make sure it's actually the player walking in (checks if the body has the word 'Player' in its name)
	if "Player" in body.name and not is_completed:
		is_player_near = true
		if prompt_ui: 
			prompt_ui.text = "Press E to Build Sandcastle"
			prompt_ui.show()

func _on_proximity_trigger_body_exited(body: Node3D) -> void:
	if "Player" in body.name:
		is_player_near = false
		if prompt_ui: prompt_ui.hide()
		
		# If they walk away while somehow still in puzzle mode, force exit
		if in_puzzle_mode: exit_puzzle_mode()

# --- PUZZLE LOGIC (Triggered by the _input_event script on your Areas) ---

func cycle_tier(tier_index: int) -> void:
	if is_completed or not in_puzzle_mode: return 
	
	var max_size = 0
	if tier_index == 0: max_size = base_models.size()
	elif tier_index == 1: max_size = mid_models.size()
	elif tier_index == 2: max_size = top_models.size()
	
	if max_size == 0: return
	
	current_combo[tier_index] = (current_combo[tier_index] + 1) % max_size
	update_meshes()
	check_win_condition()
func _input(event: InputEvent) -> void:
	if not in_puzzle_mode or is_completed:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Test 1: Is the script even detecting the click?
		print("--- 1. Mouse Click Detected! ---")
		
		var mouse_pos = get_viewport().get_mouse_position()
		var ray_origin = puzzle_camera.project_ray_origin(mouse_pos)
		var ray_end = ray_origin + puzzle_camera.project_ray_normal(mouse_pos) * 1000.0 # Increased length!
		
		
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		query.collide_with_areas = true 
		
		var result = space_state.intersect_ray(query)
		
		if result:
			var hit_object = result.collider
			# Test 2: We hit something! But what is it?
			print("2. Laser HIT an object! Name: '", hit_object.name, "'")
			
			if hit_object.name == "BaseTrigger":
				print("3. Base matched! Cycling tier 0.")
				cycle_tier(0)
			elif hit_object.name == "MidTrigger":
				print("3. Mid matched! Cycling tier 1.")
				cycle_tier(1)
			elif hit_object.name == "TopTrigger":
				print("3. Top matched! Cycling tier 2.")
				cycle_tier(2)
			else:
				print("ERROR: The name didn't match any of our IF statements!")
		else:
			# Test 3: The laser fired, but hit nothing.
			print("2. Laser MISSED. It hit thin air.")

func update_meshes() -> void:
	if base_models.size() > 0: base_mesh.mesh = base_models[current_combo[0]]
	if mid_models.size() > 0: mid_mesh.mesh = mid_models[current_combo[1]]
	if top_models.size() > 0: top_mesh.mesh = top_models[current_combo[2]]

func check_win_condition() -> void:
	if current_combo == target_combo:
		is_completed = true
		exit_puzzle_mode() # Kick them back to FPS mode automatically!
		Global.Lake += 1
		
		if prompt_ui: 
			prompt_ui.text = "Perfect Match!"
			prompt_ui.show()
